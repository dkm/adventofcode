--  see it live https://godbolt.org/z/dMo3r68fb

with Ada.Text_IO; use Ada.Text_IO;

with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

with Ada.Containers.Vectors;
with Ada.Containers; use Ada.Containers;

procedure Main is
  type Node_Type is (Dir, File);

  type Node;
  type Node_Access is access all Node;

  package Node_Vector is new
    Ada.Containers.Vectors
      (Index_Type   => Positive,
       Element_Type => Node_Access);

  type Node (T : Node_Type) is record
    Name : Unbounded_String;
    Parent : Node_Access := null;
    Size : Natural := 0;

    case T is
    when Dir =>
      Nodes : Node_Vector.Vector;
    when File =>
      null;
    end case;
  end record;

  Root : aliased Node := (T => Dir, Name => To_Unbounded_String ("/"), Nodes => <>, others => <>);

  procedure Load_FS is
    C : Character;
    Command : Unbounded_String;
    Dir_Name : Unbounded_String;
    New_Directory : Unbounded_String;

    EOL : Boolean;
    F : File_Type;
    File_Name : Unbounded_String;
    File_Size : Natural;

    Dir_Stack : Node_Vector.Vector;
    Cur_Node_Access : Node_Access := Root'Access;
    Tmp : Node_Access;

  begin
    open (F, In_File, "input");
    Node_Vector.Append (Dir_Stack, Cur_Node_Access);

    Skip_Line (F); --  cd /

    while (not Ada.Text_IO.End_Of_File (F)) loop
      Look_Ahead (F, C, EOL);

      case C is
      when '$' =>
        Get (F, C); -- $
        Get (F, C); -- ' '
        Look_Ahead (F, C, EOL);

        if C = 'c' then
          Get (F, C); -- c
          Get (F, C); -- d
          Get (F, C); -- ' '

          Look_Ahead (F, C, EOL);

          if C = '.' then
            Skip_Line (F); -- ..
            Dir_Stack.Delete_Last;
            Cur_Node_Access := Node_Vector.Last_Element (Dir_Stack);

          else
            Get_Line (F, New_Directory);
            Tmp := new Node'(T => Dir, Name => New_Directory, others => <>);
            Node_Vector.Append (Cur_Node_Access.all.Nodes, Tmp);
            Cur_Node_Access := Tmp;
            Node_Vector.Append (Dir_Stack, Cur_Node_Access);
          end if;

        else
          Skip_Line (F); -- ls
        end if;

      when 'd' =>
        Get (F, C); -- d
        Get (F, C); -- i
        Get (F, C); -- r
        Get (F, C); -- ' '
        Get_Line (F, Dir_Name);
        --  omit this for now.

      when others =>
        Get (F, File_Size);
        Get (F, C);
        Get_Line (F, File_Name);
        Node_Vector.Append (Cur_Node_Access.all.Nodes,
          new Node'(T => File, Name => File_Name, Size => File_Size, Parent => Cur_Node_Access));
      end case;
    end loop;

    close (F);
  end Load_FS;

  procedure Dump_FS (N : Node_Access; Indent : Natural := 0) is
  begin
    for I in 0 .. Indent loop
      Put (" ");
    end loop;

    case N.all.T is
    when File =>
      Put_Line ("- [F] '" & N.all.Name'Image & "' : " & N.all.Size'Image);
    when Dir =>
      Put_Line ("- [D] " & N.all.Name & " Size: " & N.all.Size'Image);
      for Sub_Dir of N.all.Nodes loop
        Dump_FS (Sub_Dir, Indent + 1);
      end loop;
    end case;
  end Dump_FS;

  At_Most_100k : Natural := 0;

  procedure Size_FS (N : Node_Access; Size : out Natural) is
    My_Size, Tmp : Natural := 0;
  begin
    case N.all.T is
    when File =>
      My_Size := N.all.Size;

    when Dir =>
      for Sub_Dir of N.all.Nodes loop
        Size_FS (Sub_Dir, Tmp);
        My_Size := My_Size + Tmp;
      end loop;

      N.all.Size := My_Size;

      if My_Size <= 100000 then
        At_Most_100k := At_Most_100k + My_Size;
      end if;
    end case;

    Size := My_Size;
  end Size_FS;

  procedure Find_Smallest_FS (N : Node_Access; Target : Natural; Size : in out Natural) is
  begin
    case N.all.T is
    when File =>
      return;

    when Dir =>
      if N.all.Size >= Target and then N.all.size < Size then
        Size := N.all.Size;
      end if;

      for Sub_Dir of N.all.Nodes loop
        Find_Smallest_FS (Sub_Dir, Target, Size);
      end loop;
    end case;
  end Find_Smallest_FS;

  Root_Size : Natural := 0;
  Find_Size : Natural := 70000000;
  Found : Natural := 70000000;
begin
  Load_FS;
  Size_FS (Root'Access, Root_Size);

  Find_Size := 30000000 - (Find_Size - Root_Size);
  Find_Smallest_FS (Root'Access, Find_Size, Found);

  --  Dump_FS (Root'Access, 0);

  --  Part1:  1444896
  Put_Line ("Part1: " & At_Most_100k'Image);
  --  Part2:  404395
  Put_Line ("Part2: " & Found'Image);
end Main;
