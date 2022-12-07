with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Proto_Seq is

  type Data_Type is array (Indexes) of Character;
   
  type Ring_Buffer is record
    Next_In : Indexes;
    Data : Data_Type;
  end record;
   
  procedure Push (R : in out Ring_Buffer; E : Character) is
  begin
    R.Data (R.Next_In) := E;
    R.Next_In := R.Next_In + Indexes (1);
  end Push;
   
  function Unique_Count (R : Ring_Buffer) return Natural is
    C : Natural := 0;
    Unique : Boolean := True;
  begin
    for A in 0 .. Indexes'Last loop
      Unique := True;
      inner: for B in A + 1 .. Indexes'Last loop
        if R.Data (A) = R.Data (B) then
          Unique := False;
          exit inner;
        end if;
      end loop inner;
      if Unique then
        C := C + 1;
      end if;
    end loop;
    return C;
  end Unique_Count;
   

  Line : Unbounded_String;

  Fifo : Ring_Buffer := (Data => (others => ' '), others => 0);

  function Do_The_Work return Natural is
    Cur : Character;
    Read_Count : Natural := 0;
    F : File_Type;
  begin
    Open (F, In_File, "input");

    while (not Ada.Text_IO.End_Of_File (F)) loop
      Get (F, Cur);
      Read_Count := Read_Count + 1;
      Push (Fifo, Cur);
     
      if Unique_Count (Fifo) = Integer (Indexes'Last) and then Read_Count > Integer (Indexes'Last) then
        exit;
      end if;
    end loop;
    Close (F);
    return Read_Count;
  end Do_The_Work;
end Proto_Seq;
