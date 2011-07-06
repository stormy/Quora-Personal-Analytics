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

if not File.exist?(name)
  Dir.mkdir(name)
end

def click_more(b)
  while !b.cell(:xpath, "//div[@class='pager_next action_button' and @style='display: none;']").exists?
    b.cell(:xpath, "//div[@class='pager_next action_button']").click
  end
end

def expand_more(b)
  while b.cell(:xpath, "//span[@class='answer_voters']//a[@class='more_link']").exists?
      b.cell(:xpath, "//span[@class='answer_voters']//a[@class='more_link']").click
    end
#  while b.cell(:xpath, "//span[@class='answer_voters']//span[@class='more_link']/a").exists?
#    b.cell(:xpath, "//span[@class='answer_voters']//span[@class='more_link']/a").click
#  end
end

def get_following(b, name)
  b.goto "http://www.quora.com/#{name}/following"
  click_more(b)
  File.open("#{name}/following.html", 'w') {|f| f.write(b.html)}
end

def get_followers(b, name)
  b.goto "http://www.quora.com/#{name}/followers"
  click_more(b)
  File.open("#{name}/followers.html", 'w') {|f| f.write(b.html)}
end

def get_answers(b, name)
  b.goto "http://www.quora.com/#{name}/answers"
  click_more(b)
  expand_more(b)
  File.open("#{name}/answers.html", 'w') {|f| f.write(b.html)}
end

def get_questions(b, name)
  b.goto "http://www.quora.com/#{name}/questions"
  click_more(b)
  while b.cell(:xpath, "//a[@class='view_all_topics']").exists?
    b.cell(:xpath, "//a[@class='view_all_topics']").click
  end
  File.open("#{name}/questions.html", 'w') {|f| f.write(b.html)}
end

def get_posts(b, name)
  b.goto "http://www.quora.com/#{name}/posts"
  click_more(b)
#  expand_more(b)
  File.open("#{name}/posts.html", 'w') {|f| f.write(b.html)}
end

def get_mentions(b, name)
  b.goto "http://www.quora.com/#{name}/mentions"
  click_more(b)
  File.open("#{name}/mentions.html", 'w') {|f| f.write(b.html)}
end

def get_topics(b, name)
  b.goto "http://www.quora.com/#{name}/topics"
  click_more(b)
#  while b.cell(:xpath, "//a[@class='view_all_topics']").exists? and !b.cell(:xpath, "//a[@class='view_all_topics hidden']").exists?
#    b.cell(:xpath, "//a[@class='view_all_topics']")
#  end
  File.open("#{name}/topics.html", 'w') {|f| f.write(b.html)}
end

def get_profile(b, name)
  b.goto "http://www.quora.com/#{name}/"
  File.open("#{name}/about.html", 'w') {|f| f.write(b.html)}
end

get_followers(b, name)
get_following(b, name)
get_answers(b, name)
get_questions(b, name)
get_posts(b, name)
get_mentions(b, name)
get_profile(b, name)
get_topics(b, name)
