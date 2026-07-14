class Project < ApplicationRecord
  belongs_to :client
  has_many :tasks, dependent: :destroy

  enum :status, { active: "active", paused: "paused", completed: "completed" },
       default: :active, validate: true

  validates :title, presence: true
  validates :status, presence: true

  def total_tasks_count
    tasks.size
  end

  def completed_tasks_count
    tasks.count(&:done?)
  end

  # Completion percentage (integer 0–100) based on done vs. total tasks.
  # Counts in Ruby so an eager-loaded `tasks` association adds no queries.
  def progress
    return 0 if total_tasks_count.zero?

    ((completed_tasks_count.to_f / total_tasks_count) * 100).round
  end
end
