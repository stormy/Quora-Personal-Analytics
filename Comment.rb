class Comment

  attr_reader :date, :content, :full_name, :url

  def initialize(comment)
   # @url = comment.search('.user')[0]['href']
    @date = comment.css('.action_bar').inner_text.split(' ')[3..6].join(' ')
    @content = comment.css('.comment_text').inner_text
    @full_name = comment.css('.user').inner_text 
  end
end
