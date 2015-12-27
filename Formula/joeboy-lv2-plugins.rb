class JoeboyLv2Plugins < Formula
  desc "assortment of LV2 plugins"
  homepage "https://github.com/Joeboy/joeboy-lv2-plugins"
  head "https://github.com/Joeboy/joeboy-lv2-plugins.git"

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "lv2"
  depends_on "fluid-synth"
  depends_on "aubio"

  patch do
    #  Fix segfault when restoring fluidsynth settings
    url "https://github.com/david0/joeboy-lv2-plugins/commit/289940bc06eec2a5afe1f833b17898b81ac1e6d6.patch"
    sha256 "b7ce935a182a254a505869a516c9c8dc6f5b73100a864be0d716ee651f128d86"
  end

  patch do
    # add targets install and uninstall to amp_with_gui
    url "https://github.com/david0/joeboy-lv2-plugins/commit/6f1a0d71daf8da5c05b75ecdc55687f4059f29e7.patch"
    sha256 "05739e73ee0d9c0c39fdc0dcf6528d8b5f0f01eef5974a90bbe7670f93d2c4b2"
  end

  def install
    inreplace "fluidsynth/Makefile", "lv2-plugin", "lv2"

    ["fluidsynth", "pitchdetect", "shimmer", "amp_with_gui"].each do |plugin| # "visual_compressor" needs lv2-c++-tools
      cd "#{buildpath}/#{plugin}" do
        system "make", "install", "INSTALL_DIR=#{lib}/lv2"
      end
    end
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/fluidsynth.lv2/fluidsynth.so")
  end
end
