# frozen_string_literal: true

# Choose names for kings
class ChooseName
  attr_accessor :file_path

  def initialize(title)
    @file_path = "public/uploads/#{title}s_names.txt"
  end

  def run
    names = find_uniq_leader_name

    { ru: names.first, en: names.last }
  end

  private

  def find_uniq_leader_name
    loop do
      names = File.read(file_path).split("\n").sample.split(', ')
      break names if Kingdom.find_by(leader_en: names.last).nil?
    end
  end
end
