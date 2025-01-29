# == Schema Information
#
# Table name: flex_subs_subscription_feature_consumptions
#
#  id              :integer          not null, primary key
#  amount          :decimal(, )
#  consumer_type   :string
#  expires_at      :datetime
#  price_cents     :integer          default(0), not null
#  price_currency  :string           default("USD"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  consumer_id     :integer
#  feature_id      :integer          not null
#  subscription_id :integer          not null
#
# Indexes
#
#  idx_on_consumer_type_and_consumer_id_8a48f601ec  (consumer_type,consumer_id)
#  idx_on_feature_id_d45489aedb                     (feature_id)
#  idx_on_subscription_id_87bbc8031d                (subscription_id)
#
# Foreign Keys
#
#  feature_id       (feature_id => flex_subs_features.id)
#  subscription_id  (subscription_id => flex_subs_subscriptions.id)
#
module FlexSubs
  class SubscriptionFeatureConsumption < ApplicationRecord
    include State

    belongs_to :feature, class_name: 'FlexSubs::Feature'
    belongs_to :subscription, class_name: 'FlexSubs::Subscription'
    belongs_to :consumer, polymorphic: true, optional: true

    monetize :price_cents, numericality: { greater_than_or_equal_to: 0 }

    validates :amount, presence: true, numericality: { greater_than: 0 }
  end
end
