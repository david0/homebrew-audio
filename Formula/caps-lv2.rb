class CapsLv2 < Formula
  desc "LV2 port for the CAPS Audio Plugin Suit"
  homepage "https://github.com/moddevices/caps-lv2"
  head "https://github.com/moddevices/caps-lv2.git"

  depends_on "lv2"

  def install

    # WA for https://github.com/moddevices/caps-lv2/issues/30
    ['dsp/v4f.h', 'dsp/v4f_IIR2.h'].each do |header| 
      inreplace header, '__builtin_cosf', 'cosf'
      inreplace header, '__builtin_sinf', 'sinf'
    end

    system 'make', 'all', 'install', "PREFIX=#{prefix}", 'MACOS=1'
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/mod-caps-Scape.lv2/Scape.so")
  end
end
