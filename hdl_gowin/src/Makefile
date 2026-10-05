# Variables configurables desde la línea de comandos
TB         ?= tb_micro_ejemplo
STOP_TIME  ?= 1000us

# Configuración de compilador y simulador
GHDL       = ghdl
GTKWAVE    = surfer
FLAGS      = --std=93c

# Directorios
SRC_DIR    = .
CORE_DIR   = core
BUILD_DIR  = work

# Detección de fuentes VHDL
CORE_SRCS  = $(wildcard $(CORE_DIR)/*.vhd)
TOP_SRCS   = $(wildcard $(SRC_DIR)/*.vhd)
VHDL_SRCS  = $(CORE_SRCS) $(TOP_SRCS)

WAVE_FILE  = $(BUILD_DIR)/$(TB).ghw

.PHONY: all analyze run view clean directories

all: run

directories:
	@mkdir -p $(BUILD_DIR)

# Importa y analiza resolviendo las dependencias automáticamente
analyze: directories
	$(GHDL) -i $(FLAGS) --workdir=$(BUILD_DIR) $(VHDL_SRCS)
	$(GHDL) -m $(FLAGS) --workdir=$(BUILD_DIR) $(TB)

# Ejecuta la simulación
run: analyze
	$(GHDL) -r $(FLAGS) --workdir=$(BUILD_DIR) $(TB) --wave=$(WAVE_FILE) --stop-time=$(STOP_TIME)

view: run
	$(GTKWAVE) $(WAVE_FILE) &

clean:
	rm -rf $(BUILD_DIR) *.cf