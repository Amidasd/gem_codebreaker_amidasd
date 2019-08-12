module GemCodebreakerAmidasd
  DIFFICULTY_HASH = {:easy => { total_count_attempt: 15, total_count_hints: 2 },
                     :medium => { total_count_attempt: 10, total_count_hints: 1 },
                     :hell => { total_count_attempt: 5, total_count_hints: 1 }}

  class GemCodebreaker

    attr_accessor :difficulty_hash, :difficulty
    attr_accessor :length_code, :max_num, :min_num
    attr_reader :total_count_attempt, :total_count_hints, :error, :win, :count_plus, :count_minus, :hint
    attr_reader :count_attempt, :secret_code, :array_hints

    def initialize(other_difficulty: {})
      @difficulty_hash = DIFFICULTY_HASH.merge(other_difficulty)
      @array_hints = []
      @length_code = 4
      @min_num = 1
      @max_num = 6
      @count_attempt = 0
      generate_secret_code
      empty_result
    end

    def string_secertcode
      @secret_code.join('')
    end

    def set_difficulty(difficulty)
      return unless @difficulty_hash.has_key? difficulty
      @difficulty = difficulty
      @total_count_attempt = @difficulty_hash[difficulty][:total_count_attempt]
      @total_count_hints = @difficulty_hash[difficulty][:total_count_hints]
    end

    def gets_hint
      return_hint
    end

    def generate_secret_code
      @secret_code = []
      @length_code.times do
        @secret_code << rand(@min_num..@max_num)
      end
    end

    def guess_code(code_attempt)
      check_code(code_attempt)
    end

    private

    def empty_result
      @error = nil
      @count_plus = 0
      @count_minus = 0
      @hint = 0
    end

    def return_hint
      empty_result
      cache_array = search_hint
      return unless @error.nil?

      max = cache_array.length
      rand_index = rand(0..(max - 1))
      @hint = cache_array[rand_index]
      @array_hints << @hint
      @hint
    end

    def search_hint
      cache_array = []
      @secret_code.each { |val| cache_array << val if !@array_hints.include?(val) && !cache_array.include?(val) }
      @error = 'HintsEnd' unless @total_count_hints > @array_hints.size
      @error = 'NoCluesAvailable' if cache_array.empty?
      cache_array
    end

    def check_code(code_attempt)
      correct_code = to_array(code_attempt)
      empty_result
      @error = 'WrongCode' unless code_attempt.match(/[1-6]+$/)
      @error = 'WrongCode' unless correct_code.size == @length_code
      return nil if @error == 'WrongCode'

      status_game(correct_code)
      @count_attempt += 1
      @win = false if @total_count_attempt <= @count_attempt && @win.nil?
      nil
    end

    def status_game(correct_code)
      cache_code = correct_code
      cache_secret_code = @secret_code.clone
      prepare_arrays(correct_code, cache_code, cache_secret_code)
      @win = true if cache_secret_code.empty?
      @count_plus = @length_code - cache_secret_code.size
      count_minus = 0
      cache_secret_code.each { |value| count_minus += 1 if cache_code.include?(value) }
      @count_minus = count_minus
    end

    def prepare_arrays(correct_code, cache_code, cache_secret_code)
      num = @secret_code.size
      while num >= 0
        if @secret_code[num] == correct_code[num]
          cache_code.delete_at(num)
          cache_secret_code.delete_at(num)
        end
        num -= 1
      end
    end

    def to_array(str)
      str.to_i.digits.reverse
    end
  end
end
