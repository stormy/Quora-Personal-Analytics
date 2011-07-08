class Voter

  attr_reader :order, :fullname, :url

  def initialize(voter,index)
    @order = index
    @fullname = voter.inner_text
    @url = voter.attribute('href').value
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
