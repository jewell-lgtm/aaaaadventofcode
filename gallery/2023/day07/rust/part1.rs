//! A Hand struct whose field order *is* the ranking: #[derive(Ord)] compares
//! the count shape (e.g. [3, 2] = full house) first, then card values. Then just sort.
use std::collections::HashMap;
use std::fmt::Display;

#[derive(PartialEq, Eq, PartialOrd, Ord)]
struct Hand {
    shape: Vec<usize>,  // card counts, largest first
    values: Vec<usize>, // card strengths in hand order
    bid: usize,
}

pub fn solve(input: &str) -> impl Display {
    total_winnings(input, "23456789TJQKA", false)
}

pub fn total_winnings(input: &str, order: &str, jokers: bool) -> usize {
    let mut hands: Vec<Hand> = input
        .lines()
        .map(|line| {
            let (cards, bid) = line.split_once(' ').unwrap();
            Hand {
                shape: shape(cards, jokers),
                values: cards.chars().map(|c| order.find(c).unwrap()).collect(),
                bid: bid.parse().unwrap(),
            }
        })
        .collect();
    hands.sort();
    hands
        .iter()
        .zip(1..)
        .map(|(hand, rank)| hand.bid * rank)
        .sum()
}

/// Card counts sorted descending. With jokers, J joins the biggest group.
fn shape(cards: &str, jokers: bool) -> Vec<usize> {
    let mut counts: HashMap<char, usize> = HashMap::new();
    for c in cards.chars() {
        *counts.entry(c).or_default() += 1;
    }
    let wild = if jokers {
        counts.remove(&'J').unwrap_or(0)
    } else {
        0
    };
    let mut shape: Vec<usize> = counts.into_values().collect();
    shape.sort_unstable_by(|a, b| b.cmp(a));
    match shape.first_mut() {
        Some(top) => *top += wild,
        None => shape.push(wild), // JJJJJ
    }
    shape
}
