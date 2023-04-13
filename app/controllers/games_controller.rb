require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = generate_letters
  end

  def score
    @score_time = Time.now
    @score = (calc_score * 100).round(0)
  end
end

private

def lookup_word(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word.strip}"
  url_serialized = URI.open(url).read
  JSON.parse(url_serialized)
end

def calc_score
  @time_taken = calc_time
  @time_points = @time_taken.fdiv(10)
  @message = ''
  length_score = 0
  guess_word = params['word'].downcase.strip
  checked_word = lookup_word(guess_word)
  guess_letters = guess_word.split('')
  generated_letters = params['generated_letters'].split(' ')
  guess_letters.each do |letter|
    unless generated_letters.include?(letter)
      @message = "'#{guess_word}' cannot be built out of the letters above"
      return 0
    end
    length_score += 1
  end
  unless checked_word['found']
    @message = "'#{guess_word}' doesn't seem to be an word in the english alphabet"
    return 0
  end

  unless @time_points >= length_score
    score = length_score - @time_points
    return score
  end
  0
end

def calc_time
  Time.now - Time.parse(params['start_time'])
end

def generate_letters
  letters = []
  (10.times { letters << ('a'..'z').to_a.sample } )
  letters
end
