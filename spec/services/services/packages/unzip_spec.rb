# frozen_string_literal: true

require "rails_helper"

RSpec.describe Services::Packages::Unzip, type: :service do
  let(:spec_zip_path) { "spec/fixtures/ATE_0.2.0.tar.gz" }
  let(:zip_path) { "lib/tmp_packages/ATE_0.2.0.tar.gz" }
  let(:destination_path) { "lib/tmp_packages/descriptions/ATE_0.2.0" }

  describe ".call" do
    before { FileUtils.cp(spec_zip_path, "lib/tmp_packages") }
    after do
      File.delete(zip_path) if File.exist?(zip_path)
      File.delete(destination_path) if File.exist?(destination_path)
    end

    it "save unziped file to lib/descriptions" do
      described_class.call(zip_path)
      expect(File.exists?(destination_path)).to eq(true)

      file = File.open(destination_path).read
      expect(file).to eq "Package: ATE\nType: Package\nTitle: Inference for Average Treatment Effects using Covariate\n        Balancing\nVersion: 0.2.0\nDate: 2015-02-16\nAuthor: Asad Haris <aharis@uw.edu> and Gary Chan <kcgchan@uw.edu>\nMaintainer: Asad Haris <aharis@uw.edu>\nDescription: Nonparametric estimation and inference for average treatment effects based on covariate balancing.\nLicense: GPL (>= 2)\nPackaged: 2015-02-17 19:08:32 UTC; Asad\nNeedsCompilation: no\nRepository: CRAN\nDate/Publication: 2015-02-17 23:42:59\n"
    end
  end

  describe ".drop" do
    let(:spec_file_path) { "spec/fixtures/ATE_0.2.0" }
    before { FileUtils.cp(spec_file_path, "lib/tmp_packages/descriptions") }

    after { File.delete(destination_path) if File.exist?(destination_path) }

    it "delete file" do
      described_class.new(zip_path).drop

      expect(File.exists?(destination_path)).to eq(false)
    end
  end
end
