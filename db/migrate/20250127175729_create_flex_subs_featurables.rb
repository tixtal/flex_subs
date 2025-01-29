class CreateFlexSubsFeaturables < ActiveRecord::Migration[8.0]
  def change
    create_table :flex_subs_featurables do |t|
      t.references :feature, null: false, foreign_key: { to_table: :flex_subs_features }
      t.references :featurable, null: false, polymorphic: true
      t.decimal :consumption_limit
      t.decimal :consumption_recurrence_value
      t.string :consumption_recurrence_unit
      t.boolean :over_consumption_allowed
      t.monetize :price
      t.decimal :units_per_price
      t.timestamps
    end
  end
end
