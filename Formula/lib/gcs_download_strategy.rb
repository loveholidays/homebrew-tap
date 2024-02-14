require "download_strategy"
require "open3"

def fetch_with_gsutil(gsutil_path:, bucket:, binary_path:, destination:)
  command = "#{gsutil_path} cp gs://#{bucket}/#{binary_path} #{destination}"
  stdout, stderr, status = Open3.capture3(command)

  if status.success?
    puts "Successfully downloaded: #{binary_path}"
  else
    puts "Error downloading #{binary_path}: #{stderr}"
    raise "Failed to download with gsutil. Exit status: #{status.exitstatus}"
  end
end

# Custom download strategy for GCS
class GcsDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    @url = url
    @bucket, @binary_path = parse_gcs_url(url)
  end

  def parse_gcs_url(url)
    match = url.match(%r{^gs://([^/]+)/(.+)$})
    raise "Invalid GCS URL" unless match

    [match[1], match[2]]
  end

  def fetch(timeout: nil, **options)
    ohai "Downloading #{@binary_path} from GCS bucket #{@bucket}"
    binary_path = @binary_path
    bucket = @bucket
    destination = cached_location
    gsutil_path = "/opt/homebrew/bin/gsutil"

    if File.exist?(gsutil_path)
      fetch_with_gsutil(bucket: bucket, binary_path: binary_path, destination: destination)
    else
      command = "/opt/homebrew/bin/brew install --cask google-cloud-sdk"
      command! "/bin/bash", args: ["-c", command]
      fetch_with_gsutil(bucket: bucket, binary_path: binary_path, destination: destination)
    end

  end
end
