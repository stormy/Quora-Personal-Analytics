class Post

  attr_reader :title, :url, :votes, :voters, :comments, :content, :date, :fragment, :comments_total

  def initialize(fragment)
    @fragment = fragment
    @title = fragment.css('.answer_user .light > a').inner_text.to_s
    @url = fragment.css('.timestamp > a')[0]['href']
    @votes = fragment.css('.post_votes.light').css('strong').inner_text.to_i
    @voters = build_voters(fragment.css('.post_votes_item'))
    @comments = build_comments(fragment.css('.comments.post_comments.hidden'))
    @comments_total = fragment.css('.view_comments.supp').inner_text.split(' ')[0].to_i 
    @content = Content.new(fragment.css('.inline.expanded_q_text'))
    @date = fragment.css('.timestamp').inner_text.to_s
  end

  def build_comments(comment)
    if comment.css('.comment_contents').nil? or comment.css('.comment_contents .action_bar').inner_text.include?("Anon User")
     comment_list = []
   elsif (comment.css('.comment_contents .action_bar').inner_text =~ /Anon/) == 0
     comment_list = []
    else
      comment_list = []
      comment.css('.comment_contents').each_with_index do |x,i|
        comment_list << Comment.new(x,i,@url)
      end
      comment_list
    end
  end


  def build_voters(answer_voters)
    voter_list = []
      answer_voters.css('span.hidden').css('.user').each_with_index do |x,i|
        voter_list << Voter.new(x,i,@url)
      end
    voter_list
  end


end
