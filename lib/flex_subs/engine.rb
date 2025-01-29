require 'rails/engine'

module FlexSubs
  class Engine < Rails::Engine
    engine_name 'flex_subs'

    initializer 'flex_subs.load_subscriber' do
      ActiveSupport.on_load :active_record do
        def self.acts_as_subscriber
          include FlexSubs::Subscriber
        end
      end
    end
  end
end