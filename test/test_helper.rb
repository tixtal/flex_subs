# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require File.expand_path('dummy/config/environment.rb', __dir__)

ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]

require 'rails/test_help'

require 'flex_subs'
require 'minitest/hooks/default'
require 'minitest/autorun'

if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths << File.expand_path('fixtures', __dir__)
  ActionDispatch::IntegrationTest.fixture_paths << File.expand_path('fixtures', __dir__)
elsif ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('fixtures', __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
end

class ActiveSupport::TestCase
  fixtures :all
  self.file_fixture_path = File.expand_path('fixtures/files', __dir__)
end
