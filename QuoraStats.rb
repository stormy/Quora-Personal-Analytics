require 'rubygems'
require 'CSV'
require 'nokogiri'
require 'pp'

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

directory = "#{ENV['HOME']}/Quora-Personal-Analytics"

if not Dir.pwd == directory
  Dir.chdir directory
end

user = QuoraUser.new(ARGV[0])
user.load_all_data

puts "***User Overview***"
puts "Username: " + user.name.to_s
puts "User URL: " + user.url.to_s
puts "User BIO: "
puts ""
puts "***Answer Stats***"
puts "Total Answers: " + user.answers.length.to_s
puts "        Votes: " + user.votes_total.to_s

total=0
user.answers.each do |x|
  total += x.total_comments
end
puts "     Comments: " + total.to_s
puts ""
puts "***Question Stats***"
puts "Total Questions: " + user.questions.length.to_s
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
