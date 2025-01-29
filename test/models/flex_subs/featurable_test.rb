require "test_helper"

class FlexSubs::FeaturableTest < ActiveSupport::TestCase
  setup do
    @featurable = flex_subs_featurables(:free_deploy_minutes)
  end

  test 'should belong to featurable' do
    assert_respond_to @featurable, :featurable
  end

  test 'should belong to feature' do
    assert_respond_to @featurable, :feature
  end

  test 'should validate price numericality' do
    featurable = FlexSubs::Featurable.new(
      price: -1,
      over_consumption_allowed: true
    )

    refute featurable.valid?
    assert_includes featurable.errors.messages[:price],
                    'must be greater than 0'

    featurable.price = 10

    featurable.valid?

    refute_includes featurable.errors.messages[:price],
                    'must be greater than 0'
  end

  test 'should validate units per price numericality' do
    featurable = FlexSubs::Featurable.new(
      units_per_price: -1,
      over_consumption_allowed: true
    )

    refute featurable.valid?
    assert_includes featurable.errors.messages[:units_per_price],
                    'must be greater than 0'

    featurable.units_per_price = 10

    featurable.valid?

    refute_includes featurable.errors.messages[:units_per_price],
                    'must be greater than 0'
  end

  test 'should be able to set unlimited consumption limit' do
    featurable = FlexSubs::Featurable.new

    featurable.valid?

    assert featurable.unlimited_consumption?
  end
end
