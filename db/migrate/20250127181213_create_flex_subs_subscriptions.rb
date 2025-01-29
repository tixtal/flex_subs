class CreateFlexSubsSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :flex_subs_subscriptions do |t|
      t.references :plan, null: false, foreign_key: { to_table: :flex_subs_plans }
      t.references :subscriber, polymorphic: true
      t.boolean :on_trial, default: false
      t.datetime :starts_at
      t.datetime :ends_at
      t.datetime :canceled_at
      t.datetime :suppressed_at
      t.datetime :grace_period_ends_at

      t.timestamps
    end
  end
end
