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

  def topics
    type = "topics"
    css_selector = ".row.user_topic.p1.feed_item"
    loadhtml(type, css_selector)
  end

  def mentions
    type ="mentions"
    css_selector = ".feed_item.row.p1.mention_item"
    loadhtml(type, css_selector)
  end

  def posts
    type ="posts"
    css_selector = ".p1.feed_item.row"
    loadhtml(type, css_selector)
  end

  def about
    type = "about"
    css_selector = "html"
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
      elsif type == 'topics'
        result << Topic.new(item)
      elsif type == 'mentions'
        result << Mention.new(item)
      elsif type == 'posts'
        result << Post.new(item)
      elsif type == 'about'
        result = About.new(item)
      end
    end
    result
  end

end

