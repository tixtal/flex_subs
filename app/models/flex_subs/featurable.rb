# == Schema Information
#
# Table name: flex_subs_featurables
#
#  id                           :integer          not null, primary key
#  consumption_limit            :decimal(, )
#  consumption_recurrence_unit  :string
#  consumption_recurrence_value :decimal(, )
#  featurable_type              :string           not null
#  over_consumption_allowed     :boolean
#  price_cents                  :integer          default(0), not null
#  price_currency               :string           default("USD"), not null
#  units_per_price              :decimal(, )
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  featurable_id                :integer          not null
#  feature_id                   :integer          not null
#
# Indexes
#
#  index_flex_subs_featurables_on_featurable  (featurable_type,featurable_id)
#  index_flex_subs_featurables_on_feature_id  (feature_id)
#
# Foreign Keys
#
#  feature_id  (feature_id => flex_subs_features.id)
#
module FlexSubs
  class Featurable < ApplicationRecord
    include Recurrence

    belongs_to :feature, class_name: 'FlexSubs::Feature'
    belongs_to :featurable, polymorphic: true

    monetize :price_cents,
             numericality: { greater_than: 0 },
             if: :unlimited_consumption?

    validates :units_per_price,
              presence: true,
              numericality: { greater_than: 0 },
              if: :unlimited_consumption?

    def unlimited_consumption?
      consumption_limit.nil? || over_consumption_allowed?
    end
  end
end
