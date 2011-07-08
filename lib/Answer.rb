class Answer

  attr_reader :fragment, :title, :url, :bio, :date, :votes, :voters, :content, :comments_total, :comments, :total_comments

  def initialize(fragment)
    @fragment = fragment
    @title = fragment.css('.question_link').inner_text
    @url = fragment.css('.question_link').attribute('href').value
    @date = fragment.search('a[@class="answer_permalink"]').inner_text
    @bio = bio_check(fragment.css('.feed_item_answer_user'))
    @votes = fragment.search('strong[@class="voter_count"]').inner_text
    @voters = build_voters(fragment.css('.answer_voters'))
    @comments = build_comments(fragment)
    @content = Content.new(fragment.search('div[@class="feed_item_answer_content answer_content"]'))
  end

  def build_voters1(allvoters)
    voter_list = []
    allvoters.each_with_index do |x,i|
      voter_list << Voter.new(x,i)
    end
    voter_list
  end

  def build_voters(answer_voters)
    voter_list = []
    if answer_voters.css('span.hidden').empty?
      answer_voters.css('.user').each_with_index do |x,i|
        voter_list << Voter.new(x,i)
      end
    else
      answer_voters.css('span.hidden').css('.user').each_with_index do |x,i|
        voter_list << Voter.new(x,i)
      end
    end
    voter_list
  end

  def total_comments
    @comments.length
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

  def to_csv
    answers_csv = File.open("results_#{type}/#{@name}_#{type}.csv", 'ab')
    CSV::Writer.generate(outfile_commenters, ',') do |csv|
      csv << [ "question", "commenter_url" ]
    end
  end
end
