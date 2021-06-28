'---------------------------------------------------------------------------
' RunDetect.vbs
' execute each bat file in the directory.  If any are still running after
' 180 seconds, kill them
'---------------------------------------------------------------------------
 
Dim Path
Dim TimeToWait
Dim MinimumFileSize
Dim fso,WshShell,objDict
ReDim arrFilesToRunAgain(2)
On Error Resume Next
  

dir=WScript.Arguments.Item(0) 
Path=dir & "*.cfg"
'Path="C:\ubrrawdata_reg\*.cfg"
' wait time is now 180 seconds
TimeToWait = 180
MinimumFileSize = 10
  
Set WshShell = CreateObject("WScript.Shell") 
Set objDict = CreateObject("Scripting.Dictionary")
Set fso = CreateObject("Scripting.FileSystemObject")
 
arrFilesToRun = ListDir(Path)
 
' run the programs 
Call RunPrograms(arrFilesToRun)
' check to see if any of the programs did not return enough data
WScript.Echo "Check for uncompleted files and rerun if needed"
Call CheckFiles(arrFilesToRun, arrFilesToRunAgain)
' run the programs again 
Call RunPrograms(arrFilesToRunAgain)
 
  
Set WshShell = Nothing
Set objDict = Nothing
Set fso = Nothing
 
WScript.Quit 
  
'---------------------------------------------------------------------------
' For each file, run the program, if it is still runninig after a minute, kill it
'---------------------------------------------------------------------------
Private Function RunPrograms(arrFile)
 
'for each file, exec the program, which creates a WshExec object, and put it in an array
For i=0 to UBound(arrFile)
   strOutfile = Split(arrFile(i), ".")(0) & ".txt"
   strConfig = Split(arrFile(i), ".")(0) & ".cfg"
   Set oExec = WshShell.Exec("TST10.exe /r:" & strConfig & " /o:" & strOutfile & " /m")
   objDict.add i, oExec 
   Wscript.sleep (3000)  'sleep 1/4 of a second
Next

 
' Loop and for each exec object, check the status. After 60 seconds give up and kill
' anything still running
total_time = 0 
Do While total_time < TimeToWait
   still_running = 0
   ' if the exec is still running, the status is 0
   For i = 0 to UBound(objDict.items)
      If (objDict.item(i)).status = 0 then
         still_running = still_running+1
      end if
   Next
   Wscript.echo still_running & " processes still running - " & total_time & " seconds elapsed"
   total_time=total_time + 10
   If still_running = 0 then
      Exit Do
   else
      Wscript.sleep (10000)  'sleep ten seconds  
   end if
Loop
 
' kill any processes that are still running
If still_running > 0 then
   For i = 0 to UBound(objDict.items)
      If (objDict.item(i)).status = 0 then
         Wscript.echo "Killing process"
         set tmp = objDict.item(i)
         tmp.Terminate
      end if
   Next
end if
 
'Clean up
For i = 0 to UBound(objDict.items)
      set tmp = objDict.item(i)
      set tmp = Nothing
Next
objDict.RemoveAll
  
end Function
 
'---------------------------------------------------------------------------
' For each file, see there was a successful run, check for the exit statement
'---------------------------------------------------------------------------
Private Function CheckFiles(arrFilesToCheck, arrFilesToRunAgain)
 
Dim file, x
x=0
'for each output file, read thru it and find the exit statement
' if the exit statement is not found, add it to the arrFilesToRunAgain array
For i=0 to UBound(arrFilesToCheck)
    file_good="false"
    strOutfile = Split(arrFilesToCheck(i), ".")(0) & ".txt"
    WScript.echo "Checking " & strOutfile
    set file = fso.OpenTextFile(strOutfile)
    Do While Not file.AtEndOfStream
       line=file.ReadLine() 
       ' exit found, add to copy array
       If InStr(line,"#exit") > 0 then
            file_good="true"
            Exit Do
         end If
    Loop
    If file_good <> "true" then
       If x > UBound(arrFilesToRunAgain) Then ReDim Preserve arrFilesToRunAgain(x*2)
       arrFilesToRunAgain(x)=arrFilesToCheck(i)
       x=x+1
       Wscript.echo "Exit line not found for " & arrFilesToCheck(i)
    end if
    file.Close
    set file = Nothing
Next
   ReDim Preserve arrFilesToRunAgain(x-1)
 
end Function
 
'---------------------------------------------------------------------------
'  Support functions to get the file listing
'---------------------------------------------------------------------------
Public Function ListDir (ByVal Path)
   If Path = "" then Path = "*.*"
   Dim Parent, Filter
   if fso.FolderExists(Path) then     ' Path is a directory
      Parent = Path
      Filter = "*"
     Else
      Parent = fso.GetParentFolderName(Path)
      If Parent = "" Then If Right(Path,1) = ":" Then Parent = Path: Else Parent = "."
      Filter = fso.GetFileName(Path)
      If Filter = "" Then Filter = "*"
      End If
   ReDim a(10)
   Dim n: n = 0
   Dim Folder: Set Folder = fso.GetFolder(Parent)
   Dim Files: Set Files = Folder.Files
   Dim File
   For Each File In Files
      If CompareFileName(File.Name,Filter) Then
         If n > UBound(a) Then ReDim Preserve a(n*2)
         a(n) = File.name
         n = n + 1
         End If
      Next
   ReDim Preserve a(n-1)
   ListDir = a
   End Function 
  
Private Function CompareFileName (ByVal Name, ByVal Filter) ' (recursive)
   CompareFileName = False
   Dim np, fp: np = 1: fp = 1
   Do
      If fp > Len(Filter) Then CompareFileName = np > len(name): Exit Function
      If Mid(Filter,fp) = ".*" Then       ' special case: ".*" at end of filter
         If np > Len(Name) Then CompareFileName = True: Exit Function
         End If
      Dim fc: fc = Mid(Filter,fp,1): fp = fp + 1
      Select Case fc
         Case "*"
            CompareFileName = CompareFileName2(name,np,filter,fp)
            Exit Function
         Case "?"
            If np <= Len(Name) And Mid(Name,np,1) <> "." Then np = np + 1
         Case Else
            If np > Len(Name) Then Exit Function
            Dim nc: nc = Mid(Name,np,1): np = np + 1
            If Strcomp(fc,nc,vbTextCompare)<>0 Then Exit Function
         End Select
      Loop
   End Function

Private Function CompareFileName2 (ByVal Name, ByVal np0, ByVal Filter, ByVal fp0)
   Dim fp: fp = fp0
   Dim fc2
   Do
      If fp > Len(Filter) Then CompareFileName2 = True: Exit Function
      If Mid(Filter,fp) = ".*" Then    ' special case: ".*" at end of filter
         CompareFileName2 = True: Exit Function
         End If
      fc2 = Mid(Filter,fp,1): fp = fp + 1
      If fc2 <> "*" And fc2 <> "?" Then Exit Do
      Loop
   Dim np
   For np = np0 To Len(Name)
      Dim nc: nc = Mid(Name,np,1)
      If StrComp(fc2,nc,vbTextCompare)=0 Then
         If CompareFileName(Mid(Name,np+1),Mid(Filter,fp)) Then
            CompareFileName2 = True: Exit Function
            End If
         End If
      Next
   CompareFileName2 = False
   End Function