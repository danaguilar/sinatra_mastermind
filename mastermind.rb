require 'sinatra'
require 'sinatra/reloader'
require './libs/mastermind.rb'

@@game = Mastermind.new(['1','2','3','4'],4,12)
@@turn = 1
def make_new_code
  code = Array.new
  options = ['1','2','3','4']
  4.times do
    code << options.sample
  end
  @@game.setup_original(code)
end

def make_guess(guess)
  @@game.make_guess(guess)
  @@game.check_guess
end

def guess(params)
  guess = Array.new
  guess << params["input1"]
  guess << params["input2"]
  guess << params["input3"]
  guess << params["input4"]
  make_guess(guess.join(','))
end

make_new_code
get '/' do
  if params['reset']
    @@game = Mastermind.new(['1','2','3','4'],4,12)
    @@turn = 1
    make_new_code
  elsif params["input1"]
    guess(params)
    @@turn += 1
  end
  checked_guess = @@game.board.compare_codes
  erb :index, :locals => {:hidden_code => @@game.board.original, :old_guesses => @@game.old_guesses,:old_responses => @@game.old_responses, :turn => @@turn,
  :won => (@@game.has_won?)}
end
