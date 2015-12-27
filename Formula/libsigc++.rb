class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "http://libsigc.sourceforge.net"
  url "https://download.gnome.org/sources/libsigc++/2.6/libsigc++-2.6.2.tar.xz"
  sha256 "fdace7134c31de792c17570f9049ca0657909b28c4c70ec4882f91a03de54437"

  needs :cxx11

  depends_on "mm-common" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  patch do
    # nil is a keyword in Objective-C++
    # https://bugzilla.gnome.org/show_bug.cgi?id=695235
    url "https://git.gnome.org/browse/libsigc++2/patch/?id=75466ce1e1d92fe04926f72567417912779cc5c1"
    sha256 "42966b4e84096fc091ae08cffc733d252cadab719405270d1170be3a60ac7cba"
  end

  patch do
    # can_deduce_result_type_with_decltype: Rename the check() methods
    # https://bugzilla.gnome.org/show_bug.cgi?id=759315
    url "https://git.gnome.org/browse/libsigc++2/patch/?id=9bd7f99838f1fb0f67fe5a66155dc13d075041df"
    sha256 "50d01a41aed4e1a7a0d1f895b26e7cb613e17eddb1d2eb9bc32ca75ee13799e9"
  end

  def install
    ENV.cxx11

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <sigc++/sigc++.h>

      void somefunction(int arg) {}

      int main(int argc, char *argv[])
      {
         sigc::slot<void, int> sl = sigc::ptr_fun(&somefunction);
         return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                   "-L#{lib}", "-lsigc-2.0", "-I#{include}/sigc++-2.0", "-I#{lib}/sigc++-2.0/include", "-o", "test"
    system "./test"
  end
end
__END__
--- a/build/cxx.m4	
+++ a/build/cxx.m4	
@@ -117,3 +117,55 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM(
 ])
 AC_MSG_RESULT([$sigcm_cxx_self_reference_in_member_initialization])
 ])
+
+dnl
+dnl SIGC_CXX_PRAGMA_PUSH_POP_MACRO
+dnl
+dnl TODO: When we can break ABI, delete this. It's used when nil is
+dnl temporarily undefined. See comment in functor_trait.h.
+dnl
+AC_DEFUN([SIGC_CXX_PRAGMA_PUSH_POP_MACRO],[
+AC_MSG_CHECKING([if C++ preprocessor supports pragma push_macro() and pop_macro().])
+AC_COMPILE_IFELSE([AC_LANG_PROGRAM(
+[[
+  #define BEGIN {
+  #define END   }
+  #pragma push_macro("BEGIN")
+  #pragma push_macro("END")
+  #undef BEGIN
+  #undef END
+
+  // BEGIN and END are not prepreprocessor macros
+  struct Test1
+  {
+    int BEGIN;
+    double END;
+  };
+
+  #pragma pop_macro("BEGIN")
+  #pragma pop_macro("END")
+
+  // BEGIN and END are prepreprocessor macros
+  struct Test2
+  BEGIN
+    int i;
+    double d;
+  END;
+
+  void func1(Test1& x);
+  void func2(Test2& x);
+]],
+[[
+  Test1 test1;
+  Test2 test2;
+  func1(test1);
+  func2(test2);
+]])],
+[
+  sigcm_cxx_pragma_push_pop_macro=yes
+  AC_DEFINE([SIGC_PRAGMA_PUSH_POP_MACRO],[1],[does the C++ preprocessor support pragma push_macro() and pop_macro().])
+],[
+  sigcm_cxx_pragma_push_pop_macro=no
+])
+AC_MSG_RESULT([$sigcm_cxx_pragma_push_pop_macro])
+])
--- a/configure.ac	
+++ a/configure.ac	
@@ -53,6 +53,7 @@ AC_LANG([C++])
 SIGC_CXX_GCC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
 SIGC_CXX_MSVC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
 SIGC_CXX_SELF_REFERENCE_IN_MEMBER_INITIALIZATION
+SIGC_CXX_PRAGMA_PUSH_POP_MACRO
 SIGC_CXX_HAS_NAMESPACE_STD
 SIGC_CXX_HAS_SUN_REVERSE_ITERATOR
 
--- a/sigc++/adaptors/macros/bind.h.m4	
+++ a/sigc++/adaptors/macros/bind.h.m4	
@@ -235,6 +235,13 @@ _FIREWALL([ADAPTORS_BIND])
 #include <sigc++/adaptors/adaptor_trait.h>
 #include <sigc++/adaptors/bound_argument.h>
 
+//TODO: See comment in functor_trait.h.
+#if defined(nil) && defined(SIGC_PRAGMA_PUSH_POP_MACRO)
+  #define SIGC_NIL_HAS_BEEN_PUSHED 1
+  #pragma push_macro("nil")
+  #undef nil
+#endif
+
 namespace sigc {
 
 #ifndef DOXYGEN_SHOULD_SKIP_THIS
@@ -403,3 +410,8 @@ bind(const T_functor& _A_func, T_bound1 _A_b1)
 FOR(1,CALL_SIZE,[[BIND_COUNT(%1)]])dnl
 
 } /* namespace sigc */
+
+#ifdef SIGC_NIL_HAS_BEEN_PUSHED
+  #undef SIGC_NIL_HAS_BEEN_PUSHED
+  #pragma pop_macro("nil")
+#endif
--- a/sigc++/adaptors/macros/retype.h.m4	
+++ a/sigc++/adaptors/macros/retype.h.m4	
@@ -81,6 +81,13 @@ _FIREWALL([ADAPTORS_RETYPE])
 #include <sigc++/functors/mem_fun.h>
 #include <sigc++/functors/slot.h>
 
+//TODO: See comment in functor_trait.h.
+#if defined(nil) && defined(SIGC_PRAGMA_PUSH_POP_MACRO)
+  #define SIGC_NIL_HAS_BEEN_PUSHED 1
+  #pragma push_macro("nil")
+  #undef nil
+#endif
+
 namespace sigc {
 
 /** @defgroup retype retype(), retype_return()
@@ -208,3 +215,8 @@ FOR(0,CALL_SIZE,[[RETYPE_MEM_FUNCTOR(%1,[bound_volatile_])]])dnl
 FOR(0,CALL_SIZE,[[RETYPE_MEM_FUNCTOR(%1,[bound_const_volatile_])]])dnl
 
 } /* namespace sigc */
+
+#ifdef SIGC_NIL_HAS_BEEN_PUSHED
+  #undef SIGC_NIL_HAS_BEEN_PUSHED
+  #pragma pop_macro("nil")
+#endif
--- a/sigc++/functors/macros/functor_trait.h.m4	
+++ a/sigc++/functors/macros/functor_trait.h.m4	
@@ -52,6 +52,16 @@ _FIREWALL([FUNCTORS_FUNCTOR_TRAIT])
 
 namespace sigc {
 
+//TODO: When we can break ABI, replace nil by something else, such as sigc_nil.
+// nil is a keyword in Objective C++. When gcc is used for compiling Objective C++
+// programs, nil is defined as a preprocessor macro.
+// https://bugzilla.gnome.org/show_bug.cgi?id=695235
+#if defined(nil) && defined(SIGC_PRAGMA_PUSH_POP_MACRO)
+  #define SIGC_NIL_HAS_BEEN_PUSHED 1
+  #pragma push_macro("nil")
+  #undef nil
+#endif
+
 /** nil struct type.
  * The nil struct type is used as default template argument in the
  * unnumbered sigc::signal and sigc::slot templates.
@@ -65,6 +75,11 @@ struct nil;
 struct nil {};
 #endif
 
+#ifdef SIGC_NIL_HAS_BEEN_PUSHED
+  #undef SIGC_NIL_HAS_BEEN_PUSHED
+  #pragma pop_macro("nil")
+#endif
+
 /** @defgroup sigcfunctors Functors
  * Functors are copyable types that define operator()().
  *
--- a/sigc++/functors/macros/slot.h.m4	
+++ a/sigc++/functors/macros/slot.h.m4	
@@ -355,6 +355,13 @@ _FIREWALL([FUNCTORS_SLOT])
 #include <sigc++/adaptors/adaptor_trait.h>
 #include <sigc++/functors/slot_base.h>
 
+//TODO: See comment in functor_trait.h.
+#if defined(nil) && defined(SIGC_PRAGMA_PUSH_POP_MACRO)
+  #define SIGC_NIL_HAS_BEEN_PUSHED 1
+  #pragma push_macro("nil")
+  #undef nil
+#endif
+
 namespace sigc {
 
 namespace internal {
@@ -441,3 +448,8 @@ SLOT(CALL_SIZE,CALL_SIZE)
 FOR(0,eval(CALL_SIZE-1),[[SLOT(%1,CALL_SIZE)]])
 
 } /* namespace sigc */
+
+#ifdef SIGC_NIL_HAS_BEEN_PUSHED
+  #undef SIGC_NIL_HAS_BEEN_PUSHED
+  #pragma pop_macro("nil")
+#endif
--- a/sigc++/macros/signal.h.m4	
+++ a/sigc++/macros/signal.h.m4	
@@ -568,6 +568,13 @@ divert(0)
 #include <sigc++/functors/slot.h>
 #include <sigc++/functors/mem_fun.h>
 
+//TODO: See comment in functor_trait.h.
+#if defined(nil) && defined(SIGC_PRAGMA_PUSH_POP_MACRO)
+  #define SIGC_NIL_HAS_BEEN_PUSHED 1
+  #pragma push_macro("nil")
+  #undef nil
+#endif
+
 //SIGC_TYPEDEF_REDEFINE_ALLOWED:
 // TODO: This should have its own test, but I can not create one that gives the error instead of just a warning. murrayc.
 // I have just used this because there is a correlation between these two problems.
@@ -1155,4 +1162,9 @@ FOR(0,eval(CALL_SIZE-1),[[SIGNAL(%1)]])
 
 } /* namespace sigc */
 
+#ifdef SIGC_NIL_HAS_BEEN_PUSHED
+  #undef SIGC_NIL_HAS_BEEN_PUSHED
+  #pragma pop_macro("nil")
+#endif
+
 #endif /* _SIGC_SIGNAL_H_ */
--- a/sigc++config.h.in	
+++ a/sigc++config.h.in	
@@ -47,6 +47,7 @@ 
 # define SIGC_MSVC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD 1
 # define SIGC_NEW_DELETE_IN_LIBRARY_ONLY 1 /* To keep ABI compatibility */
 # define SIGC_HAVE_NAMESPACE_STD 1
+# define SIGC_PRAGMA_PUSH_POP_MACRO 1
 
 #if (_MSC_VER < 1900) && !defined (noexcept)
 #define _ALLOW_KEYWORD_MACROS 1
@@ -73,6 +74,9 @@ 
    static member field. */
 # undef SIGC_SELF_REFERENCE_IN_MEMBER_INITIALIZATION
 
+/* does the C++ preprocessor support pragma push_macro() and pop_macro(). */
+# undef SIGC_PRAGMA_PUSH_POP_MACRO
+
 #endif /* !SIGC_MSC */
 
 #ifdef SIGC_HAVE_NAMESPACE_STD
