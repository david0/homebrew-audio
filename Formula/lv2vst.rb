class Lv2vst < Formula
  desc "Experimental LV2 to VST2.x wrapper"
  homepage "https://github.com/x42/lv2vst"
  head "https://github.com/x42/lv2vst.git"

  depends_on "make" => :build

  def install
    ENV.deparallelize

    inreplace "Makefile", "$(VSTNAME).x86_64.dylib $(VSTNAME).i386.dylib", "$(VSTNAME).x86_64.dylib"
    inreplace "./include/lilv_config.h", 'LILV_DEFAULT_LV2_PATH "', 'LILV_DEFAULT_LV2_PATH "/usr/local/lib/lv2:'
    system "make", "STRIP=", "osxbundle"
    mkdir_p "#{lib}/vst/"
    lib.install "lv2.vst" => "#{lib}/vst/lv2.vst"
  end

  test do
    assert_match /_VSTPluginMain/, shell_output("nm  #{lib}/vst/lv2.vst/Contents/MacOS/lv2vst")
  end
end

