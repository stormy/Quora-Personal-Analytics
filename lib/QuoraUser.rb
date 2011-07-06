class QuoraUser

  attr_reader :name, :url, :answers, :questions, :followers, :following, :topics, :posts, :mentions, :about

  def initialize(user_name)
    @name = user_name
    @url = "http://www.quora.com/" + @name + "/"
    @load = QuoraHtmlLoader.new(@name)
  end

  def load_all_data
    @answers = @load.answers
    @questions = @load.questions
    @followers = @load.followers
    @following = @load.following
    @topics = @load.topics
    @mentions = @load.mentions
    @posts = @load.posts
    @about = @load.about
  end

  def load_answers
   @answers = @load.answers 
  end

  def votes_total
    total_votes = 0 
    answers.each do |x|
      total_votes += x.votes.to_i
    end
    total_votes 
  end

end

