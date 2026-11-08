OPENSCAD ?= openscad
SOURCE := glove80_perch.scad
ASSETS := glove80_mark.svg
OUT_DIR ?= build
IMG_SIZE ?= 1200,800

PNG := $(OUT_DIR)/glove80_perch.png
PREVIEW_PNG := $(OUT_DIR)/glove80_perch_preview.png
TOP_PNG := $(OUT_DIR)/glove80_perch_top.png
PHONE_PNG := $(OUT_DIR)/glove80_phone_fit.png
LOGO_PNG := $(OUT_DIR)/glove80_logo_detail.png
STL := $(OUT_DIR)/glove80_perch.stl
THREE_MF := $(OUT_DIR)/glove80_perch.3mf

.DEFAULT_GOAL := all
.PHONY: all png preview top phone logo stl 3mf view clean help

all: png stl

png: $(PNG)
preview: $(PREVIEW_PNG)
top: $(TOP_PNG)
phone: $(PHONE_PNG)
logo: $(LOGO_PNG)
stl: $(STL)
3mf: $(THREE_MF)

view:
	$(OPENSCAD) $(SOURCE)

$(OUT_DIR):
	mkdir -p "$@"

$(PNG): $(SOURCE) $(ASSETS) | $(OUT_DIR)
	$(OPENSCAD) --render --autocenter --viewall --imgsize=$(IMG_SIZE) -o "$@" "$<"

$(PREVIEW_PNG): $(SOURCE) $(ASSETS) | $(OUT_DIR)
	$(OPENSCAD) --autocenter --viewall --imgsize=$(IMG_SIZE) -o "$@" "$<"

$(TOP_PNG): $(SOURCE) $(ASSETS) | $(OUT_DIR)
	$(OPENSCAD) --render --autocenter --viewall --camera=0,0,0,0,0,0,500 --imgsize=$(IMG_SIZE) -o "$@" "$<"

$(PHONE_PNG): phone_fit_preview.scad $(SOURCE) $(ASSETS) | $(OUT_DIR)
	$(OPENSCAD) --autocenter --viewall --imgsize=$(IMG_SIZE) -o "$@" "$<"

$(LOGO_PNG): $(SOURCE) $(ASSETS) | $(OUT_DIR)
	$(OPENSCAD) --render --camera=0,-50,38,-75,180,0,150 --imgsize=$(IMG_SIZE) -o "$@" "$<"

$(STL): $(SOURCE) $(ASSETS) | $(OUT_DIR)
	$(OPENSCAD) --export-format binstl -o "$@" "$<"

$(THREE_MF): $(SOURCE) $(ASSETS) | $(OUT_DIR)
	$(OPENSCAD) -o "$@" "$<"

clean:
	rm -f "$(PNG)" "$(PREVIEW_PNG)" "$(TOP_PNG)" "$(PHONE_PNG)" "$(LOGO_PNG)" "$(STL)" "$(THREE_MF)"
	rmdir "$(OUT_DIR)" 2>/dev/null || true

help:
	@printf '%s\n' \
		'make          Render PNG and export STL' \
		'make png      Render build/glove80_perch.png' \
		'make preview  Export a faster preview PNG' \
		'make top      Render a top view PNG' \
		'make phone    Preview an estimated Pixel 9 Pro XL case' \
		'make logo     Render a close-up of the recessed backrest mark' \
		'make stl      Export build/glove80_perch.stl' \
		'make 3mf      Export build/glove80_perch.3mf' \
		'make view     Open the model in the OpenSCAD GUI' \
		'make clean    Remove generated files'
