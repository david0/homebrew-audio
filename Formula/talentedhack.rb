class Talentedhack < Formula
  desc "Real-time pitch correction plugin for melodies"
  homepage "https://github.com/jeremysalwen/TalentedHack"
  url "https://github.com/jeremysalwen/TalentedHack/archive/v1.86.tar.gz"
  sha256 "8e8362d64a363b242cc10976c480150b7e88c544e7185087a133925e575258b2"

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "fftw"

  def install
    system "make"
    output_dir = lib/"lv2"/"talentedhack.lv2"
    output_dir.install "talentedhack.so"
    output_dir.install "talentedhack.ttl"
    output_dir.install "manifest.ttl"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/blop.lv2/triangle.dylib")
  end
end
