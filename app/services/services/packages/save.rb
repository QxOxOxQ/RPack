# frozen_string_literal: true

module Services
  module Packages
    class Save < Services::Application
      def initialize(file_path)
        @file_path = file_path
      end

      def call
        if package.save
          package
        else
          { @file_path => package.errors }
        end
      end

      private

        def package
          @package ||= Package.new(
            name: find_and_parse("Package"),
            description: find_and_parse("Description"),
            title: find_and_parse("Title"),
            authors: find_and_parse("Author"),
            version: find_and_parse("Version"),
            maintainers: find_and_parse("Maintainer"),
            license: find_and_parse("License"),
            publication_date: Time.parse(find_and_parse("Date/Publication"))
          )
        end

        def find_and_parse(attr)
          keys_with_values = IO.foreach(file).grep(/#{attr}:/)
          key_size = attr.size + 2
          keys_with_values[0][key_size..-1].delete!("\n")  # output only attributes
        end

        def file
          @file ||= File.open(Rails.root.join(@file_path))
        end
    end
  end
end
