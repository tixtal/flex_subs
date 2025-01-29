# == Schema Information
#
# Table name: flex_subs_features
#
#  id         :integer          not null, primary key
#  consumable :boolean          default(FALSE)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module FlexSubs
  class Feature < ApplicationRecord
    has_many :featurables,
             class_name: 'FlexSubs::Featurable',
             dependent: :destroy
  end
end
