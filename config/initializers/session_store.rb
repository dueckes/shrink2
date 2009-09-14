# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_platter_session',
  :secret      => '8925d05a1b11511d6ca1da766ab45fed1b376638d3e5b1e644f19a2a64ebcf0de2b16292bf413a3e88630278fbb816c5c13586f985110682967253626631e25a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
