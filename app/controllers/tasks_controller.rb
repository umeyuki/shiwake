class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = Rails.cache.fetch("tasks/#{params[:team_id]}") do
      tasks = []
      page = 1
      data = ['a element']
      while data.present? && page < 100
        data = client.team_tasks(params[:team_id], 'all', page)
        tasks += data
        page += 1
      end
      tasks.sort { |a, b| a['path'] <=> b['path'] }
    end
    render formats: :json
  end

  def update
    client.update_team_task(params[:team_id], params[:id], { parent_id: params[:parent_id] })
    render json: {}
  end
end
