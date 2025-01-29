require "test_helper"

class FlexSubs::SubscriptionTest < ActiveSupport::TestCase
  test 'should have subscriber' do
    subscription = FlexSubs::Subscription.new

    assert_respond_to subscription, :subscriber
  end

  test 'should have plan' do
    subscription = FlexSubs::Subscription.new

    assert_respond_to subscription, :plan
  end

  test 'should delegated to plan' do
    subscription = FlexSubs::Subscription.new

    assert_respond_to subscription, :features
    assert_respond_to subscription, :find_feature
    assert_respond_to subscription, :feature?
  end

  test 'should be able to get calculation of starts at in the end of period' do
    ends_at = Time.zone.now
    subscription = FlexSubs::Subscription.new(ends_at:)

    assert_equal ends_at, FlexSubs::Subscription.calculate_starts_at(subscription)
  end

  test 'should be able to get calculation of starts at immediately' do
    assert FlexSubs::Subscription.calculate_starts_at <= Time.zone.now
  end

  test 'should be able to get calculation of starts at immediately when subscription is suppressed' do
    subscription = FlexSubs::Subscription.new(ends_at: 20.days.from_now, suppressed_at: Time.zone.now)

    assert FlexSubs::Subscription.calculate_starts_at(subscription) <= Time.zone.now
  end
end
