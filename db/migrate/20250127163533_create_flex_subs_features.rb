class CreateFlexSubsFeatures < ActiveRecord::Migration[8.0]
  def change
    create_table :flex_subs_features do |t|
      t.string :name
      t.boolean :consumable, default: false
      t.timestamps
    end
  end
end
