module GemCodebreakerAmidasd
  class User
    attr_accessor :name,
                  :difficulty,
                  :total_count_attempt,
                  :count_attempt,
                  :total_count_hints,
                  :count_hint

    def initialize(name:)
      @name = name
    end

    def set_params(difficulty:, total_count_attempt:, count_attempt:, total_count_hints:, count_hint:)
      @difficulty = difficulty
      @total_count_attempt = total_count_attempt
      @count_attempt = count_attempt
      @total_count_hints = total_count_hints
      @count_hint = count_hint
    end

    def self.validtion_name(name)
      name.is_a?(String) && !name.empty? && name.length.between?(3, 20)
    end
  end
end
