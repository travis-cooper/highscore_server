require 'sinatra'

set :public_folder, File.dirname(__FILE__) + "/html5"

get '/' do
    response.headers['Access-Control-Allow-Origin'] = "*"
    high_scores = File.read('highscores.txt')
    body high_scores
end

post '/:initials/:score' do
     score_list = []
     score_file = File.open('highscores.txt', 'r')
     # parse score file into an array of hashes
     score_file.each_line do |line|
       line_fields = line.split(":")
       score_list.push({initials: line_fields[0], score: line_fields[1]})
     end
     score_file.close
     all_scores = ""
     # see if score is higher than any of our stored scores
     if score_list.length >= 10
       score_list.each do |high_score|
         if params[:score].to_i > high_score[:score].to_i
           high_score[:initials] = params[:initials]
	   high_score[:score] = params[:score]
         end
         # write new scores to file
         all_scores += high_score[:initials] + ":" + high_score[:score] + "\n"       
       end
     else
       all_scores += params[:initials] + ":" + params[:score] + "\n"
     end
     new_score_file = File.open('highscores.txt', 'w')
     new_score_file.write(all_scores)
     score_file.close
end