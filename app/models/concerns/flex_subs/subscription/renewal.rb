module FlexSubs
  module Subscription::Renewal
    extend ActiveSupport::Concern

    included do
      has_many :renewals,
               class_name: 'FlexSubs::SubscriptionRenewal',
               dependent: :destroy
    end

    def renew(renewed_at: Time.zone.now, ends_at: nil)
      raise NotRenewablePlanError unless plan.renewable?

      ends_at ||= plan.recurrence.from_now
      grace_period_ends_at = ends_at + plan.grace_period if plan.grace_period?

      renewals.create!(
        renewed_at:,
        subscription_ends_at: self.ends_at,
        subscription_grace_period_ends_at: self.grace_period_ends_at
      )

      update!(ends_at:, grace_period_ends_at:)
    end
  end
end
