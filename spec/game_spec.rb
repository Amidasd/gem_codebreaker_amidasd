# frozen_string_literal: true

require 'spec_helper'

module GemCodebreakerAmidasd
  RSpec.describe Game do
    let(:gemCodebreaker) { Game.new }

    specify 'gemCodebreaker attributes' do
      expect(gemCodebreaker).to respond_to(:error)
      expect(gemCodebreaker).not_to respond_to(:error=)

      expect(gemCodebreaker).to respond_to(:status)
      expect(gemCodebreaker).not_to respond_to(:status=)

      expect(gemCodebreaker).to respond_to(:count_plus)
      expect(gemCodebreaker).not_to respond_to(:count_plus=)

      expect(gemCodebreaker).to respond_to(:count_minus)
      expect(gemCodebreaker).not_to respond_to(:count_minus=)

      expect(gemCodebreaker).to respond_to(:hint)
      expect(gemCodebreaker).not_to respond_to(:hint=)

      expect(gemCodebreaker).to respond_to(:count_attempt)
      expect(gemCodebreaker).not_to respond_to(:count_attempt=)

      expect(gemCodebreaker).to respond_to(:secret_code)
      expect(gemCodebreaker).not_to respond_to(:secret_code=)

      expect(gemCodebreaker).to respond_to(:count_hints)
      expect(gemCodebreaker).not_to respond_to(:count_hints=)

      expect(gemCodebreaker).to respond_to(:total_count_attempt)
      expect(gemCodebreaker).not_to respond_to(:total_count_attempt=)

      expect(gemCodebreaker).to respond_to(:total_count_hints)
      expect(gemCodebreaker).not_to respond_to(:total_count_hints=)

      expect(gemCodebreaker).to respond_to(:length_code)
      expect(gemCodebreaker).not_to respond_to(:length_code=)

      expect(gemCodebreaker).to respond_to(:max_num)
      expect(gemCodebreaker).not_to respond_to(:max_num=)

      expect(gemCodebreaker).to respond_to(:min_num)
      expect(gemCodebreaker).not_to respond_to(:min_num=)

      expect(gemCodebreaker).to respond_to(:difficulty_hash)
      expect(gemCodebreaker).not_to respond_to(:difficulty_hash=)

      expect(gemCodebreaker).to respond_to(:difficulty)
      expect(gemCodebreaker).not_to respond_to(:difficulty=)
    end

    before do
      gemCodebreaker.setDifficulty(:easy)
    end

    describe '#initialize' do
      it 'sets total_count_attempt' do
        expect(gemCodebreaker.instance_variable_get(:@total_count_attempt)).to be(15)
      end

      it 'sets total_count_hints' do
        expect(gemCodebreaker.instance_variable_get(:@total_count_hints)).to be(2)
      end

      it 'sets size array_hints' do
        expect(gemCodebreaker.instance_variable_get(:@array_hints).size).to be(0)
      end

      it 'sets length_code' do
        expect(gemCodebreaker.instance_variable_get(:@length_code)).to be(4)
      end

      it 'sets min_num' do
        expect(gemCodebreaker.instance_variable_get(:@min_num)).to be(1)
      end

      it 'sets max_num' do
        expect(gemCodebreaker.instance_variable_get(:@max_num)).to be(6)
      end

      it 'sets count_attempt' do
        expect(gemCodebreaker.instance_variable_get(:@count_attempt)).to be(0)
      end

      context 'when secret code' do
        let(:secret_code) { gemCodebreaker.instance_variable_get(:@secret_code) }

        it 'not empty' do
          expect(secret_code).not_to be_empty
        end

        it 'with 4 numbers' do
          expect(secret_code.size).to be(4)
        end

        it 'with numbers from 1 to 6' do
          expect(secret_code.join).to match(/[1-6]+/)
        end

        it 'new each time game starts' do
          code1 = secret_code
          gemCodebreaker2 = Game.new
          gemCodebreaker2.setDifficulty(:easy)
          code2 = gemCodebreaker2.instance_variable_get(:@secret_code)
          expect(code1).not_to eql(code2)
        end
      end
    end

    describe '#generate_hint' do
      before do
        gemCodebreaker.instance_variable_set(:@secret_code, [6, 5, 4, 3])
        gemCodebreaker.secret_code_shuffle
      end

      it 'generates correct hint' do
        gemCodebreaker.instance_variable_set(:@total_count_hints, 4)
        4.times do
          hint = gemCodebreaker.gets_hint
          expect(gemCodebreaker.instance_variable_get(:@secret_code)).to include(hint)
        end
      end

      it 'generates new hint each time' do
        gemCodebreaker.instance_variable_set(:@total_count_hints, 4)
        hint1 = gemCodebreaker.gets_hint
        hint2 = gemCodebreaker.gets_hint
        hint3 = gemCodebreaker.gets_hint
        hint4 = gemCodebreaker.gets_hint

        expect(hint1).not_to eql(hint2)
        expect(hint2).not_to eql(hint3)
        expect(hint3).not_to eql(hint4)
        expect(hint4).not_to eql(hint1)
      end

      it 'generates new hint and size array_hints' do
        gemCodebreaker.instance_variable_set(:@total_count_hints, 4)
        i = 1
        while i <= 4
          gemCodebreaker.gets_hint
          expect(gemCodebreaker.instance_variable_get(:@count_hints)).to be(i)
          i += 1
        end
      end

      it 'increases array_hints by one' do
        expect do
          gemCodebreaker.gets_hint
        end.to change { gemCodebreaker.instance_variable_get(:@count_hints) }.by(+1)
      end

      it 'adds error if no hints left' do
        gemCodebreaker.instance_variable_set(:@total_count_hints, 0)
        gemCodebreaker.gets_hint
        expect(gemCodebreaker.instance_variable_get(:@error)).equal?(:HintsEnd)
      end

      it 'adds an error if all hints are already shown' do
        gemCodebreaker.instance_variable_set(:@secret_code, [1, 1, 1, 1])
        gemCodebreaker.gets_hint
        gemCodebreaker.gets_hint
        expect(gemCodebreaker.instance_variable_get(:@error)).equal?(:NoCluesAvailable)
      end
    end

    describe 'guess_code' do
      before do
        gemCodebreaker.instance_variable_set(:@secret, [1, 2, 3, 4])
      end

      it 'returns string_secretcode' do
        expect(gemCodebreaker.string_secretcode).equal?('1234')
      end

      it 'returns WrongCode' do
        gemCodebreaker.guess_code('1237')
        expect(gemCodebreaker.instance_variable_get(:@error)).equal?(:WrongCode)
        gemCodebreaker.guess_code('12373')
        expect(gemCodebreaker.instance_variable_get(:@error)).equal?(:WrongCode)
        gemCodebreaker.guess_code('asd')
        expect(gemCodebreaker.instance_variable_get(:@error)).equal?(:WrongCode)
        expect(gemCodebreaker.instance_variable_get(:@count_attempt)).to be(0)
      end

      it 'minus test' do
        gemCodebreaker.guess_code('5555')
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(0)
        gemCodebreaker.guess_code('1234')
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(0)
        gemCodebreaker.guess_code('5155')
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(1)
        gemCodebreaker.guess_code('5125')
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(2)
        gemCodebreaker.guess_code('5123')
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(3)
        gemCodebreaker.guess_code('4321')
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(4)
      end

      it 'plus test' do
        gemCodebreaker.guess_code('5555')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(0)
        gemCodebreaker.guess_code('4321')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(0)
        gemCodebreaker.guess_code('1555')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(1)
        gemCodebreaker.guess_code('1255')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(2)
        gemCodebreaker.guess_code('1235')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(3)
        gemCodebreaker.guess_code('1234')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(4)
      end

      it 'process_game' do
        gemCodebreaker.guess_code('1134')
        expect(gemCodebreaker.instance_variable_get(:@status)).equal?(STATUS[:process_game])
      end

      it 'won' do
        gemCodebreaker.guess_code('1234')
        expect(gemCodebreaker.instance_variable_get(:@status)).equal?(STATUS[:win])
        # @status = STATUS[:process_game]
      end

      it 'lost' do
        gemCodebreaker.instance_variable_set(:@total_count_attempt, 0)
        gemCodebreaker.guess_code('1111')
        expect(gemCodebreaker.instance_variable_get(:@status)).equal?(STATUS[:lose])
      end
    end

    describe 'test game logic' do
      it 'game 6543' do
        gemCodebreaker.instance_variable_set(:@secret, [6, 5, 4, 3])

        gemCodebreaker.guess_code('5643')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(2)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(2)

        gemCodebreaker.guess_code('6411')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(1)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(1)

        gemCodebreaker.guess_code('6544')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(3)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(0)

        gemCodebreaker.guess_code('3456')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(0)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(4)

        gemCodebreaker.guess_code('6666')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(1)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(0)

        gemCodebreaker.guess_code('2666')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(0)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(1)

        gemCodebreaker.guess_code('2222')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(0)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(0)
      end

      it 'game 6666' do
        gemCodebreaker.instance_variable_set(:@secret, [6, 6, 6, 6])

        gemCodebreaker.guess_code('1661')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(2)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(0)
      end

      it 'game 1234' do
        gemCodebreaker.instance_variable_set(:@secret, [1, 2, 3, 4])

        gemCodebreaker.guess_code('3124')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(1)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(3)

        gemCodebreaker.guess_code('1524')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(2)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(1)

        gemCodebreaker.guess_code('1234')
        expect(gemCodebreaker.instance_variable_get(:@count_plus)).equal?(4)
        expect(gemCodebreaker.instance_variable_get(:@count_minus)).equal?(0)
      end
    end
  end
end
