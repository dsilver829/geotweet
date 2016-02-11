require 'factory_girl'
require 'database_cleaner'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
    Geotweet.__elasticsearch__.create_index! force: true
  end
end