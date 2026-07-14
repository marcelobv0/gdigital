require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:website)
  end

  test "index lists projects" do
    get projects_url
    assert_response :success
    assert_match @project.title, response.body
  end

  test "index filters by status" do
    get projects_url(status: "completed")
    assert_response :success
    assert_match projects(:migration).title, response.body
    assert_no_match @project.title, response.body
  end

  test "index ignores an invalid status filter instead of erroring" do
    get projects_url(status: "bogus")
    assert_response :success
    assert_match @project.title, response.body
  end

  test "show displays a project with its progress" do
    get project_url(@project)
    assert_response :success
    assert_match "#{@project.progress}%", response.body
  end

  test "show highlights overdue tasks" do
    get project_url(@project)
    assert_response :success
    assert_match "task-overdue", response.body
  end

  test "new renders the form" do
    get new_project_url
    assert_response :success
  end

  test "create with valid params persists a project and redirects" do
    assert_difference("Project.count", 1) do
      post projects_url, params: { project: { title: "Proyecto Nuevo", status: "active", client_id: clients(:acme).id } }
    end
    assert_redirected_to project_url(Project.last)
  end

  test "create with invalid params does not persist" do
    assert_no_difference("Project.count") do
      post projects_url, params: { project: { title: "", status: "active", client_id: clients(:acme).id } }
    end
    assert_response :unprocessable_entity
  end

  test "update changes the project" do
    patch project_url(@project),
          params: { project: { title: @project.title, status: "paused", client_id: @project.client_id } }
    assert_redirected_to project_url(@project)
    assert_equal "paused", @project.reload.status
  end

  test "destroy removes a project" do
    assert_difference("Project.count", -1) do
      delete project_url(@project)
    end
    assert_redirected_to projects_url
  end
end
