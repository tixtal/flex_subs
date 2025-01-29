require "test_helper"

class FlexSubs::Subscription::RenewalTest < ActiveSupport::TestCase
  setup do
    @renewable_subscription = flex_subs_subscriptions(:premium_monthly_user)
    @not_renewable_subscription = flex_subs_subscriptions(:free_user)
  end

  test 'should have many renewals' do
    subscription = FlexSubs::Subscription.new

    assert_respond_to subscription, :renewals
  end

  test 'should be able to renew subscription' do
    assert_difference 'FlexSubs::SubscriptionRenewal.count' do
      @renewable_subscription.renew
    end

    assert @renewable_subscription.ends_at > Time.zone.now
    assert @renewable_subscription.grace_period_ends_at > Time.zone.now
  end

  test 'should be able to renew subscription with custom ends_at' do
    ends_at = 1.month.from_now

    assert_difference 'FlexSubs::SubscriptionRenewal.count' do
      @renewable_subscription.renew(ends_at:)
    end

    assert_equal ends_at, @renewable_subscription.ends_at
    assert ends_at + @renewable_subscription.plan.grace_period, @renewable_subscription.grace_period_ends_at
  end

  test 'should be able to renew subscription with custom renewed_at' do
    renewed_at = Time.zone.now

    assert_difference 'FlexSubs::SubscriptionRenewal.count' do
      @renewable_subscription.renew(renewed_at:)
    end

    assert_equal renewed_at, @renewable_subscription.renewals.last.renewed_at
  end

  test 'should be able to renew subscription with custom ends_at and renewed_at' do
    ends_at = 1.month.from_now
    renewed_at = Time.zone.now

    assert_difference 'FlexSubs::SubscriptionRenewal.count' do
      @renewable_subscription.renew(renewed_at:, ends_at:)
    end

    assert_equal ends_at, @renewable_subscription.ends_at
    assert ends_at + @renewable_subscription.plan.grace_period, @renewable_subscription.grace_period_ends_at
    assert_equal renewed_at, @renewable_subscription.renewals.last.renewed_at
  end

  test 'should raise error when renewing non renewable plan' do
    assert_raise(FlexSubs::NotRenewablePlanError) do
      @not_renewable_subscription.renew
    end
  end
end
