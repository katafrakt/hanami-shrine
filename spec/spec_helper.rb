$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hanami/shrine'
require 'shrine'
require 'shrine/storage/file_system'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new(Dir.tmpdir),
  store: Shrine::Storage::FileSystem.new("spec/tmp", prefix: "uploads")
}
