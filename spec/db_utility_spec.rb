require_relative 'spec_helper'

module GemCodebreakerAmidasd
  RSpec.describe DbUtility do
    let(:user) { User.new(name: 'Amidasd') }

    let(:gemCodebreaker) { Game.new }

    let(:yml_db) { './db/codebreaker_Test_db.yml' }

    before do
      gemCodebreaker.setDifficulty(:easy)
    end

    after do
      File.delete(yml_db) if File.exist?(yml_db)
    end

    describe '#Test DbUtility' do
      it 'Test load ' do
        array = DbUtility.load_yaml_db(yml_db)
        expect(array.class).equal?(Array)
      end

      it 'Test add_in_db ' do
        array = DbUtility.load_yaml_db(yml_db)
        count_array_before = array.count
        DbUtility.add_in_db(array: array, user: user, game: gemCodebreaker)
        count_array_after = array.count
        expect(count_array_after).equal?(count_array_before + 1)
      end

      it 'Test save ' do
        array = DbUtility.load_yaml_db(yml_db)
        DbUtility.add_in_db(array: array, user: user, game: gemCodebreaker)
        DbUtility.save_yaml_db(array, yml_db)
        array2 = DbUtility.load_yaml_db(yml_db)
        count_array_before = array.count
        count_array_after = array2.count
        expect(count_array_after).equal?(count_array_before)
      end
    end
  end
end
