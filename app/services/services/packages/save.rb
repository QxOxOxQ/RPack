# frozen_string_literal: true

module Services
  module Packages
    class Save < Services::Application
      attr_reader :errors

      def initialize(file_path)
        @file_path = file_path
        @errors = {}
      end

      def call
        package = Package.new(package_attributes)
        if package.save
          package
        else
          errors[@file_path] = package.errors
        end
      rescue ArgumentError, ActiveRecordError => e
        errors[@file_path] = e
      end

      def valid?
        errors.empty?
      end

      private

        def package_attributes
          attr = {}
          file.lines.each_with_index do |line, index|
            case encode_to_utf8(line)
            when /^Package:/
              attr[:name] = parse_line("Package:", line, index)
            when /^Description:/
              attr[:description] = parse_line("Description:", line, index)
            when /^Title:/
              attr[:title] = parse_line("Title:", line, index)
            when /^Author:/
              attr[:authors] = parse_line("Author:", line, index)
            when /^Version:/
              attr[:version] = parse_line("Version:", line, index)
            when /^Maintainer:/
              attr[:maintainers] = parse_line("Maintainer:", line, index)
            when /^License:/
              attr[:license] = parse_line("License:", line, index)
            when /^Date\/Publication:/
              date = parse_line("License:", line, index)
              attr[:publication_date] = DateTime.parse(date) if date.present?
            end
          end
          attr
        end

        def parse_line(attr, line, index)
          line = encode_to_utf8(line)
          key_size = attr.size + 1
          text = line[key_size..-1]
          next_line = encode_to_utf8(@file.lines[index + 1])
          if next_line && /       /.match?(next_line)
            text = "#{text}#{next_line[7..-1]}"
          end
          text.delete("\n\r") # output only attributes
        end

        def encode_to_utf8(line)
          return if line.nil? || line.empty?
          line.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: "")
        end

        def file
          @file ||= File.open(Rails.root.join(@file_path)).read
        end
    end
  end
end
