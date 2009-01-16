if response['content-type'] =~ /javascript/
  response['content-encoding'] = nil
  # if you have Firebug, you should see some log messages
  response.body = "if (window.console) console.log('sotong was here');"
  response['content-length'] = response.body.length
end
