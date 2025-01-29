require 'test_helper'

class FlexSubs::SubscriptionFeatureConsumption::StateTest < ActiveSupport::TestCase
  setup do
    @active_consumption = flex_subs_subscription_feature_consumptions(
      :free_user_deploy_minutes_active
    )

    @inactive_consumption = flex_subs_subscription_feature_consumptions(
      :free_user_deploy_minutes_inactive
    )
  end

  test 'should belong to subscription' do
    assert_respond_to @active_consumption, :subscription
  end

  test 'should belong to feature' do
    assert_respond_to @active_consumption, :feature
  end

  test 'should belong to consumer' do
    assert_respond_to @active_consumption, :consumer
  end

  test 'should get active consumptions' do
    active_consumptions = FlexSubs::SubscriptionFeatureConsumption.active

    assert_includes active_consumptions, @active_consumption
    refute_includes active_consumptions, @inactive_consumption
  end

  test 'should get expired consumptions' do
    expired_consumptions = FlexSubs::SubscriptionFeatureConsumption.expired

    assert_includes expired_consumptions, @inactive_consumption
    refute_includes expired_consumptions, @active_consumption
  end

  test 'should check if consumption is active' do
    assert @active_consumption.active?
    refute @active_consumption.expired?
  end

  test 'should check if consumption is expired' do
    assert @inactive_consumption.expired?
    refute @inactive_consumption.active?
  end
end