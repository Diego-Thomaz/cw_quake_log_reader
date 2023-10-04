# frozen_string_literal: true

module LogParser
  module LogRegex
    def new_game?(line)
      line.match?(/InitGame/)
    end

    def player?(line)
      line.match?(/ClientUserinfoChanged/)
    end

    def player_name(line)
      line.match(/((?<=n\\).*?(?=\\t))/)[0]
    rescue StandardError
      puts "Could not fetch player's name"
      'unknown_player'
    end

    def new_kill?(line)
      line.match?(/Kill/)
    end

    def killer(line)
      line.match(/([^:.]+).(?=\skilled)/)[0].strip
    rescue StandardError
      puts "Could not fetch killer's name"
      'unknown_killer'
    end

    def victim(line)
      line.match(/((?<=killed\s).*(?=\sby))/)[0]
    rescue StandardError
      puts "Could not fetch victim's name"
      'unknown_victim'
    end

    def death_reason(line)
      line.match(/((?<=by\s).*)/)[0]
    rescue StandardError
      puts 'Could not fetch death reason'
      'MOD_UNKNOWN'
    end
  end
end
