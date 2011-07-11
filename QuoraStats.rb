require 'rubygems'
require 'CSV'
require 'nokogiri'
require 'optparse'

directory = File.dirname(__FILE__)

if not Dir.pwd == directory
  Dir.chdir directory
end

require './lib/QuoraUser'
require './lib/QuoraHtmlLoader'
require './lib/About'
require './lib/Answer'
require './lib/Comment'
require './lib/Content'
require './lib/Follower'
require './lib/Following'
require './lib/Mention'
require './lib/Post'
require './lib/Question'
require './lib/QuestionTopic'
require './lib/Topic'
require './lib/Voter'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options] 'first-last'. Provide no options to process all."

  opts.on("-a", "--answers", "Process Answers only") do |v|
    options[:answers] = v
  end

  opts.on("-f", "--followers", "Process followers only") do |v|
    options[:followers] = v
  end

  opts.on("-n", "--following", "Process following only") do |v|
    options[:following] = v
  end

  opts.on("-q", "--questions", "Process questions only") do |v|
    options[:questions] = v
  end

  opts.on("-p", "--posts", "Process posts only") do |v|
    options[:posts] = v
  end

  opts.on("-t", "--topics", "Process topics only") do |v|
    options[:topics] = v
  end

  opts.on("-m", "--mentions", "Process mentions only") do |v|
    options[:mentions] = v
  end

  opts.on("-r", "--profile", "Process profile only") do |v|
    options[:profile] = v
  end

end.parse!

user = QuoraUser.new(ARGV[0])

def display_answers(user)
  puts "***Answer Stats***"
  puts "Total Answers: " + user.answers.length.to_s
  puts "Votes/Answers: " + (user.votes_total.to_f / user.answers.length.to_f).to_s
  puts "        Votes: " + user.votes_total.to_s
  puts "  Uniq Voters: " + user.voters_to_array.uniq.length.to_s
  puts "     Comments: " + user.comments_total.to_s
  puts ""
  puts "***Your Top Voters:"
    user.top_voters(20)
  puts ""
end

def display_followers(user)
  puts "***Followers Stats***"
  puts "Total Followers " + user.followers.length.to_s
  puts ""
end

def display_following(user)
  puts "***Following Stats***"
  puts "Total Following " + user.following.length.to_s
  puts "" 
end

def display_questions(user)
  puts "***Question Stats***"
  puts "Total Questions:          " + user.questions.length.to_s
  puts "  Question Followers :    " + user.questions_total_followers.to_s
  puts "  Question Answers:       " + user.questions_total_answers.to_s
  puts "  Followers/Questions: " + (user.questions_total_followers.to_f / user.questions.length.to_f).to_s
  puts "  Answers/Questions: " + (user.questions_total_answers.to_f / user.questions.length.to_f).to_s
  puts "  Questions not Followed: " + user.questions_not_followed.to_s
  puts "  Questions not Answered: " + user.questions_not_answered.to_s
  puts "  Top Followed Questions: "
  user.top_questions_followers(20)
  puts "  Top Answered Questions: "
  user.top_questions_answers(20)
  puts ""
end

def display_posts(user)
  puts "***Post Stats***"
  puts "Total Posts: " + user.posts.length.to_s
  puts "" 
end

def display_topics(user)
  puts "***Topic Stats***"
  puts "Topics: " + user.topics.length.to_s
  puts ""  
end

def display_mentions(user)
  puts "***Mention Stats"
  puts "Mentions: " + user.mentions.length.to_s
  puts "" 
end

def display_profile(user)
  puts "***User Overview***"
  puts "Username: " + user.name.to_s
  puts "User URL: " + user.url.to_s
  puts "User BIO: "
  puts ""
end

def display_combine_follow(user)
  puts "***Not following back:"
  puts (user.following.collect {|x| x.url} - user.followers.collect {|x| x.url}) #not following you back
  puts ""
  puts "***Not following, but followed by:"
  puts (user.followers.collect {|x| x.url} - user.following.collect {|x| x.url}) #not following but follewd by
  puts ""
end



if options.empty?
  user.load_all_data
  display_profile(user)
  display_answers(user)
  display_questions(user)
  display_followers(user)
  display_following(user)
  display_combine_follow(user)
  display_posts(user)
  display_topics(user)
  display_mentions(user)
else
  if options.include? :followers
    user.load_followers
    display_followers(user)
  end

  if options.include? :following
    user.load_following
    display_following(user)
  end

  if options.include? :following and options.include? :followers
    display_combine_follow(user)
  end

  if options.include? :answers
    user.load_answers
    display_answers(user)
  end

  if options.include? :questions
    user.load_questions
    display_questions(user)
  end

  if options.include? :posts
    user.load_posts
    display_posts(user)
  end

  if options.include? :topics
    user.load_topics
    display_topics(user)
  end

  if options.include? :mentions
    user.load_mentions
    display_mentions(user)
  end

  if options.include? :profile
    user.load_profile
    display_profile(user)
  end
end

