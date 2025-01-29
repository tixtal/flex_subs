class SubscriberTest < ActiveSupport::TestCase
  setup do
    @guest = users(:guest)
    @free = users(:free)
    @premium = users(:premium_monthly)
  end

  test 'should be able to check if user is subscribed to a plan' do
    assert @premium.subscribed_to?(@premium.current_subscription.plan)
  end

  test 'should be able to subscribe when no subscription' do
    assert_difference 'FlexSubs::Subscription.count' do
      @guest.subscribe_to(flex_subs_plans(:premium_monthly))
    end

    @guest.reload

    assert @guest.current_subscription.present?
  end

  test 'should be able to subscribe when subscription is suppressed' do
    @free.current_subscription.suppress!

    assert_difference 'FlexSubs::Subscription.count' do
      @free.subscribe_to(flex_subs_plans(:premium_monthly))
    end

    @free.reload

    assert @free.current_subscription.present?
    assert_equal flex_subs_plans(:premium_monthly), @free.current_subscription.plan
    refute @free.current_subscription.suppressed?
  end

  test 'should be able to change subscription plan immediately' do
    @premium.subscriptions.where.not(id: @premium.current_subscription.id).destroy_all

    previous_subscription = @premium.current_subscription

    assert_difference 'FlexSubs::Subscription.count' do
      @premium.switch_plan_to(flex_subs_plans(:premium_yearly), immediate: true)
    end

    @premium.reload
    previous_subscription.reload

    refute_equal previous_subscription, @premium.current_subscription
    assert_equal flex_subs_plans(:premium_yearly), @premium.current_subscription.plan

    assert previous_subscription.suppressed?
    refute previous_subscription.active?
    refute previous_subscription.canceled?
  end

  test 'should be able to change subscription plan and active in next period' do
    @premium.subscriptions.where.not(id: @premium.current_subscription.id).destroy_all

    previous_subscription = @premium.current_subscription

    assert_difference 'FlexSubs::Subscription.count' do
      @premium.switch_plan_to(flex_subs_plans(:premium_yearly))
    end

    @premium.reload
    previous_subscription.reload

    assert_equal previous_subscription, @premium.current_subscription
    assert_equal previous_subscription.plan, @premium.current_subscription.plan

    assert previous_subscription.canceled?
    assert previous_subscription.active?
    refute previous_subscription.suppressed?
    assert @premium.subscribed_to?(flex_subs_plans(:premium_yearly))
  end
end