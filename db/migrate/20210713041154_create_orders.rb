class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.date :date
      t.datetime :delivered_at
      t.bigint :user_id
      t.string :status
      t.decimal :price

      t.timestamps
    end
  end
end
