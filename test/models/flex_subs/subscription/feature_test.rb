require 'test_helper'

class FlexSubs::Subscription::FeatureTest < ActiveSupport::TestCase
  setup do
    @free_subscription_user = flex_subs_subscriptions(:free_user)
    @premium_monthly_user = flex_subs_subscriptions(:premium_monthly_user)
    @premium_yearly_user = flex_subs_subscriptions(:premium_yearly_user)
    @platinum_monthly_user = flex_subs_subscriptions(:platinum_monthly_user)
    @platinum_yearly_user = flex_subs_subscriptions(:platinum_yearly_user)
    @free_subscription_workspace = flex_subs_subscriptions(:free_workspace)
    @pay_as_you_go_monthly_user = flex_subs_subscriptions(:pay_as_you_go_monthly_user)

    @deploy_minutes_feature = flex_subs_features(:deploy_minutes)
    @file_storage_feature = flex_subs_features(:file_storage)
    @custom_domain_feature = flex_subs_features(:custom_domain)
  end

  test 'should have many consumptions' do
    assert_respond_to @free_subscription_user, :consumptions
  end

  test 'should be able to consume consumable feature' do
    @free_subscription_user.consumptions.destroy_all

    assert @free_subscription_user.feature?(@deploy_minutes_feature)

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count' do
      @free_subscription_user.consume!(@deploy_minutes_feature)
    end
  end

  test 'should not be able to consume non consumable feature' do
    @free_subscription_user.consumptions.destroy_all

    @deploy_minutes_feature.update!(consumable: false)

    assert_raise(FlexSubs::CannotConsumeError) do
      @free_subscription_user.consume!(@deploy_minutes_feature)
    end
  end

  test 'should not be able to consume with invalid amount' do
    @free_subscription_user.consumptions.destroy_all

    assert_raise(FlexSubs::InvalidConsumptionAmountError) do
      @free_subscription_user.consume!(@deploy_minutes_feature, amount: 0)
    end

    assert_raise(FlexSubs::InvalidConsumptionAmountError) do
      @free_subscription_user.consume!(@deploy_minutes_feature, amount: -1)
    end
  end

  test 'should be able to consume over consumption' do
    @premium_monthly_user.consumptions.destroy_all

    featurable = @premium_monthly_user.all_featurables
                                      .find_by(feature: @deploy_minutes_feature)

    assert featurable.over_consumption_allowed?

    limit = featurable.consumption_limit.to_i

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count', limit do
      limit.times do
        @premium_monthly_user.consume!(@deploy_minutes_feature)
      end
    end

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count' do
      @premium_monthly_user.consume!(@deploy_minutes_feature)
    end
  end

  test 'should not be able to consume over consumption' do
    @premium_monthly_user.consumptions.destroy_all

    featurable = @premium_monthly_user.all_featurables
                                      .find_by(feature: @deploy_minutes_feature)

    featurable.update!(over_consumption_allowed: false)

    refute featurable.over_consumption_allowed?

    limit = featurable.consumption_limit.to_i

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count', limit do
      limit.times do
        @premium_monthly_user.consume!(@deploy_minutes_feature)
      end
    end

    assert_raise(FlexSubs::CannotConsumeError) do
      @premium_monthly_user.consume!(@deploy_minutes_feature)
    end
  end

  test 'should be able to consume over consumption with custom amount' do
    @premium_monthly_user.consumptions.destroy_all

    featurable = @premium_monthly_user.all_featurables
                                      .find_by(feature: @deploy_minutes_feature)

    assert featurable.over_consumption_allowed?

    limit = featurable.consumption_limit.to_i

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count' do
      @premium_monthly_user.consume!(@deploy_minutes_feature, amount: limit)
    end

    @premium_monthly_user.reload

    assert_equal limit, @premium_monthly_user.consumptions.last.amount
    assert_equal 0, @premium_monthly_user.consumptions.last.price.to_i

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count' do
      @premium_monthly_user.consume!(@deploy_minutes_feature, amount: limit - 1)
    end

    assert_equal limit - 1, @premium_monthly_user.consumptions.last.amount
    refute_equal 0, @premium_monthly_user.consumptions.last.price.to_i

    expected_price = featurable.price *
                     ((limit - 1) / featurable.units_per_price)

    assert_equal expected_price, @premium_monthly_user.consumptions.last.price
  end

  test 'should not be able to consume over consumption with prorated amount price' do
    @premium_monthly_user.consumptions.destroy_all

    featurable = @premium_monthly_user.all_featurables
                                      .find_by(feature: @deploy_minutes_feature)

    assert featurable.over_consumption_allowed?

    limit = featurable.consumption_limit.to_i

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count' do
      @premium_monthly_user.consume!(@deploy_minutes_feature, amount: limit - 13)
    end

    @premium_monthly_user.reload

    assert_equal limit - 13, @premium_monthly_user.consumptions.last.amount
    assert_equal 0, @premium_monthly_user.consumptions.last.price.to_i

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count' do
      @premium_monthly_user.consume!(@deploy_minutes_feature, amount: 16)
    end

    assert_equal 16, @premium_monthly_user.consumptions.last.amount
    refute_equal 0, @premium_monthly_user.consumptions.last.price.to_i

    expected_price = featurable.price *
                     (16 / featurable.units_per_price)

    assert_equal expected_price, @premium_monthly_user.consumptions.last.price
  end

  test 'should be able to consume with custom price' do
    @free_subscription_user.consumptions.destroy_all

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count' do
      @free_subscription_user.consume!(@deploy_minutes_feature, price: 10)
    end

    assert_equal 10, @free_subscription_user.consumptions.last.price.to_i
  end

  test 'should be able to consume with custom expiration' do
    @free_subscription_user.consumptions.destroy_all

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count' do
      @free_subscription_user.consume!(@deploy_minutes_feature, expires_at: 1.day.from_now)
    end

    assert_equal 1.day.from_now.to_date, @free_subscription_user.consumptions.last.expires_at.to_date
  end

  test 'should be able to consume with custom consumer' do
    @free_subscription_user.consumptions.destroy_all

    assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count' do
      @free_subscription_workspace.consume!(
        @deploy_minutes_feature,
        consumer: @free_subscription_user.subscriber
      )
    end

    assert_equal @free_subscription_user.subscriber,
                 @free_subscription_workspace.consumptions.last.consumer
  end

  test 'should consume pay as you go feature' do
    assert @pay_as_you_go_monthly_user.feature?(@deploy_minutes_feature)
    assert @pay_as_you_go_monthly_user.consume?(@deploy_minutes_feature)

    3.times do |x|
      amount = x + 3

      assert_difference 'FlexSubs::SubscriptionFeatureConsumption.count' do
        @pay_as_you_go_monthly_user.consume!(@deploy_minutes_feature, amount:)
      end

      featurable = @pay_as_you_go_monthly_user.all_featurables
                                              .find_by(feature: @deploy_minutes_feature)

      expected_price = featurable.price *
                       (amount / featurable.units_per_price)

      assert_equal expected_price, @pay_as_you_go_monthly_user.consumptions.last.price
      assert @pay_as_you_go_monthly_user.consumptions.last.expires_at?
      assert_equal featurable.consumption_recurrence.from_now.to_date,
                   @pay_as_you_go_monthly_user.consumptions.last.expires_at.to_date
    end
  end
end
