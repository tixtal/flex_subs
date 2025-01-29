class CreateFlexSubsSubscriptionRenewals < ActiveRecord::Migration[8.0]
  def change
    create_table :flex_subs_subscription_renewals do |t|
      t.references :subscription, null: false, foreign_key: { to_table: :flex_subs_subscriptions }
      t.datetime :subscription_ends_at
      t.datetime :subscription_grace_period_ends_at
      t.datetime :renewed_at
      t.timestamps
    end
  end
end
