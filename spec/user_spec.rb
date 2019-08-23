require_relative 'spec_helper'

module GemCodebreakerAmidasd
  RSpec.describe User do
    let(:str) { 'Amidasd' }
    let(:user) { User.new(name: str) }

    specify 'User attributes' do
      expect(user).to respond_to(:name)
      expect(user).not_to respond_to(:name=)
    end

    it 'user  set @name' do
      expect(user.instance_variable_get(:@name)).equal?(str)
    end

    it 'user  valid_name? min' do
      expect(User.valid_name?(name: 'Am')).to be(false)
    end

    it 'user  valid_name? max' do
      expect(User.valid_name?(name: 'AmidasdAmidasdAmidasd')).to be(false)
    end
  end
end
