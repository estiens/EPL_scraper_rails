require 'rest-client'
require 'nokogiri'



namespace :data do
  desc "Scrape Teams to Database"
  task :scrape_teams => :environment do
    TeamScraper.scrape_teams
  end
end

class TeamScraper

  EPL_TABLE_URL= "http://www.premierleague.com/en-gb/matchday/league-table.html"

  def self.scrape_teams
    page = Nokogiri::HTML(RestClient.get(EPL_TABLE_URL))

    team_array= page.css(".leagueTable td.col-club").map(&:text)
    win_array = page.css(".col-w").map(&:text)
    loss_array = page.css(".col-l").map(&:text)
    draw_array = page.css(".col-d").map(&:text)
    goals_for = page.css(".col-gf").map(&:text)
    goals_away = page.css(".col-ga").map(&:text)

    #creating teams
    (0..19).each do |x|
      t=Team.create
      debugger
      t.name=team_array[x]
      t.games_won=win_array[x+1]
      t.games_lost=loss_array[x+1]
      t.games_drawn=draw_array[x+1]
      t.goals_for=goals_for[x+1]
      t.goals_against=goals_away[x+1]
      t.save!
    end
  end
  end

end




