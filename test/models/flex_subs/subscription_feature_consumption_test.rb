require "test_helper"

class FlexSubs::SubscriptionFeatureConsumptionTest < ActiveSupport::TestCase
  test 'should belong to subscription' do
    assert_respond_to FlexSubs::SubscriptionFeatureConsumption.new, :subscription
  end

  test 'should belong to feature' do
    assert_respond_to FlexSubs::SubscriptionFeatureConsumption.new, :feature
  end

  test 'should belong to consumer' do
    assert_respond_to FlexSubs::SubscriptionFeatureConsumption.new, :consumer
  end

  test 'should validate price numericality' do
    consumption = FlexSubs::SubscriptionFeatureConsumption.new(price: -1)

    refute consumption.valid?
    assert_includes consumption.errors.messages[:price], 'must be greater than or equal to 0'
  end
end
