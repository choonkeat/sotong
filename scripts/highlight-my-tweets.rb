if response['content-type'] =~ /text\/html/ && content =~ /class\=\"hentry[^\"]* mine/
  # find elements with class .hentry.mine, and add an inline style
  response.body = content.
    gsub(/(class\=\"hentry[^\"]* mine)/, 'style="background-color: yellow;" \1')

  # update http headers to respect modifications
  response['content-length'] = response.body.length
  response['content-encoding'] = nil # was "gzip"
end
