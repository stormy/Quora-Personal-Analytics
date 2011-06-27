def create(user)
  open('output_file.html', 'w') do |f|

   
    f.puts "<html>
      <head>
        <!--Load the AJAX API-->
        <script type='text/javascript' src='https://www.google.com/jsapi'></script>
    </head>
    <body>"

    user.answers.each_with_index do |answer, index|
      if not answer.content.emotion.parsed_response['Compassion'] == nil
        f.puts "    <script type='text/javascript'>
        
          // Load the Visualization API and the piechart package.
          google.load('visualization', '1', {'packages':['corechart']});
          
          // Set a callback to run when the Google Visualization API is loaded.
          google.setOnLoadCallback(drawChart);
          
          // Callback that creates and populates a data table, 
          // instantiates the pie chart, passes in the data and
          // draws it.
          function drawChart() {

          // Create our data table.
          var data = new google.visualization.DataTable();
          data.addColumn('string', 'Emotions');
          data.addColumn('number', 'Intensity');
          data.addRows([
            ['Compassion', #{answer.content.emotion.parsed_response['Compassion']['ChartLevel']}],
            ['Confidence', #{answer.content.emotion.parsed_response['Confidence']['ChartLevel']}],
            ['Anxiety', #{answer.content.emotion.parsed_response['Anxiety']['ChartLevel']}],
            ['Hostility', #{answer.content.emotion.parsed_response['Hostility']['ChartLevel']}],
            ['Depression', #{answer.content.emotion.parsed_response['Depression']['ChartLevel']}],
            ['Happiness', #{answer.content.emotion.parsed_response['Happiness']['ChartLevel']}]

          ]);

          // Instantiate and draw our chart, passing in some options.
          var chart = new google.visualization.BarChart(document.getElementById('chart_div#{index}'));
          chart.draw(data, {width: 400, height: 240});
        }
        </script>"
 

        f.puts "<h1>#{answer.title}</h1><ul><li>Votes: #{answer.votes}</li></ul>"
        f.puts "<div id='chart_div#{index}'></div>"
        
        answer.content.emotionwords.parsed_response['Compassion'].each do |word|
          if word['Level'] > 2
           f.puts word['Word'] + "<>"
          end
        end
        f.puts "</br>" 
        answer.content.emotionwords.parsed_response['Confidence'].each do |word|
          if word['Level'] > 2
           f.puts word['Word'] + "<>"
          end
        end
        f.puts "</br>"

        answer.content.emotionwords.parsed_response['Anxiety'].each do |word|
          if word['Level'] > 2
           f.puts word['Word'] + "<>"
          end
        end
        f.puts "</br>"

        answer.content.emotionwords.parsed_response['Hostility'].each do |word|
          if word['Level'] > 2
           f.puts word['Word'] + "<>"
          end
        end
        f.puts "</br>"
        answer.content.emotionwords.parsed_response['Depression'].each do |word|
          if word['Level'] > 2
           f.puts word['Word'] + "<>"
          end
        end
        f.puts "</br>"  
        answer.content.emotionwords.parsed_response['Happiness'].each do |word|
          if word['Level'] > 2
           f.puts word['Word'] + "<>"
          end
        end
      end
    end


    f.puts "</body>
    </html>"

  end
end


