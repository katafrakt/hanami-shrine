require 'spec_helper'
require 'fixtures/models'
require 'fileutils'
require 'json'

describe 'Hanami::Shrine with plugins' do
  after do
    FileUtils.rm_rf('spec/tmp/uploads')
  end

  let(:image) { ::File.open('spec/support/cat.jpg') }
  let(:image2) { ::File.open('spec/support/cat2.jpg') }
  let(:model) do
    model = PluginsModel.new(image: image)
    PluginsModelRepository.new.create(model)
  end

  context 'versions + processing' do
    it 'raises exception for url without version param' do
      expect{ model.image_url }.to raise_exception(Shrine::Error)
    end

    it 'has versions hash as data' do
      data = JSON.parse(model.image_data)
      expect(data).to be_kind_of(Hash)
      expect(data).to have_key('original')
      expect(data).to have_key('small')
      expect(data).to have_key('tiny')
    end

    %w(original small tiny).each do |version|
      it "creates #{version} version" do
        version = model.image[version.to_sym]
        file_path = File.join('spec/tmp/uploads', version.id)
        expect(File.exist?(file_path)).to eq(true)
      end
    end
  end

  context 'determine_mime_type' do
    it 'detects mime type of image' do
      metadata = model.image[:original].data['metadata']
      expect(metadata['mime_type']).to eq('image/jpeg')
    end
  end

  context 'store_dimensions' do
    it 'stores dimensions in metadata' do
      metadata = model.image[:original].data['metadata']
      expect(metadata['width']).to eq(470)
      expect(metadata['height']).to eq(459)
    end

    it 'defines methods on attachment' do
      expect(model.image[:tiny].width).to eq(30)
      expect(model.image[:small].height).to eq(98)
    end
  end
end
