module GemCodebreakerAmidasd
  DIFFICULTY_HASH = { easy: { total_count_attempt: 15, total_count_hints: 2 },
                      medium: { total_count_attempt: 10, total_count_hints: 1 },
                      hell: { total_count_attempt: 5, total_count_hints: 1 } }.freeze

  ERRORS = { WrongCode: :WrongCode,
             HintsEnd: :HintsEnd,
             NoCluesAvailable: :NoCluesAvailable }.freeze

  STATUS = { process_game: :process_game,
             win: :win,
             lose: :lose }.freeze

  class Game
    attr_reader :difficulty_hash, :difficulty
    attr_reader :length_code, :max_num, :min_num
    attr_reader :total_count_attempt, :total_count_hints, :error, :count_plus, :count_minus, :hint
    attr_reader :count_attempt, :secret_code, :secret_code_rand, :count_hints, :status

    def initialize(other_difficulty: {})
      @difficulty_hash = DIFFICULTY_HASH.merge(other_difficulty)
      @total_count_attempt = 0
      @total_count_hints = 0
      @count_plus = 0
      @count_minus = 0
      @length_code = 4
      @min_num = 1
      @max_num = 6
      @count_attempt = 0
      @count_hints = 0
      @status = STATUS[:process_game]
    end

    def string_secretcode
      secret_code.join('')
    end

    def difficulty_set(difficulty)
      return unless @difficulty_hash.key? difficulty

      @difficulty = difficulty
      @total_count_attempt = @difficulty_hash[difficulty][:total_count_attempt]
      @total_count_hints = @difficulty_hash[difficulty][:total_count_hints]
    end

    def gets_hint
      empty_result
      return add_error(ERRORS[:HintsEnd]) unless @total_count_hints > @count_hints
      return add_error(ERRORS[:NoCluesAvailable]) unless secret_code_rand

      @count_hints += 1
      @hint = secret_code_rand.pop
    end

    def secret_code
      @secret_code ||= Array.new(@length_code) { rand(@min_num..@max_num) }
    end

    def secret_code_rand
      @secret_code_rand ||= secret_code.clone.shuffle!
    end

    def guess_code(code_attempt)
      empty_result
      input_code = to_array(code_attempt)
      return @status = STATUS[:win] if input_code == secret_code

      return add_error(ERRORS[:WrongCode]) unless valid_code? input_code

      check_results(input_code)
      @count_attempt += 1
      @status = STATUS[:lose] if @total_count_attempt <= @count_attempt
    end

    private

    def check_results(input_code)
      secret_code_temp = secret_code.map.with_index do |value,key|
        next input_code[key] = nil if value == input_code[key]; value
      end

      @count_plus = secret_code_temp.count(nil)
      secret_code_temp = secret_code_temp.map.with_index do |value, |
        next nil if value && input_code.include?(value)
        value
      end
      @count_minus = secret_code_temp.count(nil) - @count_plus
    end

    def empty_result
      @error = nil
      @count_plus = 0
      @count_minus = 0
      @hint = 0
    end

    def add_error(error)
      (@error = error) && nil
    end

    def valid_code?(input)
      input.size == length_code && input.all? { |number| number.between? min_num, max_num }
    end

    def to_array(str)
      str.chars.map(&:to_i)
    end
  end
end
