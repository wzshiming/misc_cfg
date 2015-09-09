
INCILDE      := -I.
LIBS         := -L.
BUILD_DIR    := build
TARGET_EXEC  := $(shell basename `pwd`)
TARGET_SO    := lib$(TARGET_EXEC).so
TARGET_A     := lib$(TARGET_EXEC).a
CFLAGS       := -O0
MV           := -mv
RM           := -rm -rf
CD           := cd
MAKE         := make
MKDIR        := -mkdir -p
PRES         := lib*.so lib*.a
PRE_FILES    := $(wildcard $(PRES))
SU           := *.c *.cc *.cpp
SUFS         := %.c %.cc %.cpp
SUF_FILES    := $(wildcard $(SU))
OBJS         := $(addsuffix .o,$(SUF_FILES))
DEPS         := $(addsuffix .d,$(SUF_FILES))
CC           := gcc $(CFLAGS) $(INCILDE)
LINK         := gcc $(LIBS)
AR           := ar
LOAD         :=
RULE         := make_rule.d


.PHONY: default objs deps exec lib_so lib_a run move clean clean_objs clean_deps clean_target
default:
	@echo 2014/11/20
	@echo wzshiming@foxmail.com

objs: $(OBJS)

deps: $(DEPS)

info:
	@echo $(SU)
	@echo $(SUFS)
	@echo $(SUF_FILES)
	@echo $(OBJS)
	@echo $(DEPS)

exec: $(TARGET_EXEC)

lib_so: $(TARGET_SO)

lib_a: $(TARGET_A)

run: $(TARGET_EXEC)
	./$(TARGET_EXEC)

move:
	$(MKDIR) $(BUILD_DIR)
	$(MV) $(OBJS) $(TARGET_EXEC) $(BUILD_DIR)
	$(CD) $(BUILD_DIR)

$(TARGET_EXEC): $(OBJS)
	$(LINK) -o $@ $?

$(TARGET_SO): $(OBJS)
	$(LINK) -fPIC -shared -o $@ $?

$(TARGET_A): $(OBJS)
	$(AR) cqs $@ $?

$(RULE): 
	@echo -ne "$(foreach tar, $(SUFS),\n$(tar).d: $(tar)\n	$(CC) -M -MT $$<.o $$< > \$$@\n	@echo '	$(CC) -c -o \$$\$$@ \$$\$$<' >> \$$@ \n)" > $@

-include $(RULE)
-include $(DEPS)

clean_objs:
	$(RM) *.o

clean_deps:
	$(RM) *.d

clean_target:
	$(RM) $(TARGET_EXEC) $(TARGET_SO) $(TARGET_A)

clean: clean_objs clean_deps clean_target

