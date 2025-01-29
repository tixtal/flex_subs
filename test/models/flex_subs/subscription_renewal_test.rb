require "test_helper"

class FlexSubs::SubscriptionRenewalTest < ActiveSupport::TestCase
  test 'should belong to subscription' do
    assert_respond_to FlexSubs::SubscriptionRenewal.new, :subscription
  end

  test 'should get overdue renewals' do
    renewal = flex_subs_subscription_renewals(:premium_monthly_user)

    renewal.update(
      renewed_at: 1.week.ago,
      subscription_ends_at: 1.month.ago,
      subscription_grace_period_ends_at: 1.month.ago + 1.week
    )

    assert renewal.overdue?
    assert_includes FlexSubs::SubscriptionRenewal.overdue, renewal

    renewal.update(
      renewed_at: 1.week.ago,
      subscription_ends_at: 1.week.ago,
      subscription_grace_period_ends_at: 1.week.ago + 1.week
    )

    refute renewal.overdue?
    refute_includes FlexSubs::SubscriptionRenewal.overdue, renewal
  end

  test 'should check for overdue' do
    renewal = flex_subs_subscription_renewals(:premium_monthly_user)

    renewal.update(
      renewed_at: 1.week.ago,
      subscription_ends_at: 1.month.ago,
      subscription_grace_period_ends_at: 1.month.ago + 1.week
    )

    assert renewal.overdue?

    renewal.update(
      renewed_at: 1.week.ago,
      subscription_ends_at: 1.week.ago,
      subscription_grace_period_ends_at: 1.week.ago + 1.week
    )

    refute renewal.overdue?
  end
end
