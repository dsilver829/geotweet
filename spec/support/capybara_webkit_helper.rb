# Use Capybara-Webkit for JavaScript integration testing
require 'capybara-webkit'
require 'capybara/rspec'
Capybara.javascript_driver = :webkit
Capybara::Webkit.configure do |config|
  config.allow_url("*.googleapis.com")
  config.allow_url("*.gstatic.com")
  config.allow_url("*.google.com")
end