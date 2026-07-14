class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: :update

  def create
    @task = @project.tasks.build(task_params)

    if @task.save
      redirect_to @project, notice: "Tarea creada correctamente."
    else
      redirect_to @project, alert: @task.errors.full_messages.to_sentence
    end
  end

  def update
    @task.update(task_toggle_params)
    redirect_to @project
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.expect(task: %i[title due_date])
  end

  def task_toggle_params
    params.expect(task: [ :done ])
  end
end
