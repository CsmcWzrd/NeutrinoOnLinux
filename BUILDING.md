# Building NeutrinoOnLinux

Requires C++17 and X11 development headers/libraries. Optional Xft uses pkg-config.
The original renderer remains X11 on every supported Unix-like OS. Wayland
preference/probing remains unchanged and still requires X11/XWayland for drawing;
this split does not create a native Wayland or Cocoa backend.

Linux: install the distribution's compiler, make, CMake, X11 development package,
and optionally Xft/pkg-config. Unix/BSD: use their X11 packages and GNU make
(often `gmake`). macOS: install the command-line developer tools, CMake and XQuartz;
XQuartz must be running when a demo launches. `/opt/X11` is detected by CMake and
the makefile; set PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig when needed. Preserve a
valid DISPLAY for X11. Native macOS/other-Unix execution remains unverified here.

CMake:

```sh
cmake -S . -B build-cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build-cmake --parallel
cmake --install build-cmake --prefix /your/install/prefix
```

GNU make:

```sh
make -j2
make install PREFIX=/your/install/prefix
```

`Makefile.linux`, `Makefile.unix`, `Makefile.macos` include the same standalone
makefile: `gmake -f Makefile.unix` or `make -f Makefile.macos`. Run from this root.
Use `WITH_XFT=0 WITH_WAYLAND=0` to disable optional build features, or
`NEUTRINO_USE_X11=1` to retain the original force-X11 preference. Change feature
flags in a fresh BUILD_DIR. Override X11_CFLAGS, X11_LIBS and DL_LIBS for a custom
Unix installation. make install supports DESTDIR staging.

Autoconf + Automake (real generated GNU build system):

```sh
./autogen.sh
mkdir build-autotools
cd build-autotools
../configure --prefix=/your/install/prefix
make -j2
make install
```

Requires autoconf, automake, an archiver and ranlib to regenerate. Generated
configure/Makefile.in and helper files are included if generation was available
when this release was packaged. For a source tree with configure present, skip
./autogen.sh. Use `--disable-xft`, `--disable-wayland`, `--x-includes=...`,
`--x-libraries=...`, CPPFLAGS and LDFLAGS as needed. Build out of tree so configure
does not overwrite the hand-written root Makefile. `make distcheck` checks
Automake's source-distribution and staged-install workflow.

All three routes build the same 26 implementation sources and all 29 original
portable demos. The original target/library name `Neutrino` is preserved for
consumer compatibility. CMake installs `NeutrinoOnLinuxConfig.cmake`; use
`find_package(NeutrinoOnLinux CONFIG REQUIRED)` then `Neutrino::Neutrino`.
Use `-DNEUTRINO_BUILD_EXAMPLES=OFF` for a CMake library-only build.

Run demos with this package root as the working directory for the original
relative asset paths. Installed demos use share/NeutrinoOnLinux as their working
directory. No rendering, event, asset lookup or public API changes were made.
