with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
  type Section_Range is record
    Low : Positive;
    High: Positive;
  end record;

  function Is_Subset_Of (S : Section_Range; O : Section_Range) return Boolean
  is (S.low >= o.low and then S.high <= O.high);

  function Overlaps_With (S : Section_Range; O : Section_Range) return Boolean
  is ((S.low <= O.low and then S.high >= O.low)
         or else (O.low <= S.low and then O.high >= S.low));

  function One_Is_Subrange (S : Section_Range; O : Section_Range) return Boolean
  is (Is_Subset_Of (S, O) or else Is_Subset_Of (O, S));

  R1 : Section_Range;
  R2 : Section_Range;

  function Read_Section (F : File_Type) return Section_Range is
    Low : Positive;
    High : Positive;
    Omit : Character;
  begin
    Get (F, Low);
    Get (F, Omit);
    Get (F, High);
    return (Low => Low, High => High);
  end Read_Section;

  F : File_Type := Standard_Input;
  Omit : Character;

  Subrange_Count : Natural := 0;
  Overlaps_Count : Natural := 0;

begin
  while (not Ada.Text_IO.End_Of_File (F)) loop
    R1 := Read_Section (F);
    Get (F, Omit);
    R2 := Read_Section (F);

    if One_Is_Subrange (R1, R2) then
      Subrange_Count := Subrange_Count + 1;
    end if;

    if Overlaps_With (R1, R2) then
      Overlaps_Count := Overlaps_Count + 1;
    end if;
  end loop;

  --  part 1 : 584
  Put_Line ("Part1 " & Subrange_Count'Image);
  --  part 2 :933
  Put_Line ("Part2 " & Overlaps_Count'Image);
end Main;
