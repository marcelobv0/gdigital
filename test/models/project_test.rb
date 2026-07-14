require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "valid project is valid" do
    assert projects(:website).valid?
  end

  test "requires a title" do
    project = Project.new(status: "active", client: clients(:acme))
    assert_not project.valid?
    assert_includes project.errors[:title], "can't be blank"
  end

  test "requires a client" do
    project = Project.new(title: "Orphan", status: "active")
    assert_not project.valid?
  end

  test "defaults status to active" do
    assert_equal "active", Project.new.status
  end

  test "rejects an unknown status" do
    project = Project.new(title: "X", client: clients(:acme), status: "archived")
    assert_not project.valid?
  end

  test "progress is 0 when there are no tasks" do
    assert_equal 0, projects(:paused_app).progress
  end

  test "progress reflects the ratio of completed tasks" do
    # website fixture: 1 of 3 tasks done => 33%
    assert_equal 33, projects(:website).progress
  end

  test "status scopes filter projects" do
    assert_includes Project.active, projects(:website)
    assert_not_includes Project.active, projects(:migration)
  end
end
