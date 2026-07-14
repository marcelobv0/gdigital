require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "valid task is valid" do
    assert tasks(:build).valid?
  end

  test "requires a title" do
    task = Task.new(project: projects(:website))
    assert_not task.valid?
    assert_includes task.errors[:title], "no puede estar en blanco"
  end

  test "requires a project" do
    task = Task.new(title: "Homeless task")
    assert_not task.valid?
  end

  test "overdue? is true when past due and not done" do
    assert tasks(:overdue_task).overdue?
  end

  test "overdue? is false when the task is done" do
    assert_not tasks(:design).overdue? # done, even though past due
  end

  test "overdue? is false when the due date is in the future" do
    assert_not tasks(:build).overdue?
  end

  test "overdue? is false when there is no due date" do
    assert_not Task.new(done: false, due_date: nil).overdue?
  end

  test "overdue scope returns only overdue tasks" do
    overdue = Task.overdue
    assert_includes overdue, tasks(:overdue_task)
    assert_not_includes overdue, tasks(:design)
    assert_not_includes overdue, tasks(:build)
  end
end
