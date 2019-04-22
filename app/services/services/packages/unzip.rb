# frozen_string_literal: true

require "rubygems/package"

module Services
  module Packages
    class Unzip < Services::Application
      # Unzip gz.tar
      def initialize(file_path)
        @file_path = file_path
      end

      def call
        File.open(@file_path, "rb") do |file|
          Zlib::GzipReader.wrap(file) do |gz|
            Gem::Package::TarReader.new(gz) do |tar|
              tar.each do |entry|
                if /DESCRIPTION/.match?(entry.full_name)
                  File.open(destination_path, "wb") do |f|
                    f.write(entry.read)
                  end
                end
              end
            end
          end
        end
        destination_path
      end

      def drop
        File.delete(destination_path) if File.exist?(destination_path)
      end

      private

        def destination_path
          "lib/tmp_packages/descriptions/#{file_name}"
        end

        def file_name
          @file_path.split("/")[-1][0..-8]
        end
    end
  end
end
