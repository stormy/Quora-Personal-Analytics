class Answer

  attr_reader :fragment, :title, :url, :bio, :date, :votes, :voters, :anon_votes, :content, :comments_total, :comments, :total_comments, :question_url

  def initialize(fragment)
    @fragment = fragment
    @title = fragment.css('.question_link').inner_text
    @question_url = fragment.css('.question_link').attribute('href').value
    @url = fragment.css('.answer_permalink')[0][:href]
    @date = fragment.search('a[@class="answer_permalink"]').inner_text
    @bio = bio_check(fragment.css('.feed_item_answer_user'))
    @votes = fragment.search('strong[@class="voter_count"]').inner_text.to_i
    @voters = build_voters(fragment.css('.answer_voters'))
    @anon_votes = (@votes.to_i - @voters.length.to_i)
    @comments = build_comments(fragment)
    @content = Content.new(fragment.search('div[@class="feed_item_answer_content answer_content"]'))
  end

  def build_voters(answer_voters)
    voter_list = []
    if answer_voters.css('span.hidden').empty?
      answer_voters.css('.user').each_with_index do |x,i|
        voter_list << Voter.new(x,i,@url)
      end
    else
      answer_voters.css('span.hidden').css('.user').each_with_index do |x,i|
        voter_list << Voter.new(x,i,@url)
      end
    end
    voter_list
  end

  def total_comments
    @comments.length
  end

  def build_comments(comment)
    comment_list = []
    if comment.css('.comment_contents').nil? or comment.css('.comment_contents .action_bar').inner_text.include?("Anon User")
     comment_list = []
    elsif comment.css('.comment_contents .action_bar .user').nil?
      puts "hellllllllloooooo"
      comment_list = []
    else
      comment.css('.comment_contents').each_with_index do |x,i|
        comment_list << Comment.new(x,i,@url)
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

  def to_csv
    answers_csv = File.open("results_#{type}/#{@name}_#{type}.csv", 'ab')
    CSV::Writer.generate(outfile_commenters, ',') do |csv|
      csv << [ "question", "commenter_url" ]
    end
  end
end
