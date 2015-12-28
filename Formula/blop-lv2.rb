class BlopLv2 < Formula
  desc "LV2 port of the BLOP LADSPA plugins by Mike Rawes"
  homepage "http://drobilla.net/software/blop-lv2/"
  url "http://download.drobilla.net/blop-lv2-1.0.0.tar.bz2"
  sha256 "f327eb62bfe88da335f109f28d0f8e2cd07000c548114bda41b477b0e9b23329"

  depends_on "pkg-config" => :build
  depends_on "lv2"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/blop.lv2/triangle.dylib")
  end
end
