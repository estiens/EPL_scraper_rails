require 'rest-client'
require 'nokogiri'
require 'twitter'
namespace :data do
  desc "import data from files to database"
  task :import => :environment do
    TeamScraper.scrape_teams
  end
# class Team

#   attr_accessor :name, :wins, :losses, :draws, :goals_for, :goals_away, :status

#   def initialize(name,wins,losses,draws,goals_for,goals_away,status)
#     @name=name
#     @wins=wins.to_i
#     @losses=losses.to_i
#     @draws=draws.to_i
#     @goals_for=goals_for.to_i
#     @goals_away=goals_away.to_i
#     @status=status
#   end

#   def points
#     points=(3*wins)+ draws
#   end

#   def goal_difference
#     goal_difference=(goals_for-goals_away)
#   end

# end

# class News
#   attr_accessor :headline, :url

#   def initialize(headline,url)
#     @headline=headline
#     @url=url
#   end
# end

# class Database

#   attr_accessor :team_array, :news_array, :tweet_array

#   def initialize
#     @team_array=[]
#     @news_array=[]
#     @tweet_array=[]
#   end

# end

class TeamScraper

  EPL_TABLE_URL= "http://www.premierleague.com/en-gb/matchday/league-table.html"
  @team_hash={}
  def scrape_teams
    page = Nokogiri::HTML(RestClient.get(EPL_TABLE_URL))

    team_array= page.css(".leagueTable td.col-club").map(&:text)
    win_array = page.css(".col-w").map(&:text)
    loss_array = page.css(".col-l").map(&:text)
    draw_array = page.css(".col-d").map(&:text)
    goals_for = page.css(".col-gf").map(&:text)
    goals_away = page.css(".col-ga").map(&:text)

    #creating teams
    for x in (0..19)
      @team.new
      @team.name=team_array[x]
      @team.wins=win_array[x+1]
      @team.losses=loss_array[x+1]
      @team.draws=draw_array[x+1]
      @team.goals_for=goals_for[x+1]
      @team.goals_away=goals_away[x+1]
      @team.save
    end

  #   @db.team_array.sort_by! {|x| [-x.points, -x.goal_difference, -x.goals_for]}
  #   for x in (0..@db.team_array.length-1)
  #     @db.team_array[x].status="champions" if x > -1 && x < 4
  #     @db.team_array[x].status="europa" if x == 4
  #     @db.team_array[x].status="relegation" if x > 16
  #   end
  #   return @db.team_array
  # end
end

# class NewsScraper

#   BBC_NEWS_URL="http://www.bbc.co.uk/sport/football/teams/"
#   EPLFEEDS_NEWS_URL="http://eplfeeds.com/"

  # def scrape_bbc(team)
  #   page = Nokogiri::HTML(RestClient.get(BBC_NEWS_URL+team))
  #   headlines = page.css("#more-headlines ul li a")

  #   @db=Database.new

  #   headlines.each do |headline|
  #     @db.news_array<<News.new(headline.text, headline.attribute('href').to_s, )
  #   end
  #   @db.news_array.each do |x|
  #     puts "#{x.headline}--BBC"
  #   end
  #   @db.news_array
  # end

#   def scrape_epl(team)
#     page = Nokogiri::HTML(RestClient.get(EPLFEEDS_NEWS_URL+team+".php"))
#     headlines = page.css(".content h2 a")

#     @db=Database.new

#     headlines.each do |headline|
#       @db.news_array<<News.new(headline.text, headline.attribute('href').to_s, )
#     end
#     @db.news_array.each do |x|
#       puts "#{x.headline}--EPL"
#     end
#     @db.news_array
#   end
# end

# # class TweetScraper

# #   Twitter.configure do |config|
# #   config.consumer_key = "EAhY8dHmZgMHrcztSxdg"
# #   config.consumer_secret = "1ddwMrOiTPAHSMCaUAZMaDUyjvvqIYpEqQlqK8R13c"
# #   config.oauth_token = "15913837-Iy0DKKHbwqlq3hFk0z660nd6gyz8Zsu0XCCMpLLEv"
# #   config.oauth_token_secret = "1ccl3H19nwFuZCYLbN2c74OWggw8LeW1iLSpeS4563g"
# #   end

# #   def scrape_tweets(name)
# #     tweets = Twitter.search("\##{name}fc -rt", :count => 8).results
   
# #   end
# # end

