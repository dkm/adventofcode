--  see it live in https://godbolt.org/z/M67e7h8qs and https://godbolt.org/z/azWdPePM6

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
  Acc : Integer := 0;
  Max : Integer := 0;
  New_Val : Integer;
  Line : String(1..10);
  Last : Natural;
begin
  while (not Ada.Text_IO.End_Of_File (Standard_Input)) loop
    Get_Line (Standard_Input, Line, Last);
    if Line(1..Last) = "" then
      if Acc > Max then
        Max := Acc;
      end if;
      Acc := 0;
    else
      New_Val := Integer'Value (Line (1..Last));
      Acc := Acc + New_Val;
    end if;
  end loop;
  Put_Line (Max'Image);
end Main;
