class Content

  attr_reader :text, :images, :breaks, :italics, :blockquote, :list_item, :links, :underline, :codeblock, :latex

  def initialize(fragment)
    strip_divs(fragment.dup)
    @text = fragment.inner_text
    @images = fragment.css('.qtext_image')
    @breaks = fragment.css('br')
    @italics = fragment.css('i')
    @blockquote = fragment.css('blockquote')
    @list_item = fragment.css('li')
    @links = fragment.css('a')
    @underline = fragment.css('u')
    @codeblock = fragment.css('.codeblocktable') #+ fragment.css('pre')
    @latex = fragment.css('.math')
  end

  def strip_divs(content_div)
    stripped = content_div
     stripped.css('.comments.answer_comments.hidden').remove
     stripped.css('.answer_user').remove
     stripped.css('.action_bar').remove
     stripped.css('.add_answer_tag').remove
     stripped
  end
end
