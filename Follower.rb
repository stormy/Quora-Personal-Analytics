class Follower

  attr_reader :fullname, :firstname, :img_src, :id, :bio, :url

  def initialize(follower_html_fragment)
    @fullname = follower_html_fragment.css('.user').inner_text
    @firstname = @fullname.split(' ')[0]
    @img_src = follower_html_fragment.css('.profile_photo_img').attribute('src').value
    @id = @img_src.split('thumb-')[1].to_s.split('-')[0]
    @bio = follower_html_fragment.css('.rep').inner_text.strip
    @url = follower_html_fragment.css('.user').attribute('href').value
  end
end

