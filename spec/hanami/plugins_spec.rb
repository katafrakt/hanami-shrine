require 'spec_helper'
require 'fixtures/models'
require 'fileutils'
require 'json'

describe 'Hanami::Shrine with plugins' do
  after do
    FileUtils.rm_rf('spec/tmp/uploads')
  end

  let(:image) do
    FileUtils.cp('spec/support/cat.jpg', 'spec/support/cat_copy.jpg')
    ::File.open('spec/support/cat_copy.jpg')
  end

  let(:image2) do
    FileUtils.cp('spec/support/cat2.jpg', 'spec/support/cat2_copy.jpg')
    ::File.open('spec/support/cat2_copy.jpg')
  end

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

    it 'keeps original size' do
      version = model.image[:original]
      file_path = File.join('spec/tmp/uploads', version.id)
      dimensions = MiniMagick::Image.open(file_path).dimensions
      expect(dimensions).to eq([470, 459])
    end

    it 'resizes correctly' do
      version = model.image[:small]
      file_path = File.join('spec/tmp/uploads', version.id)
      dimensions = MiniMagick::Image.open(file_path).dimensions
      expect(dimensions).to eq([100, 98])
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
