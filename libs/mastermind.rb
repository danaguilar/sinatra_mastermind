class Mastermind
  #Things needed for the game
  ## Players
  ### Players create codes
  ### First player creates a code that is stored in the board
  ### Second player creates a code and gives it as a guess to the board
  ### The board compare the two and gives a responce back based on how close the guess was to the original
  attr_reader :board
  attr_accessor :old_guesses, :old_responses
  class GameBoard
    attr_reader :original, :guess, :array_of_options, :num_of_options
    def initialize(array_of_options, num_of_options)
      @original = []
      @guess = []
      @array_of_options = array_of_options
      @num_of_options = num_of_options
    end

    def set_original?(peg_list)
      @original = []
      peg_list.each {|peg| @original << peg}
      return true
    end

    def set_guess?(peg_list)
      @guess = []
      peg_list.each {|peg| @guess << peg}
      return true
    end

    def valid_code?(peg_list)
      return false unless ( (peg_list -  @array_of_options).size == 0) && peg_list.size == @num_of_options
      return true
    end


    def compare_codes #1 means match. 0 means color is the same but no match
      response = []
      self.same_colors_count.times {response << 0}


      @original.each_with_index do |peg,index|
        if @original[index] == @guess[index]
          response.pop
          response.unshift(1)
        end
      end

      until response.size >= @num_of_options do
        response << ' '
      end

      return response
    end

    def same_colors_count
      count = 0
      @array_of_options.each do |color|
         count += [@original.select{|peg| peg == color}.size, @guess.select{|peg| peg == color}.size].min
      end
      return count
    end
  end

  class AIPlayer
    attr_reader :name
    def initialize(name)
      @name = name
    end
    def name_says
      return "#{@name} says: "
    end
    def say_thinking
      puts name_says + "Thinking...."
      sleep(1)
    end
    def say_excited
      puts name_says + "I got it!"
      sleep(1.0/2.0)
    end
    def say_frustrated
      puts name_says + "Wait that's not right..."
      sleep(1)
    end
    def say_victory
      puts name_says + "I did it! I am the greatest!"
      sleep(1.0/2.0)
    end
    def generate_random_code(num_of_options, array_of_options)
      code = []
      num_of_options.times do
        code << array_of_options.sample
      end
      return code
    end

    def guess_code(board, game)
      self.say_thinking
      self.say_excited
      guess_array =  generate_random_code(board.num_of_options, board.array_of_options)
      game.old_guesses << guess_array
      board.set_guess?(guess_array)
    end

  end


  def initialize(array_of_options, num_of_options, num_of_turns)
    @board = GameBoard.new(array_of_options, num_of_options)
    @num_of_turns = num_of_turns
    @old_guesses = Array.new
    @old_responses = Array.new
    @victory_condition = Array.new
    num_of_options.times {@victory_condition << 1}
  end

  def setup_original(code)
    @board.set_original?(code)
  end


  def make_guess(guess) #guess is a given string with each guess seperated by a comma
    guess_array = guess.split(',')
    guess_array.each {|word| word.strip!}
    return false unless @board.valid_code?(guess_array)
    @old_guesses << guess_array
    @board.set_guess?(guess_array)
    return true
  end

  def make_original(code)
    code_array = code.split(',')
    code_array .each {|word| word.strip!}
    return false unless @board.valid_code?(code_array)
    @board.set_original?(code_array)
    return true
  end

  def prompt(type_string,is_original)
    print "The code is #{@board.num_of_options} long and can contain any of the following: "
    @board.array_of_options.each{|option| print "[#{option}]"}
    print "\n"
    print "Make your #{type_string} below. Please seperate every item with a ','\n"

    code = gets.chomp
    if is_original
      until make_original(code) do
        puts "Your guess is invalid! Please try again"
        code = gets.chomp
      end
    else
      until make_guess(code) do
        puts "Your guess is invalid! Please try again"
        code = gets.chomp
      end
    end
  end

  def check_guess
    @old_responses << @board.compare_codes
  end

  def play
    comp_score = play_as_codebreaker(@computer)
    player_score = play_as_codemaker(@computer)
    puts "#{@computer.name}: #{comp_score}"
    puts "You: #{player_score}"
    if player_score > comp_score
      puts "You win the game!"
    elsif comp_score < player_score
      puts "#{@computer.name} wins the game!"
    else
      puts "It's a tie!"
    end
  end

  def play_as_codemaker(comp)
    @old_responses = Array.new
    @old_guesses = Array.new
    prompt("code",true)
    @num_of_turns.times do |turn_num|
      comp.guess_code(@board, self)
      self.check_guess
      self.draw_board
      if has_won?
        comp.say_victory
        return turn_num
      end
      comp.say_frustrated
    end
    puts "You are too smart for me...."
    puts "Ah I see... The correct code was #{@board.original.inspect}. Clever"
    return @num_of_turns+ 1
  end


  def play_as_codebreaker(comp)
    @old_responses = Array.new
    @old_guesses = Array.new
    self.setup_original(@computer.generate_random_code(@board.num_of_options, @board.array_of_options))
    self.draw_board
    @num_of_turns.times do |turn_num|
      prompt("guess",false)
      self.check_guess
      self.draw_board
      if has_won?
        return turn_num
      end
    end
    puts "You couldn't figure it out...."
    puts "The correct code was #{@board.original.inspect}"
    return @num_of_turns+ 1
  end

  def has_won?
    return true if (@old_responses.last <=> @victory_condition) == 0
    return false
  end

  def code_to_s(code_array, index)
    return draw_empty if code_array[index].nil?
    response = ""
    code_array[index].each do |item|
      response << "[#{item}]"
    end
    return response
  end

  def draw_empty
    blanks = ''
    @board.num_of_options.times do
      blanks << "[ ]"
    end
    return blanks
  end

  def draw_board
    puts "Responses    | Guesses"
    @num_of_turns.times do |num|
      print code_to_s(@old_responses, num)
      print " | "
      print code_to_s(@old_guesses, num)
      print "\n"
    end
  end

end

#new_game = Mastermind.new(['1','2','3','4'],4,12)
#new_game.play
