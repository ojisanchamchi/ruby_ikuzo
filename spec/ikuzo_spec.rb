# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ikuzo do
  describe ".random" do
    it "returns a non-empty string" do
      message = described_class.random

      expect(message).to be_a(String)
      expect(message.strip).not_to be_empty
    end

    it "supports choosing a static category" do
      message = described_class.random(:funny)

      expect(Ikuzo::Messages.messages_for(:funny)).to include(message)
    end
  end
end
