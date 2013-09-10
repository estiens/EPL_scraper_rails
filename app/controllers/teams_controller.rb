class TeamsController < ApplicationController
  
  def index
  @teams=Team.all
  end

  def show
  @Team = Team.find(params[:id])
  end

end
