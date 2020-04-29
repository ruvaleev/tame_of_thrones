# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameSet do
  it { should validate_presence_of(:uid) }
  it { should validate_uniqueness_of(:uid) }
  it { should have_many(:kingdoms).dependent(:destroy) }
  it { should have_one(:player).class_name('Kingdom').with_foreign_key('game_id').dependent(:destroy) }
end
