# frozen_string_literal: true

require "rails_helper"

RSpec.describe Services::Packages::Refresh, type: :service do

  let(:description_path_file) { "XXX" }
  before do
    obj_file_to_yml = Services::Packages::FileToYml.new(description_path_file)
    allow(Services::Packages::FileToYml).to receive(:new).with(description_path_file) { obj_file_to_yml }
    allow(obj_file_to_yml).to receive(:call) { :yml }

    obj_mark_old_packages = Services::Packages::MarkOldPackages.new(:x)
    allow(Services::Packages::MarkOldPackages).to receive(:new).with(:yml) { obj_mark_old_packages }
    allow(obj_mark_old_packages).to receive(:call) { { p: :v, p1: :v1, p2: :v2 } }

    obj_fetch = Services::Packages::Fetch.new(:x, :y)
    allow(Services::Packages::Fetch).to receive(:new).with(:p, :v) { obj_fetch }
    allow(Services::Packages::Fetch).to receive(:new).with(:p1, :v1) { obj_fetch }
    allow(Services::Packages::Fetch).to receive(:new).with(:p2, :v2) { obj_fetch }
    allow(obj_fetch).to receive(:call) { :zip_pah }
    allow(obj_fetch).to receive(:drop) {}

    obj_unzip = Services::Packages::Unzip.new(:x)
    allow(Services::Packages::Unzip).to receive(:new).with(:zip_pah) { obj_unzip }
    allow(obj_unzip).to receive(:call) { :description_path }
    allow(obj_unzip).to receive(:drop) {}

    obj_save = Services::Packages::Save.new(:x)
    allow(Services::Packages::Save).to receive(:new).with(:description_path) { obj_save }
    allow(obj_save).to receive(:call) { true }


  end
  context "when processed all services" do
    it "return packges" do
      expect(described_class.call(description_path_file)).to eq(p: :v, p1: :v1, p2: :v2)
    end
  end
end
