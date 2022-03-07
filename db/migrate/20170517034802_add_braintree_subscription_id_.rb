class AddBraintreeSubscriptionId < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :braintree_subscription_id, :string
    add_column :users, :braintree_customer_id, :integer
  end
end
