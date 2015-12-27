class MverbLv2 < Formula
  desc "LV2 port of studio quality, open-source reverb"
  head "git://git.code.sf.net/p/mverb/code"

  depends_on "lv2"

  def install
    cd "Lv2Plug" do
      inreplace "makefile", "-shared", "-dynamic -dylib -lm"

      system "make"
      system "make", "install", "INSTALL_DIR=#{lib}/lv2"
    end
  end

end
