user.answers.each_with_index do |answer, index|
  if not answer.content.emotion.parsed_response['Compassion'] == nil
    puts "    <script type='text/javascript'>
    
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
    </script>
"

    puts "<h1>#{answer.title}</h1><ul><li>Votes: #{answer.votes}</li></ul>"
    puts "<div id='chart_div#{index}'></div>"
    puts "<table>"
    answer.content.emotionwords.each do |word|
      puts "<tr>"
      word.each do |emotion|
        puts "<td>#{emotion}</td>"
      end
      puts "</tr>"
    end
    
    puts "</table>"

  end
end
