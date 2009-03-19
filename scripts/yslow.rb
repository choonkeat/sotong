#
# For all resources that does NOT come from the matching hostname do the following:
# 1. set future content expiry (1 year)
# 2. minify javascript
# 3. gzip the response body
#
# e.g. MYHOSTNAME=abc.com ruby sotong '' scripts/yslow.rb
#
if not Regexp.new(ENV['MYHOSTNAME']).match(request.host.to_s)
  # response['last-modified'] = nil
  # response['date'] = nil
  response['expires'] = nil
  response['cache-control'] = "max-age=#{3600 * 24 * 365}"

  if response['content-type'] =~ /javascript/
    open("bigjs.js", "w") {|f| f.write(content) }
    response.body = content = IO.popen("ruby vendor/jsmin.rb < bigjs.js") {|io| io.read}
    response['content-length'] = response.body.length
    response['content-encoding'] = nil
  end

  if response['content-encoding'] != 'gzip'
    new_content = StringIO.open('','w')
    gz = Zlib::GzipWriter.new(new_content)
    gz.write(response.body)
    gz.close
    response.body = content = new_content.string
    response['content-length'] = response.body.length
    response['content-encoding'] = 'gzip'
  end
end
