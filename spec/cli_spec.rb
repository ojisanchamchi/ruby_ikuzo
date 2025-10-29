# frozen_string_literal: true

require "spec_helper"
require "stringio"

RSpec.describe Ikuzo::CLI do
  let(:stdout) { StringIO.new }
  let(:stderr) { StringIO.new }
  let(:kernel) { instance_double(Kernel) }

  before do
    allow(kernel).to receive(:exit)
  end

  it "prints a generated message without committing when --no-commit is provided" do
    allow(Ikuzo::Messages).to receive(:random).and_return("feat: ship it!")
    allow(kernel).to receive(:system)

    cli = described_class.new(["--no-commit"], stdout: stdout, stderr: stderr, kernel: kernel)
    cli.run

    expect(stdout.string).to include("feat: ship it!")
    expect(kernel).to have_received(:exit).with(0)
    expect(kernel).not_to have_received(:system)
    expect(stderr.string).to be_empty
  end

  it "lists categories when --list-categories is passed" do
    allow(kernel).to receive(:system)
    cli = described_class.new(["--list-categories"], stdout: stdout, stderr: stderr, kernel: kernel)

    cli.run

    expect(stdout.string).to include("Available categories:")
    Ikuzo::Messages.categories.each do |category|
      expect(stdout.string).to include(category.to_s)
    end
    expect(kernel).to have_received(:exit).with(0)
  end
end
