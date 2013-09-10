require 'rest-client'
require 'nokogiri'




namespace :data do
  desc "Scrape Teams to Database"
  task :scrape_teams => :environment do
    TeamScraper.scrape_teams
  end
  desc "Scrape News to Database"
  task :scrape_news => :environment do
    NewsScraper.scrape_news
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
    Team.delete_all

    (0..19).each do |x|

      t=Team.create
      # debugger
      t.name=team_array[x]
      t.games_won=win_array[x+1]
      t.games_lost=loss_array[x+1]
      t.games_drawn=draw_array[x+1]
      t.goals_for=goals_for[x+1]
      t.goals_against=goals_away[x+1]
      t.save
    end
  end
end

class NewsScraper
TEAM_NEWS_URL="http://www.bbc.co.uk/sport/football/teams/"

  def self.scrape_team_news(team)
    team_url=team.name.downcase.gsub(" ","-")
    page = Nokogiri::HTML(RestClient.get(TEAM_NEWS_URL+team_url))
    headlines = page.css("#more-headlines ul li a")
    headlines.each do |headline|
      news = News.new(:team_id => team.id)
      news.headline = headline.text
      news.url = headline.attribute("href").to_s
      news.save
    end
  end

  def self.scrape_news
    @teams=Team.all
    @teams.each do |team|
      scrape_team_news(team)
    end
  end

end
  









