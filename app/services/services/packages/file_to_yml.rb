# frozen_string_literal: true

module Services
  module Packages
    class FileToYml < Services::Application
      def initialize(file_path)
        @file_path = file_path
        @error = {}
      end

      def call
        return { error: :invalid_file } if packages.size != versions.size

        create_package_version_hash
      end

      def valid?
        @error.nil?
      end

      private

        def create_package_version_hash
          [packages, versions].transpose.to_h
        end

        def packages
          @packages ||= find_and_parse("Package")
        end

        def versions
          @versions ||= find_and_parse("Version")
        end

        def find_and_parse(attr)
          keys_with_values = IO.foreach(file).grep(/#{attr}:/)
          key_size = attr.size + 2
          keys_with_values.map { |x| x[key_size..-1].delete!("\n") } # output only attributes
        end

        def file
          @file ||= File.open(Rails.root.join(@file_path))
        end
    end
  end
end
