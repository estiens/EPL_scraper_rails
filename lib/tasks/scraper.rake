require 'rest-client'
require 'nokogiri'
require 'open-uri'




namespace :data do
  desc "Scrape Teams and News to Database"
  task :scrape_teams => :environment do
    TeamScraper.scrape_teams
  end
  desc "Scrape News to Database"
  task :scrape_news => :environment do
    NewsScraper.scrape_news
  end
  desc "Scrape Fixtures to Database"
  task :scrape_fixtures => :environment do
    NewsScraper.scrape_fixtures
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
    #Team.delete_all

    (0..19).each do |x|

      t=Team.find_or_create_by_name(team_array[x])
      # debugger
      # t.name=team_array[x]
      t.games_won=win_array[x+1]
      t.games_lost=loss_array[x+1]
      t.games_drawn=draw_array[x+1]
      t.goals_for=goals_for[x+1]
      t.goals_against=goals_away[x+1]
      puts "#{t.name} updated"
      t.save
    end
  end
end

class NewsScraper
BBC_NEWS_URL="http://www.bbc.co.uk/sport/football/teams/"
TEAM_INFO_NEWS_URL="http://www.teamtalk.com/"

  def self.scrape_bbc_news(team)
    print "\nScraping BBC for #{team.name}"
    team_url=team.name.downcase.gsub(" ","-")
    page = Nokogiri::HTML(RestClient.get(BBC_NEWS_URL+team_url))
    headlines = page.css("#more-headlines ul li a")
    headlines.each do |headline|
      news = News.new(:team_id => team.id)
      news.headline = headline.text
      news.url = headline.attribute("href").to_s
      news.source = "BBC NEWS"
      news.save
      print "."
    end
  end

  def self.scrape_other_news(team)
    print "\nScraping Team Feeds for #{team.name}"
    team_url=team.name.downcase.gsub(" ","-")
    doc = Nokogiri::XML(open(TEAM_INFO_NEWS_URL+team_url+"/rss"))
    items = doc.xpath("//item")
    items.each do |item|
      news = News.new(:team_id => team.id)
      news.headline = item.at_xpath("title").text
      news.url = item.at_xpath("link").text
      news.source = "TEAM INFO"
      news.save
      print "."
    end
  end

  def self.scrape_team_fixtures(team)
    puts "scraping team fixtures for #{team.name}"
    team_url=team.name.downcase.gsub(" ","-")
    page = Nokogiri::HTML(RestClient.get(BBC_NEWS_URL+team_url))
    f=Fixture.new(:team_id => team.id)
    f.last_match_team=page.css("#last-match a span").text
    f.last_match_result=page.css("#last-match span.match-outcome").text.strip+" "+page.css("#last-match span.match-score").text.strip.gsub("\n","").gsub("                         "," ").gsub("    ",  " ")
    f.next_match_team=page.css("#next-match a span").text
    f.next_match_time=page.css("#next-match span.microdata-hide").text.strip.to_s.gsub("T00:00:00+01:00","")
    f.save
  end

  def self.scrape_news
    @teams=Team.all
    News.delete_all
    @teams.each do |team|
      scrape_bbc_news(team)
    end
    @teams.each do |team|
      scrape_other_news(team)
    end
  end

  def self.scrape_fixtures
    @teams=Team.all
    Fixture.delete_all
    @teams.each do |team|
      scrape_team_fixtures(team)
    end
  end


end
