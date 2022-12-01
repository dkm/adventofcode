with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Containers.Vectors; use Ada.Containers;

procedure Main_Part2 is

  package IVector is new Vectors
    (Index_Type   => Natural,
     Element_Type => Integer);

  package Sorter is new IVector.Generic_Sorting;
  All_Counts : IVector.Vector;

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
      All_Counts.Append (Acc);
      Acc := 0;
    else
      New_Val := Integer'Value (Line (1..Last));
      Acc := Acc + New_Val;
    end if;
  end loop;

  Sorter.Sort (All_Counts);
  All_Counts.Reverse_Elements;
  Acc := All_Counts (0) + All_Counts (1) + All_Counts (2);
  Put_Line (Acc'Image);
end Main_Part2;
