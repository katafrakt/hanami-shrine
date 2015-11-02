require 'shrine'

module Lotus
  module Shrine
    module Validations
      def self.included(base)
        base.class_eval do
          def validate
            super

            shrine_attachers.each do |attacher|
              public_send(attacher).errors.each do |message|
                errors.add(attacher_name(attacher), message)
              end
            end
          end

          private

          # this feels wrong and probably is!
          # however, I still think it's way better than having to manually
          # include validators for every attacher instance like:
          #    include Lotus::Shrine::Validations[:image]
          #    include Lotus::Shrine::Validations[:avatar]
          def shrine_attachers
            public_methods.select{|m| m =~ /attacher/}.select do |m|
              public_send(m).is_a?(::Shrine::Attacher)
            end
          end

          def attacher_name(method_name)
            method_name.to_s.gsub('_attacher', '').to_sym
          end
        end
      end
    end
  end
end
