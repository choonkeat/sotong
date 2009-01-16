require 'zlib'
require 'logger'
require 'stringio'
require 'webrick/httpproxy'

class Sotong < WEBrick::HTTPProxyServer
  attr_accessor :routines
  def initialize(array, config = {})
    @routines = array
    @routines.select do |pair|
      puts "URLs matching /#{pair.first}/ will trigger script #{pair.last.inspect}"
    end
    
    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN
    super(config = {
        :Port => 12345,
      }.merge(config).merge({
        :Logger => logger,
        :ProxyContentHandler => Proc.new {|req,res| proxy_content_handler(req,res)},
      })
    )
    puts "Proxy ready on 0.0.0.0:#{config[:Port]}. Ctrl-C to quit."
  end
  
  def proxy_content_handler(request, response)
    content = if response['content-encoding'] == 'gzip'
      Zlib::GzipReader.new(StringIO.new(response.body)).read
    else
      response.body
    end
    self.routines.select {|pair| request.request_uri.to_s.match(pair.first) }.each do |pair|
      eval(IO.read(pair.last)) unless pair.last.to_s == ""
    end
  end

end

array = ARGV.inject([]) {|sum,x| sum.last && sum.last.length == 1 ? sum.last.push(x) && sum : sum + [[x]] }
server = Sotong.new(array)
trap("INT") { server.stop }
server.start
