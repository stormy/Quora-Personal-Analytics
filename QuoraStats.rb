require 'rubygems'
require 'CSV'
require 'nokogiri'

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

user = QuoraUser.new(ARGV[0])
user.load_all_data

puts "***User Overview***"
puts "Username: " + user.name.to_s
puts "User URL: " + user.url.to_s
puts "User BIO: "
puts ""
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
puts "***Post Stats***"
puts "Total Posts: " + user.posts.length.to_s
puts ""
puts "***Followers Stats***"
puts "Total Followers " + user.followers.length.to_s
puts ""
puts "***Following Stats***"
puts "Total Following " + user.following.length.to_s
puts ""
puts "***Topic Stats***"
puts "Topics: " + user.topics.length.to_s
puts ""
puts "***Mention Stats"
puts "Mentions: " + user.mentions.length.to_s
puts ""
puts "***Not following back:"
puts (user.following.collect {|x| x.url} - user.followers.collect {|x| x.url}) #not following you back
puts ""
puts "***Not following, but followed by:"
puts (user.followers.collect {|x| x.url} - user.following.collect {|x| x.url}) #not following but follewd by
puts ""
puts ""

