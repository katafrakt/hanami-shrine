require 'spec_helper'
require 'fileutils'
require 'lotus/model'
require 'json'

describe Lotus::Shrine::Repository do
  after do
    FileUtils.rm_rf('spec/tmp')
  end

  class Cat
    include Lotus::Entity
    include Shrine[:image]

    attributes :title, :image_data
  end

  class CatRepository
    include Lotus::Repository
    include Lotus::Shrine::Repository[:image]
  end

  Lotus::Model.configure do
    adapter type: :memory, uri: 'memory://localhost/lotus-shrine_development'

    mapping do
      collection :images do
        entity Cat
        repository CatRepository

        attribute :id,          Integer
        attribute :image_data,  String
      end
    end
  end.load!

  it 'has a version number' do
    expect(Lotus::Shrine::VERSION).not_to be nil
  end

  context '#create' do
    let(:cat) do
      cat = Cat.new
      cat.image = ::File.open('spec/support/cat.jpg')
      CatRepository.create(cat)
    end

    it 'should not be in temp dir' do
      expect(cat.image_url).not_to match(/^#{Dir.tmpdir}/)
    end

    it 'exist? should be true' do
      expect(cat.image.exists?).to eq(true)
    end

    it 'should really exist' do
      json_data = JSON.parse(cat.image_data)
      expect(File.exist?('spec/tmp/uploads/' + json_data["id"])).to eq(true)
    end
  end
end
