# frozen_string_literal: true

require "yolo/version"
require "yolo/messages"
require "yolo/cli"

module Yolo
  def self.random(category = nil)
    Messages.random(category)
  end
end
