//! humn appears once in the tree. Walk from root towards it, inverting each
//! operation against the value of the other (fully known) subtree.
use crate::part1::{Job, Tribe, eval, parse};
use std::fmt::Display;

pub fn solve(input: &str) -> impl Display {
    let tribe = parse(input);
    let Job::Math(a, _, b) = tribe["root"] else {
        panic!("root must be an operation")
    };
    if has_human(&tribe, a) {
        solve_for(&tribe, a, eval(&tribe, b))
    } else {
        solve_for(&tribe, b, eval(&tribe, a))
    }
}

fn has_human(tribe: &Tribe, name: &str) -> bool {
    name == "humn"
        || matches!(tribe[name], Job::Math(a, _, b) if has_human(tribe, a) || has_human(tribe, b))
}

/// The humn value that makes the subtree at `name` evaluate to `target`.
fn solve_for(tribe: &Tribe, name: &str, target: i64) -> i64 {
    let Job::Math(a, op, b) = tribe[name] else {
        return target;
    }; // only humn is reached as a leaf
    if has_human(tribe, a) {
        let known = eval(tribe, b);
        let target = match op {
            b'+' => target - known,
            b'-' => target + known,
            b'*' => target / known,
            _ => target * known,
        };
        solve_for(tribe, a, target)
    } else {
        let known = eval(tribe, a);
        let target = match op {
            b'+' => target - known,
            b'-' => known - target,
            b'*' => target / known,
            _ => known / target,
        };
        solve_for(tribe, b, target)
    }
}
