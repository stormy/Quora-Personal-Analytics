class Comment

  attr_reader :date, :content, :full_name, :url, :parent_url

  def initialize(comment, order, comment_url)
    @url = comment.css('.action_bar .user')[0][:href]
    @date = comment.css('.action_bar').last.children.last.inner_text.to_s
    @content = comment.css('.comment_text').inner_text.to_s
    @full_name = comment.css('.action_bar').css('.user').inner_text.to_s
    @order = order
    @parent_url = comment_url
  end
end
