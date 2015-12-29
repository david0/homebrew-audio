class FompLv2 < Formula
  desc "LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen"
  homepage "http://drobilla.net/software/fomp/"
  url "http://download.drobilla.net/fomp-1.0.0.tar.bz2"
  sha256 "65a22508ed910601eb9938e9ea73c7eb5ce496a1308a70791c165b6527ec02c2"
  head "http://svn.drobilla.net/lad/trunk/plugins/fomp.lv2"

  depends_on "lv2"
  depends_on "pkg-config" => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/fomp.lv2/cs_chorus.dylib")
  end
end
