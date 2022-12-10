with Ada.Text_IO; use Ada.Text_IO;

with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with Ada.Containers.Vectors;
with Ada.Containers; use Ada.Containers;

procedure Main is
  subtype Col_Range is Positive range 1 .. 99;
  subtype Row_Range is Positive range 1 .. 99;

  type Tree_Visible_Array is array (Row_Range, Col_Range) of Boolean;
  Visible_Tree : Tree_Visible_Array := (
    Row_Range'First => (others => True),
    Row_Range'Last => (others => True),
    others => (Col_Range'First => True, Col_Range'Last => True, others => False));

  type Tree_Map_Height_T is array (Row_Range, Col_Range) of Natural;
  Tree_Map : Tree_Map_Height_T := (others => (others => 0));
  F : File_Type;

  procedure Load_Map (F : File_Type) is
    R : Row_Range := Row_Range'First;
    C : Positive := Col_Range'First;
    Digit : Character;
    EOL : Boolean;
  begin
    while (not Ada.Text_IO.End_Of_File (F)) loop
      Look_Ahead (F, Digit, EOL);

      if EOL then
        Skip_Line (F);
        R := R + 1;
        C := Col_Range'First;
      else
        Get (F, Digit);
        Tree_Map (R, C) := Integer'Value((1=>Digit));
        C := C + 1;
      end if;
    end loop;
  end Load_Map;

  procedure Create_Visible_Map is
    Prev : Natural := 0;
  begin
    
    for C in Col_Range loop
      Prev := 0;
      for R in Row_Range loop
        if Prev < Tree_Map (R, C) then
          Visible_Tree (R, C) := True;
          Prev := Tree_Map (R, C);
        end if;
      end loop;
    end loop;

    for C in Col_Range loop
      Prev := 0;
      for R in reverse Row_Range loop
        if Prev < Tree_Map (R, C) then
          Visible_Tree (R, C) := True;
          Prev := Tree_Map (R, C);
        end if;
      end loop;
    end loop;

    for R in Row_Range loop
      Prev := 0;
      for C in reverse Col_Range loop
        if Prev < Tree_Map (R, C) then
          Visible_Tree (R, C) := True;
          Prev := Tree_Map (R, C);
        end if;
      end loop;
    end loop;

    for R in Row_Range loop
      Prev := 0;
      for C in Col_Range loop
        if Prev < Tree_Map (R, C) then
          Visible_Tree (R, C) := True;
          Prev := Tree_Map (R, C);
        end if;
      end loop;
    end loop;
  end Create_Visible_Map;

  function Count_Visible return Natural is
    Count : Natural := 0;
  begin
    for R in Row_Range loop
      for C in Col_Range loop
        if Visible_Tree (R, C) then
          Count := Count + 1;
        end if;
      end loop;
    end loop;

    return Count;
  end Count_Visible;

  procedure Print_Tree_Map is
    Line : Unbounded_String;
  begin
    for R in Row_Range loop
      Line := To_Unbounded_String ("");
      for C in Col_Range loop
        Append (Line, Tree_Map (R, C)'Image);
      end loop;
      Put_Line (Line);

    end loop;
  end Print_Tree_Map;

  procedure Print_Visible_Map is
    Line : Unbounded_String;
  begin
    for R in Row_Range loop
      Line := To_Unbounded_String ("");
      for C in Col_Range loop
        if Visible_Tree (R, C) then
          Append (Line, Tree_Map (R, C)'Image);
        else
          Append (Line, "  ");
        end if;
      end loop;
      Put_Line (Line);

    end loop;
  end Print_Visible_Map;

  function Get_Score_At (R : Row_Range; C : Col_Range) return Natural is
    Me : Natural renames Tree_Map (R, C);
    Count : Natural;
    Res : Natural := 1;
  begin
    Count := 0;
    for O in R+1 .. Row_Range'Last loop
      Count := Count + 1;
      if Me <= Tree_Map (O, C) then
        exit;
      end if;
    end loop;
    Res := Res * Count;

    Count := 0;
    for O in reverse Row_Range'First .. R-1 loop
      Count := Count + 1;
      if Me <= Tree_Map (O, C) then
        exit;
      end if;
    end loop;
    Res := Res * Count;

    Count := 0;
    for O in reverse Col_Range'First .. C-1 loop
      Count := Count + 1;
      if Me <= Tree_Map (R, O) then
        exit;
      end if;
    end loop;

    Res := Res * Count;

    Count := 0;
    for O in C+1 .. Col_Range'Last loop
      Count := Count + 1;
      if Me <= Tree_Map (R, O) then
        exit;
      end if;
    end loop;

    Res := Res * Count;

    return Res;
  end Get_Score_At;

  function Get_Max_Score return Natural is
    Max : Natural := 0;
    Score : Natural := 0;
  begin
    for R in Row_Range'First + 1 .. Row_Range'Last - 1 loop
      for C in Col_Range'First + 1 .. Col_Range'Last - 1 loop
        Score := Get_Score_At (R, C);
        if Score > Max then
          Max := Score;
        end if;
      end loop;
    end loop;
    return Max;
  end Get_Max_Score;

begin
  Open (F, In_File, "input");
  Load_Map (F);
  Close (F);

  Print_Tree_Map;
  Put_Line ("");
  Create_Visible_Map;
  Print_Visible_Map;
  Put_Line ("Part 1: " & Count_Visible'Image);
  Put_Line ("Part 2: " & Get_Max_Score'Image);
end Main;