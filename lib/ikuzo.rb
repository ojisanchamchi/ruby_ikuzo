# frozen_string_literal: true

require "ikuzo/version"
require "ikuzo/messages"
require "ikuzo/cli"

module Ikuzo
  def self.random(category = nil)
    Messages.random(category)
  end
end
