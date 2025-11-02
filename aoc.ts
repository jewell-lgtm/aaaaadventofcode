#!/usr/bin/env bun

import { existsSync, mkdirSync } from "fs";
import { join } from "path";

const SOLUTIONS_DIR = "solutions";
const LAST_COMMAND_FILE = ".aoc-last";

interface Args {
  year: number;
  day: number;
  part: number;
  inputFile: string;
  expected?: string | number;
}

interface StoredArgs {
  year?: number;
  day?: number;
  part?: number;
  inputFile?: string;
  expected?: string | number;
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

async function parseArgs(): Promise<Args | null> {
  const args = process.argv.slice(2);

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
        inputFile: "input.txt"
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
        expected: stored.expected
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

  // Check if we have all required values
  if (!merged.year || !merged.day || !merged.part || !merged.inputFile) {
    if (args.length === 0) {
      console.error("Usage: aoc --year=<year> --day=<day> --part=<part> --input=<file> [--expected=<value>]");
      console.error("   or: aoc         (rerun last command)");
      console.error("   or: aoc next    (run next puzzle after last)");
      console.error("   or: aoc today   (run today's puzzle)");
      console.error("Example: aoc --year=2024 --day=01 --part=1 --input=input.txt");
    } else {
      console.error("❌ Missing required parameters. Need: year, day, part, input");
      console.error(`   Current: year=${merged.year}, day=${merged.day}, part=${merged.part}, input=${merged.inputFile}`);
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
  const { year, day, part, inputFile, expected } = args;
  const dayPadded = day.toString().padStart(2, "0");
  const dayDir = join(SOLUTIONS_DIR, year.toString(), `day${dayPadded}`);
  const solutionPath = join(process.cwd(), dayDir, `part${part}.ts`);
  const inputPath = join(process.cwd(), dayDir, inputFile);

  // Ensure solution is scaffolded
  await ensureScaffolded(year, day);

  // Check if input file exists, offer to download if not
  if (!existsSync(inputPath)) {
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
  const input = await Bun.file(inputPath).text();

  // Run solution with timing
  console.log(`\n🎄 Running ${year} Day ${day} Part ${part}`);
  console.log(`📄 Input: ${inputPath}`);

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
}

async function main() {
  const args = await parseArgs();
  if (!args) {
    process.exit(1);
  }

  await runSolution(args);
}

main();
