class Infamousplugins < Formula
  desc "audio plugins in the LV2 format"
  homepage "https://ssj71.github.io/infamousPlugins"
  url 'https://github.com/ssj71/infamousPlugins/archive/v0.3.0.tar.gz'
  sha256 'ba63cac87891a7b9c49f62fe7e73e452a01b7f84124e2e1d6b87d45d97cf0e1d'
  head "https://github.com/ssj71/infamousPlugins.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "zita-resampler"
  depends_on "fftw"

  patch :p1, :DATA

  def install
    Pathname.glob("#{buildpath}/src/*/manifest.ttl") do |file|
      inreplace file, /\.so\b/, ".dylib"
    end

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm #{lib}/lv2/powercut.lv2/powercut.dylib")
  end
end
__END__
diff --git a/src/rule.c b/src/rule.c
index 05bb1d8..c5de317 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -43,7 +43,7 @@ void useage()
     return;
 }
 
-int main(int argc, int8_t **argv)
+int main(int argc, char **argv)
 {
     uint8_t rule=0xD0;//0x7c;
     uint8_t t;
