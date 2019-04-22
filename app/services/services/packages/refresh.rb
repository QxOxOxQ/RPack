# frozen_string_literal: true

module Services
  module Packages
    class Refresh < Services::Application
      def initialize(description_path_file)
        @description_path_file = description_path_file
        @errors = {
            fetch: [],
            save: []
        }
        @logger = Logger.new "lib/tmp_packages/logfile.log"
        @saved_count = 0
      end


      def call
        log_start

        hash_description = FileToYml.call(@description_path_file)
        progressbar(hash_description.size)
        hash_description_to_fetch = MarkOldPackages.call(hash_description)
        update_bar(hash_description_to_fetch.size)

        save_packages(hash_description_to_fetch)

        log_end
        report
      end

      private

        def save_packages(packages)
          packages.each_pair do |package, version|

            @progressbar.increment

            fetch = Fetch.new(package, version)
            zip_path = fetch.call
            unless fetch.valid?
              @logger.error("FETCH: #{fetch.errors}")
              @errors[:fetch] << fetch.errors
              next
            end

            unzip = Unzip.new(zip_path)
            description_path = unzip.call

            save = Save.new(description_path)
            save.call
            if save.valid?
              @logger.info("#{package}_#{version}: save")
              @saved_count += 1
            else
              @logger.error("SAVE: #{save.errors}")
              @errors[:save] << save.errors
            end

          ensure
            fetch.drop if fetch
            unzip.drop if unzip
          end
        end

        def progressbar(total)
          @progressbar = ProgressBar.create(
            format: "%a %e %P% Processed: %c from %C",
            total: total)
        end

        def log_start
          @logger.info("------------------------------------------------")
          @logger.info("START: #{Time.current}")
        end

        def log_end
          @logger.info("END: #{Time.current}")
          @logger.info("------------------------------------------------")
        end

        def update_bar(done)
          @progressbar.progress += (@progressbar.total - done)
        end

        def report
          report = {
              saved: @saved_count,
              errors: @errors
          }
          @logger.info(report)
          report
        end
    end
  end
end
