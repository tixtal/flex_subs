require "test_helper"

class FlexSubs::PlanTest < ActiveSupport::TestCase
  setup do
    @plan = flex_subs_plans(:premium_monthly)
  end

  test 'should have many featurables' do
    assert_respond_to @plan, :featurables
  end

  test 'should have many features through featurables' do
    assert_respond_to @plan, :features
  end

  test 'should have many subscriptions' do
    assert_respond_to @plan, :subscriptions
  end

  test 'should be able to create free plan' do
    assert_difference 'FlexSubs::Plan.count' do
      FlexSubs::Plan.create(name: 'Free')
    end

    assert_difference 'FlexSubs::Plan.count' do
      FlexSubs::Plan.create(name: 'Free', price: 0)
    end
  end
end
