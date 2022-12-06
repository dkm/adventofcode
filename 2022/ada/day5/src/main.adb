--  see it live in https://godbolt.org/z/hK5WMGnPY

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with Ada.Containers.Vectors;
with Ada.Containers; use Ada.Containers;

procedure Main is
  package Stack_Vector is new
    Ada.Containers.Vectors
      (Index_Type   => Positive,
       Element_Type => Character);
  use Stack_Vector;

  subtype Stack_Index is Positive range 1 .. 9;
  type Stacks is array (Stack_Index) of aliased Vector;
  All_Stacks : Stacks;

  F : File_Type;

  Initial_state : Boolean := False;

  function Read_Initial_State return Boolean is
    Omit : Character;
    Value : Character;

  begin
    if Initial_state then
      return False;
    end if;

    for I in Stack_Index loop
      Get (F, Omit);
      Get (F, Value);

      --  Checks for end of init condition
      if not (Value in 'A' .. 'Z' | ' ') then
        Skip_Line (F);
        Initial_state := True;
        return False;
      end if;

      Get (F, Omit);
      if I < Stacks'Last then
        Get (F, Omit);
      end if;
      if Value /= ' ' then
        Prepend (All_Stacks(I), Value);
      end if;
    end loop;
    return True;
  end Read_Initial_State;

  type Command is record
    Num : Positive;
    Source : Stack_Index;
    Dest : Stack_Index;
  end record;

  procedure Read_Command (C : out Command) is
    Omit_Word4 : String(1..5);
    Omit_Word2 : String(1..2);
    Omit_Space : Character;
    Num, Source, Dest : Positive;
  begin
    Get (F, Omit_Word4);

    Get (F, Num);

    Get (F, Omit_Space);
    Get (F, Omit_Word4);

    Get (F, Source);

    Get (F, Omit_Space);
    Get (F, Omit_Word2);

    Get (F, Dest);
    C := (Num => Num, Source => Source, Dest => Dest);

  end Read_Command;

  procedure Execute_Command (C : Command; Is_9001 : Boolean := False) is
    Stash : aliased Vector;
    Effective_Stack : access Vector;
  begin
    if Is_9001 then
      Effective_Stack := Stash'Access;
    else
      Effective_Stack := All_Stacks (C.Dest)'Access;
    end if;

    for I in 1 .. C.Num loop
      Append (Effective_Stack.all, Last_Element (All_Stacks (C.Source)));
      Delete_Last (All_Stacks (C.Source));
    end loop;

    if Is_9001 then
      for I in 1 .. Length (Stash) loop
        Append ( All_Stacks (C.Dest), Last_Element (Stash));
        Delete_Last (Stash);
      end loop;
    end if;
  end Execute_Command;

  procedure Print_Top_Stack is
    S : String(1..9);
  begin
    for I in Stack_Index loop
      S (I) := Last_Element (All_Stacks (I));
    end loop;
    Put_Line (S);
  end Print_Top_Stack;

  C : Command;

  procedure Reset is
  begin
    Initial_state := False;
    for V of All_Stacks loop
      Clear (V);
    end loop;
  end Reset;

  procedure Do_Part (Is_Part1 : Boolean) is
  begin
    Open (F, In_File, "input");
     
    while (not Ada.Text_IO.End_Of_File (F)) and then Read_Initial_State loop
      null;
    end loop;
     
    --  empty line
    Skip_Line (F);
     
    while (not Ada.Text_IO.End_Of_File (F)) loop
      Read_Command (C);
      Execute_Command (C, not Is_Part1);
    end loop;
    Close (F);
     
    Print_Top_Stack;
  end Do_Part;

begin
  Do_Part (False);
  Reset;
  Do_Part (True);
end Main;
