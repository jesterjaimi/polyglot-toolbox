'---------------------------------------------------------------------------
' TSI.vbs - Telnet Script Interpreter
' interpret the input file, telnet to the device and capture the output  
'---------------------------------------------------------------------------
 
Dim ubr
Dim script
Dim output_file,ofile
CRLF = CHR(13) & CHR(10)
  
args=WScript.Arguments.Count 
if args = 0 then
  WScript.echo "usage: cscript TSI.vbs <config file>  <output file> "
  WScript.echo "if output file is not specified, output will be to the screen"
  WScript.quit
end if
 
config_file=WScript.Arguments.Item(0)
If args >1 then
   output_file=WScript.Arguments.Item(1)
   Set fso = CreateObject("Scripting.FileSystemObject")
   Set ofile =fso.CreateTextFile(output_file,1)
end If
' send output to screen if there is anything after the output filename
If args =2 then
  output_to_screen=true
end If
  
Set WshShell = CreateObject("WScript.Shell") 
Set fso = CreateObject("Scripting.FileSystemObject")
Set w3sock = CreateObject("socket.tcp")
 
call ReadConfigFile(config_file)
call InitSocket()
call ProcessScript()
 
ofile.WriteLine("#exit")
ofile.Close
set ofile = nothing
set WShell=nothing
set fso=nothing
set w3sock=nothing
WScript.quit 
  
Function InitSocket()
    w3sock.DoTelnetEmulation = True 
    w3sock.TelnetEmulation = "TTY" 
end Function
  
Function ProcessScript()
    w3sock.Host = ubr & ":23"
    w3sock.Open 
     
    for i=1 to UBound(script)
       cmd=LEFT(script(i),inStr(script(i)," "))
       parameter=Right(script(i),Len(script(i))-Len(cmd))
       parameter=Replace(parameter,"\m","")
       parameter=Replace(parameter,"""","")
       'Wscript.echo "cmd: " & cmd
       'Wscript.echo "parameter: " & parameter
       if cmd="WAIT " then
          w3sock.WaitFor parameter
          call ProcessOutput(w3Sock.Buffer)
          wscript.echo w3Sock.Buffer 
       end If
       if cmd="SEND " then
          w3sock.SendLine parameter
       end If
    Next
    w3sock.Close 
end Function
 
Function ReadConfigFile(infile)
   set file = fso.OpenTextFile(infile,1)
   contents=file.ReadAll() 
   script=split(contents,CRLF)
   ubr=script(0)
end Function
Function ProcessOutput(output)
   ' split the line into it's components
     line=split(output,CRLF)
     for i=0 to UBound(line) 
        if InStr(line(i),"C") = 1 then
           interface=ltrim(Mid(line(i),1,10))
           if len(interface) < 10 then interface=space(10)
             
           sid=ltrim(Mid(line(i),13,5))
           if len(sid) < 5 then 
              sid="0    "
           end if
             
           state=ltrim(Mid(line(i),18,12))
           state= state '& space(1)
           if len(state)<12 then space(12)
             
           timing=ltrim(Mid(line(i),30,8))
           if len(timing)<8 then timing=space(8)
            
           rec=trim(Mid(line(i),40,5))
           rec=rec & space(7-len(rec))
          
           if len(rec)<7 then rec=space(7)
            
           qos=ltrim(Mid(line(i),45,4))
           if len(qos)<4 then qos="0"&space(3)
           if instr(qos,"?")>0 then qos="0"&space(3)
            
           cpe=ltrim(Mid(line(i),49,5))
           if len(cpe)<5 then cpe=space(5)
            
           ip=ltrim(Mid(line(i),54,15))
           if len(ip)<15 then ip="0.0.0.0        "
            
           mac=ltrim(Mid(line(i),69,14))
           outstr=interface&sid&state&timing&rec&qos&cpe&ip&mac
        else
           outstr=line(i)
        end if     
        ofile.WriteLine(outstr)
     Next
end Function
Function ProcessOutput_broken(output)
Dim line_val
ReDim line_val(9)
   ' split the line into it's components
     line=split(output,CRLF)
     for i=0 to UBound(line) 
        if InStr(line(i),"C") = 1 then
           value=split(line(i)," ")
           ptr=0
           for z=0 to UBound(value)
              if len(value(z)) > 0 then
                 line_val(ptr)=value(z)
                 ptr=ptr+1
              end if
           Next
           interface=trim(line_val(0)) & space((12-len(line_val(0))))
           sid=trim(line_val(1)) & space(5-len(line_val(1)))
           state=trim(line_val(2)) & space(13-len(line_val(2)))
           timing=trim(line_val(3)) & space(7-len(line_val(3)))
           rec=trim(line_val(4)) & space(7-len(line_val(4)))
           qos=trim(line_val(5)) & space(4-len(line_val(5)))
           cpe=trim(line_val(6)) & space(4-len(line_val(6)))
           ip=trim(line_val(7)) & space(16-len(line_val(7)))
           mac=trim(line_val(8))
           outstr=interface&sid&state&timing&rec&qos&cpe&ip&mac
        else
           outstr=line(i)
        end if     
        ofile.WriteLine(outstr)
     Next
end Function