require 'spec_helper'
require 'hanami/model'
require 'hanami-validations'

RSpec.describe 'Hanami::Shrine::Validations' do
  class CatUploader < Shrine
    plugin :validation_helpers
    plugin :determine_mime_type
    plugin :hanami, validations: true

    Attacher.validate do
      validate_max_size 180_000, message: "is too large (max is 2 MB)"
      validate_mime_type_inclusion ["image/jpg", "image/jpeg"]
    end
  end

  class Cat
    include Hanami::Entity
    include Hanami::Validations
    include CatUploader[:image]

    attributes :title, :image_data
  end

  class CatRepository
    include Hanami::Repository
    extend CatUploader.repository(:image)
  end

  Hanami::Model.configure do
    adapter type: :memory, uri: 'memory://localhost/hanami-shrine_development'

    mapping do
      collection :images do
        entity Cat
        repository CatRepository

        attribute :id,          Integer
        attribute :image_data,  String
      end
    end
  end.load!

  let(:cat) { Cat.new }

  context 'file size' do
    context 'too large' do
      before do
        cat.image = File.open('spec/support/cat.jpg')
      end

      it 'should be invalid' do
        expect(cat.valid?).to eq(false)
      end

      it 'should have proper error message' do
        cat.valid?
        expect(cat.errors.for(:image)).to include('is too large (max is 2 MB)')
      end

      it 'should have only one error' do
        cat.valid?
        expect(cat.errors.for(:image).length).to eq(1)
      end
    end

    it 'should not be too large' do
      cat.image = File.open('spec/support/cat2.jpg')
      expect(cat.valid?).to eq(true)
    end
  end

  context 'mime type' do
    it 'should be valid' do
      cat.image = File.open('spec/support/cat2.jpg')
      expect(cat.valid?).to eq(true)
    end

    context 'invalid' do
      before do
        cat.image = File.open('spec/support/cat.txt')
      end

      it 'should not be valid' do
        expect(cat.valid?).to eq(false)
      end

      it 'should have proper error message' do
        cat.valid?
        expect(cat.errors.for(:image).any?{|e| e =~ /isn't of allowed type/}).to eq(true)
      end

      it 'should have only one error' do
        cat.valid?
        expect(cat.errors.for(:image).length).to eq(1)
      end
    end
  end


end
