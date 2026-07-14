require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client = clients(:acme)
  end

  test "index lists clients" do
    get clients_url
    assert_response :success
    assert_match @client.name, response.body
  end

  test "show displays a client" do
    get client_url(@client)
    assert_response :success
    assert_match @client.email, response.body
  end

  test "new renders the form" do
    get new_client_url
    assert_response :success
  end

  test "create with valid params persists a client and redirects" do
    assert_difference("Client.count", 1) do
      post clients_url, params: { client: { name: "Nueva Empresa", email: "nueva@example.com" } }
    end
    assert_redirected_to client_url(Client.last)
  end

  test "create with invalid params does not persist and re-renders the form" do
    assert_no_difference("Client.count") do
      post clients_url, params: { client: { name: "", email: "not-an-email" } }
    end
    assert_response :unprocessable_entity
  end

  test "update with valid params changes the client and redirects" do
    patch client_url(@client), params: { client: { name: "Acme Actualizado", email: @client.email } }
    assert_redirected_to client_url(@client)
    assert_equal "Acme Actualizado", @client.reload.name
  end

  test "destroy removes a client with no active projects" do
    client = clients(:globex)
    assert_difference("Client.count", -1) do
      delete client_url(client)
    end
    assert_redirected_to clients_url
  end

  test "destroy is blocked for a client with an active project" do
    assert_no_difference("Client.count") do
      delete client_url(@client)
    end
    assert_redirected_to clients_url
    follow_redirect!
    assert_match "No se puede eliminar un cliente con proyectos activos", response.body
  end
end
