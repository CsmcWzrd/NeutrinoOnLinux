# Split verification — 25 October 2026

Baseline: Neutrino_Stage2_23_Tabbar_Positions_Fixed.zip (retrieved from the existing Neutrino Project files).

Scope: independent package and build-system separation. Platform conditionals
were resolved to their existing branches. Public API names, signatures, include
path, namespace, implementation logic and visual assets are preserved. Original
license notice and release history are included. Existing platform differences
and pre-existing limitations are retained.

Checks for NeutrinoOnLinux:

- Compiler-preprocessed baseline/split comparison passed for all 55
  implementation and example translation units, including their public header.
  Nonempty preprocessed lines are identical; blank lines are ignored.
- Every copied theme/icon asset is byte-for-byte identical to the baseline.
- Every source/header checksum matches SOURCE_PROVENANCE.json.
- Linux GNU make: static library and all 29 demos built successfully.
- Linux CMake Release: static library and all 29 demos built successfully.
- Autoconf/Automake regeneration, out-of-tree configure/build and make distcheck
  passed, including staged install/uninstall and source-distribution rebuild.
- CMake install plus an independent find_package(NeutrinoOnLinux) consumer
  compiled, linked and ran successfully.
- All 29 X11 demos created windows and exited with code 0 after a
  WM_DELETE_WINDOW request under Xvfb. This is a launch/close smoke check,
  not visual or exhaustive interaction qualification.
- macOS/XQuartz and other Unix hosts were not available for native validation.
  Their build paths use the preserved X11 implementation. No native Cocoa or
  native Wayland renderer was introduced.
