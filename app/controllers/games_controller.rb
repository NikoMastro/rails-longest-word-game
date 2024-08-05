require 'URI'
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    #display the random letters
    #get the starting time
    @letters = Array.new(9) { ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def score
    #get params
    #get the attempt input
    #get the difference of time
    #show result
    @letters = params[:letters].split('')
    @attempt = params[:attempt]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @time_taken = (@end_time - @start_time).to_i
    @result = calculate_score(@attempt, @letters, @start_time, @end_time)
  end

  private
# private render the calculation and check if valid word
# -> api URI et jason into array
# (and check if letters given are included) + make sure if english
# input word into api
  def calculate_score(attempt, letters, start_time, end_time)
    if valid_word?(attempt) && included?(attempt.upcase, letters)
      score = attempt.length * (1.0 / (end_time - start_time)) * 100
      message = 'Well done!'
    elsif !included?(attempt.upcase, letters)
      score = 0
      message = 'The word cant be built'
    else
      score = 0
      message = 'Not an English word'
    end
    { time: end_time - start_time, score: score.round, message: message }
  end

   #import URI
  def valid_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json_response = JSON.parse(response)
    json_response['found']
  end

  def included?(attempt, letters)
    attempt.chars.all? { |letter| attempt.count(letter) <= letters.count(letter) }
  end
end
