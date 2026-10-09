OPENSCAD ?= openscad
SOURCE := go60_perch.scad
OUT_DIR ?= build
IMG_SIZE ?= 1200,800

PNG := $(OUT_DIR)/go60_perch.png
PREVIEW_PNG := $(OUT_DIR)/go60_perch_preview.png
STL := $(OUT_DIR)/go60_perch.stl
THREE_MF := $(OUT_DIR)/go60_perch.3mf

.DEFAULT_GOAL := all
.PHONY: all png preview stl 3mf view clean help

all: png stl

png: $(PNG)

preview: $(PREVIEW_PNG)

stl: $(STL)

3mf: $(THREE_MF)

view:
	$(OPENSCAD) $(SOURCE)

$(OUT_DIR):
	mkdir -p "$@"

$(PNG): $(SOURCE) | $(OUT_DIR)
	$(OPENSCAD) --render --autocenter --viewall --imgsize=$(IMG_SIZE) -o "$@" "$<"

$(PREVIEW_PNG): $(SOURCE) | $(OUT_DIR)
	$(OPENSCAD) --autocenter --viewall --imgsize=$(IMG_SIZE) -o "$@" "$<"

$(STL): $(SOURCE) | $(OUT_DIR)
	$(OPENSCAD) -o "$@" "$<"

$(THREE_MF): $(SOURCE) | $(OUT_DIR)
	$(OPENSCAD) -o "$@" "$<"

clean:
	rm -f "$(PNG)" "$(PREVIEW_PNG)" "$(STL)" "$(THREE_MF)"
	rmdir "$(OUT_DIR)" 2>/dev/null || true

help:
	@printf '%s\n' \
		'make          Render PNG and export STL' \
		'make png      Render build/go60_perch.png' \
		'make preview  Export a faster preview PNG' \
		'make stl      Export build/go60_perch.stl' \
		'make 3mf      Export build/go60_perch.3mf' \
		'make view     Open the model in the OpenSCAD GUI' \
		'make clean    Remove generated files'
