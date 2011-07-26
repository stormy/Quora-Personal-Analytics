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
require './lib/QuestionFollowing'

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

  opts.on("-y", "--followingquestions", "Process only the questions YOU follow") do |v|
    options[:following_questions] = v
  end

  opts.on("-d", "--display_num NUM", Integer, "Sets number of results to display"){ |n| options[:display_num] = n }

end.parse!
if not options.include? :display_num
  options[:display_num] = 20
end
user = QuoraUser.new(ARGV[0])
def display_answers(user, options)
  puts "***Answer Stats***"
  puts "  Total Answers: " + user.answers.length.to_s
  puts "    Total Votes: " + user.votes_total.to_s
  puts "      Avg Votes: " + (user.votes_total.to_f / user.answers.length.to_f).to_s
  puts "      Stand Dev: " + Math.sqrt(user.answers.inject([]){|result,element| result << element.votes}.inject([]){|r,e| r << (e-(user.votes_total/user.answers.length))**2}.inject {|r,e| r+e}/user.answers.length).to_s
  puts "    Uniq Voters: " + user.voters_to_array.uniq.length.to_s
  puts "       Comments: " + user.comments_total.to_s
  puts ""
  puts "  *Your Top Answers:"
    user.top_answers(options[:display_num])
  puts ""
  puts "  *Your Top Voters:"
    user.top_voters(options[:display_num])
  puts ""

end

def display_followers(user,options)
  puts "***Followers Stats***"
  puts "Total Followers " + user.followers.length.to_s
  puts ""
end

def display_following(user,options)
  puts "***Following Stats***"
  puts "Total Following " + user.following.length.to_s
  puts "" 
end

def display_questions(user,options)
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
  puts "  Questions with no answers: "
  user.questions_no_answers
  puts ""
  puts "  Questions with no followers: "
  user.questions_no_followers
  puts ""

end

def display_posts(user,options)
  puts "***Post Stats***"
  puts "  Total Posts: " + user.posts.length.to_s
  puts "    Total Votes: " + user.post_votes_total.to_s
  puts "      Avg Votes: " + (user.post_votes_total.to_f / user.posts.length.to_f).to_s
  puts "      Stand Dev: " + Math.sqrt(user.posts.inject([]){|result,element| result << element.votes}.inject([]){|r,e| r << (e-(user.post_votes_total/user.posts.length))**2}.inject {|r,e| r+e}/user.posts.length).to_s
  puts "    Uniq Voters: " + user.post_voters_to_array.uniq.length.to_s
  puts "       Comments: " + user.post_comments_total.to_s
  puts ""
  puts "  *Your Top Posts:"
    user.top_posts(options[:display_num])
  puts ""
  puts "  *Your Top Voters:"
    user.post_top_voters(options[:display_num])
  puts ""


end

def display_topics(user,options)
  puts "***Topic Stats***"
  puts "Topics: " + user.topics.length.to_s
  puts ""  
end

def display_mentions(user,options)
  puts "***Mention Stats"
  puts "Mentions: " + user.mentions.length.to_s
  puts "" 
end

def display_profile(user,options)
  puts "***User Overview***"
  puts "Username: " + user.name.to_s
  puts "User URL: " + user.url.to_s
  puts "User BIO: "
  puts ""
end

def display_combine_follow(user,options)
  puts "***Not following back:"
  puts (user.following.collect {|x| x.url} - user.followers.collect {|x| x.url}) #not following you back
  puts ""
  puts "***Not following, but followed by:"
  puts (user.followers.collect {|x| x.url} - user.following.collect {|x| x.url}) #not following but follewd by
  puts ""
end

def display_following_questions(user,options)
  puts "***Questions you follow stats"
  puts "Total Questions:          " + user.following_questions.length.to_s
  puts "  Question Followers :    " + user.following_questions_total_followers.to_s
  puts "  Question Answers:       " + user.following_questions_total_answers.to_s
  puts "  Followers/Questions: " + (user.following_questions_total_followers.to_f / user.following_questions.length.to_f).to_s
  puts "  Answers/Questions: " + (user.following_questions_total_answers.to_f / user.following_questions.length.to_f).to_s
  puts "  Questions not Followed: " + user.following_questions_not_followed.to_s
  puts "  Questions not Answered: " + user.following_questions_not_answered.to_s
  puts "  Top Followed Questions: "
  user.top_following_questions_followers(20)
  puts ""
  puts "  Top Answered Questions: "
  user.top_following_questions_answers(20)
  puts ""
  puts "  Questions with no answers: "
  user.following_questions_no_answers
  puts ""
  puts "  Questions with no followers: "
  user.following_questions_no_followers
  puts ""
end

if options.empty? or (options.include? :display_num and options.length == 1)
  user.load_all_data
  display_profile(user,options)
  display_answers(user,options)
  display_questions(user,options)
  display_posts(user,options)
  display_followers(user,options)
  display_following(user,options)
  display_combine_follow(user,options)
  display_topics(user,options)
  display_mentions(user,options)
else
  if options.include? :followers
    user.load_followers
    display_followers(user,options)
  end

  if options.include? :following
    user.load_following
    display_following(user,options)
  end

  if options.include? :following and options.include? :followers
    display_combine_follow(user,options)
  end

  if options.include? :answers
    user.load_answers
    display_answers(user, options)
  end

  if options.include? :questions
    user.load_questions
    display_questions(user,options)
  end

  if options.include? :posts
    user.load_posts
    display_posts(user,options)
  end

  if options.include? :topics
    user.load_topics
    display_topics(user,options)
  end

  if options.include? :mentions
    user.load_mentions
    display_mentions(user,options)
  end

  if options.include? :profile
    user.load_profile
    display_profile(user,options)
  end

  if options.include? :following_questions
    user.load_following_questions
    display_following_questions(user,options)
  end

end

