class Aether < Formula
  desc "Algorithmic reverb linux LV2 plugin based on Cloudseed"
  homepage "https://dougal-s.github.io/Aether/"
  license "MIT"
  head "https://github.com/Dougal-s/Aether.git", branch: "MacOS"

  depends_on "cmake" => :build
  depends_on "make" => :build
  depends_on "lv2"

  on_linux do
    depends_on "mesa-glu"
  end

  def install
    ENV.append "CXXFLAGS", "-g"
    mkdir "build"
    chdir "build" do
      system "cmake", '-DCMAKE_BUILD_TYPE="Debug"', "-S", "..", "-B", ".", *std_cmake_args
      system "make"
    end
    (lib / "lv2").install "aether.lv2"
  end

  test do
    assert_match "_lv2_descriptor", shell_output("nm  #{lib}/lv2/aether.lv2/aether_dsp.so")
  end
end
