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

  patch do
    url "https://github.com/david0/drmr/commit/b83aa5b7f1666056adccd3e2e58b49b0ef2b7bf8.patch"
  end

  def install
    inreplace "CMakeLists.txt", "-znodelete", ""
    inreplace "drmr.ttl", ".so", ".dylib"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/drmr.lv2/drmr.dylib")
  end
end
