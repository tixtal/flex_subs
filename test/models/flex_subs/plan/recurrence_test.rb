require 'test_helper'

class FlexSubs::Plan::RecurrenceTest < ActiveSupport::TestCase
  test 'should be able to get recurrence' do
    plan = FlexSubs::Plan.new(recurrence_value: 1, recurrence_unit: 'months')

    assert plan.recurrence?
    assert_equal 1.month, plan.recurrence
  end

  test 'should be able to get recurrence when it is not set' do
    plan = FlexSubs::Plan.new

    refute plan.recurrence?
    assert_nil plan.recurrence
  end

  test 'should be able to get grace period' do
    plan = FlexSubs::Plan.new(grace_period_value: 1, grace_period_unit: 'weeks')

    assert plan.grace_period?
    assert_equal 1.weeks, plan.grace_period
  end

  test 'should be able to get grace period when it is not set' do
    plan = FlexSubs::Plan.new

    refute plan.grace_period?
    assert_nil plan.grace_period
  end
end