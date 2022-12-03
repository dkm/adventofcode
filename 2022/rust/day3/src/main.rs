use std::io::{self, prelude::*, BufReader};
use std::collections::HashSet;

fn find_shared_in_rucksack (left: &str, right: &str) -> HashSet<char>{
    let left_set: HashSet<_> = left.chars().collect();
    let right_set : HashSet<_> = right.chars().collect();

    left_set.intersection(&right_set).copied().collect()
}

fn get_prio (c: char) -> u32 {

    if c >= 'a' && c <= 'z' {
        (c as u32 - 'a' as u32) + 1
    } else {
        (c as u32 - 'A' as u32) + 27
    }
}

fn main() -> io::Result<()> {
    let file = io::stdin();
    let reader = BufReader::new(file);
    let mut prio_count = 0u32;
    let mut group : Vec<String> = Vec::new();
    let mut p2_acc = 0u32;

    for line in reader.lines() {
        let l = line.unwrap();
        let left = &l[0..l.len()/2];
        let right = &l[l.len()/2..l.len()];
        println!("line  {}", l);
        println!("left  {}", left);
        println!("right {}", right);
        let shared = find_shared_in_rucksack (left, right);
        println!("shared len: {}, {:?}", shared.len(), shared);

        prio_count = prio_count + shared.iter().map(|m| get_prio(*m)).sum::<u32>();
        group.push(l);

        if group.len() == 3 {
            let inter = group
                .iter()
                .skip(1)
                .fold(group[0].chars().collect::<HashSet<_>>().clone(), |acc, hs| {
                    acc.intersection(&hs.chars().collect::<HashSet<_>>()).cloned().collect()
                });

            println!("inter {}", inter.len());
            if (inter.len() != 1) {panic!()};
            for i in inter {
                p2_acc = p2_acc + get_prio(i);
            }
            group.clear();
        }

    }
    println!("part 1 : {}", prio_count);
    println!("part 2 : {}", p2_acc);
    Ok(())
}
// part 1 : 8493
// part 2 : 2552
