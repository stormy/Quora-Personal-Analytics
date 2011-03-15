require 'rubygems'
require 'CSV'
require 'nokogiri'
require 'pp'
require 'date'

STDOUT.sync = true # terminal setting so print "*" actually displays

directory = "#{ENV['HOME']}/Quora-Personal-Analytics"

if not Dir.pwd == directory
  Dir.chdir directory
end

class QuoraUser

  attr_reader :name, :url, :answers, :questions, :followers, :following

  def initialize(user_name)
    @name = user_name
    @url = "http:www.quora.com/" + @name + "/"
    @load = QuoraHtmlLoader.new(@name)
  end

  def load_all_data
    @answers = @load.answers
    @questions = @load.questions
    @followers = @load.followers
    @following = @load.following
  end

  def load_answers
    @answers = @load.answers
    @questions = @load.questions
  end
end

class QuoraHtmlLoader

  attr_reader :name

  def initialize(user_name)
    @name = user_name
  end

  def answers
    type = "answers"
    css_selector = ".e_col.w4_5"
    loadhtml(type, css_selector)
  end

  def questions
    type = "questions"
    css_selector = ".e_col.w4_5"
    loadhtml(type, css_selector)
  end

  def followers
    type = "followers"
    css_selector = ".col.w4_5.item.p1"
    loadhtml(type, css_selector)
  end

  def following
    type = "following"
    css_selector = ".col.w4_5.item.p1"
    loadhtml(type, css_selector)
  end  

  def loadhtml(type, selector)
    file = File.open("results_#{type}/#{@name}_#{type}.html")
    html = Nokogiri::HTML(file)
    file.close
    result = []
    html.css(selector).each_with_index do |item, index|
      if type == 'answers'
        result << Answer.new(item)
      elsif type == 'questions'
        result << Question.new(item)
      elsif type == 'followers'
        result << Follower.new(item)
      elsif type == 'following'
        result << Following.new(item)
      end
    end
    result
  end

end

class Follower

  attr_reader :fullname, :firstname, :img_src, :id, :bio, :url

  def initialize(follower_html_fragment)
    @fullname = follower_html_fragment.css('.user').inner_text
    @firstname = @fullname.split(' ')[0]
    @img_src = follower_html_fragment.css('.profile_photo_img').attribute('src').value
    @id = @img_src.split('thumb-')[1].to_s.split('-')[0]
    @bio = follower_html_fragment.css('.rep').inner_text.strip
    @url = follower_html_fragment.css('.user').attribute('href').value
  end
end

class Following < Follower

end

class Answer

  attr_reader :fragment, :title, :url, :bio, :date, :votes_total, :voters, :content, :comments_total, :comments

  def initialize(fragment)
    @fragment = fragment
    @title = fragment#.css('.question_link').inner_text
    @url = fragment.css('.question_link').attribute('href').value
    @date = fragment.search('a[@class="answer_permalink"]').inner_text
    @bio = bio_check(fragment.css('.feed_item_answer_user'))
    @votes_total = fragment.search('strong[@class="voter_count"]').inner_text
    @voters = build_voters(fragment.css('.answer_voters').css('.user'))
    @comments = build_comments(fragment)
    @content = Content.new(fragment.search('div[@class="feed_item_answer_content answer_content"]'))
  end

  def build_voters(allvoters)
    voter_list = []
    allvoters.each_with_index do |x,i|
      voter_list << Voter.new(x,i)
    end
    voter_list
  end

  def strip_divs(content_div)
    stripped = content_div
     stripped.css('.comments.answer_comments.hidden').remove
     stripped.css('.answer_user').remove
     stripped.css('.action_bar').remove
     stripped
  end

  def build_comments(comment)
    if comment.search('a[@class="view_comments supp "]').inner_text =~ /Add Comment/
     []
    else
      comment_list = []
      comment.css('.comment_contents').each do |x|
        comment_list << Comment.new(x)
      end
      comment_list
    end
  end

  def bio_check(answer_user)
    if answer_user.css('.rep').empty?
      ""
    else
      answer_user.css('.rep')[1].inner_text
    end
  end
end

class Content

  attr_reader :text, :images, :breaks, :italics, :blockquote, :list_item, :links, :underline, :codeblock, :latex

  def initialize(fragment)
    strip_divs(fragment.dup)
    @text = fragment.inner_text
    @images = fragment.css('.qtext_image')
    @breaks = fragment.css('br').length
    @italics = fragment.css('i')
    @blockquote = fragment.css('blockquote')
    @list_item = fragment.css('li')
    @links = fragment.css('a')
    @underline = fragment.css('u')
    @codeblock = fragment.css('.codeblocktable') + fragment.css('pre')
    @latex = fragment.css('.math')
  end

  def strip_divs(content_div)
    stripped = content_div
     stripped.css('.comments.answer_comments.hidden').remove
     stripped.css('.answer_user').remove
     stripped.css('.action_bar').remove
     stripped
  end
end

class Question

  attr_reader :title, :url, :content, :answers_total

  def initialize(fragment)
    @title = fragment.css('.question_link').inner_text
    @url = fragment.css('.question_link').attribute('href').value
    @content = fragment.css('.feed_item_question_details').inner_text
    @answers_total = fragment.css('.feed_item_question_info').inner_text.split(' ')[0]
  end
end

class Voter

  attr_reader :order, :fullname, :url

  def initialize(voter,index)
    @order = index
    @fullname = voter.inner_text
    @url = voter.attribute('href').value
  end
end

class Comment

  attr_reader :date, :content, :full_name, :url

  def initialize(comment)
    @url = comment.search('.user')[0]
    @date = comment.css('.action_bar').inner_text.split(' ')[3..6].join(' ')
    @content = comment.css('.comment_text').inner_text
    @full_name = comment.css('.user').inner_text 
  end
end


user = QuoraUser.new('Venkatesh-Rao')
user.load_all_data

pp user.answers[370].content.images[0]['src']

user.answers.each_with_index do |x,i|
  if x.content.codeblock.empty?
  else
    puts i
    pp x.content.codeblock
  end
end

#pp user.answers[10].comments[0].date
#pp user.answers[10].comments[0].content
#pp user.answers[10].comments[0].full_name
#pp user.answers[10].comments[1].url['href']
#

#while b.cell(:xpath, "//div[@class='pager_next action_button']").exists? & !b.cell(:xpath, "//div[@class='pager_next action_button' and @style='display: none;']").exists?
  #if b.cell(:xpath, "//div[@class='pager_next action_button' and @style='display: none;']").exists?
    #return true
  #else
    #b.cell(:xpath, "//div[@class='pager_next action_button']").click
  #end
#end


