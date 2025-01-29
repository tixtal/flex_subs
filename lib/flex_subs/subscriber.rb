module FlexSubs
  module Subscriber
    extend ActiveSupport::Concern

    included do
      has_many :subscriptions,
               class_name: 'FlexSubs::Subscription',
               as: :subscriber,
               dependent: :destroy
      has_one :current_subscription,
              lambda {
                sql = <<-SQL.squish
                  starts_at < :current_time AND
                  suppressed_at IS NULL AND
                  (
                    grace_period_ends_at IS NULL OR
                    grace_period_ends_at > :current_time
                  ) AND
                  (
                    ends_at IS NULL OR
                    ends_at > :current_time
                  )
                SQL

                where(sql, current_time: Time.zone.now)
              }, class_name: 'FlexSubs::Subscription', as: :subscriber
    end

    def subscribed_to?(plan)
      subscriptions.active_and_next.where(plan:).exists?
    end

    def subscribe_to(plan)
      raise DoublePlanError if subscribed_to?(plan)

      starts_at = Subscription.calculate_starts_at(current_subscription)
      ends_at = starts_at + plan.recurrence if plan.renewable?
      grace_period_ends_at = ends_at + plan.grace_period if plan.grace_period?

      subscriptions.create!(
        plan:,
        starts_at:,
        ends_at:,
        grace_period_ends_at:
      )
    end

    def switch_plan_to(plan, immediate: false)
      raise NoActiveSubscriptionError unless current_subscription
      raise DoublePlanError if subscribed_to?(plan)

      if immediate
        current_subscription.suppress!
      else
        current_subscription.cancel!
      end

      subscribe_to(plan)
    end
  end
end
