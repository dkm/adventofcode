use std::io::{self, prelude::*, BufReader};

#[derive(Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
enum Turn {
    ROCK = 1,
    PAPER = 2,
    SCISSOR = 3,
}

#[derive(Copy, Clone)]
enum Ending {
    Win = 6,
    Draw = 3,
    Lose = 0,
}

impl Turn {
    fn from(f: u32) -> Turn {
        match f {
            1 => Turn::ROCK,
            2 => Turn::PAPER,
            3 => Turn::SCISSOR,
            _ => panic!(),
        }
    }

    fn my_turn(self, e: Ending) -> Turn {
        match e {
            Ending::Win => self.lose_over(),
            Ending::Lose => self.win_over(),
            Ending::Draw => self,
        }
    }

    fn lose_over(self) -> Turn {
        Turn::from((self as u32 % 3)+1)
    }

    fn win_over(self) -> Turn {
        Turn::from(((self as u32 +1) % 3) + 1)
    }

    fn versus(self, o: Turn) -> Ending {
        if self.lose_over() == o {
            Ending::Lose
        } else if self.win_over() == o {
            Ending::Win
        } else {
            Ending::Draw
        }
    }
}

fn main() -> io::Result<()> {
    let file = io::stdin();
    let reader = BufReader::new(file);

    let mut acc_score = 0u32;
    let mut acc_score_p2 = 0u32;

    for line in reader.lines() {
        let l = line.unwrap();
        let v: Vec<&str> = l.split(' ').collect();
        let opponent_turn = match v[0] {
            "A" => Turn::ROCK,
            "B" => Turn::PAPER,
            "C" => Turn::SCISSOR,
            _ => panic!(),
        };

        let (my_turn, e) = match v[1] {
            "X" => (Turn::ROCK, Ending::Lose),
            "Y" => (Turn::PAPER, Ending::Draw),
            "Z" => (Turn::SCISSOR, Ending::Win),
            _ => panic!(),
        };

        acc_score = acc_score + my_turn.versus(opponent_turn) as u32 + my_turn as u32;
        acc_score_p2 = acc_score_p2 + opponent_turn.my_turn(e) as u32 + e as u32;

    }
    println!("part 1 : {}", acc_score);
    println!("part 2 : {}", acc_score_p2);
    Ok(())
}

// part 1 : 12458
// part 2 : 12683
