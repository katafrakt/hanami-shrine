require "image_processing/mini_magick"

class ImageAttachment < Shrine
  plugin :hanami
end

class ComplexAttachment < Shrine
  include ImageProcessing::MiniMagick
  plugin :hanami
  plugin :processing
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading
  plugin :determine_mime_type
  plugin :store_dimensions

  process(:store) do |io, context|
    original = io.download

    size_100 = resize_to_limit(original,  100, 100)
    size_30 = resize_to_limit(size_100,  30, 30)

    {original: io, small: size_100, tiny: size_30}
  end
end

class Kitten < Hanami::Entity
  include ImageAttachment[:image]
end

class KittenRepository < Hanami::Repository
  self.relation = :kittens
  prepend ImageAttachment.repository(:image)
end

class MultiCat < Hanami::Entity
  include ImageAttachment[:cat1]
  include ImageAttachment[:cat2]
end

class MultiCatRepository < Hanami::Repository
  prepend ImageAttachment.repository(:cat1)
  prepend ImageAttachment.repository(:cat2)
end

class PluginsModel < Hanami::Entity
  include ComplexAttachment[:image]
end

class PluginsModelRepository < Hanami::Repository
  prepend ComplexAttachment.repository(:image)
end

Hanami::Model.load!
