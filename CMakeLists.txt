cmake_minimum_required(VERSION 3.16)
project(NeutrinoOnLinux VERSION 0.3.0 LANGUAGES CXX)
if(NOT UNIX OR WIN32)
    message(FATAL_ERROR "NeutrinoOnLinux requires Linux, Unix or macOS; use Neutrino on Windows.")
endif()
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
option(NEUTRINO_BUILD_EXAMPLES "Build the existing demonstration applications" ON)
add_library(Neutrino STATIC
    src/Neu_AdditionalControls.cpp
    src/Neu_Application.cpp
    src/Neu_Button.cpp
    src/Neu_Cards.cpp
    src/Neu_ComboBox.cpp
    src/Neu_Control.cpp
    src/Neu_Graphics.cpp
    src/Neu_IconBmp.cpp
    src/Neu_ImageView.cpp
    src/Neu_Label.cpp
    src/Neu_ListView.cpp
    src/Neu_Listbox.cpp
    src/Neu_Multilinetextbox.cpp
    src/Neu_Passwordbox.cpp
    src/Neu_Placement.cpp
    src/Neu_PopWindowMenu.cpp
    src/Neu_ProgressSquare.cpp
    src/Neu_ReadOnlyRichText.cpp
    src/Neu_RichTextCode.cpp
    src/Neu_ScrollBar.cpp
    src/Neu_ScrollWindow.cpp
    src/Neu_Textbox.cpp
    src/Neu_Theme.cpp
    src/Neu_TreeView.cpp
    src/Neu_TypeInterpreter.cpp
    src/Neu_Window.cpp
)
add_library(Neutrino::Neutrino ALIAS Neutrino)
target_compile_features(Neutrino PUBLIC cxx_std_17)
target_include_directories(Neutrino PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
# Keep the original X11 renderer, including on macOS (XQuartz).
if(APPLE)
    list(APPEND CMAKE_PREFIX_PATH /opt/X11)
endif()
find_package(X11 REQUIRED)
find_package(PkgConfig QUIET)
option(NEUTRINO_WITH_XFT "Enable existing optional Xft rendering support" ON)
option(NEUTRINO_WITH_WAYLAND "Retain existing optional Wayland preference metadata" ON)
set(NEUTRINO_HAVE_XFT FALSE)
set(NEUTRINO_HAVE_WAYLAND FALSE)
if(PkgConfig_FOUND)
    if(NEUTRINO_WITH_XFT)
        pkg_check_modules(XFT QUIET IMPORTED_TARGET xft)
        if(XFT_FOUND)
            set(NEUTRINO_HAVE_XFT TRUE)
            target_compile_definitions(Neutrino PUBLIC NEUTRINO_USE_XFT)
            target_link_libraries(Neutrino PUBLIC PkgConfig::XFT)
        endif()
    endif()
    if(NEUTRINO_WITH_WAYLAND AND NOT "$ENV{NEUTRINO_USE_X11}" STREQUAL "1")
        pkg_check_modules(WAYLAND QUIET IMPORTED_TARGET wayland-client)
        if(WAYLAND_FOUND)
            set(NEUTRINO_HAVE_WAYLAND TRUE)
            target_compile_definitions(Neutrino PUBLIC NEUTRINO_PREFER_WAYLAND)
            target_link_libraries(Neutrino PUBLIC PkgConfig::WAYLAND)
        endif()
    endif()
endif()
target_include_directories(Neutrino PUBLIC ${X11_INCLUDE_DIR})
target_link_libraries(Neutrino PUBLIC X11::X11 ${CMAKE_DL_LIBS})
if(NEUTRINO_BUILD_EXAMPLES)
    add_executable(neutrino_demo examples/demo.cpp)
    target_link_libraries(neutrino_demo PRIVATE Neutrino)
    install(TARGETS neutrino_demo RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_all_controls examples/test_all_controls.cpp)
    target_link_libraries(neutrino_test_all_controls PRIVATE Neutrino)
    install(TARGETS neutrino_test_all_controls RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_windows examples/test_windows.cpp)
    target_link_libraries(neutrino_test_windows PRIVATE Neutrino)
    install(TARGETS neutrino_test_windows RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_typed_views examples/test_typed_views.cpp)
    target_link_libraries(neutrino_test_typed_views PRIVATE Neutrino)
    install(TARGETS neutrino_test_typed_views RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_smooth_graphics examples/test_smooth_graphics.cpp)
    target_link_libraries(neutrino_test_smooth_graphics PRIVATE Neutrino)
    install(TARGETS neutrino_test_smooth_graphics RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_treeview_collapse examples/test_treeview_collapse.cpp)
    target_link_libraries(neutrino_test_treeview_collapse PRIVATE Neutrino)
    install(TARGETS neutrino_test_treeview_collapse RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_heavy_data examples/test_heavy_data.cpp)
    target_link_libraries(neutrino_test_heavy_data PRIVATE Neutrino)
    install(TARGETS neutrino_test_heavy_data RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_01_buttons_icons examples/neutrino_test_01_buttons_icons.cpp)
    target_link_libraries(neutrino_test_01_buttons_icons PRIVATE Neutrino)
    install(TARGETS neutrino_test_01_buttons_icons RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_02_text_inputs examples/neutrino_test_02_text_inputs.cpp)
    target_link_libraries(neutrino_test_02_text_inputs PRIVATE Neutrino)
    install(TARGETS neutrino_test_02_text_inputs RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_03_lists_combo_autoscroll examples/neutrino_test_03_lists_combo_autoscroll.cpp)
    target_link_libraries(neutrino_test_03_lists_combo_autoscroll PRIVATE Neutrino)
    install(TARGETS neutrino_test_03_lists_combo_autoscroll RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_04_listview_typed_data examples/neutrino_test_04_listview_typed_data.cpp)
    target_link_libraries(neutrino_test_04_listview_typed_data PRIVATE Neutrino)
    install(TARGETS neutrino_test_04_listview_typed_data RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_05_treeview_collapse examples/neutrino_test_05_treeview_collapse.cpp)
    target_link_libraries(neutrino_test_05_treeview_collapse PRIVATE Neutrino)
    install(TARGETS neutrino_test_05_treeview_collapse RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_06_placement_layout_scaling examples/neutrino_test_06_placement_layout_scaling.cpp)
    target_link_libraries(neutrino_test_06_placement_layout_scaling PRIVATE Neutrino)
    install(TARGETS neutrino_test_06_placement_layout_scaling RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_07_popup_menu_categories examples/neutrino_test_07_popup_menu_categories.cpp)
    target_link_libraries(neutrino_test_07_popup_menu_categories PRIVATE Neutrino)
    install(TARGETS neutrino_test_07_popup_menu_categories RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_08_richtext_code examples/neutrino_test_08_richtext_code.cpp)
    target_link_libraries(neutrino_test_08_richtext_code PRIVATE Neutrino)
    install(TARGETS neutrino_test_08_richtext_code RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_09_readonly_richtext_icons examples/neutrino_test_09_readonly_richtext_icons.cpp)
    target_link_libraries(neutrino_test_09_readonly_richtext_icons PRIVATE Neutrino)
    install(TARGETS neutrino_test_09_readonly_richtext_icons RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_10_images_progress_labels examples/neutrino_test_10_images_progress_labels.cpp)
    target_link_libraries(neutrino_test_10_images_progress_labels PRIVATE Neutrino)
    install(TARGETS neutrino_test_10_images_progress_labels RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_11_rendering_buffering examples/neutrino_test_11_rendering_buffering.cpp)
    target_link_libraries(neutrino_test_11_rendering_buffering PRIVATE Neutrino)
    install(TARGETS neutrino_test_11_rendering_buffering RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_12_scroll_windows_heavy_data examples/neutrino_test_12_scroll_windows_heavy_data.cpp)
    target_link_libraries(neutrino_test_12_scroll_windows_heavy_data PRIVATE Neutrino)
    install(TARGETS neutrino_test_12_scroll_windows_heavy_data RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_13_swing_swt_controls examples/neutrino_test_13_swing_swt_controls.cpp)
    target_link_libraries(neutrino_test_13_swing_swt_controls PRIVATE Neutrino)
    install(TARGETS neutrino_test_13_swing_swt_controls RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_14_label_offsets_themes examples/neutrino_test_14_label_offsets_themes.cpp)
    target_link_libraries(neutrino_test_14_label_offsets_themes PRIVATE Neutrino)
    install(TARGETS neutrino_test_14_label_offsets_themes RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_15_selection_controls examples/neutrino_test_15_selection_controls.cpp)
    target_link_libraries(neutrino_test_15_selection_controls PRIVATE Neutrino)
    install(TARGETS neutrino_test_15_selection_controls RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_16_value_controls examples/neutrino_test_16_value_controls.cpp)
    target_link_libraries(neutrino_test_16_value_controls PRIVATE Neutrino)
    install(TARGETS neutrino_test_16_value_controls RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_17_tabs_toolbar_splitter examples/neutrino_test_17_tabs_toolbar_splitter.cpp)
    target_link_libraries(neutrino_test_17_tabs_toolbar_splitter PRIVATE Neutrino)
    install(TARGETS neutrino_test_17_tabs_toolbar_splitter RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_18_stage2_scroll_controls examples/neutrino_test_18_stage2_scroll_controls.cpp)
    target_link_libraries(neutrino_test_18_stage2_scroll_controls PRIVATE Neutrino)
    install(TARGETS neutrino_test_18_stage2_scroll_controls RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_19_material_beauty examples/neutrino_test_19_material_beauty.cpp)
    target_link_libraries(neutrino_test_19_material_beauty PRIVATE Neutrino)
    install(TARGETS neutrino_test_19_material_beauty RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_20_full_richtext_control examples/neutrino_test_20_full_richtext_control.cpp)
    target_link_libraries(neutrino_test_20_full_richtext_control PRIVATE Neutrino)
    install(TARGETS neutrino_test_20_full_richtext_control RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_21_full_richtext_code_control examples/neutrino_test_21_full_richtext_code_control.cpp)
    target_link_libraries(neutrino_test_21_full_richtext_code_control PRIVATE Neutrino)
    install(TARGETS neutrino_test_21_full_richtext_code_control RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
    add_executable(neutrino_test_22_cards examples/neutrino_test_22_cards.cpp)
    target_link_libraries(neutrino_test_22_cards PRIVATE Neutrino)
    install(TARGETS neutrino_test_22_cards RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
install(TARGETS Neutrino EXPORT NeutrinoOnLinux_targets ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(DIRECTORY include/Neutrino DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(DIRECTORY assets DESTINATION ${CMAKE_INSTALL_DATADIR}/NeutrinoOnLinux)
install(EXPORT NeutrinoOnLinux_targets FILE NeutrinoOnLinuxTargets.cmake NAMESPACE Neutrino::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/NeutrinoOnLinux)
configure_package_config_file(cmake/NeutrinoOnLinuxConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/NeutrinoOnLinuxConfig.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/NeutrinoOnLinux)
write_basic_package_version_file(${CMAKE_CURRENT_BINARY_DIR}/NeutrinoOnLinuxConfigVersion.cmake
    VERSION ${PROJECT_VERSION} COMPATIBILITY SameMajorVersion)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/NeutrinoOnLinuxConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/NeutrinoOnLinuxConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/NeutrinoOnLinux)
