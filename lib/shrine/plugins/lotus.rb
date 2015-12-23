require 'shrine'

class Shrine
  module Plugins
    module Lotus
      def self.configure(uploader, validations: nil)
        uploader.opts[:lotus_validations] = validations
      end

      module AttachmentMethods
        def initialize(name)
          super

          if shrine_class.opts[:lotus_validations]
            module_eval <<-RUBY, __FILE__, __LINE__ + 1
              def validate
                super
                #{name}_attacher.errors.each do |message|
                  errors.add(:#{name}, message)
                end
              end
            RUBY
          end
        end
      end

      module ClassMethods
        def repository(name)
          RepositoryMethods.new(name)
        end
      end

      class RepositoryMethods < Module
        def initialize(name)
          module_eval <<-RUBY, __FILE__, __LINE__ + 1
            def create(entity)
              save_#{name}_attachment(entity) { super }
            end
            def update(entity)
              save_#{name}_attachment(entity) { super }
            end
            def persist(entity)
              save_#{name}_attachment(entity) { super }
            end
            def delete(entity)
              delete_#{name}_attachment(entity) { super }
            end

            private
            def save_#{name}_attachment(entity)
              entity.#{name}_attacher.save

              entity.#{name}_attacher.replace
              entity.#{name}_attacher._promote
              yield
            end

            def delete_#{name}_attachment(entity)
              yield
              entity.#{name}_attacher.destroy
            end
          RUBY
        end
      end
    end

    register_plugin(:lotus, Lotus)
  end
end
