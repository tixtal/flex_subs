# == Schema Information
#
# Table name: flex_subs_plans
#
#  id                 :integer          not null, primary key
#  grace_period_unit  :string
#  grace_period_value :decimal(, )
#  name               :string
#  price_cents        :integer          default(0), not null
#  price_currency     :string           default("USD"), not null
#  recurrence_unit    :string
#  recurrence_value   :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
module FlexSubs
  class Plan < ApplicationRecord
    include Recurrence

    monetize :price_cents, numericality: { greater_than_or_equal: 0 }

    has_many :subscriptions,
             class_name: 'FlexSubs::Subscription',
             dependent: :destroy
    has_many :featurables,
             class_name: 'FlexSubs::Featurable',
             as: :featurable,
             dependent: :destroy
    has_many :features,
             through: :featurables,
             class_name: 'FlexSubs::Feature'
  end
end
