import { daysInYear, isReleased } from "../calendar";
import { isAttempted, listYears, loadDay, stars } from "../store";
import { c, result } from "../ui";

export function status(yearFilter: number | undefined, now: number) {
  const years = yearFilter ? [yearFilter] : listYears();
  const out = years.map((year) => {
    const days = Array.from({ length: daysInYear(year) }, (_, i) => loadDay(year, i + 1));
    return {
      year,
      stars: days.reduce((n, d) => n + stars(d), 0),
      days: days.map((d) => ({
        day: d.day,
        stars: stars(d),
        attempted: isAttempted(d),
        released: isReleased(year, d.day, now),
        lang: d.lang,
      })),
    };
  });

  const human = out
    .map(({ year, stars: total, days }) => {
      const cells = days.map((d) =>
        d.stars === 2 ? c.yellow("★") : d.stars === 1 ? c.yellow("☆") : d.attempted ? c.red("·") : d.released ? c.dim("·") : " ",
      );
      const langs = days.filter((d) => d.lang).map((d) => `${d.day}:${d.lang}`).join(" ");
      return `${c.bold(String(year))} ${cells.join("")} ${String(total).padStart(2)}★  ${c.dim(langs)}`;
    })
    .join("\n");
  result({ years: out }, human || "No puzzles yet. Try `aoc next`.");
}
