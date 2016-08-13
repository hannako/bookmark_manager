ENV["RACK_ENV"] = "test"
require 'capybara/rspec'
require 'database_cleaner'
require_relative '../app/app.rb'
require_relative 'helpers/session'
require_relative '../app/models/link'
require_relative '../app/models/tag'
require_relative '../app/models/user'

Capybara.app = BookmarkManager

RSpec.configure do |config|
  config.include SessionHelpers

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  Kernel.srand config.seed
end
