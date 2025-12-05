export function solve(input: string): number | string {
  const ranges = parseRanges(
    input
      .trim()
      .split("\n\n")
      .map((it) => it.split("\n"))[0],
  );


  const rangeSet = OverlappingRanges.fromRanges(ranges);


  let result = BigInt(0);

  for (const [start, end] of rangeSet.ranges) {
    const span = BigInt(end - start + 1);
    result += span;
  }

  return result.toString();
}

function parseRanges(ranges: string[]): [number, number][] {
  return ranges.map((range) => {
    const [start, end] = range.split("-").map(Number);
    return [start, end];
  });
}

class OverlappingRanges {
  ranges: [number, number][] = [];
  static fromRanges(ranges: [number, number][]): OverlappingRanges {
    const inst = new OverlappingRanges();
    for (const range of ranges) {
      inst.addRange(range);
    }
    return inst;
  }

  addRange(range: [number, number]) {
    this.ranges.push(range);
    this.settleRanges();
  }

  private settleRanges() {
    for (let i = 0; i < this.ranges.length; i++) {
      for (let j = i + 1; j < this.ranges.length; j++) {
        if (
          contains(this.ranges[i], this.ranges[j][0]) ||
          contains(this.ranges[i], this.ranges[j][1]) ||
            contains(this.ranges[j], this.ranges[i][0]) ||
            contains(this.ranges[j], this.ranges[i][1])
        ) {
          this.ranges[i] = combine(this.ranges[i], this.ranges[j]);
          this.removeAt(j);

          this.settleRanges();
          return;
        }
      }
    }
  }

  private removeAt(index: number) {
    this.ranges.splice(index, 1);
  }
}

function contains(range: [number, number], value: number): boolean {
  return range[0] <= value && value <= range[1];
}

function combine(
  range1: [number, number],
  range2: [number, number],
): [number, number] {
  const small = Math.min(range1[0], range2[0]);
  const large = Math.max(range1[1], range2[1]);
  return [small, large];
}
