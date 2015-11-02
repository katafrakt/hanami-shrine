module Lotus
  module Shrine
    class Repository < Module
      def self.[](name)
        self::RepositoryMethods.new(name)
      end

      class RepositoryMethods < Module
        def included(base)
          base.class_eval do
            extend self::ClassMethods
          end
        end

        def initialize(attachment_name)
          module_eval <<-RUBY, __FILE__, __LINE__ + 1
            module ClassMethods
              def create(entity)
                method_name = "#{attachment_name}_attacher".to_sym

                entity.public_send(method_name).save
                entity.public_send(method_name).replace
                entity.public_send(method_name)._promote

                super
              end

              def update(entity)
                method_name = "#{attachment_name}_attacher".to_sym

                entity.public_send(method_name).save
                entity.public_send(method_name).replace
                entity.public_send(method_name)._promote

                super
              end

              def persist(entity)
                method_name = "#{attachment_name}_attacher".to_sym

                entity.public_send(method_name).save
                entity.public_send(method_name).replace
                entity.public_send(method_name)._promote

                super
              end

              def delete(entity)
                super

                method_name = "#{attachment_name}_attacher".to_sym
                begin
                  entity.public_send(method_name).destroy
                rescue Errno::ENOENT
                  # no-op - should I do something?
                end
              end
            end
          RUBY
        end
      end
    end
  end
end
