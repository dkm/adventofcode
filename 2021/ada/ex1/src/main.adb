with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   New_Val : Integer;
   Prev_Val : Integer;
   First : Boolean := True;
   Count : Integer := 0;
begin
   while (not Ada.Text_IO.End_Of_File (Standard_Input)) loop
     Get(Standard_Input, New_Val);
     if not First then
        if New_Val > Prev_Val then
           Count := Count + 1;
        end if;
     end If;
     First := False;
     Prev_Val := New_Val;
   end loop;
   Put_Line (Count'Image);
end Main;