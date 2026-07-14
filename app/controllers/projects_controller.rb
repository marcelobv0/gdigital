class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @status_filter = params[:status] if Project.statuses.key?(params[:status])
    @projects = Project.includes(:client, :tasks).order(created_at: :desc)
    @projects = @projects.where(status: @status_filter) if @status_filter
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: "Proyecto creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Proyecto actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Proyecto eliminado correctamente.", status: :see_other
  end

  private

  def set_project
    @project = Project.includes(:client, :tasks).find(params[:id])
  end

  def project_params
    params.expect(project: %i[title status client_id])
  end
end
