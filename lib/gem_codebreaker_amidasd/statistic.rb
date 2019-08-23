module GemCodebreakerAmidasd
  class Statistic
    attr_reader :user, :game, :date
    def initialize(user:, game:)
      @user = user
      @game = game
      @date = DateTime.now
    end

    def self.sort_array(array)
      array.sort_by! { |value| [value.game.total_count_attempt, value.game.count_attempt, value.game.count_hints] }
    end
  end
end
