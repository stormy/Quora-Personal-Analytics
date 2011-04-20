class Question

  attr_reader :title, :url, :content, :answers_total

  def initialize(fragment)
    @title = fragment.css('.question_link').inner_text
    @url = fragment.css('.question_link').attribute('href').value
    @content = fragment.css('.feed_item_question_details').inner_text
    @answers_total = fragment.css('.feed_item_question_info').inner_text.split(' ')[0]
    @topics_total = fragment.css('.view_all_topics.hidden').inner_text.split(' ')[0]
    @topics = QuestionTopic.new(fragment.css('.topic_name'))
  end
end
