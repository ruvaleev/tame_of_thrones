# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Create Game Set', '
  In order to launch the game
  As User
  I want to be able to create new game set or launch existing one
' do
  context 'when new user' do
    before { visit root_path }

    it 'User sees pre-filled form with title' do
      expect(page).to have_css("select#title_en option[value!='']")
    end
    it "User sees pre-filled form with leader's name" do
      expect(page).to have_css("#player_leader[value!='']")
    end
    it "User sees pre-filled form with Kingdom's name" do
      expect(page).to have_css("#player_name[value!='']")
    end
  end
  context 'when existed user' do
    let(:game_set) { create(:game_set) }
    let!(:player) { create(:player, game: game_set) }

    before do
      create_cookie('tot_game_set', game_set[:uid])
      visit root_path
    end

    it 'User sees pre-filled form with title' do
      expect(page).to have_css("select#title_en option[value=\'#{player.title}\'][selected='selected']")
    end
    it "User sees pre-filled form with leader's name" do
      expect(page).to have_css("#player_leader[value=\'#{player.leader}\']")
    end
    it "User sees pre-filled form with Kingdom's name" do
      expect(page).to have_css("#player_name[value=\'#{player.name}\']")
    end
  end
  context "when User edits player's data", js: true do
    let(:random_leader) { FFaker::Name.name }
    let(:random_kingdom) { FFaker::Lorem.word }
    let(:random_title) { %w[King Queen].sample }

    before do
      visit root_path(locale: 'en')
      select(random_title, from: 'title_en')
      fill_in('leader_en[leader]', with: random_leader)
      fill_in('name_en[name]', with: random_kingdom)
      sleep(0.1)
      find('#start_button').click
    end
    it 'User sees new leader name in rules' do
      within '.rules' do
        expect(page).to have_text(random_leader)
      end
    end
    it 'User sees new kingdom name in rules' do
      within '.rules' do
        expect(page).to have_text(random_kingdom)
      end
    end
    it 'User sees new title in rules' do
      within '.rules' do
        expect(page).to have_text(random_title)
      end
    end
  end
  context 'when User reset player', js: true do
    let(:game_set) { create(:game_set) }
    let(:random_leader) { FFaker::Name.name }
    let(:random_kingdom) { FFaker::Lorem.word }
    let(:title) { :King }
    let(:create_kingdom_double) { instance_double(CreateKingdom) }
    let!(:old_player) { create(:player, title_en: 'King', game: game_set) }
    let(:new_player) { create(:player, title_en: 'Queen') }

    before do
      write_game_set_uid(game_set.uid)
      allow(CreateKingdom).to receive(:new).and_return(create_kingdom_double)
      allow(create_kingdom_double).to receive(:run).and_return(new_player)
      visit root_path(locale: 'en')
      select(title, from: 'title_en')
      fill_in('leader_en[leader]', with: random_leader)
      fill_in('name_en[name]', with: random_kingdom)
      find('#reset_player').click
      sleep(0.1)
    end
    it 'User sees new leader name in rules' do
      within '.preload .form' do
        expect(find_field('player_leader').value).to eq new_player.leader
      end
    end
    it 'User sees new kingdom name in rules' do
      within '.preload .form' do
        expect(find_field('player_name').value).to eq new_player.name
      end
    end
    it 'User sees new title in rules' do
      within '.preload .form' do
        expect(find_field('title_en').value).to eq new_player.title
      end
    end
  end
end
