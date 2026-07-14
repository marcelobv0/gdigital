class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true

  scope :pending, -> { where(done: false) }
  scope :overdue, -> { pending.where("due_date < ?", Date.current) }

  # Past its due date and still not done. Tasks without a due date are never overdue.
  def overdue?
    !done? && due_date.present? && due_date < Date.current
  end
end
