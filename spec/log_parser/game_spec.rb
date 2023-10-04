# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::Game do
  let(:game) { described_class.new(id: 1) }

  describe '#add_kill' do
    subject(:add_kill) { game.add_kill }

    it 'increases total_kills counter' do
      expect { add_kill }.to change { game.total_kills }.by(1)
    end
  end

  describe '#update_death_reason_counter' do
    subject(:update_death_reason_counter) { game.update_death_reason_counter(reason:) }

    context 'when death reason is known by the game' do
      let(:reason) { 'MOD_PLASMA' }

      it 'updates the counter' do
        update_death_reason_counter
        expect(game.death_reasons).to eq({ 'MOD_PLASMA' => 1 })
      end
    end

    context 'when death reason is NOT known by the game' do
      let(:reason) { 'SOMETHING_ELSE' }

      it 'does NOT update the counter' do
        update_death_reason_counter
        expect(game.death_reasons).to be_empty
      end
    end
  end

  describe '#to_h' do
    subject(:convert_game_to_hash) { game.to_h }

    let(:game) { described_class.new(id: 1) }
    let(:total_kills) { 10 }
    let(:player_1) { LogParser::Player.new(name: 'Foo', kills: 2) }
    let(:player_2) { LogParser::Player.new(name: 'Bar', kills: 8) }

    let(:players) do
      {
        player_1.name => player_1,
        player_2.name => player_2
      }
    end

    let(:death_reasons) do
      {
        'MOD_SHOTGUN' => 3,
        'MOD_GRENADE' => 2,
        'MOD_PLASMA' => 5
      }
    end

    let(:expected_result) do
      {
        'game_1' => {
          'total_kills' => total_kills,
          'players' => players.keys,
          'kills' => {
            player_1.name => player_1.kills,
            player_2.name => player_2.kills
          },
          'death_reasons' => death_reasons
        }
      }
    end

    before do
      10.times { game.add_kill }
      3.times { game.update_death_reason_counter(reason: 'MOD_SHOTGUN') }
      2.times { game.update_death_reason_counter(reason: 'MOD_GRENADE') }
      5.times { game.update_death_reason_counter(reason: 'MOD_PLASMA') }

      game.players[player_1.name] = player_1
      game.players[player_2.name] = player_2
    end

    it 'converts game to hash' do
      expect(convert_game_to_hash).to eq(expected_result)
    end
  end
end
