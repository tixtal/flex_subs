require 'test_helper'

class FlexSubs::Featurable::RecurrenceTest < ActiveSupport::TestCase
  setup do
    @renewable_consumption = flex_subs_featurables(
      :free_deploy_minutes
    )

    @non_renewable_consumption = flex_subs_featurables(
      :free_file_storage
    )
  end

  test 'should get consumption recurrence' do
    assert_equal 1.day, @renewable_consumption.consumption_recurrence
  end

  test 'should get consumption recurrence when it is not set' do
    assert_nil @non_renewable_consumption.consumption_recurrence
  end

  test 'should check if consumption is have recurrence' do
    assert @renewable_consumption.consumption_recurrence?
    refute @non_renewable_consumption.consumption_recurrence?
  end

  test 'should check if consumption is renewable' do
    assert @renewable_consumption.renewable_consumption?
    refute @non_renewable_consumption.renewable_consumption?
  end
end