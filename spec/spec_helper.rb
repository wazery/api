require 'mongoid'
require 'mongoid-rspec'
require 'simplecov'
require 'webmock/rspec'

SimpleCov.profiles.define 'no_vendor_coverage' do
  load_profile 'rails'
  add_filter 'vendor' # Don't include vendored stuff
end

SimpleCov.start 'no_vendor_coverage' if ENV['COVERAGE']

SimpleCov.at_exit do
  SimpleCov.result.format!
  puts 'Opening the coverage report..'
  exec('open coverage/index.html')
end

Mongoid.configure do |config|
  config.connect_to('mongoid-rspec-test')
end

RSpec.configure do |config|
  # RSpec matchers and macros for Mongoid
  config.include Mongoid::Matchers, type: :model

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:mongoid].start
  end

  config.after(:each) do
    DatabaseCleaner[:mongoid].clean
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end
end
