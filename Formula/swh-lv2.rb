class SwhLv2 < Formula
  desc "SWH Plugins in LV2 format"
  homepage "http://plugin.org.uk/"
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
