require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    @project = projects(:website)
  end

  test "adding a task from the project page" do
    visit project_path(@project)

    fill_in "Nueva tarea", with: "Escribir documentación"
    click_on "Agregar tarea"

    assert_text "Escribir documentación"
  end

  test "toggling a task's checkbox marks it done and updates progress" do
    task = tasks(:build) # a pending task in the website project
    checkbox = "#done_task_#{task.id}"

    visit project_path(@project)
    assert_no_selector "#{checkbox}:checked"

    find(checkbox).click # fires change -> auto-submit (Stimulus), no inline JS

    assert_selector "#{checkbox}:checked"
    assert task.reload.done?
  end
end
