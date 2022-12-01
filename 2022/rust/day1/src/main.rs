use std::io;

fn main() {
    let lines = io::stdin().lines();
    let mut acc = 0u32 ;
    let mut max = 0u32;
    let mut all_counts : Vec<u32> = Vec::new();

    for line in lines {
        let l = line.unwrap();
        match l.parse::<u32>() {
            Ok(v) => acc = v + acc,
            _ => {
                if acc > max { max = acc; };
                all_counts.push(acc);
                acc = 0;
            }
        }
    }
    all_counts.sort();
    all_counts.reverse();
    println!("part 1 : {}", max);
    println!("part 2 : {}", all_counts[0] + all_counts[1] + all_counts[2]);
}
