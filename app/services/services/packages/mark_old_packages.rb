# frozen_string_literal: true

module Services
  module Packages
    class MarkOldPackages < Services::Application
      def initialize(new_packages)
        @new_packages = new_packages
      end

      def call
        mark_old_packages
        @new_packages
      end

      private

        def mark_old_packages
          Package.fresh.find_each do |package|
            if package_is_fresh?(package)
              @new_packages.delete(package.name)
            else
              package.update!(deleted_at: Time.current)
            end
          end
        end

        def package_is_fresh?(package)
          @new_packages[package.name] == package.version
        end
    end
  end
end
