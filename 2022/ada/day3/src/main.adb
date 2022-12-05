with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
with Ada.Containers; use Ada.Containers;

procedure Main is
  Line : Unbounded_String;

  type BitMask is array (1..52) of Boolean;
  package Bitmask_Vectors is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Bitmask);
  use Bitmask_Vectors;
 
  Function To_BitMask (S : String) return BitMask is
    A : BitMask := (others => False);
    Pos : Integer;
  begin
    for C of S loop
      if C >= 'a' and then C <= 'z' then
        Pos := Character'Pos(C) - Character'Pos('a') + 1;
      else
        Pos := Character'Pos(C) - Character'Pos('A') + 27;
      end if;
      A(Pos) := True;
    end loop;
    return A;
  end To_BitMask;

  Part1_Count : Integer := 0;
  Part2_Count : Integer := 0;
  Group : Vector;

begin
  while (not Ada.Text_IO.End_Of_File (Standard_Input)) loop
    Get_Line (Standard_Input, Line);
    Bitmask_Vectors.Append (Group, To_Bitmask (To_String (Line)));

    if Group.Length = 3 then
      declare
        Intersect : constant Bitmask := Group (1) and Group (2) and Group (3);
      begin
        for I in Intersect'Range loop
          if Intersect (I) then
            Part2_Count := Part2_Count + I;
          end if;
        end loop;
      end;
      Group.Clear;
    end if;

    declare
      Left : BitMask := To_BitMask (Slice(Line, 1, Length(Line)/2));
      Right : BitMask := To_BitMask (Slice(Line, Length(Line)/2+1, Length(Line)));
      Intersect : constant Bitmask := Left and Right;
    begin
      if Intersect /= Bitmask'(others => False) then
        for I in Intersect'Range loop
          if Intersect(I) then
            Part1_Count := Part1_Count + I;
          end if;
        end loop;
      end if;
    end;

  end loop;
  --  part 1 : 8493
  Put_Line ("Part1 " & Part1_Count'Image);
  --  part 2 : 2552
  Put_Line ("Part2 " & Part2_Count'Image);
end Main;
