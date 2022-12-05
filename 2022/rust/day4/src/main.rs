use std::io::{self, prelude::*, BufReader};
use std::collections::HashSet;

struct Range {
    low: u32,
    high: u32,
}

impl Range {
    fn is_subset_of (&self, other: &Range) -> bool {
        self.low >= other.low && self.high <= other.high
    }
    fn overlaps_with (&self, other: &Range) -> bool {
        self.low <= other.low && self.high >= other.low ||
            other.low <= self.low && other.high >= self.low
    }
}

fn one_is_subrange (r1: &Range, r2: &Range) -> bool {
    r1.is_subset_of(r2) || r2.is_subset_of(r1)
}

fn main() -> io::Result<()> {
    let file = io::stdin();
    let reader = BufReader::new(file);
    let mut subrange_count = 0u32;
    let mut overlap_count = 0u32;

    for line in reader.lines() {
        let l = line.unwrap();
        let pair: Vec<&str> = l.split(',').collect();
        let rs : Vec<Range>= pair.into_iter().map(|r| {
           let v = r.split('-').collect::<Vec<&str>>();
           Range {
               low: v[0].parse::<u32>().unwrap(),
               high: v[1].parse::<u32>().unwrap(),
           }
        }).collect();
        if one_is_subrange (&rs[0], &rs[1]) {
            subrange_count = subrange_count + 1;
        }
        if rs[0].overlaps_with(&rs[1]) {
            overlap_count = overlap_count + 1;
        }

    }
    println!("part 1 : {}", subrange_count);
    println!("part 2 : {}", overlap_count);
    Ok(())
}
// part 1 : 584
// part 2 : 933
