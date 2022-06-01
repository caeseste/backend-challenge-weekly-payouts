require "bigdecimal"

class Order < ApplicationRecord
  belongs_to :shopper, :class_name => "User"
  belongs_to :merchant, :class_name => "User"

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  scope :completed, -> { where.not(completed_at: nil) }
  scope :incompleted, -> { where(completed_at: nil) }

  # Complete the order
  def complete!
    self.completed_at = Time.now
    self.save!
  end

  # Find all the orders that are completed for a given week
  # of a given date
  # @param [Date] date the date to find the orders
  def self.filter_by_week date
    week_start = date.monday
    week_end = date.sunday
    self.where("completed_at >= ? AND completed_at <= ?", week_start, week_end)
  end

  # Calculate the total amount of the orders
  # @param [Array] orders
  def self.total_amount orders
    total_amount = orders.inject(0) do |sum, order|
      amount = (order.amount*100).to_i
      sum + BigDecimal(amount_i)
    end
    (total_amount/100).to_f
  end

  # Calculate the total amount of the orders
  def self.disbursed_amount orders
    disbursed = orders.inject(0) do |sum, order|
      disbursed_amount_i = (order.disbursed_amount*100).to_i
      sum + BigDecimal(disbursed_amount_i)
    end
    (disbursed/100).to_f
  end

  # Calculate the disbursed amount of the order
  def disbursed_amount
    amount_bd = BigDecimal(self.amount * 100)
    if self.amount < 50
      fee = (amount_bd/BigDecimal(100)).truncate(2)
    elsif self.amount >= 50 && self.amount <= 300
      fee = (amount_bd * (BigDecimal("0.95")/BigDecimal(100))).truncate(2)
    elsif self.amount > 300
      fee = (amount_bd * (BigDecimal("0.85")/BigDecimal(100))).truncate(2)
    end
    ((amount_bd - fee)/100).to_f
  end
end
