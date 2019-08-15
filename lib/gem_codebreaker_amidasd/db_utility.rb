module GemCodebreakerAmidasd
  require 'yaml'

  class DbUtility
    PATH_CODEBREAKER_DB = './db/codebreaker_db.yml'.freeze

    class << self
      def save_yaml_db(array, yml_db = PATH_CODEBREAKER_DB)
        File.write(yml_db, array.to_yaml)
      end

      def load_yaml_db(yml_db = PATH_CODEBREAKER_DB)
        return YAML.load_file(yml_db) if File.exist?(yml_db)

        []
      end

      def add_in_db(array:, user:, game:)
        stats = Statistic.new(user: user, game: game)
        array << stats
      end
    end
  end
end
