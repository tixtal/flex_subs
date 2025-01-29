require "test_helper"

class FlexSubs::Subscription::StateTest < ActiveSupport::TestCase
  setup do
    @active_subscription = flex_subs_subscriptions(:premium_monthly_user)
    @suppressed_subscription = flex_subs_subscriptions(:suppressed_user)
    @canceled_subscription = flex_subs_subscriptions(:canceled_user)
    @next_subscription = flex_subs_subscriptions(:switched_premium_monthly_to_yearly_user)

    @active_trial_subscription = flex_subs_subscriptions(:trial_user)
    @inactive_trial_subscription = flex_subs_subscriptions(:inactive_trial_user)
  end

  test 'should be able to cancel subscription without suppressed' do
    @active_subscription.cancel!

    assert @active_subscription.canceled?
    refute @active_subscription.suppressed?
    refute @active_subscription.inactive?
    assert @active_subscription.active?
  end

  test 'should be able to suppress' do
    @active_subscription.suppress!

    assert @active_subscription.suppressed?
    assert @active_subscription.inactive?
  end

  test 'should be able to check suppressed subscription' do
    assert @suppressed_subscription.suppressed?
    assert @suppressed_subscription.inactive?
  end

  test 'should be able to check canceled subscription' do
    assert @canceled_subscription.canceled?
    refute @canceled_subscription.inactive?
  end

  test 'should be able to get active subscriptions' do
    active_subscriptions = FlexSubs::Subscription.active

    assert_includes active_subscriptions, @active_subscription
    assert_includes active_subscriptions, @canceled_subscription
    refute_includes active_subscriptions, @suppressed_subscription
  end

  test 'should be able to get active and next subscriptions' do
    active_and_next_subscriptions = FlexSubs::Subscription.active_and_next

    assert_includes active_and_next_subscriptions, @active_subscription
    assert_includes active_and_next_subscriptions, @canceled_subscription
    assert_includes active_and_next_subscriptions, @next_subscription
    refute_includes active_and_next_subscriptions, @suppressed_subscription
  end

  test 'should be able to get inactive subscriptions' do
    inactive_subscriptions = FlexSubs::Subscription.inactive

    refute_includes inactive_subscriptions, @active_subscription
    refute_includes inactive_subscriptions, @canceled_subscription
    assert_includes inactive_subscriptions, @suppressed_subscription
    assert_includes inactive_subscriptions, @next_subscription
  end

  test 'should be able to get expired subscriptions' do
    expired_subscriptions = FlexSubs::Subscription.expired

    refute_includes expired_subscriptions, @active_subscription
    refute_includes expired_subscriptions, @canceled_subscription
    refute_includes expired_subscriptions, @next_subscription
    refute_includes expired_subscriptions, @suppressed_subscription
  end

  test 'should check if on trial' do
    assert @active_trial_subscription.on_trial?
    assert @inactive_trial_subscription.on_trial?

    assert @active_trial_subscription.active?
    refute @inactive_trial_subscription.active?
  end

  test 'should get trial subscriptions' do
    trial_subscriptions = FlexSubs::Subscription.on_trial

    assert_includes trial_subscriptions, @active_trial_subscription
    assert_includes trial_subscriptions, @inactive_trial_subscription
    refute_includes trial_subscriptions, @active_subscription
    refute_includes trial_subscriptions, @canceled_subscription
    refute_includes trial_subscriptions, @next_subscription
    refute_includes trial_subscriptions, @suppressed_subscription

    active_trial_subscriptions = trial_subscriptions.active

    assert_includes active_trial_subscriptions, @active_trial_subscription
    refute_includes active_trial_subscriptions, @inactive_trial_subscription
  end
end
