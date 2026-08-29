# frozen_string_literal: true

require "rails_helper"

RSpec.describe Profile do
  let(:profile) { Profile.new(first_name: "Ada", last_name: "Lovelace", address: "London") }

  describe "Profile attributes" do
    it "Creates a complete profile" do
      expect(profile.first_name).to eq("Ada")
      expect(profile.last_name).to eq("Lovelace")
      expect(profile.address).to eq("London")
    end

    it 'Raises an Argument error if a parameter is missing' do
      expect {
        Profile.new(first_name: "Ina", last_name: "Complete")
      }.to raise_error(ArgumentError)
    end

    it "is immutable after creation" do
      expect(profile).not_to respond_to(:first_name=)
      expect { profile.first_name = "Changed" }.to raise_error(NoMethodError)
    end
  end

  describe "#full_name" do
    it 'Returns the full name' do
      expect(profile.full_name).to eq("Ada Lovelace")
    end
  end
end
