require 'rubygems'
require 'eventmachine'
require 'em-http'
require 'nokogiri'

CHUNK_SIZE = 5

look_up_list = ["Jan-Mixon",
"John-Morrow",
"Marc-Bodnick",
"Charlie-Cheever",
"Seb-Paquet",
"Yishan-Wong",
"Mircea-Goia",
"Eunji-Choi",
"Garrick-Saito",
"Ryan-Lackey",
"Xianhang-Zhang",
"Alan-Cohen-1",
"Gary-Stein",
"Peter-Clark",
"Todd-Gardiner",
"Rakesh-Agrawal-2",
"Fred-Landis",
"Adam-DAngelo",
"Venkatesh-Rao",
"Neil-Russo",
"Andy-Lemke",
"James-Mcfeley",
"Jeff-Hammerbacher",
"Jessica-Hui",
"Adam-Rifkin",
"Michael-Wolfe",
"Joshua-Engel",
"Erik-Fair",
"Achilleas-Vortselas",
"Liz-Pullen",
"Bill-McDonald",
"Jonathan-Brill",
"Erica-Friedman",
"Ian-Peters-Campbell",
"Shannon-Larson",
"Alex-K-Chen",
"Antone-Johnson",
"Ani-Ravi",
"Mark-Hughes-1",
"Jamie-Beckland",
"Robert-Scoble-1",
"Brandon-Smietana",
"Kartik-Ayyar",
"Lisa-Galarneau",
"Annie-Lausier",
"David-S-Rose",
"Rebekah-Cox",
"Adam-Mordecai",
"Semil-Shah",
"John-Clover",
"Keith-Rabois",
"J.C.-Hewitt",
"Andrew-de-Andrade",
"Jae-Won-Joh",
"Craig-Montuori",
"Nan-Waldman",
"Laszlo-B.-Tamas",
"Jens-Wuerfel",
"Paul-Denlinger",
"Marius-Kempe",
"Jonas-M-Luster",
"Tracy-Chou",
"June-Lin",
"Dheera-Venkatraman",
"Gary-Teal",
"Danielle-Maurer",
"Jim-Gordon",
"Lisa-Borodkin",
"Prakash-Swaminathan",
"Ari-Shahdadi",
"Kelly-Erickson",
"Christopher-Lin",
"Kevin-Der",
"Joel-Lewenstein",
"Brian-Roemmele",
"Katie-Bremer",
"Anthony-Yeh",
"Samantha-Wolov",
"Sean-Owczarek"]

errors = []

data ={} 

def process_chunk(chunk,data)
  EventMachine.run do
    multi = EventMachine::MultiRequest.new

    chunk.each do |item|
      multi.add(EventMachine::HttpRequest.new("http://www.quora.com/#{item}/").get :head => {"User-Agent" => "RubyWatir/1 (stormyshippy@gmail.com)"}, :query=> {'name' => item})
    end

    multi.callback do
      multi.responses[:succeeded].each do |success|


        doc = Nokogiri::HTML(success.response)
          doc.css('.tab.linked_list_item').each do |x|
            if x.inner_text =~ /^Answers/
              data[success.options[:query]["name"]] = x.inner_text.split(' ')[1].to_i
            end
          end
      end

      multi.responses[:failed].each do |failed|
        errors << failed.options[:query]["ref"] unless failed.nil?
      end

      EventMachine.stop

     # p multi.responses[:failed]
    end
  end
end

look_up_list.each_slice(CHUNK_SIZE).to_a.each do |chunk|
  process_chunk(chunk,data)
end

puts data.sort{|a,b| -1*(a[1]<=>b[1])}.each{|x| puts "http://www.quora.com/" + x[0].to_s + " - " + x[1].to_s}
