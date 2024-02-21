require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].split('')
    attempt = params[:word].upcase
    start_time = DateTime.parse(params[:start_time])
    end_time = Time.now

    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    serialized = URI.open(url).read
    word = JSON.parse(serialized)
    letter_check = attempt.chars.all? { |letter| attempt.count(letter) <= @letters.count(letter) }

    if word["found"] && letter_check
      score_value = attempt.size.fdiv(end_time - start_time)
      session[:total_score] ||= 0
      session[:total_score] += score_value
    else
      score_value = 0
    end

    @score = score_value
    @message = if word["found"]
               letter_check ? "well done" : "not in the grid"
              else
               "not an english word"
              end
    @time = end_time - start_time
  end
end
