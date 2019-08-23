require_relative 'spec_helper'

module GemCodebreakerAmidasd
  RSpec.describe Statistic do
    let(:user) { User.new(name: 'Amidasd') }
    let(:gemCodebreaker) { Game.new }
    let(:gemCodebreaker2) { Game.new }
    let(:statistic) { Statistic.new(user: user, game: gemCodebreaker) }
    let(:statistic2) { Statistic.new(user: user, game: gemCodebreaker2) }

    specify 'Statistic attributes' do
      expect(statistic).to respond_to(:user)
      expect(statistic).not_to respond_to(:user=)

      expect(statistic).to respond_to(:game)
      expect(statistic).not_to respond_to(:game=)
    end

    before do
      gemCodebreaker.difficulty_set(:easy)
      gemCodebreaker2.difficulty_set(:hell)
    end

    it 'Statistic  set @user' do
      expect(statistic.instance_variable_get(:@user)).equal?(user)
    end

    it 'Statistic  set @game' do
      expect(statistic.instance_variable_get(:@game)).equal?(gemCodebreaker)
    end

    it 'Statistic sort_array' do
      array = []
      array << statistic
      array << statistic2
      Statistic.sort_array(array)
      expect(array[0]).equal?(statistic2)
    end
  end
end
