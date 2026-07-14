require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "valid client is valid" do
    assert clients(:acme).valid?
  end

  test "requires a name" do
    client = Client.new(email: "new@example.com")
    assert_not client.valid?
    assert_includes client.errors[:name], "no puede estar en blanco"
  end

  test "requires an email" do
    client = Client.new(name: "No Email")
    assert_not client.valid?
    assert_includes client.errors[:email], "no puede estar en blanco"
  end

  test "rejects a malformed email" do
    client = Client.new(name: "Bad Email", email: "not-an-email")
    assert_not client.valid?
    assert_includes client.errors[:email], "no es válido"
  end

  test "normalizes and enforces case-insensitive email uniqueness" do
    duplicate = Client.new(name: "Dupe", email: clients(:acme).email.upcase)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "ya está en uso"
  end

  test "cannot be destroyed while it has active projects" do
    client = clients(:acme)
    assert client.projects.active.exists?, "fixture must have an active project"

    assert_no_difference "Client.count" do
      assert_not client.destroy
    end
    assert_includes client.errors[:base], "No se puede eliminar un cliente con proyectos activos"
  end

  test "can be destroyed when it has no active projects" do
    client = clients(:globex)
    assert_not client.projects.active.exists?

    assert_difference "Client.count", -1 do
      assert client.destroy
    end
  end
end
