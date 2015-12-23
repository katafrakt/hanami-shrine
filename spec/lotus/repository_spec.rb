require 'spec_helper'
require 'fileutils'
require 'lotus/model'
require 'json'

describe 'Lotus::Shrine::Repository' do
  after do
    FileUtils.rm_rf('spec/tmp')
  end

  class ImageAttachment < Shrine
    plugin :lotus
  end

  class Kitten
    include Lotus::Entity
    include ImageAttachment[:image]

    attributes :title, :image_data
  end

  class KittenRepository
    include Lotus::Repository
    extend ImageAttachment.repository(:image)
  end

  Lotus::Model.configure do
    adapter type: :memory, uri: 'memory://localhost/lotus-shrine_development'

    mapping do
      collection :images do
        entity Kitten
        repository KittenRepository

        attribute :id,          Integer
        attribute :image_data,  String
      end
    end
  end.load!

  let(:cat) do
    cat = Kitten.new
    cat.image = ::File.open('spec/support/cat.jpg')
    KittenRepository.create(cat)
  end

  shared_context 'creation' do
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

  shared_context 'update' do
    let!(:before_update_data) { JSON.parse(cat.image_data) }
    let(:new_data) { JSON.parse(updated_cat.image_data) }
    let(:updated_cat) do
      cat.image = File.open('spec/support/cat2.jpg')
      KittenRepository.update(cat)
    end

    it 'should have different id' do
      expect(new_data['id']).not_to eq(before_update_data['id'])
    end

    it 'should have different url' do
      old_url = cat.image_url
      expect(updated_cat.image_url).not_to eq(old_url)
    end

    it 'should not be in temp dir' do
      expect(updated_cat.image_url).not_to match(/^#{Dir.tmpdir}/)
    end
  end

  # --- SPECS BEGIN HERE --- #

  context '#create' do
    include_context 'creation'
  end

  context '#delete' do
    let!(:before_delete_data) { JSON.parse(cat.image_data) }

    before do
      KittenRepository.delete(cat)
    end

    it 'should not exist' do
      expect(File.exist?('spec/tmp/uploads/' + before_delete_data["id"])).not_to eq(true)
    end

    it 'should delete entity' do
      expect(cat.id).not_to be_nil
      expect(KittenRepository.find(cat.id)).to eq(nil)
    end
  end

  context '#update' do
    include_context 'update'
  end

  context '#persist' do
    context 'on create' do
      include_context 'creation'
    end

    context 'on update' do
      include_context 'update'
    end
  end
end
