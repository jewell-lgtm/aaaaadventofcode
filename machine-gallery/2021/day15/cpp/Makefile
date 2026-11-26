# One binary per part (main + partN); make only recompiles what changed.
CXXFLAGS = -O2 -std=c++23 -Wall -Wextra -Wno-unused
B = .build

all: $(B)/p1 $(B)/p2

$(B)/p%: $(B)/main.o $(B)/part%.o
	$(CXX) $(CXXFLAGS) $^ -o $@

$(B)/%.o: %.cpp aoc.hpp | $(B)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(B):
	mkdir -p $@

.SECONDARY:
