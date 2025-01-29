# == Schema Information
#
# Table name: flex_subs_subscriptions
#
#  id                   :integer          not null, primary key
#  canceled_at          :datetime
#  ends_at              :datetime
#  grace_period_ends_at :datetime
#  starts_at            :datetime
#  subscriber_type      :string
#  suppressed_at        :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  plan_id              :integer          not null
#  subscriber_id        :integer
#
# Indexes
#
#  index_flex_subs_subscriptions_on_plan_id     (plan_id)
#  index_flex_subs_subscriptions_on_subscriber  (subscriber_type,subscriber_id)
#
# Foreign Keys
#
#  plan_id  (plan_id => flex_subs_plans.id)
#
module FlexSubs
  class Subscription < ApplicationRecord
    include State
    include Renewal
    include Feature

    belongs_to :subscriber, polymorphic: true
    belongs_to :plan, class_name: 'FlexSubs::Plan'

    def self.calculate_starts_at(subscription = nil)
      if subscription.blank? || subscription.ends_at.blank? || subscription.suppressed?
        Time.zone.now
      else
        subscription.ends_at
      end
    end
  end
end
