require 'active_record'

if ENV['LOGGER_LEVEL']
  ActiveRecord::Base.logger = Logger.new(STDERR)
  ActiveRecord::Base.logger.level = ENV['LOGGER_LEVEL'].to_i
end

db_settings = {
  :adapter  => RUBY_PLATFORM == "java" ? "jdbcpostgresql" : "postgresql",
  :database => "promiscuous",
  :username => "postgres",
  :password => nil,
  :encoding => "utf8",
  :pool => 20,
}

ActiveRecord::Base.establish_connection(db_settings.merge('database' => 'postgres'))
ActiveRecord::Base.connection.drop_database(db_settings[:database]) rescue nil
ActiveRecord::Base.connection.create_database(db_settings[:database])

load 'spec/spec_helper/sql.rb'
