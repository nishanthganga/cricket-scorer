class UserString

	attr_accessor :user_entered_string
	@@run_types = ["0", "1", "2", "3", "4", "5", "6"]
	@@extra_run_types = ["w", "n", "b", "l", "p"]
	@@commands = ["scoreboard", "partnership", "score", "overs", "runrate", "out", "inputs"]

	def initialize(user_entered_string)
	 @user_entered_string = user_entered_string
	end

	def valid_string?

	if user_entered_string.nil?
		return -1
	end	
		
	 string_length = user_entered_string.length
		
		case string_length
		when 1
		  if (@@run_types.include? user_entered_string) || (@@extra_run_types.include? user_entered_string)
		  	return true
		  end

		when 2
		  if (@@run_types.include? user_entered_string[0]) && (@@extra_run_types.include? user_entered_string[1])
		  	return true
		  end
		
		else
		  return true if (@@commands.include? user_entered_string)
		end
		
		return false
	end

	def is_extra?
		return true if (user_entered_string.length == 2) && (@@run_types.include? user_entered_string[0]) && (@@extra_run_types.include? user_entered_string[1])
		return true if @@extra_run_types.include? user_entered_string
		return false
	end

	def is_a_command?
		return true if (@@commands.include? user_entered_string)
		return false
	end

	def get_runs_and_extra_type
		return [user_entered_string[0].to_i, user_entered_string[1]] if user_entered_string.length == 2
		return [1, user_entered_string] if user_entered_string.length == 1
	end

	def get_runs
		user_entered_string[0].to_i
	end

end



class ScoreBoard
	@@team_name = "India"
	@@team = ["Rohit Sharma", "S Dhawan", "V Kohli", "MK Pandey", "MS Dhoni", "KM Jadhav", "H Pandya", "Kuldeep Yadav", "B Kumar", "YS Chahal", "JJ Bumrah"]
	@@extra_run_types   	 = ["w", "n", "b", "l", "p"] 
	@@legal_delievery 		 = 120
	@@team_score_total   	 = 0
	@@number_of_balls_bowled = 0
	@@current_partnership    = 0
	@@sample_messages_for_runs_and_extras = {
		 "0" => ["Its a dot ball.", "No run taken by Player."],
	     "1" => ["Player gets a run.", "Player takes a single.", "A single for Player"],
	     "2" => ["Player taken two.", "2 runs for Player."],
	     "3" => ["3 runs for Player. Good running between the wickets by the two batsmen.",
	     	 "Quick running between the wicket get Player 3 runs."],
	     "4" => ["Smashed! That's FOUR for Player.", "Player hits it for FOUR. That's brilliant.",
	     	 "That went like a tracer bullet! FOUR run for Player.", "Excellent shot by Player. Gets a FOUR."], 
	     "5" => ["5 runs for Player.", "Player takes 5 runs."], 
	     "6" => ["That's HUGE!! Player hits it for a SIX.", "Oh! The ball is out of here. Player smashes it for a SIX.", 
	     	 "Humongous hit that! Player hits SIX!.", "Wow! Player hits a SIX."], 
	     "w" => ["Oh that's a WIDE", "The bowler bowls a WIDE delievery."],
	     "n" => ["NO BALL!", "The bowler bowls a NO BALL!."],
	     "b" => ["BYES!", "The umpire signal it a BYE."],
	     "l" => ["That's a LEG BYE.", "The umpire signal it a LEG BYE."],
	     "p" => ["PENALTY runs given."], 
	     "extra_runs" => ["no_of_extras extra runs added to the team's total.", "#{@@team_name} gets no_of_extras extra runs.", 
	     	"no_of_extras runs for the team."]
	  } 

	def self.default_player_entries
	    @@team.each_with_object({}) do |player, hash|
	      hash[player] = yield
	    end
	end

	def self.change_striker
		@@striker, @@non_striker = @@non_striker, @@striker
	end

	def self.check_striker(runs)
		if (runs.odd?) && (@@number_of_balls_bowled % 6 != 0)
			change_striker
		elsif ((runs.even?) || (runs == 0)) && (@@number_of_balls_bowled % 6 == 0)
			change_striker
		end
	end

	def self.initial_extra_type_counter
		@@extra_run_types.each_with_object({}) do |extra_type, hash|
	      hash[extra_type] = 0
	    end
	end

	def self.convert_balls_to_overs(balls)
		in_overs = balls.divmod(6)
		return "#{in_overs[0]}.#{in_overs[1]}"
	end

	def self.dismissed_players_count
		@@player_batting_status.values.count {|v| v == "out"}
	end

	def self.show_message(runs)
        runs = runs.to_s
		message = @@sample_messages_for_runs_and_extras.fetch(runs).sample.gsub("Player", @@striker)
		line_of_stars
		puts message
		line_of_stars
	end

	def self.show_message_for_extra(runs, extra_type)
		runs_message = runs > 1 ? @@sample_messages_for_runs_and_extras.fetch("extra_runs").sample.gsub("no_of_extras", runs.to_s) : ""
		runs = runs.to_s
		message = @@sample_messages_for_runs_and_extras.fetch(extra_type).sample
		line_of_stars
		puts message + " " + runs_message
		line_of_stars
	end

	def self.score
		 puts <<~SCORE_TEXT
			*********************************************
			Score  : #{team_score_and_wickets}
			Overs  : #{overs_up}
			Runrate: #{cal_run_rate}
			Current Batsmen  
			#{@@striker} #{@@runs_scored_by_players[@@striker]}* (#{@@balls_played_by_players[@@striker]})  
			#{@@non_striker} #{@@runs_scored_by_players[@@non_striker]} (#{@@balls_played_by_players[@@non_striker]})  
			*********************************************
	    SCORE_TEXT
	end

	def self.team_score_and_wickets
		return "#{@@team_score_total}/#{dismissed_players_count}"
	end

	def self.inputs
		 puts <<~INPUT_TEXT
			You can enter runs, extras and  commands. 
			RUNS EXAMPLES    : 1, 2, 3, 4, 5, 6
			EXTRA EXAMPLES   : w, n, b, l, p, 2w, 4w, 2n, 5p 
			('w' for wide, 'n' for no ball, 'b' for bye, 'l' for leg bye, 'p' for penalty)
			COMMAND EXAMPLES : \"scoreboard\", \"partnership\", \"score\", \"overs\", \"runrate\", \"out\""
	    INPUT_TEXT
	end

	def self.scoreboard
		puts "\n"
		puts "******************************* SCOREBOARD *******************************"
		puts "#{ @@team_name .ljust(30)}  #{'Runs'.ljust(8)} #{'Balls'.ljust(8)} #{'4s'.ljust(5)} #{'6s'.ljust(5)} #{'Strike Rate'.ljust(8)}"
		puts "**************************************************************************"
		@@team.each do |player|
			player_name = @@player_batting_status[player] == "batting" ? player + "*" : player
			player_batting_status = @@player_batting_status[player] == "not out" ? "yet to bat" : @@player_batting_status[player]
			player_runs = @@runs_scored_by_players[player].to_s
			player_balls = @@balls_played_by_players[player].to_s
			if (@@balls_played_by_players[player] > 0)
				player_strike_rate = (@@runs_scored_by_players[player] * 100).to_f / @@balls_played_by_players[player]
			    player_strike_rate = player_strike_rate.round(2).to_s
			else
				player_strike_rate = "-"
			end
			player_fours = @@fours_hit_by_players[player].to_s
			player_sixes = @@sixes_hit_by_players[player].to_s
			puts "#{player_name.ljust(16)} #{player_batting_status.ljust(14)} #{player_runs.ljust(8)} #{player_balls.ljust(8)} #{player_fours.ljust(5)} #{player_sixes.ljust(5)} #{player_strike_rate.ljust(8)}"
		end
		puts "**************************************************************************"
		puts "Score   : #{team_score_and_wickets} \t Overs  : #{overs_up}"
		puts "Runrate : #{cal_run_rate}"
		puts "Extras  : #{@@extra_type_counter.values.inject(:+)}\n(w #{@@extra_type_counter['w']}, n #{@@extra_type_counter['n']}, b #{@@extra_type_counter['b']}, l #{@@extra_type_counter['l']}, p #{@@extra_type_counter['p']})"
		puts "**************************************************************************"
		puts "\n"
		puts "\n"
	end

	def self.out
		@@balls_played_by_players[@@striker] += 1
		@@number_of_balls_bowled += 1
		@@player_batting_status[@@striker] = "out"
		next_player = @@player_batting_status.find {|key, value| value == "not out"}
		puts "Oh! Big blow. #{@@striker} gets out!"
		@@striker 	= next_player[0]
		@@player_batting_status[@@striker] = "batting"
		@@current_partnership = 0
		check_striker(0)
	end

	def self.end_of_the_over?
		if (@@number_of_balls_bowled % 6 == 0) && (@@number_of_balls_bowled > 0)
			puts "After the end of #{overs_up} overs, the score is: "
			score
		end 
	end

	def self.partnership
		line_of_stars
		puts "The current partnership between #{@@striker} and #{@@non_striker} is #{@@current_partnership}"
		line_of_stars
	end

	def self.run_rate
		if @@number_of_balls_bowled > 0
			run_rate = (@@team_score_total.to_f * 6) / @@number_of_balls_bowled
			puts "The current run rate is #{run_rate.round(2)} runs per over"
		else
			puts "No ball bowled yet!"
		end
	end

	def self.cal_run_rate
		if @@number_of_balls_bowled > 0
			run_rate = (@@team_score_total.to_f * 6) / @@number_of_balls_bowled
			run_rate.round(2).to_s
		else
			"0"
		end
	end

	def self.overs_up
		convert_balls_to_overs(@@number_of_balls_bowled)
	end

	def self.overs
		remaining_balls = @@legal_delievery - @@number_of_balls_bowled
		overs_remaining = convert_balls_to_overs(remaining_balls)
		 puts <<~OVERS_TEXT
			*********************************************
			Overs Bowled: #{overs_up}
			Overs Remaining: #{overs_remaining}  
			*********************************************
	    OVERS_TEXT
	end

	def self.check_milestone(runs, type = "team")
		if type == "team" 
			old_runs 		= @@team_score_total
			current_runs    = @@team_score_total + runs
			text_string     = @@team_name
		elsif type == "player"
			old_runs 		= @@runs_scored_by_players[@@striker]
			current_runs    = @@runs_scored_by_players[@@striker] + runs
			text_string		= @@striker
		end

		case true
		 when (old_runs < 50) && (current_runs >= 50)
		 	puts "Fifty up for #{text_string}!"
		 	line_of_stars
		 when (old_runs < 100) && (current_runs >= 100)
		 	puts "Hundred up for #{text_string}!"
		 	line_of_stars
		 when (old_runs < 150) && (current_runs >= 150)
		 	puts "150 up for #{text_string}!"
		 	line_of_stars
		 when (old_runs < 200) && (current_runs >= 200)
		 	puts "200 up for #{text_string}!"
		 	line_of_stars
		 when (old_runs < 250) && (current_runs >= 250)
		 	puts "250 up for #{text_string}!"
		 	line_of_stars
		 when (old_runs < 300) && (current_runs >= 300)
		 	puts "300 up for #{text_string}!"
		 	line_of_stars
		 end 

	end

	def self.update_score(runs)
		check_milestone(runs)
		@@team_score_total += runs
		@@current_partnership += runs
	end


	def self.line_of_stars
		puts "*" * 45
	end
	
	@@player_batting_status   = default_player_entries { "not out" }
	@@extra_type_counter      = initial_extra_type_counter
	@@runs_scored_by_players  = default_player_entries { 0 }
	@@balls_played_by_players = default_player_entries { 0 }
	@@fours_hit_by_players    = default_player_entries { 0 }
	@@sixes_hit_by_players    = default_player_entries { 0 }


	@@striker 	  = @@team[0]
	@@non_striker = @@team[1]
    @@player_batting_status[@@striker] = @@player_batting_status[@@non_striker] = "batting"

    invalid_input = false

    inputs
    score

     until @@number_of_balls_bowled == @@legal_delievery
     #until @@number_of_balls_bowled <= 0
		puts "Enter runs, extras or commands "
		# user_string = gets.chomp 

		tries = gets        # get input
		tries ||= ''        # set to empty string if nil
		user_string = tries.chomp! 


		user_string = UserString.new(user_string)
		
		if user_string.valid_string? && user_string.valid_string? != -1
			if user_string.is_extra?
				if user_string.user_entered_string[0].to_i == 1
					puts " \"#{user_string.user_entered_string}\" is not a valid extra type. Just type \"#{user_string.user_entered_string[1]}\" "
					next
				end
				runs, extra_type = user_string.get_runs_and_extra_type
				show_message_for_extra(runs, extra_type)
				update_score(runs)
				@@extra_type_counter[extra_type] += runs
				check_striker(runs) if runs > 1
			elsif user_string.is_a_command?
				case user_string.user_entered_string
				when "out"
					out
				when "score"
					score
				when "inputs"
					inputs
				when "partnership"
				    partnership
				when "overs"
					overs
				when "runrate"
					run_rate
				when "scoreboard"
					scoreboard
				else
				    puts "Oh! it seams the command isn't working anymore."
				end
			else
				runs = user_string.get_runs
				show_message(runs)
				check_milestone(runs,"player")
				@@number_of_balls_bowled += 1
				update_score(runs)
				@@runs_scored_by_players[@@striker] += runs
				@@fours_hit_by_players[@@striker] += 1 if runs == 4
				@@sixes_hit_by_players[@@striker] += 1 if runs == 6

				@@balls_played_by_players[@@striker] += 1
				check_striker(runs)
			end

			 end_of_the_over? unless user_string.is_a_command?


		elsif user_string.valid_string? == -1
		   
		   invalid_input = true	
		   break 

		else
			puts "Your input is invalid. Please enter runs, extras or commands. Type \"inputs\" to see all available inputs." 
		end
		break if invalid_input == true
	end #loops


end
