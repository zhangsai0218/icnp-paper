EXEC    = daq2_cfg
CC		= gcc
SRCS    = daq2_cfg.c 



CFLAGS  = -Wall  -o3 

all: $(EXEC)


$(EXEC): $(SRCS) 
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: clean 

clean:
	rm -f *.o  $(EXEC) 

