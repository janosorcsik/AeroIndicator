# typed: strict
# frozen_string_literal: true

cask "aeroindicator" do
  version "1.0.0"
  sha256 "ef7dbc430a18c91c38be5cc3f6ee69c3f4f0e4fc9726ef5c3ee2708378ff3057"

  url "https://github.com/rien7/AeroIndicator/releases/download/v#{version}/AeroIndicator.zip"
  name "AeroIndicator"
  desc "Application to indicate the aerospace workspace"
  homepage "https://github.com/rien7/AeroIndicator"

  app "AeroIndicator.app"
  binary "#{appdir}/AeroIndicator.app/Contents/Resources/aeroIndicator", target: "aeroIndicator"
end
