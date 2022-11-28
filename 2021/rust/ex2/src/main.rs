use std::io;

fn main() {
    let lines = io::stdin().lines();

    let mut buckets: [Vec<u32>;3] = [Vec::new(), Vec::new(), Vec::new()];

    let mut cur: u32;
    let mut prev: u32 = 0;

    let mut first: bool = true;

    let mut count = 0u32;

    let mut init = 0;

    for line in lines {
        let l = line.unwrap();
        println!("line {}", l);
        let new: u32 = l.parse().unwrap();

        if init < 2 {
            for i in 0..init+1 {
                println!("adding {} to b[{}] (sz {})", new, i, buckets[i].len());
                buckets[i].push(new);
            }
            init = init + 1;
            continue;
        }

        for b in &mut buckets {
            println!("adding {} to b: {:?}", new, b);
            b.push(new);

            if b.len() == 3 {
                cur = b.iter().fold(0, |acc, x| acc + x);
                if !first {
                    if cur > prev {
                        count = count + 1;
                    }
                }
                first = false;
                prev = cur;
                b.clear();
            }
        }
    }
    println!("{}", count);
}
