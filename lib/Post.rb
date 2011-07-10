class Post

  attr_reader :title, :url, :votes, :voters, :comments, :content

  def initialize(fragment)
    @title = fragment.css('.answer_user').css('a').inner_text
    @url = fragment.css('.answer_user').css('a')[0]['href']
    @votes = fragment.css('.post_votes.light').css('strong').inner_text
    @voters = build_voters(fragment.css('.post_votes_item').css('.user'))
    @comments = build_comments(fragment)
    @content = Content.new(fragment.search('div[@class="feed_item_answer"]'))



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
  

  def build_voters(allvoters)
    voter_list = []
    allvoters.each_with_index do |x,i|
      voter_list << Voter.new(x,i,@url)
    end
    voter_list
  end  
end
