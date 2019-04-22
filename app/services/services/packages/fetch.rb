# frozen_string_literal: true

require "open-uri"

module Services
  module Packages
    class Fetch < Services::Application
      BASE_URL = "https://cran.r-project.org/src/contrib"
      EXTENSION = "tar.gz"
      attr_reader :errors
      def initialize(package, version)
        @package = package
        @version = version
        @errors = {}
      end

      def call
        download
        destination_path
      rescue OpenURI::HTTPError, Errno::ETIMEDOUT => e
        errors["#{@package}_#{@version}"] = e
      end

      def valid?
        errors.empty?
      end

      def drop
        File.delete(destination_path) if File.exist?(destination_path)
      end

      private

        def download
          File.open(destination_path, "wb") do |file|
            file.write open(uri).read
          end
        end

        def uri
          "#{BASE_URL}/#{filename}"
        end

        def destination_path
          "lib/tmp_packages/#{filename}"
        end

        def filename
          @filename ||= "#{file}.#{EXTENSION}"
        end

        def file
          @file ||= "#{@package}_#{@version}"
        end
    end
  end
end
