class Order < ApplicationRecord
  belongs_to :shopper, :class_name => "User"
  belongs_to :merchant, :class_name => "User"

  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  scope :completed, -> { where.not(completed_at: nil) }
  scope :incompleted, -> { where(completed_at: nil) }

  def complete!
    self.completed_at = Time.now
    self.save!
  end
end
