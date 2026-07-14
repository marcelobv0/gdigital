module ProjectsHelper
  def status_badge(project)
    tag.span t("project_statuses.#{project.status}"), class: "badge badge-#{project.status}"
  end
end
