class About

  attr_reader :bio, :id

  def initialize(fragment)
    @bio = fragment.css('.row.section.section_border.p1').css('hidden.expanded_q_text').inner_text
    @id = "".split('thumb-')[1].to_s.split('-')[0]
    @main_topics = ""
  end
end

