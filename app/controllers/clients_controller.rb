class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @clients = Client.order(:name).includes(:projects)
  end

  def show
  end

  def new
    @client = Client.new
  end

  def edit
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client, notice: "Cliente creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Cliente actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @client.destroy
      redirect_to clients_path, notice: "Cliente eliminado correctamente.", status: :see_other
    else
      redirect_to clients_path, alert: @client.errors[:base].to_sentence, status: :see_other
    end
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.expect(client: %i[name email])
  end
end
