require 'zlib'
require 'logger'
require 'stringio'
require 'webrick/httpproxy'

class Sotong < WEBrick::HTTPProxyServer
  attr_accessor :routines
  def initialize(array, config = {})
    @routines = array
    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN
    super({
        :Port => 12345,
      }.merge(config).merge({
        :Logger => logger,
        :ProxyContentHandler => Proc.new {|req,res| proxy_content_handler(req,res)},
      })
    )
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
puts "Starting on 0.0.0.0:12345..."
server.start
