# Removes all/selective <script> tags from a HTML page.
# Useful to find 100% CPU culprits...
# Try this:
#   ruby sotong.rb '' scripts/noscript.rb
#
if response['content-type'] =~ /html/
  # pull out all <script> tags
  scripts = content.scan(/((<script.*?>)(.*?)(<\/script>))/mi)
  # skip some of them, based on some criteria
  scripts.reject! {|match| match[0] =~ /do-not-remove-this-script/ }
  # remove the rest from the HTML
  scripts.each_with_index {|match, index| content.gsub!(match[0], "<!-- script tag##{index} was here -->") }
  # update our response object, based on new content
  response.body = content
  response['content-length'] = response.body.length
  response['content-encoding'] = nil # in case it was gzipped
end
