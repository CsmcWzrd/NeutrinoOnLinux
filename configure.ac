AC_INIT([NeutrinoOnLinux], [0.3.0])
AC_CONFIG_SRCDIR([src/Neu_Application.cpp])
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE([foreign subdir-objects])
AC_CANONICAL_HOST
AS_CASE([$host_os], [mingw*|cygwin*|msys*], [AC_MSG_ERROR([use the separate Neutrino Windows package])])
AC_PROG_CXX
AM_PROG_AR
AC_PROG_RANLIB
AC_LANG([C++])
CXXFLAGS="$CXXFLAGS -std=c++17"
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <optional>]], [[std::optional<int> n=1; return *n;]])], [], [AC_MSG_ERROR([C++17 is required])])
# XQuartz uses /opt/X11; AC_PATH_XTRA also honors --x-includes/--x-libraries.
AS_IF([test "x$host_os" != x && test -d /opt/X11/include], [CPPFLAGS="$CPPFLAGS -I/opt/X11/include"; LDFLAGS="$LDFLAGS -L/opt/X11/lib"])
AC_PATH_XTRA
CPPFLAGS="$CPPFLAGS $X_CFLAGS"
AS_IF([test "x$no_x" = xyes], [AC_MSG_ERROR([X11 development headers/libraries are required (XQuartz on macOS)])])
saved_LIBS="$LIBS"
LIBS="$X_LIBS $X_PRE_LIBS -lX11 $X_EXTRA_LIBS $LIBS"
AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <X11/Xlib.h>]], [[XOpenDisplay(nullptr);]])], [], [AC_MSG_ERROR([cannot link X11])])
LIBS="$saved_LIBS"
X11_LIBS="$X_LIBS $X_PRE_LIBS -lX11 $X_EXTRA_LIBS"
AC_SUBST([X11_LIBS])
AC_SEARCH_LIBS([dlopen], [dl], [], [AC_MSG_ERROR([dlopen is required])])
AC_PATH_TOOL([PKG_CONFIG], [pkg-config], [:])
AC_ARG_ENABLE([xft], [AS_HELP_STRING([--disable-xft], [disable optional Xft support])], [], [enable_xft=yes])
AC_ARG_ENABLE([wayland], [AS_HELP_STRING([--disable-wayland], [disable optional Wayland metadata])], [], [enable_wayland=yes])
AC_ARG_VAR([NEUTRINO_USE_X11], [set to 1 to force existing X11 preference])
FEATURE_CFLAGS=""
FEATURE_LIBS=""
AS_IF([test "x$enable_xft" = xyes && $PKG_CONFIG --exists xft], [FEATURE_CFLAGS="-DNEUTRINO_USE_XFT `$PKG_CONFIG --cflags xft`"; FEATURE_LIBS="`$PKG_CONFIG --libs xft`"])
AS_IF([test "x$enable_wayland" = xyes && test "x$NEUTRINO_USE_X11" != x1 && $PKG_CONFIG --exists wayland-client], [FEATURE_CFLAGS="$FEATURE_CFLAGS -DNEUTRINO_PREFER_WAYLAND `$PKG_CONFIG --cflags wayland-client`"; FEATURE_LIBS="$FEATURE_LIBS `$PKG_CONFIG --libs wayland-client`"])
AC_SUBST([FEATURE_CFLAGS])
AC_SUBST([FEATURE_LIBS])
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
