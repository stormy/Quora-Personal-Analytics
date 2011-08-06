class Topic

  attr_reader :title, :url, :answers, :endorsements, :endorsers, :bio, :fragment

  def initialize(fragment)
    @fragment = fragment
    @title = fragment.css('.topic_name').length == 1 ? fragment.css('.topic_name').inner_text : fragment.css('.topic_name')[1].inner_text
    @url = fragment.css('a.topic_name')[0]['href']
    @answers = build_answers(fragment.css('.light.feed_item_activity a'))
    @endorsements = fragment.css('.light.feed_item_activity > span')[0].inner_text == "Endorse" ? 0 : fragment.css('.light.feed_item_activity > span')[0].inner_text.split(' ')[0].to_i
    @endorsers = build_endorsers(fragment.css('.photo_tooltip'))
    @bio = fragment.css('.user_topic_sig > div.inline').empty? ? "" : fragment.css('.user_topic_sig > div.inline').inner_text.to_s
  end

  def build_endorsers(endorsers)
    endorse_list = []
    if endorsers.empty?
      endorse_list = []
    else
      endorsers.each_with_index do |x,i|
        endorse_list << x.css('a')[0]['href'] 
      end
    end
      endorse_list
  end

  def build_answers(answers)
    answers
    if answers.empty?
      return 0
    elsif answers.length == 1
      answers[0].inner_text.split(' ')[0].to_s
    else
      answers[1].inner_text.split(' ')[0].to_s
    end
   end
end
