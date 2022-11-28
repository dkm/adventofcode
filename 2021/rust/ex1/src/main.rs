use std::io;

fn main() {
    let lines = io::stdin().lines();
    let mut count = 0u32;
    let mut prev: u32 = 0;
    let mut first = true;

    for line in lines {
        let l = line.unwrap();
        println!("line {}", l);

        let new: u32 = l.parse().unwrap();

        if !first {
            if new > prev {
                count = count + 1;
            }
        }
        prev = new;
        first = false;
    }
    println!("{}", count);
}
