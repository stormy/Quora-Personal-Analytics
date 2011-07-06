class Topic

  attr_reader :title, :url, :answers, :endorsements, :endorsers

  def initialize(fragment)
    @title = fragment.css('.topic_name').inner_text
    @url = fragment.css('.topic_name')[0]['href']
    @answers = fragment.css('.light.feed_item_activity a').inner_text.split(' ')[0]
    @endorsements = fragment.css('.light.feed_item_activity span')[2].inner_text.split(' ')[0]
    @endorsers = fragment.css('photo_tooltip')
  end
end
