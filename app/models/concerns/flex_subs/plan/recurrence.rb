module FlexSubs
  module Plan::Recurrence
    extend ActiveSupport::Concern

    def recurrence
      return unless recurrence?

      ActiveSupport::Duration.send(recurrence_unit, recurrence_value)
    end

    def recurrence?
      recurrence_value? && recurrence_unit?
    end

    def renewable?
      recurrence?
    end

    def grace_period
      return unless grace_period?

      ActiveSupport::Duration.send(grace_period_unit, grace_period_value)
    end

    def grace_period?
      grace_period_value? && grace_period_unit?
    end
  end
end
