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

    return result
  end

end

class Follower
  
  attr_reader :fullname, :firstname, :img_src, :id, :bio, :url
  
  def initialize(follower_html_fragment)
    @fullname = follower_html_fragment.css('.user').inner_text
    @firstname = @fullname.split(' ')[0]
    @img_src = follower_html_fragment.css('.profile_photo_img').attribute('src').value
    @id = @img_src.split('thumb-')[1].to_s.split('-')[0]
    @bio = follower_html_fragment.css('.rep').inner_text
    @url = follower_html_fragment.css('.user').attribute('href').value
  end

end

class Following < Follower

end

class Answer

  attr_reader :title, :url, :bio, :votes_num, :voters, :content, :comments_num, :comments

  def initialize(fragment)
    @title = fragment.css('.question_link').inner_text
    @url = fragment.css('.question_link').attribute('href').value
#    @bio = fragment.css('.feed_item_answer_user.rep')[1].inner_text
    @votes_num = fragment.search('strong[@class="voter_count"]').inner_text
    @content = strip_divs(fragment.search('div[@class="feed_item_answer_content answer_content"]')).inner_text
    @comments_num = comments(fragment.search('div[@class="action_bar"]'))

  end

  def strip_divs(content_div)
     content_div.css('.comments.answer_comments.hidden').remove
     content_div.css('.answer_user').remove
     content_div.css('.action_bar').remove
     content_div
  end

  def comments(comment)
    if comment.search('a[@class="view_comments supp "]').inner_text =~ /Add Comment/
     0
    else
      comment.search('a[@class="view_comments supp "]').inner_text.split(' ')[0]
    end
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



user = QuoraUser.new('Venkatesh-Rao')
user.load_all_data

