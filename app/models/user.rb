class User < ApplicationRecord
  has_many :sales_orders, :class_name => "Order", :foreign_key => "merchant_id"
  has_many :purchase_orders, :class_name => "Order", :foreign_key => "shopper_id"

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :rfc, presence: true
  validates :user_type, presence: true

  scope :merchants, -> { where(user_type: "merchant") }
  scope :shoppers, -> { where(user_type: "shopper") }

  # Get all the orders that are completed
  def completed_orders
    self.orders.completed
  end

  # Get all the orders that are incompleted
  def incompleted_orders
    self.orders.incompleted
  end

  # Get all orders depending on the user type
  def orders
    if self.user_type == "merchant"
      self.sales_orders
    else
      self.purchase_orders
    end
  end

end
