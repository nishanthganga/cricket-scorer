require '../cricket_scorer.rb'

describe 'UserString' do
	
	describe 'tests valid_string? method' do

		it 'validates the user entered string' do
			user_entered_string = UserString.new("1")
			expect(user_entered_string.valid_string?).to eq(true)

			user_entered_string = UserString.new("6")
			expect(user_entered_string.valid_string?).to eq(true)

			user_entered_string = UserString.new("7")
			expect(user_entered_string.valid_string?).to eq(false)

			user_entered_string = UserString.new("1w")
			expect(user_entered_string.valid_string?).to eq(true)

			user_entered_string = UserString.new("w1")
			expect(user_entered_string.valid_string?).to eq(false)

			user_entered_string = UserString.new("7w")
			expect(user_entered_string.valid_string?).to eq(false)
		end

	end

	describe 'test is_extra? method' do

		it 'validates if the string is of a extra type' do 
			user_entered_string = UserString.new("1")
			expect(user_entered_string.is_extra?).to eq(false)

			user_entered_string = UserString.new("w")
			expect(user_entered_string.is_extra?).to eq(true)

			user_entered_string = UserString.new("2w")
			expect(user_entered_string.is_extra?).to eq(true)

			user_entered_string = UserString.new("w2")
			expect(user_entered_string.is_extra?).to eq(false)
		end

	end


	describe 'test is_a_command? method' do

		it 'validates if the user entered a string' do 
			user_entered_string = UserString.new("1")
			expect(user_entered_string.is_a_command?).to eq(false)

			user_entered_string = UserString.new("scoreboard")
			expect(user_entered_string.is_a_command?).to eq(true)

			user_entered_string = UserString.new("2w")
			expect(user_entered_string.is_a_command?).to eq(false)

			user_entered_string = UserString.new("partnership")
			expect(user_entered_string.is_a_command?).to eq(true)

			user_entered_string = UserString.new("partner")
			expect(user_entered_string.is_a_command?).to eq(false)
		end

	end


	describe 'test get_runs_and_extra_type method' do

		it 'validates runs and extra type from the user entered input' do 
			user_entered_string = UserString.new("1w")
			runs, extra_type = user_entered_string.get_runs_and_extra_type
			expect(runs).to eq(1)
			expect(extra_type).to eq("w")

			user_entered_string = UserString.new("2n")
			runs, extra_type = user_entered_string.get_runs_and_extra_type
			expect(runs).to eq(2)
			expect(extra_type).to eq("n")

			user_entered_string = UserString.new("w")
			runs, extra_type = user_entered_string.get_runs_and_extra_type
			expect(runs).to eq(1)
			expect(extra_type).to eq("w")
			
		end

	end

	describe 'test get_runs method' do

		it 'validates runs from the user entered input' do 
			user_entered_string = UserString.new("1w")
			runs = user_entered_string.get_runs
			expect(runs).to eq(1)

			user_entered_string = UserString.new("2n")
			runs = user_entered_string.get_runs
			expect(runs).to eq(2)

			user_entered_string = UserString.new("1")
			runs = user_entered_string.get_runs
			expect(runs).to eq(1)

			user_entered_string = UserString.new("0")
			runs = user_entered_string.get_runs
			expect(runs).to eq(0)
			
		end

	end

	describe 'Class variables counts and values' do

		it 'tests runs type count' do
			expect(UserString.class_variable_get(:@@run_types).count).to equal(7)
		end	

		it 'tests the values stored in @@run_types' do
		    run_types = UserString.class_variable_get(:@@run_types)
			expect(run_types).to contain_exactly("0", "1", "2", "3", "4", "5", "6")
		end

		it 'tests extra runs type count' do
			expect(UserString.class_variable_get(:@@extra_run_types).count).to equal(5)
		end	

		it 'tests the values stored in @@extra_run_types' do
		    extra_run_types = UserString.class_variable_get(:@@extra_run_types)
			expect(extra_run_types).to contain_exactly("w", "n", "b", "l", "p")
		end

		it 'tests command count' do
			expect(UserString.class_variable_get(:@@commands).count).to equal(7)
		end	

		it 'tests the values stored in @@commands' do
		    commands = UserString.class_variable_get(:@@commands)
			expect(commands).to contain_exactly("scoreboard", "partnership", "score", "overs", "runrate", "out", "inputs")
		end

	end


end
