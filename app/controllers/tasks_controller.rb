class TasksController < ApplicationController
  # before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  before_action :set_task, only: [:show, :edit, :update]
  
  def index
    #    @tasks = Task.all
    if logged_in?
      @task = current_user.tasks.build  # form_with 用
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
  end

  def show
    #@task = current_user.tasks(id: @task.id)
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Task が正常に登録されました'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'Task が登録されませんでした'
      render 'tasks/new'
    end
  end

  def edit
  end

  def update


    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
    #redirect_back(fallback_location: root_path)
  end
  
  private

  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def task_params
    params.require(:task).permit(:content ,:status)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end

end
