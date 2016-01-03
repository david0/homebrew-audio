class Artyfx < Formula
  desc "plugin bundle of artistic real-time audio effects"
  homepage "http://openavproductions.com/artyfx/"
  head "https://github.com/harryhaaren/openAV-ArtyFX.git"
  # release-1.2 does not support HAVE_NTK

  depends_on "lv2"
  depends_on "libsndfile"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    inreplace "CMakeLists.txt", "-shared -Wl,-z,nodelete -Wl,--no-undefined", "-dynamiclib"
    inreplace "artyfx.lv2/manifest.ttl", /\.so\b/, ".dylib"
    system "cmake", ".", "-DHAVE_NTK=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/artyfx.lv2/artyfx.dylib")
  end
end
