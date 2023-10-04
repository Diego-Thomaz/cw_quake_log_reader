# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::Player do
  let(:player) { described_class.new(name: 'Test Player') }

  describe '#add_kill' do
    subject(:add_kill) { player.add_kill }

    it 'increases kill counter' do
      expect { add_kill }.to change { player.kills }.by(1)
    end
  end

  describe '#remove_kill' do
    subject(:remove_kill) { player.remove_kill }

    it 'decreases kill counter' do
      expect { remove_kill }.to change { player.kills }.by(-1)
    end
  end
end
