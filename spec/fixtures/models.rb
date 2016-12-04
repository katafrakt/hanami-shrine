class ImageAttachment < Shrine
  plugin :hanami
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

Hanami::Model.load!
