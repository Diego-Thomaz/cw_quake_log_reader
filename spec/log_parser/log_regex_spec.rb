# frozen_string_literal: true

require 'spec_helper'

class Dummy
  include LogParser::LogRegex
end

RSpec.describe LogParser::LogRegex do
  describe '#new_game?' do
    subject(:new_game?) { Dummy.new.new_game?(line) }

    context 'when line text contains InitGame' do
      let(:line) { '0:00 InitGame: \sv_floodProtect\1\sv_maxPing' }

      it 'returns true' do
        expect(new_game?).to eq(true)
      end
    end

    context 'when line text does NOT contain InitGame' do
      let(:line) { '15:00 Exit: Timelimit hit.' }

      it 'returns false' do
        expect(new_game?).to eq(false)
      end
    end
  end

  describe '#player?' do
    subject(:player?) { Dummy.new.player?(line) }

    context 'when line text contains ClientUserinfoChanged' do
      let(:line) { '20:34 ClientUserinfoChanged: 2 n\Isgalamido\t\0\model\xian/default\hmodel\xian/default' }

      it 'returns true' do
        expect(player?).to eq(true)
      end
    end

    context 'when line text does NOT contain ClientUserinfoChanged' do
      let(:line) { '15:00 Exit: Timelimit hit.' }

      it 'returns false' do
        expect(player?).to eq(false)
      end
    end
  end

  describe '#player_name' do
    subject(:player_name) { Dummy.new.player_name(line) }

    context 'when line text matches regex pattern to find player name' do
      let(:line) { '20:34 ClientUserinfoChanged: 2 n\Isgalamido\t\0\model\xian/default\hmodel\xian/default' }

      it 'returns player name' do
        expect(player_name).to eq('Isgalamido')
      end
    end

    context 'when line text does NOT match regex pattern to find player name' do
      let(:line) { '15:00 Exit: Timelimit hit.' }

      it 'returns unknown_player' do
        expect { player_name }.to output("Could not fetch player's name\n").to_stdout
        expect(player_name).to eq('unknown_player')
      end
    end
  end

  describe '#new_kill?' do
    subject(:new_kill?) { Dummy.new.new_kill?(line) }

    context 'when line text contains Kill' do
      let(:line) { '20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT' }

      it 'returns true' do
        expect(new_kill?).to eq(true)
      end
    end

    context 'when line text does NOT contain Kill' do
      let(:line) { '15:00 Exit: Timelimit hit.' }

      it 'returns false' do
        expect(new_kill?).to eq(false)
      end
    end
  end

  describe '#killer' do
    subject(:killer) { Dummy.new.killer(line) }

    context "when line text matches regex pattern to find killer's name" do
      let(:line) { '20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT' }

      it "returns killer's name" do
        expect(killer).to eq('<world>')
      end
    end

    context "when line text does NOT match regex pattern to find killer's name" do
      let(:line) { '15:00 Exit: Timelimit hit.' }

      it 'returns unknown_killer', :aggregate_failures do
        expect { killer }.to output("Could not fetch killer's name\n").to_stdout
        expect(killer).to eq('unknown_killer')
      end
    end
  end

  describe '#victim' do
    subject(:victim) { Dummy.new.victim(line) }

    context "when line text matches regex pattern to find victim's name" do
      let(:line) { '20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT' }

      it "returns victim's name" do
        expect(victim).to eq('Isgalamido')
      end
    end

    context "when line text does NOT match regex pattern to find victim's name" do
      let(:line) { '15:00 Exit: Timelimit hit.' }

      it 'returns unknown_victim', :aggregate_failures do
        expect { victim }.to output("Could not fetch victim's name\n").to_stdout
        expect(victim).to eq('unknown_victim')
      end
    end
  end

  describe '#death_reason' do
    subject(:death_reason) { Dummy.new.death_reason(line) }

    context 'when line text matches regex pattern to find death_reason' do
      let(:line) { '20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT' }

      it 'returns death_reason' do
        expect(death_reason).to eq('MOD_TRIGGER_HURT')
      end
    end

    context 'when line text does NOT match regex pattern to find death_reason' do
      let(:line) { '15:00 Exit: Timelimit hit.' }

      it 'returns unknown_death_reason', :aggregate_failures do
        expect { death_reason }.to output("Could not fetch death reason\n").to_stdout
        expect(death_reason).to eq('MOD_UNKNOWN')
      end
    end
  end
end
