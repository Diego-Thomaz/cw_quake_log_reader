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
    end

    def new_kill?(line)
      line.match?(/Kill/)
    end

    def killer(line)
      line.match(/([^:.]+).(?=\skilled)/)[0].strip
    end

    def victim(line)
      line.match(/((?<=killed\s).*(?=\sby))/)[0]
    end

    def death_reason(line)
      line.match(/((?<=by\s).*)/)[0]
    end
  end
end
