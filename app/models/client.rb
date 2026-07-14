class Client < ApplicationRecord
  has_many :projects, dependent: :destroy

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  # A client may only be deleted when it has no active projects.
  # `prepend: true` guarantees this runs before the `dependent: :destroy`
  # callback, so no associated records are removed when the guard aborts.
  before_destroy :ensure_no_active_projects, prepend: true

  private

  def ensure_no_active_projects
    return unless projects.active.exists?

    errors.add(:base, :active_projects_exist)
    throw :abort
  end
end
