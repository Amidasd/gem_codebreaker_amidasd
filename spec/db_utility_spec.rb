require_relative 'spec_helper'

module GemCodebreakerAmidasd
  RSpec.describe DbUtility do
    let(:user) do
      User.new(name: 'Amidasd')
    end

    let(:yml_db) do
      './db/codebreaker_Test_db.yml'
    end

    before do
      user.set_params(difficulty: :easy,
                      total_count_attempt: 15,
                      count_attempt: 2,
                      total_count_hints: 2,
                      count_hint: 0)
    end

    after do
      File.delete(yml_db)
    end
    describe '#Test DbUtility' do
      it 'Test add_db ' do
        DbUtility.add_db(user, yml_db)
        expect(File.exist?(yml_db)).equal?(true)
        expect(DbUtility.load_yaml_db(yml_db)).equal?(true)
        db = DbUtility.load_yaml_db(yml_db)
        expect(db.class).equal?(Array)
        DbUtility.add_db(user, yml_db)
        db2 = DbUtility.load_yaml_db(yml_db)
        expect(db.count).equal?(db2.count + 1)
      end
    end
  end
end
