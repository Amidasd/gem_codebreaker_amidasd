module GemCodebreakerAmidasd
  class User
    MIN_LENGTH_NAME = 3
    MAX_LENGTH_NAME = 20

    attr_reader :name

    def initialize(name:)
      @name = name
    end

    def self.valid_name?(name:)
      name.is_a?(String) && !name.empty? && name.length.between?(MIN_LENGTH_NAME, MAX_LENGTH_NAME)
    end
  end
end
