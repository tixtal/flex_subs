module FlexSubs
  module Subscription::Feature
    extend ActiveSupport::Concern

    included do
      has_many :consumptions,
               class_name: 'FlexSubs::SubscriptionFeatureConsumption',
               dependent: :destroy
      has_many :featurables,
               class_name: 'FlexSubs::Featurable',
               dependent: :destroy,
               as: :featurable
      has_many :features,
               through: :featurables,
               class_name: 'FlexSubs::Feature'
    end

    def consume!(feature, amount: 1.0, consumer: nil, price: nil, expires_at: nil)
      raise InvalidConsumptionAmountError if amount <= 0

      feature = find_feature(feature)
      amount = amount.to_f

      raise CannotConsumeError unless consume?(feature, amount:)

      featurable = all_featurables.find_by(feature:)
      price ||= calculate_consumption_price(feature, featurable, amount)
      expires_at ||= calculate_consumption_expiration(featurable)

      consumptions.create!(feature:, consumer:, amount:, price:, expires_at:)
    end

    def consume?(feature, amount: 1.0)
      raise InvalidConsumptionAmountError if amount <= 0

      return false unless active?

      feature = find_feature(feature)
      amount = amount.to_f

      return false if feature.nil? || !feature.consumable?

      featurable = all_featurables.find_by(feature:)

      return true if featurable.unlimited_consumption?

      next_consumption = total_active_consumption(feature) + amount

      featurable.consumption_limit >= next_consumption
    end

    def total_active_consumption(feature)
      feature = find_feature(feature)

      consumptions.active.where(feature:).sum(:amount)
    end

    def feature?(feature)
      find_feature(feature).present?
    end

    def find_feature(feature)
      return all_features.find_by(name: feature) unless feature.is_a?(FlexSubs::Feature)

      return unless all_features.include?(feature)

      feature
    end

    def find_featurable(feature)
      all_featurables.find_by(feature:)
    end

    def all_features
      features.or(plan.features)
    end

    def all_featurables
      featurables.or(plan.featurables)
    end

    private

    def calculate_consumption_price(feature, featurable, amount)
      return 0 if on_trial?

      total_next_active_consumption = total_active_consumption(feature) + amount

      return 0 if total_next_active_consumption <= featurable.consumption_limit

      FlexSubs.consumption_price_calculation.call(
        feature:,
        featurable:,
        amount:,
        total_next_active_consumption:
      )
    end

    def calculate_consumption_expiration(featurable)
      if featurable.renewable_consumption?
        featurable.consumption_recurrence.from_now
      else
        expires_at
      end
    end
  end
end
