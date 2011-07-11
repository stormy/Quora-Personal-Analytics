require 'rubygems'
require 'bundler/setup'

require 'watir'
require 'optparse'

directory = File.dirname(__FILE__)

if not Dir.pwd == directory
  Dir.chdir directory
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options] 'first-last'. No options to crawl all."

  opts.on("-a", "--answers", "Crawl Answers only") do |v|
    options[:answers] = v
  end

  opts.on("-f", "--followers", "Crawl followers only") do |v|
    options[:followers] = v
  end

  opts.on("-n", "--following", "Crawl following only") do |v|
    options[:following] = v
  end

  opts.on("-q", "--questions", "Crawl questions only") do |v|
    options[:questions] = v
  end

  opts.on("-p", "--posts", "Crawl posts only") do |v|
    options[:posts] = v
  end

  opts.on("-t", "--topics", "Crawl topics only") do |v|
    options[:topics] = v
  end

  opts.on("-m", "--mentions", "Crawl mentions only") do |v|
    options[:mentions] = v
  end

  opts.on("-r", "--profile", "Crawl profile only") do |v|
    options[:profile] = v
  end

end.parse!

Watir::Browser.default = 'firefox'

b = Watir::Browser.new

name = ARGV[0]

if not File.exist?(name)
  Dir.mkdir(name)
end

def click_more(b)
  if b.cell(:xpath, "//div[@class='pager_next action_button']").exists?
    while !b.cell(:xpath, "//div[@class='pager_next action_button' and @style='display: none;']").exists?
      b.cell(:xpath, "//div[@class='pager_next action_button']").click
    end
  end
end

def expand_more(b)
  if b.cell(:xpath, "//span[@class='answer_voters']//a[@class='more_link']").exists?
    while b.cell(:xpath, "//span[@class='answer_voters']//a[@class='more_link']").exists?
      b.cell(:xpath, "//span[@class='answer_voters']//a[@class='more_link']").click
    end
  end
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
  sleep(3)
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

if options.empty?
  get_followers(b, name)
  get_following(b, name)
  get_answers(b, name)
  get_questions(b, name)
  get_posts(b, name)
  get_mentions(b, name)
  get_profile(b, name)
  get_topics(b, name)
else
  if options.include? :followers
    get_followers(b, name)
  end

  if options.include? :following
    get_following(b, name)
  end

  if options.include? :answers
    get_answers(b, name)
  end

  if options.include? :questions
    get_questions(b, name)
  end

  if options.include? :posts
    get_posts(b, name)
  end

  if options.include? :topics
    get_topics(b, name)
  end

  if options.include? :mentions
    get_mentions(b, name)
  end

  if options.include? :profile
    get_profile(b, name)
  end

end


