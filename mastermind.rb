require 'sinatra'
require 'sinatra/reloader'
require './libs/mastermind.rb'



def make_new_code(code)
  @game.setup_original(code)
end

def init_game
  @game = Mastermind.new(['1','2','3','4'],4,12)
  make_new_code([1,2,3,4])
end

def make_guess(guess)
  @game.make_guess(guess)
  @game.check_guess
end

get '/' do
  init_game unless @game
  make_guess("1,1,1,1")
  make_guess("2,2,2,2")
  make_guess("3,4,1,1")
  erb :index, :locals => {:hidden_code => @game.board.original, :old_guesses => @game.old_guesses, :old_responses => @game.old_responses}
end
