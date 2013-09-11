class Team < ActiveRecord::Base
  has_many :news
  has_one :fixture
  
  def points
    points=(3*games_won)+ games_drawn
  end

  def goal_difference
    goal_difference=(goals_for-goals_against)
  end

end
