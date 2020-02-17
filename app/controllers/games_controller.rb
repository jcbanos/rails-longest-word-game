require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (1..10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @attempt = params[:word]
    @letters = params[:letters]
    @url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    @word_text = open(@url).read
    @parsed_word = JSON.parse(@word_text)
    @valid = valid?(@attempt, @letters)
    @english = @parsed_word['found']
    @message = message(@valid, @english, @attempt, @letters)
  end

  private

  def valid?(attempt, letters)
    attempt = attempt.upcase
    attempt_array = attempt.chars
    return attempt_array.all? { |char| attempt_array.count(char) <= letters.count(char) }
  end

  def message(valid, english, attempt, letters)
    if !valid
      "#{attempt} is not in #{letters}"
    elsif !english
      "#{attempt} is not an english word!"
    else
      "Congratulations! #{attempt} is a valid English word!"
    end
  end
end
