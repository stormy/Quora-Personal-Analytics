class QuestionFollowing

  attr_reader :title, :url, :answers_total, :followers_total

  def initialize(fragment)
    @title = fragment.css('.question_link').inner_text.to_s
    @url = fragment.css('.question_link')[0]['href'].to_s
    @answers_total = fragment.css('.number_answers')[0].inner_text.split(' ')[0].to_i
    @followers_total = fragment.css('.number_answers')[1].inner_text.split(' ')[0].to_i
  end

end
