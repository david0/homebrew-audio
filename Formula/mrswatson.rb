class Mrswatson < Formula
  desc "Command-line audio plugin host, useful for development and testing"
  homepage "http://teragonaudio.com/MrsWatson.html"
  url "http://static.teragonaudio.com/MrsWatson.zip"
  version "0.9.7"
  sha256 "9b4e3f40dd352a13bd33e1f5cd75a93250e68c59910e9bf19695c583e0f40bac"

  def install
    bin.install "Mac OS X/mrswatson", "Mac OS X/mrswatson64"
  end

  test do
    assert_match "Quickstart", shell_output("#{bin}/mrswatson -h", 1)
  end
end
