module Multisite
  module ActionMailer
    class << self
      def included(base)
        base.extend ClassMethods
        class << base
          alias_method_chain :method_missing, :multisite
        end
      end
    end

    module ClassMethods
      def method_missing_with_multisite(method, *args, &block)
        last_exception = nil
        ::ActionController::Base.view_paths.each do |vp|
          begin
            self.template_root = vp
            method_missing_without_multisite(method, *args, &block)
            last_exception = nil
            break # Stop iteration if call succeeded
          rescue ::ActionView::MissingTemplate => e
            last_exception = e
          end
        end
        raise last_exception if last_exception
      end
    end
  end
end

if Object.const_defined?("ActionMailer")
  ActionMailer::Base.send(:include, Multisite::ActionMailer)
end