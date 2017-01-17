if ENV['coverage'] == 'on'
  require 'simplecov'

  SimpleCov.start 'rails' do
    minimum_coverage 100

    # Groups
    add_group 'Services', 'app/services'
    add_group 'Workers', 'app/workers'
    add_group 'Generators', 'lib/generators'
  end
end
