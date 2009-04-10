# Highlights your own twitter status updates with yellow background
# Try this:
#   ruby sotong.rb twitter scripts/highlight-my-tweets.rb
#
if response['content-type'] =~ /text\/html/
  # add a "yellow background" css style to twitter.com
  response.body = content.gsub(%r{</head>}, '<style>ol.statuses li.hentry.mine { background-color: yellow; }</style></head>')
  # update http headers to respect modifications
  response['content-length'] = response.body.length
  response['content-encoding'] = nil # was "gzip"
end
