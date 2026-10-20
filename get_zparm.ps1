[CmdletBinding()]
param(
        [Parameter(Mandatory)]  [string] $location,
        [Parameter(Mandatory)]  [string] $line_pwd,
        [Parameter(Mandatory)]  [string] $id,
        [Parameter(Mandatory=$false)]  [string] $prompt
    )



set DB2CLP=DB20FADE
set DB2INSTANCE=DB2_01
set DB2PATH=C:\Program Files\IBM\SQLLIB_01

set-item -path env:DB2CLP -value "**$$**"

D:
CD D:\powershell\all-zparms
erase sp-out.out

$linex = get-Content("D:\powershell\all-zparms\LPAR-LIST.TXT")

if ($line_pwd -gt 1) {
    $pw = $line_pwd
} else {
    $pw = Read-Host 'what is password?' 
}


#####################################


                                             

################################


$prevssn = "xxxx"


for ( $x=0; $x -lt $linex.count; $x++ ) {
   $first = $linex[$x].Substring(0,1)
   $line_no = $x + 1
   if ( $first -ne "#" ) {
        $myparms = $linex[$x].Split(",")
        $loc1 = $myparms[0].Substring(0,2);
        $loc2 = $myparms[0].Substring(3,4);
        $loc2 = $loc2 + ".mvs.us.ups.com"
        $db2grp = $myparms[1];
        $db2mem = $myparms[2];
        $myport = $myparms[5];
        
        if ( $loc1 -eq $location.ToUpper() ) {
           $msg = ".\jrun.bat" + " " +  $loc2  + " " + $myport + " " + $id + " " + $pw + " " + $db2grp + " " + $db2mem + " " + $loc1
           write-host $msg
           cmd.exe /C D:\powershell\all-zparms\jrun.bat $loc2 $myport $id $pw $db2grp $db2mem $loc1 
           $rc = $LASTEXITCODE
           if ($rc -eq 0 ) { Write-Host "ok"; Write-Host " "; sleep(1); }
           else { 
              Write-Host "error"; 
              Write-Host $rc ; 
              $ppp = Read-Host 'press enter to continue after error'
           }
           if ( $prompt.ToLower() -eq "y" ) {
             $ppp = Read-Host 'press enter'
           } else { sleep(1); }
           
        } else {
          $msg = "skip: " + $loc1 + $loc2 + "-" + $db2grp + "-" + $myport
          Write-Host -ForegroundColor Gray $msg
          }
   
   } 
}

$msg = "Program ends ... see outfile " + $location + "-out.raw"
Write-Host -ForegroundColor Magenta $msg



