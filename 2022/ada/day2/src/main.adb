--  see it live in https://godbolt.org/z/v6jE9E6EE

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is

  type Turn is (Rock, Paper, Scissor);
  for Turn use (Rock => 1, Paper => 2, Scissor => 3);

  type Ending is (Lose, Draw, Win);
  for Ending use (Win => 6, Draw => 3, Lose => 0);

  Function Lose_Over (S : Turn) return Turn is
    (Turn'Enum_Val ((Turn'Enum_Rep(S) mod 3) + 1));

  Function Win_Over (S : Turn) return Turn is
    (Turn'Enum_Val (((Turn'Enum_Rep (S) + 1) mod 3) + 1));

  Function Versus (S : Turn; O : Turn) return Ending is
  begin
    if Lose_Over (S) = O then
      return Lose;
    elsif Win_Over (S) = O then
      return Win;
    else
      return Draw;
    end if;
  end Versus;

  Function My_Turn (S : Turn; E : Ending) return Turn is
  begin
    case e is
      when Win => return Lose_Over (S);
      when Lose => return Win_Over (S);
      when Draw => return S;
    end case;
  end My_Turn;

  Acc_Score : Integer := 0;
  Acc_Score_P2 : Integer := 0;

  Line : String(1..10);
  Last : Natural;
  Op_Turn : Turn;
  M_Turn : Turn;
  Exp_Ending : Ending;

begin
  while (not Ada.Text_IO.End_Of_File (Standard_Input)) loop
    Get_Line (Standard_Input, Line, Last);

    case Line(1) is
      when 'A' =>
        Op_Turn := ROCK;
      when 'B' =>
        Op_Turn := PAPER;
      when 'C' =>
        Op_Turn := SCISSOR;
      when others =>
        pragma Assert(False);
    end case;

    case Line(3) is
      when 'X' =>
        M_Turn := ROCK;
        Exp_Ending := Lose;
      when 'Y' =>
        M_Turn := PAPER;
        Exp_Ending := Draw;
      when 'Z' =>
        M_Turn := SCISSOR;
        Exp_Ending := Win;
      when others =>
        pragma Assert(False);
    end case;

    Acc_Score := Acc_Score  + Ending'Enum_Rep (Versus (M_Turn, Op_Turn)) + Turn'Enum_Rep (M_Turn);
    Acc_Score_P2 := Acc_Score_P2 + Turn'Enum_Rep (My_Turn (Op_Turn, Exp_Ending)) + Ending'Enum_Rep (Exp_Ending);

  end loop;
  Put_Line ("Part1 " & Acc_Score'Image);
  Put_Line ("Part2 " & Acc_Score_P2'Image);
end Main;
