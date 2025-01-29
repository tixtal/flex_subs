class CreateFlexSubsPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :flex_subs_plans do |t|
      t.string :name
      t.decimal :grace_period_value
      t.string :grace_period_unit
      t.decimal :recurrence_value
      t.string :recurrence_unit
      t.monetize :price
      t.timestamps
    end
  end
end
