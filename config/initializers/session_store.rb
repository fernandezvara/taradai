# Be sure to restart your server when you modify this file.

require "mongo_session_store/mongoid"
#ActionController::Base.session_store = :mongoid_store

#Taradai::Application.config.session_store :cookie_store, :key => '_taradai_session'
Taradai::Application.config.session_store :mongoid_store, :key => '_taradai_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Taradai::Application.config.session_store :active_record_store
