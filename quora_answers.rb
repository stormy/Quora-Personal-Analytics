require 'rubygems'
require 'CSV'
require 'nokogiri'
require 'pp'

STDOUT.sync = true

directory = "#{ENV['HOME']}/Quora-Personal-Analytics"

if not Dir.pwd == directory
  Dir.chdir directory
end

doc = File.open("answers_#{ARGV[0]}.html")
pp "Now processing" + doc.inspect
puts "\n"
page = Nokogiri::HTML(doc)
doc.close

answerer_name = page.search('h1').inner_text
date = DateTime.now.to_s

outfile = File.open("#{answerer_name}_answers_#{date}.csv", 'ab')
CSV::Writer.generate(outfile, ',') do |csv|
 csv << [ "question", "question_url", "answerer", "answerer_url", "answerer_bio", "votes", "comments_num", "answer_date", "images",
   "breaks", "italics", "blockquote", "list_item", "anchor", "underline", "codeblock", "latex", "answer_length", "answer", "answer_url", "voter_list", "commenter_list" ]
end

outfile_voters = File.open("#{answerer_name}_voters_#{date}.csv", 'ab')
CSV::Writer.generate(outfile_voters, ',') do |csv|
 csv << [ "question", "voter_name", "voter_url" ]
end

outfile_commenters = File.open("#{answerer_name}_commenters_#{date}.csv", 'ab')
CSV::Writer.generate(outfile_commenters, ',') do |csv|
 csv << [ "question", "commenter_url" ]
end

def content(content_div)
   content_div.css('.comments.answer_comments.hidden').remove
   content_div.css('.answer_user').remove
   content_div.css('.action_bar').remove
   content_div
end

def comments(comment)
  if comment.search('a[@class="view_comments supp "]').inner_text =~ /Add Comment/
   0
  else
    comment.search('a[@class="view_comments supp "]').inner_text.split(' ')[0]
  end
end

def voters(list)
  array = Array.new
  list.each_with_index do |x,i|
    array[i] = x.attribute('href').value
  end

  array2 = Array.new
  list.each_with_index do |x,i|
    array2[i] = x.inner_text
  end

  ordered_list = Array.new
  list.each_with_index do|x,i|
    ordered_list[i] = [array2[i], array[i]]
  end
  ordered_list
end

most_votes = []
most_comments = []
total_votes = 0
total_comments = 0
total_answers = 0
total_images = 0
total_quotes = 0
total_links = 0
voter_array = []

page.css('div.e_col.w4_5').each_with_index do |answer, index|
  
  print "*"
  
  comment_urls = answer.search('p[@class="action_bar"]//a[@class="user"]').collect {|x| x.attribute('href').value}
  voter_urls = answer.search('span[@class="answer_voters"]//a[@class="user"]').collect {|x| x.attribute('href').value}.uniq
  
  answer_info = {
    'question' => answer.search('a[@class="question_link"]').inner_text,
    'question_url' => answer.search('a[@class="question_link"]').attribute('href').value,
    'answerer' => answer.search('span[@class="feed_item_answer_user"]/a').inner_text,
    'answerer_url' => answer.search('span[@class="feed_item_answer_user"]/a').attribute('href').value,
    'answerer_bio' => answer.search('span[@class="rep"]').inner_text.split(',')[1].strip,
    'votes' => answer.search('strong[@class="voter_count"]').inner_text,
    'voter_list' => voters(answer.search('span[@class="answer_voters"]//a[@class="user"]')).uniq,
    'comments_num' => comments(answer.search('div[@class="action_bar"]')),
    'answer_url' => answer.search('a[@class="answer_permalink"]').attribute('href').value,
    'answer_date' => answer.search('a[@class="answer_permalink"]').inner_text,
    'answer' => content(answer.search('div[@class="feed_item_answer_content answer_content"]')).inner_text,
    'answer_length' => content(answer.search('div[@class="feed_item_answer_content answer_content"]')).length,
    'images' => answer.search('div[@class="feed_item_answer_content answer_content"]/img').length - content(answer.search('div[@class="feed_item_answer_content answer_content"]')).search('img[@class="math"]').length,
    'breaks' => content(answer.search('div[@class="feed_item_answer_content answer_content"]')).search('br').length,
    'italics' => content(answer.search('div[@class="feed_item_answer_content answer_content"]')).search('i').length,
    'blockquote' => content(answer.search('div[@class="feed_item_answer_content answer_content"]')).search('blockquote').length,
    'list_item' => content(answer.search('div[@class="feed_item_answer_content answer_content"]')).search('li').length,
    'anchor' => content(answer.search('div[@class="feed_item_answer_content answer_content"]')).search('a').length,
    'underline' => content(answer.search('div[@class="feed_item_answer_content answer_content"]')).search('u').length,
    'codeblock' => content(answer.search('div[@class="feed_item_answer_content answer_content"]')).search('table[@class="codeblocktable"]').length + content(answer.search('div[@class="feed_item_answer_content answer_content"]')).search('pre').length,
    'latex' => content(answer.search('div[@class="feed_item_answer_content answer_content"]')).search('img[@class="math"]').length,
    'commenter_list' => comment_urls,
  }

  most_comments << answer_info['commenter_list']
  most_votes << voter_urls
  total_votes += answer_info['votes'].to_i
  total_comments += answer_info['comments_num'].to_i
  total_answers += 1
  total_images += answer_info['images']
  total_quotes += answer_info['blockquote']
  total_links += answer_info['anchor']

  CSV::Writer.generate(outfile, ',') do |csv|
    csv << [ answer_info['question'], answer_info['question_url'], answer_info['answerer'], answer_info['answerer_url'], 
      answer_info['answerer_bio'], answer_info['votes'], answer_info['comments_num'], answer_info['answer_date'], answer_info['images'], answer_info['breaks'],
      answer_info['italics'], answer_info['blockquote'], answer_info['list_item'], answer_info['anchor'], answer_info['underline'], answer_info['codeblock'], 
      answer_info['latex'], answer_info['answer_length'], answer_info['answer'], answer_info['answer_url'], answer_info['voter_list'],
      answer_info['commenter_list'] ]
  end

  answer_info['voter_list'].each do |voter|
    CSV::Writer.generate(outfile_voters, ',') do |csv|
      csv << [ answer_info['question'], voter[0], voter[1] ]
    end
  end

  answer_info['commenter_list'].each do |comment|
  CSV::Writer.generate(outfile_commenters, ',') do |csv|
    csv << [ answer_info['question'], comment  ]
  end
  end
end

b = Hash.new(0)
c = Hash.new(0)

most_comments.flatten.sort.each do |v|
  b[v] +=1
end

most_votes.flatten.sort.each do |v|
  c[v] +=1
end

puts "########Top Commenters########"
pp b.sort {|a,b| a[1]<=>b[1]}
puts "########End Top Commenters########"
puts "\n"
puts "########Top Voters########"
pp c.sort {|a,b| a[1]<=>b[1]}
puts "########End Top Voters########"
puts "\n"

#c.each do |k,v|
  #percent = v.quo(total_answers)*100.to_f
  #pp k + " has upvoted " + v.to_s + " answers and votes " + percent.to_s + " percent of the time."
#end

puts "########Answer Summary Stats########"
puts "Total answers: " + total_answers.to_s
puts "Total votes: " + total_votes.to_s
puts "Total comments: " + total_comments.to_s
puts "Total images: " + total_images.to_s
puts "Total quotes: " + total_quotes.to_s
puts "Total links: " + total_links.to_s
