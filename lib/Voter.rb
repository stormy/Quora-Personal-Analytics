class Voter

  attr_reader :order, :fullname, :url, :answer_url

  def initialize(voter,index,answer_url)
    @order = index
    @fullname = voter.inner_text
    @url = voter.attribute('href').value
    @answer_url = answer_url
  end

  def ==(other)
    @url==other.url
  rescue
    false
  end
  
  alias eql? ==

  def hash
    code = 17
    code = 37*code + @url.hash
    code = 37*code + @fullname.hash
   #code = 37*code + @order.hash ##Voter could have a different order on different answer
    code
  end
    

end
