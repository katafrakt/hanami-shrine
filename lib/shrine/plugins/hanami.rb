require 'shrine'

class Shrine
  module Plugins
    module Hanami
      module AttachmentMethods
        def initialize(name)
          super

          module_eval <<-RUBY, __FILE__, __LINE__ + 1
            module EntitySupport
              attr_reader :attributes
              def initialize(attributes)
                attachment = attributes[:#{name}]
                @_#{name} = attachment
                self.#{name}_attacher
                super(attributes)
              end

              def #{name}_data=(data)
                @#{name}_data = data
              end

              def #{name}_data
                super || @#{name}_data
              end

              def #{name}
                @_#{name} || super
              end

              def attributes
                @_#{name} ? super.merge(#{name}: @_#{name}) : super
              end
            end

            prepend EntitySupport
          RUBY
        end
      end

      module ClassMethods
        def repository(name)
          RepositoryMethods.new(name, self)
        end
      end

      class RepositoryMethods < Module
        def initialize(name, attacher_class)
          module_eval <<-RUBY, __FILE__, __LINE__ + 1
            def create(entity)
              save_#{name}_attachment(entity) { |new_entity| super(new_entity) }
            end
            def update(id, entity)
              save_#{name}_attachment(entity) { |new_entity| super(id, new_entity) }
            end
            def persist(entity)
              save_#{name}_attachment(entity) { |new_entity| super(new_entity) }
            end
            def delete(id)
              delete_#{name}_attachment(id) { super(id) }
            end

            private
            def save_#{name}_attachment(original_entity)
              attacher_proxy = Entity.attacher(:#{name}, #{attacher_class})

              if original_entity.#{name}
                attacher_proxy.#{name} = original_entity.#{name}
                attacher_proxy.#{name}_attacher.save

                attacher_proxy.#{name}_attacher.replace
                attacher_proxy.#{name}_attacher._promote

                original_entity_attributes = original_entity.attributes
                original_entity_attributes.delete(:#{name})

                entity = original_entity.class.new(original_entity_attributes.merge(#{name}_data: attacher_proxy.#{name}_data))
              else
                entity = original_entity
              end

              yield(entity)
            end

            def delete_#{name}_attachment(id)
              entity = find(id)
              yield
              entity.#{name}_attacher.destroy
            end
          RUBY
        end
      end

      module Entity
        def self.attacher(name, attacher)
          attachment_proxy ||= Class.new
          attachment_proxy.send(:include, attacher[name])
          attachment_proxy.class_eval do
            define_method :initialize do |attributes|
            end

            define_method :"#{name}_data" do
              @attachment_data
            end

            define_method :"#{name}_data=" do |data|
              @attachment_data = data
            end
          end
          attachment_proxy.new({})
        end
      end
    end

    register_plugin(:hanami, Hanami)
  end
end
