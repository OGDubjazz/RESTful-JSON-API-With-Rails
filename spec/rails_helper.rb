require 'database_cleaner'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  #config.include RequestSpecHelper, type: :request
  config.include RequestSpecHelper
  config.include ControllerSpecHelper

  config.use_transactional_fixtures = true
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end
