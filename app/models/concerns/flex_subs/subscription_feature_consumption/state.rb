module FlexSubs
  module SubscriptionFeatureConsumption::State
    extend ActiveSupport::Concern

    included do
      scope :active, -> { where('expires_at IS NULL OR expires_at > ?', Time.zone.now) }
      scope :expired, -> { where('expires_at <= ?', Time.zone.now) }
    end

    def active?
      return true unless expires_at?

      expires_at > Time.zone.now
    end

    def expired?
      !active?
    end
  end
end