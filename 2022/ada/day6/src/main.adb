--  see it live in https://godbolt.org/z/rj3jWcEf6
with Ada.Text_IO; use Ada.Text_IO;
with Proto_Seq;

procedure Main is

  type Part1_Imod is mod 4;
  subtype Part1_Indexes is Part1_Imod range 0 .. 3;

  package Part1_Proto is new Proto_Seq (Part1_Indexes);

  type Part2_Imod is mod 14;
  subtype Part2_Indexes is Part2_Imod range 0 .. 13;
  package Part2_Proto is new Proto_Seq (Part2_Indexes);

begin
  Put_Line ("Part 1 : " & Part1_Proto.Do_The_Work'Image);
  Put_Line ("Part 2 : " & Part2_Proto.Do_The_Work'Image);
end Main;
