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
  def self.completed_orders
    if self.user_type == "merchant"
      self.sales_orders.completed
    else
      self.purchase_orders.completed
    end
  end

  # Get all the orders that are incompleted
  def self.incompleted_orders
    if self.user_type == "merchant"
      self.sales_orders.incompleted
    else
      self.purchase_orders.incompleted
    end
  end

end
