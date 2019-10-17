require 'shrine'
require 'hanami/utils/class_attribute'
require 'ostruct'

class Shrine
  module Plugins
    module Hanami
      def self.load_dependencies(uploader, **)
        uploader.plugin :entity
      end

      module AttachmentMethods
        def initialize(name, **options)
          super

          module_eval <<-RUBY, __FILE__, __LINE__ + 1
            module EntitySupport
              attr_reader :_shrine_attachers

              def initialize(attributes)
                attachment = attributes[:#{name}]
                @_shrine_attachers = []
                super(attributes)
                attacher = self.#{name}_attacher
                attacher.attach(attachment)
                @_shrine_attachers << attacher
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
              if !entity.is_a?(::Hanami::Entity)
                entity = self.class.entity.new(entity)
              end

              entity._shrine_attachers.each do |attacher|
                entity = save_attachment(entity, attacher)
              end

              yield(entity)
            end

            def save_attachment(original_entity, attacher)
                original_entity_attributes = original_entity.send(:attributes).dup
                original_entity_attributes.delete(attacher.name)

                original_entity.class.new(original_entity_attributes.merge(:"#{attacher.name}_data" => attacher.column_data))
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
    end

    register_plugin(:hanami, Hanami)
  end
end
