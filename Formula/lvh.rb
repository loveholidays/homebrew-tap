# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
require_relative "lib/gcs_download_strategy"
class Lvh < Formula
  desc "Loveholidays CLI, help your automate your day to day tasks in Loveholidays"
  homepage "https://github.com/loveholidays/lvh"
  version "0.0.27"

  on_macos do
    on_intel do
      url "gs://lh-homebrew-bin/lvh/v0.0.27/lvh_darwin_x86_64.tar.gz", using: GcsDownloadStrategy
      sha256 "bce2dffe364416ce9d3dbe0469ed241f488312877aef1feecc89a50ceb942aed"

      def install
        bin.install "lvh"
      end
    end
    on_arm do
      url "gs://lh-homebrew-bin/lvh/v0.0.27/lvh_darwin_arm64.tar.gz", using: GcsDownloadStrategy
      sha256 "abd291fb873284cec8999a9a3fd760219f8501dec07bc877e772d0574a253e7c"

      def install
        bin.install "lvh"
      end
    end
  end

  on_linux do
    on_intel do
      if Hardware::CPU.is_64_bit?
        url "gs://lh-homebrew-bin/lvh/v0.0.27/lvh_linux_x86_64.tar.gz", using: GcsDownloadStrategy
        sha256 "56e05db6bb7d3701f7576865b4fe5da530a49a30ace14b85a09154ca5be67e8d"

        def install
          bin.install "lvh"
        end
      end
    end
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "gs://lh-homebrew-bin/lvh/v0.0.27/lvh_linux_arm64.tar.gz", using: GcsDownloadStrategy
        sha256 "639dbdebc2e82c98d15f97aa74598f822b73dcda0a499c678902ce9e1c70916c"

        def install
          bin.install "lvh"
        end
      end
    end
  end
end
