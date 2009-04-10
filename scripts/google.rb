# Swaps out Google ads for Google logo.gif
# Try this:
#   ruby sotong.rb google scripts/google.rb
#
if response['content-type'] =~ /javascript/
  response['content-encoding'] = nil
  response.body = <<-EOM
    if (window.google_ad_width && window.google_ad_height) {
      document.write('<img src="http://www.google.com/intl/en_ALL/images/logo.gif" width="' + google_ad_width + '" height="' + google_ad_height + '">');
    } else {
      document.write('<img src="http://www.google.com/intl/en_ALL/images/logo.gif">');
    }
  EOM
  response['content-length'] = response.body.length
end
