// humn appears once in the tree. Walk from root towards it, inverting each
// operation against the value of the other (fully known) subtree.
package main

func part2(input string) any {
	t := parseTribe(input)
	root := t["root"]
	if t.hasHuman(root.left) {
		return t.solveFor(root.left, t.eval(root.right))
	}
	return t.solveFor(root.right, t.eval(root.left))
}

func (t tribe) hasHuman(name string) bool {
	if name == "humn" {
		return true
	}
	j := t[name]
	return j.op != 0 && (t.hasHuman(j.left) || t.hasHuman(j.right))
}

// solveFor returns the humn value that makes the subtree at name equal target.
func (t tribe) solveFor(name string, target int) int {
	if name == "humn" {
		return target
	}
	j := t[name]
	if t.hasHuman(j.left) {
		known := t.eval(j.right)
		switch j.op {
		case '+':
			return t.solveFor(j.left, target-known)
		case '-':
			return t.solveFor(j.left, target+known)
		case '*':
			return t.solveFor(j.left, target/known)
		default:
			return t.solveFor(j.left, target*known)
		}
	}
	known := t.eval(j.left)
	switch j.op {
	case '+':
		return t.solveFor(j.right, target-known)
	case '-':
		return t.solveFor(j.right, known-target)
	case '*':
		return t.solveFor(j.right, target/known)
	default:
		return t.solveFor(j.right, known/target)
	}
}
