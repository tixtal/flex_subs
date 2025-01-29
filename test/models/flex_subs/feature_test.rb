require "test_helper"

class FlexSubs::FeatureTest < ActiveSupport::TestCase
  test 'should have many featurables' do
    feature = FlexSubs::Feature.new

    assert_respond_to feature, :featurables
  end
end
