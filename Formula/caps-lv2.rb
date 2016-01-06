class CapsLv2 < Formula
  desc "LV2 port for the CAPS Audio Plugin Suit"
  homepage "https://github.com/moddevices/caps-lv2"
  head "https://github.com/moddevices/caps-lv2.git"

  depends_on "lv2"

  # remove unsupported linker options: --no-undefined, --strip-all
  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/mod-caps-Scape.lv2/Scape.so")
  end
end
__END__
diff --git a/plugins/mod-caps-AmpVTS.lv2/Makefile b/plugins/mod-caps-AmpVTS.lv2/Makefile
index 4341637..0433dc2 100644
--- a/plugins/mod-caps-AmpVTS.lv2/Makefile
+++ b/plugins/mod-caps-AmpVTS.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Amp.cc ../../ToneStack.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-AutoFilter.lv2/Makefile b/plugins/mod-caps-AutoFilter.lv2/Makefile
index f76d778..ee6d569 100644
--- a/plugins/mod-caps-AutoFilter.lv2/Makefile
+++ b/plugins/mod-caps-AutoFilter.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../AutoFilter.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-CEO.lv2/Makefile b/plugins/mod-caps-CEO.lv2/Makefile
index 3e578fb..ba312e3 100644
--- a/plugins/mod-caps-CEO.lv2/Makefile
+++ b/plugins/mod-caps-CEO.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Click.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-CabinetIII.lv2/Makefile b/plugins/mod-caps-CabinetIII.lv2/Makefile
index 4cae8da..6aea249 100644
--- a/plugins/mod-caps-CabinetIII.lv2/Makefile
+++ b/plugins/mod-caps-CabinetIII.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../CabIII.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-CabinetIV.lv2/Makefile b/plugins/mod-caps-CabinetIV.lv2/Makefile
index 696fd63..a00d868 100644
--- a/plugins/mod-caps-CabinetIV.lv2/Makefile
+++ b/plugins/mod-caps-CabinetIV.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../CabIV.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-ChorusI.lv2/Makefile b/plugins/mod-caps-ChorusI.lv2/Makefile
index ff61ee5..d6bb882 100644
--- a/plugins/mod-caps-ChorusI.lv2/Makefile
+++ b/plugins/mod-caps-ChorusI.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Chorus.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Click.lv2/Makefile b/plugins/mod-caps-Click.lv2/Makefile
index 09fca5e..7594818 100644
--- a/plugins/mod-caps-Click.lv2/Makefile
+++ b/plugins/mod-caps-Click.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Click.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Compress.lv2/Makefile b/plugins/mod-caps-Compress.lv2/Makefile
index 63d2eb1..e1f8ec4 100644
--- a/plugins/mod-caps-Compress.lv2/Makefile
+++ b/plugins/mod-caps-Compress.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Compress.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-CompressX2.lv2/Makefile b/plugins/mod-caps-CompressX2.lv2/Makefile
index ffe80ae..865649a 100644
--- a/plugins/mod-caps-CompressX2.lv2/Makefile
+++ b/plugins/mod-caps-CompressX2.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Compress.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Eq10.lv2/Makefile b/plugins/mod-caps-Eq10.lv2/Makefile
index a6c8f70..4bb2cbd 100644
--- a/plugins/mod-caps-Eq10.lv2/Makefile
+++ b/plugins/mod-caps-Eq10.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Eq.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Eq10X2.lv2/Makefile b/plugins/mod-caps-Eq10X2.lv2/Makefile
index bd9a50a..5f90d4e 100644
--- a/plugins/mod-caps-Eq10X2.lv2/Makefile
+++ b/plugins/mod-caps-Eq10X2.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Eq.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Eq4p.lv2/Makefile b/plugins/mod-caps-Eq4p.lv2/Makefile
index 930ae9b..bb5532e 100644
--- a/plugins/mod-caps-Eq4p.lv2/Makefile
+++ b/plugins/mod-caps-Eq4p.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Eq.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-EqFA4p.lv2/Makefile b/plugins/mod-caps-EqFA4p.lv2/Makefile
index 788c213..25e553c 100644
--- a/plugins/mod-caps-EqFA4p.lv2/Makefile
+++ b/plugins/mod-caps-EqFA4p.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Eq.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Fractal.lv2/Makefile b/plugins/mod-caps-Fractal.lv2/Makefile
index 39a00ac..032f708 100644
--- a/plugins/mod-caps-Fractal.lv2/Makefile
+++ b/plugins/mod-caps-Fractal.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Fractals.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Narrower.lv2/Makefile b/plugins/mod-caps-Narrower.lv2/Makefile
index a46e15b..127bd57 100644
--- a/plugins/mod-caps-Narrower.lv2/Makefile
+++ b/plugins/mod-caps-Narrower.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Pan.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Noisegate.lv2/Makefile b/plugins/mod-caps-Noisegate.lv2/Makefile
index a07c456..9fc6a0a 100644
--- a/plugins/mod-caps-Noisegate.lv2/Makefile
+++ b/plugins/mod-caps-Noisegate.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Noisegate.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-PhaserII.lv2/Makefile b/plugins/mod-caps-PhaserII.lv2/Makefile
index 45c9c64..7e91175 100644
--- a/plugins/mod-caps-PhaserII.lv2/Makefile
+++ b/plugins/mod-caps-PhaserII.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Phaser.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Plate.lv2/Makefile b/plugins/mod-caps-Plate.lv2/Makefile
index ddfc50e..77bf2bd 100644
--- a/plugins/mod-caps-Plate.lv2/Makefile
+++ b/plugins/mod-caps-Plate.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Reverb.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-PlateX2.lv2/Makefile b/plugins/mod-caps-PlateX2.lv2/Makefile
index f1d6f71..1e8cfc6 100644
--- a/plugins/mod-caps-PlateX2.lv2/Makefile
+++ b/plugins/mod-caps-PlateX2.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Reverb.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Saturate.lv2/Makefile b/plugins/mod-caps-Saturate.lv2/Makefile
index 4491443..12d4e05 100644
--- a/plugins/mod-caps-Saturate.lv2/Makefile
+++ b/plugins/mod-caps-Saturate.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Saturate.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Scape.lv2/Makefile b/plugins/mod-caps-Scape.lv2/Makefile
index a659302..f20ad29 100644
--- a/plugins/mod-caps-Scape.lv2/Makefile
+++ b/plugins/mod-caps-Scape.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Scape.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Sin.lv2/Makefile b/plugins/mod-caps-Sin.lv2/Makefile
index d6e3a8c..f9ddfb9 100644
--- a/plugins/mod-caps-Sin.lv2/Makefile
+++ b/plugins/mod-caps-Sin.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Sin.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Spice.lv2/Makefile b/plugins/mod-caps-Spice.lv2/Makefile
index 85bdc59..6c7ccf2 100644
--- a/plugins/mod-caps-Spice.lv2/Makefile
+++ b/plugins/mod-caps-Spice.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Saturate.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-SpiceX2.lv2/Makefile b/plugins/mod-caps-SpiceX2.lv2/Makefile
index 0a67989..aa2d881 100644
--- a/plugins/mod-caps-SpiceX2.lv2/Makefile
+++ b/plugins/mod-caps-SpiceX2.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Saturate.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-ToneStack.lv2/Makefile b/plugins/mod-caps-ToneStack.lv2/Makefile
index dfde69f..59facba 100644
--- a/plugins/mod-caps-ToneStack.lv2/Makefile
+++ b/plugins/mod-caps-ToneStack.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../ToneStack.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-White.lv2/Makefile b/plugins/mod-caps-White.lv2/Makefile
index a4634e7..0c9d2bf 100644
--- a/plugins/mod-caps-White.lv2/Makefile
+++ b/plugins/mod-caps-White.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../White.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
diff --git a/plugins/mod-caps-Wider.lv2/Makefile b/plugins/mod-caps-Wider.lv2/Makefile
index 991f4f6..016ac24 100644
--- a/plugins/mod-caps-Wider.lv2/Makefile
+++ b/plugins/mod-caps-Wider.lv2/Makefile
@@ -11,11 +11,11 @@ OPTS = -g -DDEBUG
 else
 # OPTS = -O2 -Wall -fPIC -DPIC
 OPTS = -O3 -ffast-math -funroll-loops -Wall -fPIC -DPIC
-LDFLAGS += -Wl,--strip-all
+LDFLAGS += 
 endif
 
 CXXFLAGS += $(OPTS) -I../..
-LDFLAGS += -shared -Wl,--no-undefined
+LDFLAGS += -shared 
 
 SOURCES = ../../Pan.cc ../../dsp/polynomials.cc interface.cc
 OBJECTS = $(SOURCES:.cc=.o)
