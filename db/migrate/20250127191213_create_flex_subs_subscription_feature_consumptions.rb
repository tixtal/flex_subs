class CreateFlexSubsSubscriptionFeatureConsumptions < ActiveRecord::Migration[8.0]
  def change
    create_table :flex_subs_subscription_feature_consumptions do |t|
      t.references :subscription, null: false, foreign_key: { to_table: :flex_subs_subscriptions }
      t.references :feature, null: false, foreign_key: { to_table: :flex_subs_features }
      t.references :consumer,
                   polymorphic: true,
                   index: {
                     name: 'idx_on_consumer_type_and_consumer_id_8a48f601ec'
                   }
      t.decimal :amount
      t.monetize :price
      t.datetime :expires_at
      t.timestamps
    end
  end
end
