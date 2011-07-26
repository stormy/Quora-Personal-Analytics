class QuoraUser

  attr_reader :name, :url, :answers, :questions, :followers, :following, :topics, :posts, :mentions, :about, :following_questions

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
    @following_questions = @load.following_questions
  end

  def load_answers
   @answers = @load.answers 
  end

  def load_questions
   @questions = @load.questions 
  end

  def load_followers
   @followers = @load.followers 
  end

  def load_following
   @following = @load.following 
  end

  def load_posts
   @posts = @load.posts 
  end

  def load_topics
   @topics = @load.topics 
  end

  def load_mentions
   @mentions = @load.mentions
  end

  def load_profile
   @about = @load.about 
  end

  def load_following_questions
    @following_questions = @load.following_questions
  end

####
#### Answer related methods
####

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

  def top_voters(n)
    most_voters_array[0..n-1].each do |voter|
      puts "   " + voter[1].to_s + " votes from: " + voter[0].url + " (" + voter[0].fullname + ")"
    end
  end

  def top_answers(n)
    @answers.sort {|a,b| -1*(a.votes <=> b.votes) }[0..n-1].each do |answer|
      puts "   " + answer.votes.to_s + " votes on: " + answer.title
    end
  end


####
#### Post related methods
####

  def post_votes_total
    total_votes = 0
    posts.each do |x|
      total_votes += x.votes
    end
    total_votes
  end

  def post_comments_total
    total_comments = 0
    posts.each do |x|
      total_comments += x.comments_total
    end
    total_comments
  end

  def post_voters_to_array
    all_voters = []
    posts.each do |x|
      x.voters.each do |y|
        all_voters << y
      end
    end
    all_voters
  end

  def post_most_voters_array
    voters = Hash.new(0)
    post_voters_to_array.flatten.each do |x|
      voters[x] += 1
    end
    voters.sort {|a, b| -1*(a[1] <=> b [1])}
  end

  def post_top_voters(n)
    post_most_voters_array[0..n-1].each do |voter|
      puts "   " + voter[1].to_s + " votes from: " + voter[0].url + " (" + voter[0].fullname + ")"
    end
  end

  def top_posts(n)
    @posts.sort {|a,b| -1*(a.votes <=> b.votes) }[0..n-1].each do |post|
      puts "   " + post.votes.to_s + " votes on: " + post.title
    end
  end


####
#### Question related methods
####

  def top_questions_followers(n)
    @questions.sort {|a,b| -1*(a.followers_total <=> b.followers_total) }[0..n-1].each do |question|
      puts "   " + question.followers_total.to_s + " followers on: " + question.title
    end
  end

  def top_questions_answers(n)
    @questions.sort {|a,b| -1*(a.answers_total <=> b.answers_total) }[0..n-1].each do |question|
      puts "   " + question.answers_total.to_s + " answers on: " + question.title
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

  def questions_no_answers
    @questions.reject {|x| x.answers_total > 0}.each do |question|
      puts "   " + question.title
    end
  end

  def questions_no_followers
    @questions.reject {|x| x.followers_total > 1}.each do |question|
      puts "   " + question.title
    end
  end

  def following_questions_total_answers
    question_answers = 0
    @following_questions.each do |x|
      question_answers += x.answers_total
    end
    question_answers
  end

  def following_questions_total_followers
    question_followers = 0
    @following_questions.each do |x|
      question_followers += x.followers_total
    end
    question_followers
  end

  def following_questions_most_followed
    @following_questions.max {|a,b| a.followers_total <=> b.followers_total}
  end

  def following_questions_not_answered
    question_not_answered = 0
    @following_questions.each do |x|
      if x.answers_total == 0
        question_not_answered += 1
      end
    end
    question_not_answered
  end

  def following_questions_not_followed
    question_not_followed = 0
    @following_questions.each do |x|
      if x.followers_total == 1
        question_not_followed += 1
      end
    end
    question_not_followed
  end

  def following_questions_most_answered
    @following_questions.max {|a,b| a.answers_total <=> b.answers_total}
  end

  def top_following_questions_followers(n)
    @following_questions.sort {|a,b| -1*(a.followers_total <=> b.followers_total) }[0..n-1].each do |question|
      puts "   " + question.followers_total.to_s + " followers on: " + question.title
    end
  end

  def top_following_questions_answers(n)
    @following_questions.sort {|a,b| -1*(a.answers_total <=> b.answers_total) }[0..n-1].each do |question|
      puts "   " + question.answers_total.to_s + " answers on: " + question.title
    end
  end

  def following_questions_no_answers
    @following_questions.reject {|x| x.answers_total > 0}.each do |question|
      puts "   " + question.title
    end
  end

  def following_questions_no_followers
    @following_questions.reject {|x| x.followers_total > 1}.each do |question|
      puts "   " + question.title
    end
  end


end

