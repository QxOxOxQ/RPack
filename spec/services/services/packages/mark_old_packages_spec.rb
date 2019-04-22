# frozen_string_literal: true

require "rails_helper"

RSpec.describe Services::Packages::MarkOldPackages, type: :service do

  let(:new_packages) { { "XML2R" => "0.0.6",
                       "Package" => "1.0.2",
                       "Version" => "1.1",
                       "XMRF" => "1.0" }}
  let!(:outdated_version) { create(:package, name: "XMRF", version: "999999") }
  let!(:not_exists_package) { create(:package, name: "Out_Dated") }
  before do
    create(:package, name: "XML2R", version: new_packages["XML2R"])
    @results = described_class.call(new_packages)
  end

  it "return packages without exists packages in db" do
    expect(@results).to eq("Package" => "1.0.2",
                            "Version" => "1.1",
                            "XMRF" => "1.0")
  end

  it "save deleted_at in olddated packages" do
    expect(outdated_version).to_not be_nil
    expect(not_exists_package).to_not be_nil
  end
end
