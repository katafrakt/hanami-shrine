require 'shrine'
require 'hanami/utils/class_attribute'

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
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def self.prepended(base)
              base.send(:include, ::Hanami::Utils::ClassAttribute)
              base.send(:class_attribute, :_attachments)
              base.class_eval do
                self._attachments ||= []
                self._attachments << { name: :#{name}, class: #{attacher_class} }
              end
            end
          RUBY

          class_eval do
            def create(entity)
              save_attachments(entity) { |new_entity| super(new_entity) }
            end

            def update(id, entity)
              save_attachments(entity) { |new_entity| super(id, new_entity) }
            end

            def persist(entity)
              save_attachments(entity) { |new_entity| super(new_entity) }
            end

            def delete(id)
              delete_attachments(id) { super(id) }
            end

            private
            def _attachments
              self.class._attachments
            end

            def save_attachments(entity)
              _attachments.each do |a|
                entity = save_attachment(entity, a[:name], a[:class])
              end
              yield(entity)
            end

            def save_attachment(original_entity, name, attacher_class)
              attacher_name = "#{name}_attacher".to_sym
              attacher_proxy = Entity.attacher(name, attacher_class)

              if original_entity.send(name)
                attacher_proxy.send("#{name}=", original_entity.send(name))
                attacher_proxy.send(attacher_name).save

                attacher_proxy.send(attacher_name).replace
                attacher_proxy.send(attacher_name)._promote

                original_entity_attributes = original_entity.attributes
                original_entity_attributes.delete(name)

                entity = original_entity.class.new(original_entity_attributes.merge(:"#{name}_data" => attacher_proxy.send("#{name}_data")))
              else
                entity = original_entity
              end
            end

            def delete_attachments(id)
              entity = find(id)
              yield
              _attachments.each do |a|
                entity.send("#{a[:name]}_attacher").destroy
              end
            end
          end
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
