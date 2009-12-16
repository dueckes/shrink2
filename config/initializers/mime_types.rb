# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
Mime::Type.register "application/zip", :zip, [], %w(zip)
Mime::Type.register "text/feature", :feature, %w(application/x-zip, application/x-zip-compressed, application/octet-stream, application/x-compress, application/x-compressed, multipart/x-zip), %w(feature)
