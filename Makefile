# GNU make: Linux/Unix/macOS, with the existing X11 backend.
CXX = c++
AR = ar
PREFIX ?= /usr/local
DESTDIR ?=
BUILD_DIR ?= build
PKG_CONFIG ?= pkg-config
CXXFLAGS ?= -O2 -Wall -Wextra
CPPFLAGS ?=
LDFLAGS ?=
UNAME_S := $(shell uname -s)
X11_CFLAGS := $(shell $(PKG_CONFIG) --cflags x11 2>/dev/null)
X11_LIBS := $(shell $(PKG_CONFIG) --libs x11 2>/dev/null)
ifeq ($(strip $(X11_LIBS)),)
X11_LIBS = -lX11
ifeq ($(UNAME_S),Darwin)
X11_CFLAGS = -I/opt/X11/include
X11_LIBS = -L/opt/X11/lib -lX11
endif
endif
DL_LIBS ?= $(if $(filter Linux SunOS,$(UNAME_S)),-ldl,)
WITH_XFT ?= 1
WITH_WAYLAND ?= 1
ifeq ($(WITH_XFT),1)
XFT_CFLAGS := $(shell $(PKG_CONFIG) --cflags xft 2>/dev/null)
XFT_LIBS := $(shell $(PKG_CONFIG) --libs xft 2>/dev/null)
ifneq ($(strip $(XFT_LIBS)),)
FEATURE_CPPFLAGS += -DNEUTRINO_USE_XFT $(XFT_CFLAGS)
endif
endif
ifeq ($(WITH_WAYLAND),1)
ifneq ($(NEUTRINO_USE_X11),1)
WAYLAND_CFLAGS := $(shell $(PKG_CONFIG) --cflags wayland-client 2>/dev/null)
WAYLAND_LIBS := $(shell $(PKG_CONFIG) --libs wayland-client 2>/dev/null)
ifneq ($(strip $(WAYLAND_LIBS)),)
FEATURE_CPPFLAGS += -DNEUTRINO_PREFER_WAYLAND $(WAYLAND_CFLAGS)
endif
endif
endif
SRC = src/Neu_AdditionalControls.cpp src/Neu_Application.cpp src/Neu_Button.cpp src/Neu_Cards.cpp src/Neu_ComboBox.cpp src/Neu_Control.cpp src/Neu_Graphics.cpp src/Neu_IconBmp.cpp src/Neu_ImageView.cpp src/Neu_Label.cpp src/Neu_ListView.cpp src/Neu_Listbox.cpp src/Neu_Multilinetextbox.cpp src/Neu_Passwordbox.cpp src/Neu_Placement.cpp src/Neu_PopWindowMenu.cpp src/Neu_ProgressSquare.cpp src/Neu_ReadOnlyRichText.cpp src/Neu_RichTextCode.cpp src/Neu_ScrollBar.cpp src/Neu_ScrollWindow.cpp src/Neu_Textbox.cpp src/Neu_Theme.cpp src/Neu_TreeView.cpp src/Neu_TypeInterpreter.cpp src/Neu_Window.cpp
OBJ = $(patsubst src/%.cpp,$(BUILD_DIR)/%.o,$(SRC))
LIB = $(BUILD_DIR)/libNeutrino.a
EXAMPLES = $(BUILD_DIR)/neutrino_demo $(BUILD_DIR)/neutrino_test_all_controls $(BUILD_DIR)/neutrino_test_windows $(BUILD_DIR)/neutrino_test_typed_views $(BUILD_DIR)/neutrino_test_smooth_graphics $(BUILD_DIR)/neutrino_test_treeview_collapse $(BUILD_DIR)/neutrino_test_heavy_data $(BUILD_DIR)/neutrino_test_01_buttons_icons $(BUILD_DIR)/neutrino_test_02_text_inputs $(BUILD_DIR)/neutrino_test_03_lists_combo_autoscroll $(BUILD_DIR)/neutrino_test_04_listview_typed_data $(BUILD_DIR)/neutrino_test_05_treeview_collapse $(BUILD_DIR)/neutrino_test_06_placement_layout_scaling $(BUILD_DIR)/neutrino_test_07_popup_menu_categories $(BUILD_DIR)/neutrino_test_08_richtext_code $(BUILD_DIR)/neutrino_test_09_readonly_richtext_icons $(BUILD_DIR)/neutrino_test_10_images_progress_labels $(BUILD_DIR)/neutrino_test_11_rendering_buffering $(BUILD_DIR)/neutrino_test_12_scroll_windows_heavy_data $(BUILD_DIR)/neutrino_test_13_swing_swt_controls $(BUILD_DIR)/neutrino_test_14_label_offsets_themes $(BUILD_DIR)/neutrino_test_15_selection_controls $(BUILD_DIR)/neutrino_test_16_value_controls $(BUILD_DIR)/neutrino_test_17_tabs_toolbar_splitter $(BUILD_DIR)/neutrino_test_18_stage2_scroll_controls $(BUILD_DIR)/neutrino_test_19_material_beauty $(BUILD_DIR)/neutrino_test_20_full_richtext_control $(BUILD_DIR)/neutrino_test_21_full_richtext_code_control $(BUILD_DIR)/neutrino_test_22_cards
all: $(LIB) $(EXAMPLES)
library: $(LIB)
$(BUILD_DIR)/%.o: src/%.cpp
	@mkdir -p "$(@D)"
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 -MMD -MP -c $< -o $@
$(LIB): $(OBJ)
	$(AR) rcs $@ $^
$(BUILD_DIR)/neutrino_demo: examples/demo.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_all_controls: examples/test_all_controls.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_windows: examples/test_windows.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_typed_views: examples/test_typed_views.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_smooth_graphics: examples/test_smooth_graphics.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_treeview_collapse: examples/test_treeview_collapse.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_heavy_data: examples/test_heavy_data.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_01_buttons_icons: examples/neutrino_test_01_buttons_icons.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_02_text_inputs: examples/neutrino_test_02_text_inputs.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_03_lists_combo_autoscroll: examples/neutrino_test_03_lists_combo_autoscroll.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_04_listview_typed_data: examples/neutrino_test_04_listview_typed_data.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_05_treeview_collapse: examples/neutrino_test_05_treeview_collapse.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_06_placement_layout_scaling: examples/neutrino_test_06_placement_layout_scaling.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_07_popup_menu_categories: examples/neutrino_test_07_popup_menu_categories.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_08_richtext_code: examples/neutrino_test_08_richtext_code.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_09_readonly_richtext_icons: examples/neutrino_test_09_readonly_richtext_icons.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_10_images_progress_labels: examples/neutrino_test_10_images_progress_labels.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_11_rendering_buffering: examples/neutrino_test_11_rendering_buffering.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_12_scroll_windows_heavy_data: examples/neutrino_test_12_scroll_windows_heavy_data.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_13_swing_swt_controls: examples/neutrino_test_13_swing_swt_controls.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_14_label_offsets_themes: examples/neutrino_test_14_label_offsets_themes.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_15_selection_controls: examples/neutrino_test_15_selection_controls.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_16_value_controls: examples/neutrino_test_16_value_controls.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_17_tabs_toolbar_splitter: examples/neutrino_test_17_tabs_toolbar_splitter.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_18_stage2_scroll_controls: examples/neutrino_test_18_stage2_scroll_controls.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_19_material_beauty: examples/neutrino_test_19_material_beauty.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_20_full_richtext_control: examples/neutrino_test_20_full_richtext_control.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_21_full_richtext_code_control: examples/neutrino_test_21_full_richtext_code_control.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

$(BUILD_DIR)/neutrino_test_22_cards: examples/neutrino_test_22_cards.cpp $(LIB)
	$(CXX) $(CPPFLAGS) -Iinclude $(X11_CFLAGS) $(FEATURE_CPPFLAGS) $(CXXFLAGS) -std=c++17 $< $(LIB) $(LDFLAGS) $(X11_LIBS) $(DL_LIBS) $(XFT_LIBS) $(WAYLAND_LIBS) $(LDLIBS) -o $@

install: all
	mkdir -p "$(DESTDIR)$(PREFIX)/lib" "$(DESTDIR)$(PREFIX)/include/Neutrino" "$(DESTDIR)$(PREFIX)/bin" "$(DESTDIR)$(PREFIX)/share/NeutrinoOnLinux"
	cp $(LIB) "$(DESTDIR)$(PREFIX)/lib/"
	cp include/Neutrino/Neutrino.hpp "$(DESTDIR)$(PREFIX)/include/Neutrino/"
	cp $(EXAMPLES) "$(DESTDIR)$(PREFIX)/bin/"
	cp -R assets "$(DESTDIR)$(PREFIX)/share/NeutrinoOnLinux/"
clean:
	rm -rf "$(BUILD_DIR)"
-include $(OBJ:.o=.d)
.PHONY: all library install clean
