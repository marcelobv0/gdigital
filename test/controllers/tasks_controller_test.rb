require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:website)
  end

  test "create adds a task to the project" do
    assert_difference("Task.count", 1) do
      post project_tasks_url(@project), params: { task: { title: "Nueva tarea", due_date: 3.days.from_now.to_date } }
    end
    assert_redirected_to project_url(@project)
  end

  test "create with a blank title does not persist and shows an alert" do
    assert_no_difference("Task.count") do
      post project_tasks_url(@project), params: { task: { title: "" } }
    end
    assert_redirected_to project_url(@project)
    follow_redirect!
    assert_match "Título no puede estar en blanco", response.body
  end

  test "update toggles a task's done state" do
    task = tasks(:build)
    assert_not task.done?

    patch project_task_url(@project, task), params: { task: { done: "1" } }

    assert_redirected_to project_url(@project)
    assert task.reload.done?
  end
end
