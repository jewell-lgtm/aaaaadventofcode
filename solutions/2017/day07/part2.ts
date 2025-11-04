import assert from "assert";

export function solve(input: string): number | string {
  interface Node {
    name: string;
    weight: number;
    children: string[];
  }
  const nodes = input
    .trim()
    .split("\n")
    .map((line): Node => {
      const [first, second] = line.split("->");
      const [nodeName, weightLike] = first.split(" ");
      const [_, weightStr] = weightLike.match(/\((\d+)\)/) || [];
      const children =
        second
          ?.trim()
          ?.split(",")
          ?.map((it) => it.trim()) ?? [];
      return {
        name: nodeName,
        weight: parseInt(weightStr, 10),
        children,
      };
    });

  const hasParent = new Map<string, string>();
  const nodeMap = new Map<string, Node>();
  for (const node of nodes) {
    nodeMap.set(node.name, node);
    if (node.children.length === 0) continue;
    for (const child of node.children) {
      if (!hasParent.has(child)) {
        hasParent.set(child, node.name);
      } else {
        throw new Error(`Node ${child} has multiple parents`);
      }
    }
  }

  const hasNoParent = nodes.filter(({ name }) => !hasParent.has(name));
  assert(hasNoParent.length === 1);

  function findUnbalancedChild(node: Node): Node | null {
    const weights = node.children.map((name) => findWeight(name));
    if (allEqual(weights)) return null;
    const targetWeight = findSingle(weights);
    for (let i = 0; i < weights.length; i++) {
      if (weights[i] !== targetWeight) continue;
      return nodeMap.get(node.children[i])!;
    }
    throw new Error("Unreachable");
  }

  const nodeWeights = new Map<string, number>();
  function findWeight(name: string): number {
    if (nodeWeights.has(name)) return nodeWeights.get(name)!;
    const node = nodeMap.get(name)!;
    const totalWeight = sum([
      node.weight,
      ...node.children.map((childName) => findWeight(childName)),
    ]);
    nodeWeights.set(name, totalWeight);
    return totalWeight;
  }

  let traverse = hasNoParent[0];
  while (traverse) {
    const unbalancedChild = findUnbalancedChild(traverse);
    // the root node has to have an unbalanced child
    if (!unbalancedChild) throw new Error("Unbalanced child expected");
    if (findUnbalancedChild(unbalancedChild)) {
      traverse = unbalancedChild;
    } else {
      // this node is unbalanced, but all of its children are balanced, this is the problem node
      const parentWeights = traverse.children.map((name) => findWeight(name));
      const thisWeight = findWeight(unbalancedChild.name);
      const targetWeight = new Set(parentWeights)
        .difference(new Set([thisWeight]))
        .values()
        .next().value!;
      const nodeWeightDiff = targetWeight - thisWeight;

      return unbalancedChild.weight + nodeWeightDiff;
    }
  }
}

function allEqual<T>(arr: T[]): boolean {
  if (arr.length === 0) return true;
  const first = arr[0];
  return arr.every((item) => item === first);
}

function findSingle<T>(arr: T[]): T {
  const frequency = new Map<T, number>();
  for (const item of arr) {
    if (!frequency.has(item)) {
      frequency.set(item, 1);
    } else {
      frequency.set(item, frequency.get(item)! + 1);
    }
  }
  for (const [item, count] of frequency.entries()) {
    if (count === 1) return item;
  }
  throw new Error("No single item found");
}

function sum(arr: number[]): number {
  return arr.reduce((a, b) => a + b, 0);
}
