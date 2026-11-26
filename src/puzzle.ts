// Puzzle page HTML → markdown, examples and already-accepted answers.
// AoC markup is small and regular (h2, p, pre>code, code, em, a, ul>li, span), so regexes do.

export interface Article {
  part: 1 | 2;
  html: string;
}

export function articles(html: string): Article[] {
  return [...html.matchAll(/<article class="day-desc">([\s\S]*?)<\/article>/g)].map((m, i) => ({ part: (i + 1) as 1 | 2, html: m[1] }));
}

export const title = (html: string) => html.match(/<h2>--- Day \d+: (.*?) ---<\/h2>/)?.[1];

/** "Your puzzle answer was <code>X</code>." per solved part, in order. */
export function acceptedAnswers(html: string): string[] {
  return [...html.matchAll(/Your puzzle answer was <code>(.*?)<\/code>/g)].map((m) => decode(m[1]));
}

export function decode(s: string): string {
  return s
    .replace(/<[^>]+>/g, "")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#39;|&apos;/g, "'")
    .replace(/&nbsp;/g, " ")
    .replace(/&amp;/g, "&");
}

export function toMarkdown(html: string, year: number, day: number): string {
  const parts = articles(html).map(({ html: a }) =>
    a
      .replace(/<h2[^>]*>--- (.*?) ---<\/h2>/g, "\n## $1\n\n")
      .replace(/<pre><code>([\s\S]*?)<\/code><\/pre>/g, (_, code) => `\n\`\`\`\n${decode(code).replace(/\n$/, "")}\n\`\`\`\n\n`)
      .replace(/<code><em>(.*?)<\/em><\/code>|<em><code>(.*?)<\/code><\/em>/g, (_, a, b) => `**\`${decode(a ?? b)}\`**`)
      .replace(/<code>(.*?)<\/code>/g, (_, code) => `\`${decode(code)}\``)
      .replace(/<em class="star">(.*?)<\/em>/g, "*$1*")
      .replace(/<em>(.*?)<\/em>/g, "**$1**")
      .replace(/<a href="([^"]*)"[^>]*>(.*?)<\/a>/g, (_, href, text) => `[${text}](${href.startsWith("/") ? "https://adventofcode.com" + href : href})`)
      .replace(/<li>/g, "- ")
      .replace(/<\/?(ul|li|p|span)[^>]*>/g, (t) => (t.startsWith("</p") || t.startsWith("</li") ? "\n" : ""))
      .replace(/<[^>]+>/g, ""),
  );
  const answers = acceptedAnswers(html).map((a, i) => `> Part ${i + 1} answer: \`${a}\``);
  const body = parts.map((p) => decodeEntitiesOnly(p)).join("\n");
  return `# ${year} day ${day}\n<https://adventofcode.com/${year}/day/${day}>\n${body}\n${answers.join("\n")}\n`.replace(/\n{3,}/g, "\n\n");
}

const decodeEntitiesOnly = (s: string) => decode(s.replace(/</g, "\u0000")).replace(/\u0000/g, "<");

export interface ExtractedExample {
  text: string;
  part1?: string;
  part2?: string;
  /** Low confidence: no "example" sentence before the block, or no emphasised answer found. */
  confident: boolean;
  /** The text says the example uses different constants ("in this example ... only 7 tiles"). */
  constantsDiffer: boolean;
}

interface Found {
  text: string;
  answer?: string;
  confident: boolean;
}

/** Emphasised answer: <code><em>42</em></code>, <em><code>42</code></em>, or <code>1749 - 161 = <em>1588</em></code>. */
const EM_CODE = /<code>[^<]*<em>(.*?)<\/em>[^<]*<\/code>|<em><code>(.*?)<\/code><\/em>/g;

/** Block example: first <pre><code> after a paragraph mentioning "example"; expected = last <code><em> in the article. */
function blockExample(a: string): Found | undefined {
  const blocks = [...a.matchAll(/<pre><code>([\s\S]*?)<\/code><\/pre>/g)];
  const ems = [...a.matchAll(EM_CODE)];
  const answer = ems.length ? decode(ems[ems.length - 1][1] ?? ems[ems.length - 1][2]) : undefined;
  for (const b of blocks) {
    const before = a.slice(Math.max(0, b.index! - 400), b.index!);
    if (/example/i.test(before.slice(before.lastIndexOf("<p>")))) return { text: decode(b[1]), answer, confident: answer !== undefined };
  }
  return blocks.length ? { text: decode(blocks[0][1]), answer, confident: false } : undefined;
}

/** Inline list examples: <li><code>(())</code> and <code>()()</code> both result in floor <code>0</code>.</li> */
function listExamples(a: string): Found[] {
  const out: Found[] = [];
  for (const [, li] of a.matchAll(/<li>([\s\S]*?)<\/li>/g)) {
    const codes = [...li.matchAll(/<code>(.*?)<\/code>/g)];
    if (codes.length < 2 || !li.trimStart().startsWith("<code>")) continue;
    let i = 0;
    const inputs = [codes[0]];
    while (i + 1 < codes.length && /^(,\s*|\s*(,\s*)?(and|or)\s+)$/.test(li.slice(codes[i].index! + codes[i][0].length, codes[i + 1].index))) inputs.push(codes[++i]);
    const answer = codes[i + 1];
    if (!answer) continue;
    for (const inp of inputs) out.push({ text: decode(inp[1]), answer: decode(answer[1]), confident: true });
  }
  return out;
}

const articleExamples = (a: string): Found[] => {
  const block = blockExample(a);
  const list = listExamples(a);
  return block?.confident || !list.length ? (block ? [block] : []) : list;
};

/** The text says the example uses different constants ("70,70 in your memory space, but 6,6 in this example"). */
function constantsDiffer(a: string): boolean {
  return decode(a)
    .split(/(?<=[.!?])\s+/)
    .some((s) => /example/i.test(s) && /\d/.test(s) && /\b(but|only|instead|rather)\b/i.test(s));
}

export function extractExamples(html: string): ExtractedExample[] {
  const arts = articles(html);
  const out: ExtractedExample[] = [];
  const differ = arts.some((a) => constantsDiffer(a.html));
  for (const { part, html: a } of arts) {
    let found = articleExamples(a);
    if (!found.length && part === 2 && out[0]) {
      // No new example block: part 2 states the answer for the part 1 example.
      const ems = [...a.matchAll(EM_CODE)];
      if (ems.length) found = [{ text: out[0].text, answer: decode(ems[ems.length - 1][1] ?? ems[ems.length - 1][2]), confident: out[0].confident }];
    }
    for (const f of found) {
      const key = part === 1 ? "part1" : "part2";
      // Part 2 often states only the new answer for the same example; a reused or unclear block attaches to example 1.
      const same = out.find((e) => e.text === f.text) ?? (part === 2 && !f.confident && found.length === 1 ? out[0] : undefined);
      if (same) {
        same[key] = f.answer;
        same.confident &&= f.confident;
      } else out.push({ text: f.text, [key]: f.answer, confident: f.confident, constantsDiffer: differ });
    }
  }
  return out;
}
