$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hanami/shrine'
require 'shrine'
require 'shrine/storage/file_system'
require 'hanami/model'
require 'hanami/model/sql'
require 'hanami/model/migrator'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new(Dir.tmpdir),
  store: Shrine::Storage::FileSystem.new("spec/tmp", prefix: "uploads")
}

Hanami::Model.configure do
  adapter :sql, 'sqlite://spec/tmp/hanami-shrine_test'
  migrations Pathname.new(__dir__ + '/fixtures/migrations').to_s
end
Hanami::Model::Migrator.prepare
