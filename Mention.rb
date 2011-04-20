class Mention

  attr_reader :title, :url

  def initialize(fragment)
    @title = fragment.css('h2').inner_text
    @url = fragment.css('h2')
  end
end


