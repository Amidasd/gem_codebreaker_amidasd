require_relative 'spec_helper'

module GemCodebreakerAmidasd
  RSpec.describe User do
    let(:user) do
      User.new(name: 'Amidasd')
    end

    specify 'User attributes' do
      expect(user).to respond_to(:name)
      expect(user).to respond_to(:name=)

      expect(user).to respond_to(:difficulty)
      expect(user).to respond_to(:difficulty=)

      expect(user).to respond_to(:total_count_attempt)
      expect(user).to respond_to(:total_count_attempt=)

      expect(user).to respond_to(:count_attempt)
      expect(user).to respond_to(:count_attempt=)

      expect(user).to respond_to(:total_count_hints)
      expect(user).to respond_to(:total_count_hints=)

      expect(user).to respond_to(:count_hint)
      expect(user).to respond_to(:count_hint=)
    end

    before do
      user.set_params(difficulty: :easy,
                      total_count_attempt: 15,
                      count_attempt: 2,
                      total_count_hints: 2,
                      count_hint: 0)
    end

    it 'user  set @name' do
      expect(user.instance_variable_get(:@name)).equal?('Amidasd')
    end

    it 'user  set @difficulty' do
      expect(user.instance_variable_get(:@difficulty)).equal?(:easy)
    end

    it 'user  set @total_count_attempt' do
      expect(user.instance_variable_get(:@total_count_attempt)).equal?(15)
    end

    it 'user  set @count_attempt' do
      expect(user.instance_variable_get(:@count_attempt)).equal?(2)
    end

    it 'user  set @total_count_hints' do
      expect(user.instance_variable_get(:@total_count_hints)).equal?(2)
    end

    it 'user  set @count_hint' do
      expect(user.instance_variable_get(:@count_hint)).equal?(0)
    end

    it 'user  validtion_name' do
      expect(User.validtion_name('Am')).equal?(false)
    end
  end
end
