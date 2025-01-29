# frozen_string_literal: true

require 'money-rails'
require_relative 'flex_subs/version'
require_relative 'flex_subs/engine'
require_relative 'flex_subs/railtie'
require_relative 'flex_subs/errors'

module FlexSubs
  mattr_accessor :model_parent_class, default: 'ApplicationRecord'

  autoload :Subscriber, 'flex_subs/subscriber'

  mattr_accessor :consumption_price_calculation,
                 default: lambda { |feature:, featurable:, amount:, total_next_active_consumption:|
                   return 0 if total_next_active_consumption <= featurable.consumption_limit

                   featurable.price *
                     (amount / featurable.units_per_price)
                 }
end
