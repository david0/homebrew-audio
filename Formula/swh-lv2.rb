class SwhLv2 < Formula
  desc "SWH Plugins in LV2 format"
  homepage "http://plugin.org.uk/"
  url "https://github.com/swh/lv2/archive/v1.0.16.tar.gz"
  sha256 "bc24512de6e2fb7a493226e2e01a80ba8462a318b15c3b0fd0cd914b018c3548"
  head "https://github.com/swh/lv2.git"

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "fftw"

  def install
    system "make"
    system "make", "install-system", "PREFIX=#{prefix}"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/delay-swh.lv2/plugin-Darwin.dylib")
  end
end
