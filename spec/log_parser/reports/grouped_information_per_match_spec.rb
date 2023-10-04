# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::Reports::GroupedInformationPerMatch do
  subject { described_class.new(matches:).call }

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

  let(:expected_response)  { matches }

  before do
    allow($stdout).to receive(:puts)
  end

  it 'returns player rank report' do
    expect(subject).to eq(expected_response)
  end
end
