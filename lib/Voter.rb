class Voter

  attr_reader :order, :fullname, :url

  def initialize(voter,index)
    @order = index
    @fullname = voter.inner_text
    @url = voter.attribute('href').value
  end
end
