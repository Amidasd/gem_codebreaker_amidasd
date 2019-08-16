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
      @array_hints = []
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

    def setDifficulty(difficulty)
      return unless @difficulty_hash.key? difficulty

      generate_secret_code
      secret_code_shuffle
      @difficulty = difficulty
      @total_count_attempt = @difficulty_hash[difficulty][:total_count_attempt]
      @total_count_hints = @difficulty_hash[difficulty][:total_count_hints]
    end

    def gets_hint
      empty_result
      return add_error(ERRORS[:HintsEnd]) unless @total_count_hints > @count_hints
      return add_error(ERRORS[:NoCluesAvailable]) unless @secret_code_rand

      @count_hints += 1
      @hint = @secret_code_rand.pop
    end

    def secret_code_shuffle
      @secret_code_rand = @secret_code.clone
      @secret_code_rand.shuffle!
      @secret_code_rand.uniq!
    end

    def generate_secret_code
      @secret_code = []
      @length_code.times do
        @secret_code << rand(@min_num..@max_num)
      end
    end

    def guess_code(code_attempt)
      empty_result
      input_code = to_array(code_attempt)
      return add_error(ERRORS[:WrongCode]) unless valid_code? input_code

      cache_secret_code = secret_code.clone
      prepare_arrays(input_code, cache_secret_code)
      status = STATUS[:win] unless cache_secret_code
      @count_attempt += 1
      @status = STATUS[:lose] if @total_count_attempt <= @count_attempt && status == STATUS[:process_game]
    end

    def prepare_arrays(input_code, cache_secret_code)
      del_index = []
      @secret_code.each_with_index do |val, index|
        del_index << index if val == input_code[index]
        @count_plus += 1 if val == input_code[index]
      end

      del_index.reverse.each do |index|
        input_code.delete_at(index)
        cache_secret_code.delete_at(index)
      end
      cache_secret_code.each { |value| @count_minus += 1 if input_code.include?(value) }
    end

    private

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
      str.to_i.digits.reverse
    end
  end
end
