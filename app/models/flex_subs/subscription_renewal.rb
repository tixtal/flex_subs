# == Schema Information
#
# Table name: flex_subs_subscription_renewals
#
#  id                                :integer          not null, primary key
#  renewed_at                        :datetime
#  subscription_ends_at              :datetime
#  subscription_grace_period_ends_at :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  subscription_id                   :integer          not null
#
# Indexes
#
#  idx_on_subscription_id_351581098b  (subscription_id)
#
# Foreign Keys
#
#  subscription_id  (subscription_id => flex_subs_subscriptions.id)
#
module FlexSubs
  class SubscriptionRenewal < ApplicationRecord
    belongs_to :subscription, class_name: 'FlexSubs::Subscription'

    validates :renewed_at, presence: true

    scope :overdue, lambda {
      where('
        renewed_at > COALESCE(
          subscription_grace_period_ends_at,
          subscription_ends_at
        )
      ')
    }

    def overdue?
      renewed_at > if subscription_grace_period_ends_at?
                     subscription_grace_period_ends_at
                   else
                     subscription_ends_at
                   end
    end
  end
end
