# frozen_string_literal: true

require "rails_helper"

RSpec.describe Services::Packages::FileToYml, type: :service do

  let(:file_path) { "spec/fixtures/PACKAGES" }
  let(:invalid_file_path) { "spec/fixtures/INVALID_PACKAGES" }

  context "with valid file" do
    it "return hash(package: version)" do
      expect(described_class.call(file_path)).to eq(
        "XML2R" => "0.0.6",
        "Package" => "1.0.2",
        "Version" => "1.1",
        "XMRF" => "1.0")
    end
  end

  context "with invalid file" do
    it "return error" do
      expect(described_class.call(invalid_file_path)).to eq(error: :invalid_file)
    end
  end
end
