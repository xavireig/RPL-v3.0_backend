class ExtendBraintreeCustomerIdSize < ActiveRecord::Migration[5.0]
  def self.up
    change_column :users, :braintree_customer_id, :integer, limit: 8
  end
end
