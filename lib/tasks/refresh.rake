# frozen_string_literal: true

require "open-uri"

namespace :refresh do
  desc "TODO"
  task from_local: :environment do

    Services::Packages::Refresh.call("lib/PACKAGES")
  end

  task from_remote: :environment do
    File.open("lib/PACKAGES", "wb") do |file|
      file.write open("https://cran.r-project.org/src/contrib/PACKAGES").read
    end
    Services::Packages::Refresh.call("lib/PACKAGES")
  end

  task delete_outdated: :environment do
    count = Package.count
    Package.outdated.destroy_all
    deleted_count = Package.count - count
    puts "Deleted: #{deleted_count} packages"
  end
end
