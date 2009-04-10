# Removes cache headers
# Try this:
#   ruby sotong.rb '' scripts/nocache.rb
#
response['last-modified'] = nil
response['cache-control'] = nil
response['expires'] = nil
response['date'] = nil
