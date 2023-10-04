# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::ReportsBuilder do
  subject { described_class.new(option:).call }

  let(:grouped_information_instance) { instance_double(LogParser::Reports::GroupedInformationPerMatch) }
  let(:player_rank_instance) { instance_double(LogParser::Reports::PlayerRank) }
  let(:death_reason_instance) { instance_double(LogParser::Reports::DeathReasonsPerMatch) }
  let(:log_parser_instance) { instance_double(LogParser::Parser) }

  let(:matches) do
    [
      {
        'game_1' => {
          'total_kills' => 11,
          'players' => ['Isgalamido', 'Dono da Bola', 'Mocinha'],
          'kills' => {
            'Isgalamido' => -5,
            'Dono da Bola' => 0,
            'Mocinha' => 0
          },
          'death_reasons' => {
            'MOD_TRIGGER_HURT' => 7,
            'MOD_ROCKET_SPLASH' => 3,
            'MOD_FALLING' => 1
          }
        }
      },
      {
        'game_2' => {
          'total_kills' => 4,
          'players' => ['Dono da Bola', 'Mocinha', 'Isgalamido', 'Zeh'],
          'kills' => {
            'Zeh' => -2,
            'Dono da Bola' => -1,
            'Mocinha' => 0,
            'Isgalamido' => 1
          },
          'death_reasons' => {
            'MOD_ROCKET' => 1,
            'MOD_TRIGGER_HURT' => 2,
            'MOD_FALLING' => 1
          }
        }
      }
    ]
  end

  before do
    allow(LogParser::Parser).to receive(:new).and_return(log_parser_instance)
    allow(LogParser::Reports::GroupedInformationPerMatch)
      .to receive(:new)
      .with(matches:)
      .and_return(grouped_information_instance)
    allow(LogParser::Reports::PlayerRank)
      .to receive(:new)
      .with(matches:)
      .and_return(player_rank_instance)
    allow(LogParser::Reports::DeathReasonsPerMatch)
      .to receive(:new)
      .with(matches:)
      .and_return(death_reason_instance)

    allow(log_parser_instance).to receive(:call).and_return(matches)
  end

  context 'when no option is provided' do
    let(:option) { nil }

    it 'calls all reports', :aggregate_failures do
      expect(grouped_information_instance).to receive(:call)
      expect(player_rank_instance).to receive(:call)
      expect(death_reason_instance).to receive(:call)

      subject
    end
  end

  context 'when option "gi" is provided' do
    let(:option) { 'gi' }

    it 'calls only grouped information report', :aggregate_failures do
      expect(grouped_information_instance).to receive(:call)
      expect(player_rank_instance).not_to receive(:call)
      expect(death_reason_instance).not_to receive(:call)

      subject
    end
  end

  context 'when option "pr" is provided' do
    let(:option) { 'pr' }

    it 'calls only player rank report', :aggregate_failures do
      expect(player_rank_instance).to receive(:call)
      expect(grouped_information_instance).not_to receive(:call)
      expect(death_reason_instance).not_to receive(:call)

      subject
    end
  end

  context 'when option "dr" is provided' do
    let(:option) { 'dr' }

    it 'calls only death reasons report', :aggregate_failures do
      expect(death_reason_instance).to receive(:call)
      expect(player_rank_instance).not_to receive(:call)
      expect(grouped_information_instance).not_to receive(:call)

      subject
    end
  end

  context 'when invalid option is provided' do
    let(:option) { 'foo' }

    it 'raises an error and exit', :aggregate_failures do
      expect { subject }
        .to raise_error(SystemExit)
        .and output("Invalid option. The valid options are: gi, pr, dr\n")
        .to_stderr
    end
  end
end
