
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def home
  end

  def new
    @letters = []
    @letters << ('A'..'Z').to_a.sample(10)
  end

  def score
    @letters = params[:letters].downcase.split('')
    @word = params[:word]
    @answer = if english_word
                if word_in_grid(@word, @letters)
                  "Well done! #{@word.capitalize} works!"
                else
                  "#{@word.capitalize} is not in the grid"
                end
              else
                "#{@word} is not an english word"
              end
  end

  def english_word
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    lw_dictionary = open(url).read
    response = JSON.parse(lw_dictionary)
    response['found']
  end

  def word_in_grid(word, letters)
    new_hash = Hash.new(0)
    letters.each { |letter| new_hash[letter] += 1 }
    word.split('').each do |letter|
      new_hash[letter] -= 1
      return false if new_hash[letter].negative?
    end
    true
  end
end
