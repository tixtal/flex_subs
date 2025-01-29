module FlexSubs
  module Featurable::Recurrence
    extend ActiveSupport::Concern

    def consumption_recurrence
      return unless consumption_recurrence?

      ActiveSupport::Duration.send(consumption_recurrence_unit, consumption_recurrence_value)
    end

    def consumption_recurrence?
      consumption_recurrence_value? && consumption_recurrence_unit?
    end

    def renewable_consumption?
      feature.consumable? && consumption_recurrence?
    end
  end
end