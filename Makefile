#
# A Makefile that compiles all .c and .s files in "src" and "res"
# subdirectories and places the output in a "obj" subdirectory
#

# I install all of my Game Boy development tools in one root.
TOOLS_ROOT = C:/Users/RobProuse/OneDrive/bin/Emulators/

# If you move this project you can change the directory
# to match your GBDK root directory (ex: GBDK_HOME = "C:/GBDK/"
GBDK_HOME = $(TOOLS_ROOT)gbdk/

# Set the path to the ZGB game engine, https://github.com/Zal0/ZGB
ZGB_HOME = $(TOOLS_ROOT)ZGB-2022.0/

LCC = $(GBDK_HOME)bin/lcc
GBM2C = $(ZGB_HOME)tools/gbm2c/gbm2c
GBR2C = $(ZGB_HOME)tools/gbr2c/gbr2c
GBR2PNG = $(ZGB_HOME)tools/gbr2png/gbr2png

# Run using the bgb64.exe emulator in the path
GBEMU = $(TOOLS_ROOT)bgb/bgb64

# You can set flags for LCC here
# For example, you can uncomment the line below to turn on debug output
# LCCFLAGS = -debug
LCCFLAGS = -Wa-l -Wl-m
CFLAGS = -Wf-Iinclude -Wf-MMD

# You can set the name of the .gb ROM file here
PROJECTNAME    = gb-template

SRCDIR      = src
OBJDIR      = obj
RESDIR      = res
BINS	      = $(OBJDIR)/$(PROJECTNAME).gbc
CSOURCES    = $(foreach dir,$(SRCDIR),$(notdir $(wildcard $(dir)/*.c))) $(foreach dir,$(RESDIR),$(notdir $(wildcard $(dir)/*.c)))
ASMSOURCES  = $(foreach dir,$(SRCDIR),$(notdir $(wildcard $(dir)/*.s)))
GBRS        = $(foreach dir,$(RESDIR),$(notdir $(wildcard $(dir)/*.gbr)))
GBMS        = $(foreach dir,$(RESDIR),$(notdir $(wildcard $(dir)/*.gbm)))
OBJS        = $(CSOURCES:%.c=$(OBJDIR)/%.o) $(ASMSOURCES:%.s=$(OBJDIR)/%.o)
ASSETS      = $(GBRS:%.gbr=$(RESDIR)/%.gbr.c) $(GBMS:%.gbm=$(RESDIR)/%.gbm.c)

all:	prepare $(BINS) run

assets: $(ASSETS)

# Compile .gbm files in "res/" to .c files
$(RESDIR)/%.gbm.c:	$(RESDIR)/%.gbm
	$(GBM2C) $< $(RESDIR)

# Compile .gbr files in "res/" to .c files
$(RESDIR)/%.gbr.c:	$(RESDIR)/%.gbr
	$(GBR2C) $< $(RESDIR)

# Compile .c files in "src/" to .o object files
$(OBJDIR)/%.o:	$(SRCDIR)/%.c
	$(LCC) $(LCCFLAGS) $(CFLAGS) -c -o $@ $<

# Compile .c files in "res/" to .o object files
$(OBJDIR)/%.o:	$(RESDIR)/%.c
	$(LCC) $(LCCFLAGS) $(CFLAGS) -c -o $@ $<

# Compile .s assembly files in "src/" to .o object files
$(OBJDIR)/%.o:	$(SRCDIR)/%.s
	$(LCC) $(LCCFLAGS) -c -o $@ $<

# If needed, compile .c files in "src/" to .s assembly files
# (not required if .c is compiled directly to .o)
$(OBJDIR)/%.s:	$(SRCDIR)/%.c
	$(LCC) $(LCCFLAGS) $(CFLAGS) -S -o $@ $<

# Link the compiled object files into a .gb ROM file
$(BINS):	$(OBJS)
	$(LCC) $(LCCFLAGS) -Wm-yC -o $(BINS) $(OBJS)

run:	$(BINS)
	$(GBEMU) --rom $(BINS)

prepare:
	mkdir -p $(OBJDIR)

clean:
#	rm -f  *.gb *.ihx *.cdb *.adb *.noi *.map
	rm -f  $(OBJDIR)/*.*

