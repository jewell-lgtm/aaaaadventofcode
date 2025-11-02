#!/usr/bin/env bun

import { existsSync, mkdirSync } from "fs";
import { join } from "path";

const SOLUTIONS_DIR = "solutions";

interface Args {
  year: number;
  day: number;
  part: number;
  inputFile: string;
  expected?: string | number;
}

function parseArgs(): Args | null {
  const args = process.argv.slice(2);

  if (args.length < 4) {
    console.error("Usage: aoc <year> <day> <part> <input_file> [--expected=<value>]");
    console.error("Example: aoc 2025 01 1 input.txt --expected=301");
    return null;
  }

  const year = parseInt(args[0]);
  const day = parseInt(args[1]);
  const part = parseInt(args[2]);
  const inputFile = args[3];

  if (isNaN(year) || isNaN(day) || isNaN(part)) {
    console.error("Year, day, and part must be numbers");
    return null;
  }

  if (part !== 1 && part !== 2) {
    console.error("Part must be 1 or 2");
    return null;
  }

  let expected: string | number | undefined;
  const expectedArg = args.find((arg) => arg.startsWith("--expected="));
  if (expectedArg) {
    const value = expectedArg.split("=")[1];
    expected = isNaN(Number(value)) ? value : Number(value);
  }

  return { year, day, part, inputFile, expected };
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
  const args = parseArgs();
  if (!args) {
    process.exit(1);
  }

  await runSolution(args);
}

main();
