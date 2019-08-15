require_relative 'spec_helper'

module GemCodebreakerAmidasd
  RSpec.describe User do
    let(:user) { User.new(name: 'Amidasd') }

    specify 'User attributes' do
      expect(user).to respond_to(:name)
      expect(user).not_to respond_to(:name=)
    end

    it 'user  set @name' do
      expect(user.instance_variable_get(:@name)).equal?('Amidasd')
    end

    it 'user  valid_name?' do
      expect(User.valid_name?(name: 'Am')).equal?(false)
    end
  end
end
