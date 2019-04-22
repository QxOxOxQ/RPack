# frozen_string_literal: true

require "rails_helper"

RSpec.describe Services::Packages::Save, type: :service do

  let(:file_path) { "spec/fixtures/ATE_0.2.0" }
  let(:invalid_file_path) { "spec/fixtures/INVALID_PACKAGES" }

  context "with valid attributes" do
    it "save package" do
      service = described_class.new
      expect { service.call(file_path) }.to change(Package, :count).by(1)
      package = Package.last
      aggregate_failures do
        expect(package.name).to eq "ATE"
        expect(package.description).to eq "Nonparametric estimation and inference for average treatment effects based on covariate balancing."
        expect(package.title).to eq "Inference for Average Treatment Effects using Covariate Balancing"
        expect(package.authors).to eq "Asad Haris <aharis@uw.edu> and Gary Chan <kcgchan@uw.edu>"
        expect(package.version).to eq "0.2.0"
        expect(package.maintainers).to eq "Asad Haris <aharis@uw.edu>"
        expect(package.license).to eq "GPL (>= 2)"
        expect(package.publication_date).to eq DateTime.new(2015, 02, 17, 23, 42, 59)
      end
      expect(service.valid?).to eq true
    end
  end
end
