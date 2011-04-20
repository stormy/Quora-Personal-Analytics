require 'rubygems'
require 'pp'
require 'date'
require 'watir'

STDOUT.sync = true # terminal setting so print "*" actually displays

directory = "#{ENV['HOME']}/Quora-Personal-Analytics"

if not Dir.pwd == directory
  Dir.chdir directory
end

Watir::Browser.default = 'firefox'

b = Watir::Browser.new

name = ARGV[0]

def click_more(b)
  while b.cell(:xpath, "//div[@class='pager_next action_button']").exists? & !b.cell(:xpath, "//div[@class='pager_next action_button' and @style='display: none;']").exists?
    if b.cell(:xpath, "//div[@class='pager_next action_button' and @style='display: none;']").exists?
      return true
    else
      b.cell(:xpath, "//div[@class='pager_next action_button']").click
    end
  end
end

def expand_more(b)
  while b.cell(:xpath, "//a[@class='more_link']").exists? & !b.cell(:xpath, "//a[@class='more_link hidden']").exists?
    if b.cell(:xpath, "//a[@class='more_link hidden']").exists?
      return true
    else
      b.cell(:xpath, "//a[@class='more_link']").click
    end
  end
end

def get_following(b, name)
  b.goto "http://www.quora.com/#{name}/following"
  click_more(b)
  File.open("results_following/#{name}_following.html", 'w') {|f| f.write(b.html)}
end

def get_followers(b, name)
  b.goto "http://www.quora.com/#{name}/followers"
  click_more(b)
  File.open("results_followers/#{name}_followers.html", 'w') {|f| f.write(b.html)}
end

def get_answers(b, name)
  b.goto "http://www.quora.com/#{name}/answers"
  click_more(b)
  expand_more(b)
  File.open("results_answers/#{name}_answers.html", 'w') {|f| f.write(b.html)}
end

def get_questions(b, name)
  b.goto "http://www.quora.com/#{name}/questions"
  click_more(b)
  while b.cell(:xpath, "//a[@class='view_all_topics']").exists?
    b.cell(:xpath, "//a[@class='view_all_topics']").click
  end
  File.open("results_questions/#{name}_questions.html", 'w') {|f| f.write(b.html)}
end

def get_posts(b, name)
  b.goto "http://www.quora.com/#{name}/posts"
  click_more(b)
  expand_more(b)
  File.open("results_posts/#{name}_posts.html", 'w') {|f| f.write(b.html)}
end

def get_mentions(b, name)
  b.goto "http://www.quora.com/#{name}/mentions"
  click_more(b)
  File.open("results_mentions/#{name}_mentions.html", 'w') {|f| f.write(b.html)}
end

def get_topics(b, name)
  b.goto "http://www.quora.com/#{name}/topics"
  click_more(b)
  while b.cell(:xpath, "//a[@class='view_all_topics']").exists? and !b.cell(:xpath, "//a[@class='view_all_topics hidden']").exists?
    b.cell(:xpath, "//a[@class='view_all_topics']")
  end
  File.open("results_topics/#{name}_topics.html", 'w') {|f| f.write(b.html)}
end

def get_profile(b, name)
  b.goto "http://www.quora.com/#{name}/"
  File.open("results_about/#{name}_about.html", 'w') {|f| f.write(b.html)}
end

get_followers(b, name)
get_following(b, name)
get_answers(b, name)
get_questions(b, name)
get_posts(b, name)
get_mentions(b, name)
get_profile(b, name)
get_topics(b, name)
