#!/usr/bin/env bun

import { existsSync, mkdirSync, readdirSync } from "fs";
import { join } from "path";

const SOLUTIONS_DIR = "solutions";
const LAST_COMMAND_FILE = ".aoc-last";

interface Args {
  year: number;
  day: number;
  part: number;
  inputFile?: string;
  rawInput?: string;
  expected?: string | number;
}

interface StoredArgs {
  year?: number;
  day?: number;
  part?: number;
  inputFile?: string;
  rawInput?: string;
  expected?: string | number;
  lastResult?: string | number;
}

function parseFlags(args: string[]): Partial<StoredArgs> {
  const parsed: Partial<StoredArgs> = {};

  for (const arg of args) {
    if (arg.startsWith("--year=")) {
      parsed.year = parseInt(arg.split("=")[1]);
    } else if (arg.startsWith("--day=")) {
      parsed.day = parseInt(arg.split("=")[1]);
    } else if (arg.startsWith("--part=")) {
      parsed.part = parseInt(arg.split("=")[1]);
    } else if (arg.startsWith("--input=")) {
      parsed.inputFile = arg.split("=")[1];
    } else if (arg.startsWith("--raw-input=")) {
      parsed.rawInput = arg.substring("--raw-input=".length);
    } else if (arg.startsWith("--expected=")) {
      const value = arg.split("=")[1];
      parsed.expected = isNaN(Number(value)) ? value : Number(value);
    }
  }

  return parsed;
}

async function loadStoredArgs(): Promise<StoredArgs> {
  if (!existsSync(LAST_COMMAND_FILE)) {
    return {};
  }

  try {
    const content = await Bun.file(LAST_COMMAND_FILE).text();
    return JSON.parse(content);
  } catch {
    return {};
  }
}

interface DayProgress {
  day: number;
  part1Solved: boolean;
  part2Solved: boolean;
  part1InProgress: boolean;
  part2InProgress: boolean;
}

interface YearProgress {
  year: number;
  days: DayProgress[];
  totalStars: number;
}

async function showProgress(): Promise<void> {
  if (!existsSync(SOLUTIONS_DIR)) {
    console.log("📂 No solutions directory found");
    return;
  }

  const years = readdirSync(SOLUTIONS_DIR, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name)
    .filter(name => /^\d{4}$/.test(name))
    .map(name => parseInt(name))
    .sort((a, b) => b - a); // Sort descending (newest first)

  if (years.length === 0) {
    console.log("📂 No year directories found");
    return;
  }

  const yearProgressList: YearProgress[] = [];

  for (const year of years) {
    const yearDir = join(SOLUTIONS_DIR, year.toString());
    const dayDirs = readdirSync(yearDir, { withFileTypes: true })
      .filter(dirent => dirent.isDirectory())
      .map(dirent => dirent.name)
      .filter(name => /^day\d{2}$/.test(name))
      .sort();

    const days: DayProgress[] = [];
    let totalStars = 0;

    for (const dayDir of dayDirs) {
      const dayNum = parseInt(dayDir.replace('day', ''));
      const dayPath = join(yearDir, dayDir);

      const part1Expected = existsSync(join(dayPath, 'expected-part1.txt'));
      const part2Expected = existsSync(join(dayPath, 'expected-part2.txt'));
      const part1Exists = existsSync(join(dayPath, 'part1.ts'));
      const part2Exists = existsSync(join(dayPath, 'part2.ts'));

      days.push({
        day: dayNum,
        part1Solved: part1Expected,
        part2Solved: part2Expected,
        part1InProgress: part1Exists && !part1Expected,
        part2InProgress: part2Exists && !part2Expected,
      });

      if (part1Expected) totalStars++;
      if (part2Expected) totalStars++;
    }

    if (days.length > 0) {
      yearProgressList.push({ year, days, totalStars });
    }
  }

  console.log("\n🎄 Advent of Code Progress\n");

  for (const yearProgress of yearProgressList) {
    const maxStars = yearProgress.days.length * 2;
    console.log(`\n📅 ${yearProgress.year}: ${yearProgress.totalStars}/${maxStars} ⭐`);
    console.log("─".repeat(50));

    for (const day of yearProgress.days) {
      const dayLabel = `Day ${day.day.toString().padStart(2, ' ')}`;
      let status = "";

      if (day.part1Solved && day.part2Solved) {
        status = "⭐⭐";
      } else if (day.part1Solved) {
        status = "⭐  ";
        if (day.part2InProgress) status += " (part 2 in progress)";
      } else if (day.part1InProgress || day.part2InProgress) {
        status = "🔨  (in progress)";
      } else {
        status = "   ";
      }

      console.log(`  ${dayLabel}: ${status}`);
    }
  }

  const grandTotal = yearProgressList.reduce((sum, y) => sum + y.totalStars, 0);
  console.log("\n" + "─".repeat(50));
  console.log(`Total: ${grandTotal} ⭐\n`);
}

function showHelp(): void {
  console.log(`
🎄 Advent of Code Runner

USAGE:
  aoc --year=<year> --day=<day> --part=<part> --input=<file> [--expected=<value>]
  aoc --year=<year> --day=<day> --part=<part> --raw-input=<string> [--expected=<value>]
  aoc                (rerun last command)
  aoc next           (run next puzzle after last)
  aoc today          (run today's puzzle)
  aoc correct        (save last result as expected answer)
  aoc progress       (show star progress by year)
  aoc help           (show this help)

EXAMPLES:
  aoc --year=2024 --day=1 --part=1 --input=input.txt
  aoc                # rerun, validates against expected-part1.txt if exists
  aoc correct        # save last result to expected-part1.txt
  aoc --year=2024 --day=1 --part=1 --input=example.txt --expected=42
  aoc --year=2017 --day=1 --part=1 --raw-input=1122 --expected=3
  aoc --part=2       # rerun with part 2, keeping other params
  aoc --input=example.txt # switch to example input
  aoc next           # advance to next part/day

EXPECTED VALUES:
  File-based (gitignored, auto-created with "aoc correct"):
    solutions/YYYY/dayDD/expected-part1.txt
    solutions/YYYY/dayDD/expected-part2.txt
    solutions/YYYY/dayDD/expected-example-part1.txt

  Files auto-load if present. Use --expected flag for one-off validation.
  --expected flag only persists on exact reruns (aoc with no args).

FLAGS:
  --year=YYYY        Year (2015-2025)
  --day=DD           Day (1-25)
  --part=P           Part (1 or 2)
  --input=FILE       Input file (e.g., input.txt, example.txt)
  --raw-input=STR    Raw input string (instead of file)
  --expected=VALUE   Expected answer for validation
`);
}

async function parseArgs(): Promise<Args | null> {
  const args = process.argv.slice(2);

  // Handle help
  if (args.length > 0 && (args[0] === "help" || args[0] === "--help" || args[0] === "-h")) {
    showHelp();
    return null;
  }

  // Handle progress command
  if (args.length > 0 && args[0] === "progress") {
    await showProgress();
    return null;
  }

  // Handle correct command
  if (args.length > 0 && args[0] === "correct") {
    const stored = await loadStoredArgs();

    if (!stored.year || !stored.day || !stored.part) {
      console.error("❌ No previous command found. Run a puzzle first.");
      return null;
    }

    if (stored.lastResult === undefined) {
      console.error("❌ No result from last run. Run a puzzle first.");
      return null;
    }

    const dayPadded = stored.day.toString().padStart(2, "0");
    const dayDir = join(SOLUTIONS_DIR, stored.year.toString(), `day${dayPadded}`);

    // Determine expected filename based on input type
    let expectedFilename: string;
    if (stored.rawInput !== undefined) {
      console.error("❌ Cannot create expected file for raw input. Use --input with a file instead.");
      return null;
    } else if (stored.inputFile) {
      const inputBase = stored.inputFile.replace(/\.txt$/, '');
      expectedFilename = inputBase === 'input'
        ? `expected-part${stored.part}.txt`
        : `expected-${inputBase}-part${stored.part}.txt`;
    } else {
      console.error("❌ No input file in last run.");
      return null;
    }

    const expectedPath = join(dayDir, expectedFilename);
    await Bun.write(expectedPath, String(stored.lastResult));
    console.log(`✅ Created ${expectedPath} with value: ${stored.lastResult}`);

    return null;
  }

  // Handle special commands
  if (args.length > 0 && (args[0] === "next" || args[0] === "today")) {
    const command = args[0];

    if (command === "today") {
      const now = new Date();
      const year = now.getFullYear();
      const month = now.getMonth() + 1;
      const day = now.getDate();

      if (month !== 12 || day > 25) {
        console.error("❌ Today is not an Advent of Code day (Dec 1-25)");
        return null;
      }

      const result: Args = {
        year,
        day,
        part: 1,
        inputFile: "input.txt",
        rawInput: undefined
      };

      await Bun.write(LAST_COMMAND_FILE, JSON.stringify(result));
      console.log(`📅 Running today's puzzle: ${year} day ${day} part 1\n`);
      return result;
    } else if (command === "next") {
      const stored = await loadStoredArgs();

      if (!stored.year || !stored.day || !stored.part) {
        console.error("❌ No previous command found. Run a puzzle first.");
        return null;
      }

      let nextYear = stored.year;
      let nextDay = stored.day;
      let nextPart = stored.part;

      // Increment: part 1 -> part 2, part 2 -> next day part 1
      const isGoingToPart2 = stored.part === 1;
      if (stored.part === 1) {
        nextPart = 2;
      } else {
        nextPart = 1;
        nextDay += 1;
        if (nextDay > 25) {
          nextDay = 1;
          nextYear += 1;
        }
      }

      // Ask if user wants to copy part1 to part2
      if (isGoingToPart2) {
        const dayPadded = nextDay.toString().padStart(2, "0");
        const dayDir = join(SOLUTIONS_DIR, nextYear.toString(), `day${dayPadded}`);
        const part1Path = join(dayDir, "part1.ts");
        const part2Path = join(dayDir, "part2.ts");

        if (existsSync(part1Path) && existsSync(part2Path)) {
          process.stdout.write("📋 Copy part1.ts to part2.ts? [y/N]: ");

          for await (const line of console) {
            const answer = line.trim().toLowerCase();
            if (answer === "y" || answer === "yes") {
              const part1Content = await Bun.file(part1Path).text();
              await Bun.write(part2Path, part1Content);
              console.log("✅ Copied part1.ts to part2.ts\n");
            }
            break;
          }
        }
      }

      const result: Args = {
        year: nextYear,
        day: nextDay,
        part: nextPart,
        inputFile: stored.inputFile || "input.txt",
        rawInput: undefined, // Don't carry over raw input to next puzzle
        expected: undefined // Don't carry over expected to next puzzle
      };

      await Bun.write(LAST_COMMAND_FILE, JSON.stringify(result));
      console.log(`⏭️  Running next puzzle: ${nextYear} day ${nextDay} part ${nextPart}\n`);
      return result;
    }
  }

  // Load stored values and merge with new flags
  const stored = await loadStoredArgs();
  const newFlags = parseFlags(args);
  const merged = { ...stored, ...newFlags };

  // If switching input type, clear the other
  if (newFlags.inputFile !== undefined) {
    merged.rawInput = undefined;
  } else if (newFlags.rawInput !== undefined) {
    merged.inputFile = undefined;
  }

  // Only persist expected flag if exact rerun (no new args)
  // Otherwise rely on file-based expected values
  if (args.length > 0) {
    // User provided new flags, clear expected unless explicitly provided
    if (newFlags.expected === undefined) {
      merged.expected = undefined;
    }
  }
  // If args.length === 0, keep stored expected for exact rerun

  // Check if we have all required values
  if (!merged.year || !merged.day || !merged.part || (!merged.inputFile && !merged.rawInput)) {
    if (args.length === 0) {
      console.error("❌ No previous command found. Run 'aoc help' for usage.");
    } else {
      console.error("❌ Missing required parameters. Need: year, day, part, and (input OR raw-input)");
      console.error(`   Current: year=${merged.year}, day=${merged.day}, part=${merged.part}, input=${merged.inputFile}, raw-input=${merged.rawInput}`);
      console.error("\nRun 'aoc help' for usage.");
    }
    return null;
  }

  if (merged.part !== 1 && merged.part !== 2) {
    console.error("Part must be 1 or 2");
    return null;
  }

  const result: Args = {
    year: merged.year,
    day: merged.day,
    part: merged.part,
    inputFile: merged.inputFile,
    rawInput: merged.rawInput,
    expected: merged.expected
  };

  // Save merged args for next time
  await Bun.write(LAST_COMMAND_FILE, JSON.stringify(result));

  if (args.length === 0) {
    console.log(`♻️  Rerunning: ${result.year} day ${result.day} part ${result.part}\n`);
  }

  return result;
}

async function ensureScaffolded(year: number, day: number): Promise<void> {
  const dayDir = join(SOLUTIONS_DIR, year.toString(), `day${day.toString().padStart(2, "0")}`);

  if (existsSync(dayDir)) {
    return; // Already scaffolded
  }

  console.log(`📁 Scaffolding ${year}/day${day.toString().padStart(2, "0")}...`);
  mkdirSync(dayDir, { recursive: true });

  const template = `export function solve(input: string): number | string {
  const lines = input.trim().split('\\n');

  // Your solution here

  return 0;
}
`;

  await Bun.write(join(dayDir, "part1.ts"), template);
  await Bun.write(join(dayDir, "part2.ts"), template);

  console.log(`✅ Created solution templates`);
}

async function downloadInput(year: number, day: number, targetPath: string): Promise<boolean> {
  const sessionCookie = process.env.AOC_SESSION;

  if (!sessionCookie) {
    console.error("❌ AOC_SESSION not found in environment");
    console.error("   Get your session cookie from adventofcode.com and add to .env");
    return false;
  }

  console.log(`⬇️  Downloading input for ${year} day ${day}...`);

  try {
    const response = await fetch(
      `https://adventofcode.com/${year}/day/${day}/input`,
      {
        headers: {
          Cookie: `session=${sessionCookie}`,
        },
      }
    );

    if (!response.ok) {
      console.error(`❌ Failed to download: ${response.status} ${response.statusText}`);
      return false;
    }

    const input = await response.text();
    await Bun.write(targetPath, input);
    console.log(`✅ Downloaded input to ${targetPath}`);
    return true;
  } catch (error) {
    console.error(`❌ Download failed:`, error);
    return false;
  }
}

async function runSolution(args: Args): Promise<void> {
  const { year, day, part, inputFile, rawInput } = args;
  let { expected } = args;
  const dayPadded = day.toString().padStart(2, "0");
  const dayDir = join(SOLUTIONS_DIR, year.toString(), `day${dayPadded}`);
  const solutionPath = join(process.cwd(), dayDir, `part${part}.ts`);
  const inputPath = inputFile ? join(process.cwd(), dayDir, inputFile) : null;

  // Ensure solution is scaffolded
  await ensureScaffolded(year, day);

  // Load expected value from file if not provided via flag
  if (expected === undefined && inputFile) {
    // Derive expected filename from input filename
    // input.txt -> expected-part1.txt
    // example.txt -> expected-example-part1.txt
    // example2.txt -> expected-example2-part1.txt
    const inputBase = inputFile.replace(/\.txt$/, '');
    const expectedFilename = inputBase === 'input'
      ? `expected-part${part}.txt`
      : `expected-${inputBase}-part${part}.txt`;
    const expectedPath = join(process.cwd(), dayDir, expectedFilename);
    if (existsSync(expectedPath)) {
      const value = (await Bun.file(expectedPath).text()).trim();
      expected = isNaN(Number(value)) ? value : Number(value);
    }
  }

  // Check if input file exists, offer to download if not
  if (inputPath && !existsSync(inputPath)) {
    if (inputFile === "input.txt") {
      console.log(`📥 Input file not found: ${inputPath}`);
      const downloaded = await downloadInput(year, day, inputPath);
      if (!downloaded) {
        console.error(`💡 You can manually create ${inputPath} with your puzzle input`);
        process.exit(1);
      }
    } else {
      console.error(`❌ Input file not found: ${inputPath}`);
      process.exit(1);
    }
  }

  // Load solution module
  let solutionModule;
  try {
    solutionModule = await import(solutionPath);
  } catch (error) {
    console.error(`❌ Failed to load solution from ${solutionPath}:`, error);
    process.exit(1);
  }

  if (typeof solutionModule.solve !== "function") {
    console.error(`❌ Solution must export a 'solve' function`);
    process.exit(1);
  }

  // Read input
  const input = rawInput !== undefined ? rawInput : await Bun.file(inputPath!).text();

  // Run solution with timing
  console.log(`\n🎄 Running ${year} Day ${day} Part ${part}`);
  if (rawInput !== undefined) {
    console.log(`📝 Raw input: ${rawInput.length > 50 ? rawInput.substring(0, 50) + '...' : rawInput}`);
  } else {
    console.log(`📄 Input: ${inputPath}`);
  }

  const startTime = performance.now();
  const result = solutionModule.solve(input);
  const endTime = performance.now();
  const duration = (endTime - startTime).toFixed(2);

  console.log(`\n⭐ Result: ${result}`);
  console.log(`⏱️  Time: ${duration}ms`);

  // Validate against expected if provided
  if (expected !== undefined) {
    const matches = String(result) === String(expected);
    if (matches) {
      console.log(`✅ Matches expected value: ${expected}`);
    } else {
      console.log(`❌ Expected: ${expected}`);
      console.log(`   Got: ${result}`);
      process.exit(1);
    }
  }

  // Store result for "aoc correct" command
  const storedArgs = await loadStoredArgs();
  storedArgs.lastResult = result;
  await Bun.write(LAST_COMMAND_FILE, JSON.stringify(storedArgs));
}

async function main() {
  const args = await parseArgs();
  if (!args) {
    // parseArgs returns null for help or errors
    // Help has already been displayed, just exit cleanly
    process.exit(0);
  }

  await runSolution(args);
}

main();
