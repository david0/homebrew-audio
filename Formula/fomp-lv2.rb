class FompLv2 < Formula
  desc 'LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen'
  homepage 'http://drobilla.net/software/fomp/'
  url 'http://download.drobilla.net/fomp-1.2.2.tar.bz2'
  sha256 'c671a28f27623b707b0634a5af216e1f58ff38f8a8f610986e78aad885e9d96f'
  head 'http://svn.drobilla.net/lad/trunk/plugins/fomp.lv2'

  depends_on 'lv2'
  depends_on 'pkg-config' => :build

  def install
    system './waf', 'configure', "--prefix=#{prefix}", "--lv2dir=#{lib}/lv2"
    system './waf', 'install'
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/fomp.lv2/cs_chorus.dylib")
  end
end
