# frozen_string_literal: true

module Services
  module Packages
    class Refresh < Services::Application
      def initialize(description_path_file)
        @description_path_file = description_path_file
      end


      def call
        hash_description = FileToYml.call(@description_path_file)
        hash_description_to_fetch = MarkOldPackages.call(hash_description)
        save_packages(hash_description_to_fetch)
      end

      private

        def save_packages(packages)
          progressbar(packages.size)
          packages.each_pair do |package, version|

            @progressbar.increment

            fetch = Fetch.new(package, version)
            zip_path = fetch.call


            unzip = Unzip.new(zip_path)
            description_path = unzip.call

            Save.call(description_path)

            fetch.drop
            unzip.drop
          end
        end

        def progressbar(total)
          @progressbar = ProgressBar.create(
            format: "%a %e %P% Processed: %c from %C",
            total: total)
        end
    end
  end
end
