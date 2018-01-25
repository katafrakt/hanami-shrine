module DatabaseHelper
  MAPPING = {
    'postgres' => 'POSTGRES_URL',
    'mysql' => 'MYSQL_URL',
    'sqlite' => 'SQLITE_PATH',
  }

  module_function

  def adapter
    ENV['DB'] || 'sqlite'
  end

  def postgres?
    adapter == 'postgres'
  end

  def db_url(desired_adapter = nil)
    env_name = MAPPING.fetch(desired_adapter || adapter)
    ENV[env_name]
  end
end
