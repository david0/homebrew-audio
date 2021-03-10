class Jalv < Formula
  desc "simple but fully featured LV2 host for Jack"
  homepage "http://drobilla.net/software/jalv/"
  head "http://git.drobilla.net/jalv.git"

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "jack"
  depends_on "lilv"
  depends_on "serd"
  depends_on "sord"
  depends_on "suil"
  depends_on "sratom"
  depends_on "gtk+"
  depends_on "gtk+3" => :optional
  depends_on "qt5"

  # Workaround: Deadlock on program start, disable semaphores
  patch :p1, :DATA

  def install
    ENV.cxx11
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/jalv -h 2>&1", 1)
  end
end
__END__
diff --git a/src/jalv.c b/src/jalv.c
index e445c64..4c825f6 100644
--- a/src/jalv.c
+++ b/src/jalv.c
@@ -104,9 +104,9 @@ map_uri(LV2_URID_Map_Handle handle,
         const char*         uri)
 {
 	Jalv* jalv = (Jalv*)handle;
-	zix_sem_wait(&jalv->symap_lock);
+	//zix_sem_wait(&jalv->symap_lock);
 	const LV2_URID id = symap_map(jalv->symap, uri);
-	zix_sem_post(&jalv->symap_lock);
+	//zix_sem_post(&jalv->symap_lock);
 	return id;
 }
 
