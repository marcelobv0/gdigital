module ProjectsHelper
  def status_badge(project)
    tag.span t("project_statuses.#{project.status}"), class: "badge badge-#{project.status}"
  end

  # Pending tasks first, then by due date (undated tasks last within each group).
  def sorted_tasks(project)
    project.tasks.sort_by { |task| [ task.done? ? 1 : 0, task.due_date || Date.new(9999, 12, 31) ] }
  end
end
