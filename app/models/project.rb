class Project < ApplicationRecord
  belongs_to :client
  has_many :tasks, dependent: :destroy

  enum :status, { active: "active", paused: "paused", completed: "completed" },
       default: :active, validate: true

  validates :title, presence: true
  validates :status, presence: true

  # Completion percentage (integer 0–100) based on done vs. total tasks.
  # Counts in Ruby so an eager-loaded `tasks` association adds no queries.
  def progress
    total = tasks.size
    return 0 if total.zero?

    ((tasks.count(&:done?).to_f / total) * 100).round
  end
end
