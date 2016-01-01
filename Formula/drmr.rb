class Drmr < Formula
  desc "LV2 sampler plugin that (currently) plays hydrogen drum kits"
  homepage "https://github.com/nicklan/drmr"
  head "https://github.com/nicklan/drmr.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "libsndfile"
  depends_on "libsamplerate"
  depends_on "gtk+"

  def install
    inreplace "CMakeLists.txt", "-znodelete", ""
    inreplace "drmr.ttl", ".so", ".dylib"

    # add search path for Hydrogen on OS/X https://github.com/nicklan/drmr/pull/14
    inreplace "drmr_hydrogen.c",  '"~/.hydrogen/data/drumkits/",', '"~/.hydrogen/data/drumkits/", "~/Library/Application Support/Hydrogen/drumkits", '

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/drmr.lv2/drmr.dylib")
  end
end
