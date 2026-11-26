import assert from "assert";

export function solve(input: string): number | string {
  const nodes = input
    .trim()
    .split("\n")
    .map((line) => {
      const [first, second] = line.split("->");
      const [nodeName] = first.split(" (");
      const children = second
        ?.trim()
        ?.split(",")
        ?.map((it) => it.trim());
      return { nodeName, children };
    });
  const hasParent = new Map<string, Set<string>>();
  for (const node of nodes) {
    if (node.children == undefined) continue;
    for (const child of node.children) {
      if (!hasParent.has(child)) {
        hasParent.set(child, new Set([node.nodeName]));
      } else {
        hasParent.get(child)!.add(node.nodeName);
      }
    }
  }

  const hasNoParent = nodes.filter(({ nodeName }) => !hasParent.has(nodeName));
  assert(hasNoParent.length === 1);

  return hasNoParent[0].nodeName;
}
