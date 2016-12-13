class X42Plugins < Formula
  desc "collection of LV2 audio plugins"
  homepage "http://x42-plugins.com"
  sha256 "551b5f9ff025796e870536754a1a98cf5a94a15458ec519aee89aebf547e00d7"
  head "https://github.com/x42/x42-plugins.git"

  depends_on "pkg-config" => :build
  depends_on "libsndfile"
  depends_on "libltc"
  depends_on "glib"
  depends_on "cairo"
  depends_on "pango"
  depends_on "jack"
  depends_on "coreutils" => :build
  depends_on "libsamplerate"
  depends_on "zita-convolver"
  depends_on "lv2"
  depends_on "ftgl" => :optional
  depends_on "gtk+" => :optional
  depends_on "fftw"

  def install
    # https://github.com/x42/tuna.lv2/issues/3
    ENV.prepend "PATH", Formula["coreutils"].libexec/"gnubin" + ":"
    ENV.append_to_cflags "-I" + Formula["zita-convolver"].include
    ENV.append_to_cflags "-L" + Formula["zita-convolver"].lib
    ENV.append_to_cflags "-I" + Formula["fftw"].include
    ENV.append_to_cflags "-L" + Formula["fftw"].lib
    ENV.append_to_cflags "-I" + Formula["cairo"].include
    ENV.append_to_cflags "-L" + Formula["cairo"].lib


    if build.head?
      system "git", "submodule", "foreach", "git", "pull", "origin", "master"
    end

    # TODO: remove SUBDIRS but meters.lv2 is not yet building
    system "make", "install", "PREFIX=#{prefix}", "SUBDIRS=balance.lv2 convoLV2 nodelay.lv2 xfade.lv2 midifilter.lv2  sisco.lv2 tuna.lv2 onsettrigger.lv2 mixtri.lv2 fil4.lv2 fat1.lv2 stepseq.lv2 midigen.lv2 testsignal.lv2 midimap.lv2 controlfilter.lv2"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/convo.lv2/convoLV2.dylib")
  end
end
