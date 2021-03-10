class BlopLv2 < Formula
  desc "LV2 port of the BLOP LADSPA plugins by Mike Rawes"
  homepage "http://drobilla.net/software/blop-lv2/"
  url "http://download.drobilla.net/blop-lv2-1.0.2.tar.bz2"
  sha256 '3e0c31ad19e144cc3e81ddb92f713062215ce7ab8382535a397d2396d7cff819'

  depends_on "pkg-config" => :build
  depends_on "lv2"

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{lib}/lv2"
    system "./waf", "install"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/blop.lv2/triangle.dylib")
  end
end
