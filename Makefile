###
# GNU ARM Embedded Toolchain
CC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
CP=arm-none-eabi-objcopy
OD=arm-none-eabi-objdump

MKDIR_P=mkdir -p
OUT_DIR=bin
###
# Directory Structure

BINDIR=${OUT_DIR}
INCDIR=inc
SRCDIR=src

###
# Find source files
ASOURCES=$(shell find -L $(SRCDIR) -name '*.s')
CSOURCES+=$(shell find -L $(SRCDIR) -name '*.c')
#CXXSOURCES+=$(shell find -L $(SRCDIR) -name '*.cpp')
# Find header directories
INC=$(shell find -L . -name '*.h' -exec dirname {} \; | uniq)
INCLUDES=$(INC:%=-I%)
# Create object list
OBJECTS=$(ASOURCES:%.s=%.o)
OBJECTS+=$(CSOURCES:%.c=%.o)
#OBJECTS+=$(CXXSOURCES:%.cpp=%.o)
# Define output files ELF & IHEX
BINELF=out.elf
BINHEX=out.hex
BINBIN=out.bin
###
# MCU FLAGS
MCFLAGS=-mcpu=cortex-m4 -mthumb -mlittle-endian \
-mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb-interwork -std=gnu99
# COMPILE FLAGS
DEFS=-DHSE_VALUE=8000000 -DUSE_HAL_DRIVER -DSTM32F407xx
CFLAGS=-c $(MCFLAGS) $(DEFS) $(INCLUDES)
#CXXFLAGS=-c $(MCFLAGS) $(DEFS) $(INCLUDES) -std=c++11
# LINKER FLAGS
LDSCRIPT= stm32_flash.ld
LDFLAGS =-T $(LDSCRIPT) $(MCFLAGS) --specs=nosys.specs -fno-math-errno -lm

###
# Build Rules
.PHONY: all release release-memopt debug clean

all: release-memopt


release: $(BINDIR)/$(BINHEX)

release-memopt: CFLAGS+=-Os
#release-memopt: CXXFLAGS+=-Os
release-memopt: LDFLAGS+=-Os
release-memopt: release

debug: CFLAGS+=-g
#debug: CXXFLAGS+=-g
debug: LDFLAGS+=-g
debug: release

# $(BINDIR)/$(BINBIN): $(BINDIR)/$(BINELF)
# 	$(CP) -O binary $< $@
# 	@echo "Objcopy from ELF to IHEX complete!\n"

$(BINDIR)/$(BINHEX): $(BINDIR)/$(BINELF)
	$(CP) -O ihex $< $@
	$(CP) -O binary $< $(BINDIR)/$(BINBIN)
	@echo "Objcopy from ELF to IHEX IBIN complete!\n"

$(BINDIR)/$(BINELF): $(OBJECTS)
	${MKDIR_P} ${OUT_DIR}
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
	@echo "Linking complete BINELF!\n"
#	$(SIZE) $(BINDIR)/$(BINELF)

#%.o: %.cpp
#	$(CXX) $(CXXFLAGS) $< -o $@
#	@echo "Compiled "$<"!\n"

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@
	@echo "Compiled "$<"!\n"

%.o: %.s
	$(CC) $(CFLAGS) $< -o $@
	@echo "Assambled "$<"!\n"

clean:
	rm -rf $(OBJECTS)  ${OUT_DIR}/#$(BINDIR)/$(BINELF) $(BINDIR)/$(BINHEX) $(BINDIR)/$(BINBIN) $(BINDIR)/

deploy:
ifeq ($(wildcard /opt/openocd/bin/openocd),)
	/usr/bin/openocd -f /usr/share/openocd/scripts/board/stm32f4discovery.cfg -c "program bin/"$(BINELF)" verify reset"
else
	/opt/openocd/bin/openocd -f /opt/openocd/share/openocd/scripts/board/stm32f4discovery.cfg -c "program bin/"$(BINELF)" verify reset"
endif
