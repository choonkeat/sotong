# For any script, these are the 3 variables you can manipulate
# 
# 1. WEBrick::HTTPRequest
puts request.inspect

# 2. WEBrick::HTTPResponse. Most of the time, you'd want to modify this object.
puts response.inspect

# 3. String. For your convenience, this is "response.body" -- always ungzipped.
puts content.inspect

# You can do anything here.
puts "I sleep."
sleep 5
puts "I wake."

# Feel free to edit and save without restarting sotong.rb