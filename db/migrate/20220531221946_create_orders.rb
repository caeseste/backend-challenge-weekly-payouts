class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.belongs_to :merchant, through: :users, null: false
      t.belongs_to :shopper, through: :users, null: false
      t.decimal :amounnt, precision: 10, scale: 2, null: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
