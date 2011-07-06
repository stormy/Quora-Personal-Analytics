class QuestionTopic

  attr_reader :title, :url

  def initialize(fragment)
    @title = fragment.inner_text
  #  @url = fragment[0]['href']
  end
end
