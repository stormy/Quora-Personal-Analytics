class Question

  attr_reader :title, :url, :content, :answers_total, :topics_total, :topics, :followers_total

  def initialize(fragment)
    @title = fragment.css('.question_link').inner_text
    @url = fragment.css('.question_link').attribute('href').value
    @content = fragment.css('.feed_item_question_details').inner_text
    @answers_total = fragment.css('.number_answers')[0].inner_text.split(' ')[0].to_i
    @followers_total = fragment.css('.number_answers')[1].inner_text.split(' ')[0].to_i
   #@topics = QuestionTopic.new(fragment.css('.topic_name')) #=> Quora HTML has changed, topics not shown now
  end
end
