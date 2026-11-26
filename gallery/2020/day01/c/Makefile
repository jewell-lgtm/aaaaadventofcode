# One binary per part (main + aoc + partN); make only recompiles what changed.
CFLAGS = -O2 -std=c23 -Wall -Wextra -Wno-unused
B = .build

all: $(B)/p1 $(B)/p2

$(B)/p%: $(B)/main.o $(B)/aoc.o $(B)/part%.o
	$(CC) $(CFLAGS) $^ -o $@ -lm

$(B)/%.o: %.c aoc.h | $(B)
	$(CC) $(CFLAGS) -c $< -o $@

$(B):
	mkdir -p $@

.SECONDARY:
