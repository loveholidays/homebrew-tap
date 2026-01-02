# typed: false
# frozen_string_literal: true

class Dbt < Formula
  desc "Run dbt (data build tool) via uv with version pinning"
  homepage "https://www.getdbt.com/"
  version "1.10.8"
  license "Apache-2.0"

  # This is a wrapper formula, no actual download needed
  url "data:text/plain,dbt"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  depends_on "uv"

  # Version pins
  DBT_CORE_VERSION = "1.10.8".freeze
  DBT_BIGQUERY_VERSION = "1.10.2".freeze
  PYTHON_VERSION = "3.11.8".freeze

  def install
    # Create dbt wrapper script that uses uv tool install for faster startup
    (bin/"dbt").write <<~EOS
      #!/bin/bash

      DBT_CORE_VERSION="#{DBT_CORE_VERSION}"
      DBT_BIGQUERY_VERSION="#{DBT_BIGQUERY_VERSION}"
      PYTHON_VERSION="#{PYTHON_VERSION}"

      # Check if dbt is installed with the correct version
      INSTALLED_VERSION=$(uv tool list 2>/dev/null | grep "dbt-core" | grep -o "v[0-9.]*" | sed 's/v//' || echo "")

      if [ "$INSTALLED_VERSION" != "$DBT_CORE_VERSION" ]; then
        echo "Installing dbt-core $DBT_CORE_VERSION with dbt-bigquery $DBT_BIGQUERY_VERSION..." >&2
        uv tool install \\
          --python "$PYTHON_VERSION" \\
          --force \\
          dbt-core=="$DBT_CORE_VERSION" \\
          --with dbt-bigquery=="$DBT_BIGQUERY_VERSION"
      fi

      # Run the installed dbt (uv automatically adds tools to PATH)
      exec "$(uv tool dir)/dbt-core/bin/dbt" "$@"
    EOS

    chmod 0755, bin/"dbt"
  end

  test do
    # Test that the wrapper script exists and is executable
    assert_predicate bin/"dbt", :exist?
    assert_predicate bin/"dbt", :executable?
  end

  def caveats
    <<~EOS
      This formula provides dbt via uv with pinned versions:
        - dbt-core: #{DBT_CORE_VERSION}
        - dbt-bigquery: #{DBT_BIGQUERY_VERSION}
        - Python: #{PYTHON_VERSION}

      Usage:
        dbt --version
        dbt run
        dbt test

      The first run will download and cache the packages.
      Subsequent runs will be faster.

      To update versions, edit the formula's version constants.
    EOS
  end
end
