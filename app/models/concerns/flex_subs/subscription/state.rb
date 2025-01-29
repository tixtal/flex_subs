module FlexSubs
  module Subscription::State
    extend ActiveSupport::Concern

    included do # rubocop:disable Metrics/BlockLength
      scope :active,
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
            }

      scope :on_trial, -> { where(on_trial: true) }

      scope :active_and_next,
            lambda {
              sql = <<-SQL.squish
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
            }

      scope :inactive,
            lambda {
              sql = <<-SQL.squish
                starts_at > :current_time OR
                suppressed_at IS NOT NULL OR
                (
                  grace_period_ends_at IS NOT NULL AND
                  grace_period_ends_at < :current_time
                ) OR
                (ends_at < :current_time)
              SQL

              where(sql, current_time: Time.zone.now)
            }

      scope :expired,
            lambda {
              sql = <<-SQL.squish
                suppressed_at IS NULL AND
                (
                  grace_period_ends_at IS NULL OR
                  grace_period_ends_at > :current_time
                ) AND
                (ends_at < :current_time)
              SQL

              where(sql, current_time: Time.zone.now)
            }
    end

    def suppress!
      raise DoubleSuppressError if suppressed?

      update!(suppressed_at: Time.zone.now)
    end

    def suppressed?
      suppressed_at?
    end

    def cancel!
      raise DoubleCancelError if canceled?

      update!(canceled_at: Time.zone.now)
    end

    def canceled?
      canceled_at?
    end

    def active?
      return false if starts_at > Time.zone.now
      return false if suppressed?
      return false if expired?

      true
    end

    def inactive?
      !active?
    end

    def expires_at
      grace_period_ends_at || ends_at
    end

    def expired?
      return false if expires_at.nil?

      expires_at < Time.zone.now
    end
  end
end
