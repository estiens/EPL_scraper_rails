class Team < ActiveRecord::Base
  has_many :news, :dependent => :destroy
  has_one :fixture, :dependent => :destroy
  
  def points
    points=(3*games_won)+ games_drawn
  end

  def goal_difference
    goal_difference=(goals_for-goals_against)
  end

end
