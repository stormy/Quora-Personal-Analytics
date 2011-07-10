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

  def comments_total
    total_comments = 0
    answers.each do |x|
      total_comments += x.total_comments
    end
    total_comments
  end

  def voters_to_array
    all_voters = []
    answers.each do |x|
      x.voters.each do |y|
        all_voters << y
      end
    end
    all_voters  
  end

  def most_voters_array 
    voters = Hash.new(0)
    voters_to_array.flatten.each do |x|
      voters[x] += 1
    end
    voters.sort {|a, b| -1*(a[1] <=> b [1])}

  end

  def top_voters
    most_voters_array[0..19].each do |voter|
      puts voter[1].to_s + " votes from: " + voter[0].url + " (" + voter[0].fullname + ")"
    end
  end

  def questions_total_answers
    question_answers = 0
    @questions.each do |x|
      question_answers += x.answers_total
    end
    question_answers
  end

  def question_most_answered
    @questions.max {|a,b| a.answers_total <=> b.answers_total}
  end

  def questions_total_followers
    question_followers = 0
    @questions.each do |x|
      question_followers += x.followers_total
    end
    question_followers
  end

  def question_most_followed
    @questions.max {|a,b| a.followers_total <=> b.followers_total}
  end

  def questions_not_answered
    question_not_answered = 0
    @questions.each do |x|
      if x.answers_total == 0
        question_not_answered += 1
      end
    end
    question_not_answered
  end

  def questions_not_followed
    question_not_followed = 0
    @questions.each do |x|
      if x.followers_total == 1
        question_not_followed += 1
      end
    end
    question_not_followed
  end


end

