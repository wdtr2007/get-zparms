# read zparms , sort, and reprint

[CmdletBinding()]
param(
        [Parameter(Mandatory)]  [string] $FileName
        
    )


function put-line {
  param( [string]$p_line )
  $writer.WriteLine( $p_line );
}



[System.Collections.ArrayList] $master_zparm = [System.Collections.ArrayList] @();
[System.Collections.ArrayList] $master_ssid  = [System.Collections.ArrayList] @();

# ht_ means hash table

$ht_zparm = @{};
$ht_ssid  = @{};

$fileout = $FileName.Substring(0,$filename.Length-4) + "_zp_vert.csv"


class Zparmc {
    [System.Collections.ArrayList] $myBag;
    [String] $ssn;
    [String] $zparm;
    [String] $value;
    [String] $online;
    Zparmc() {
      $this.myBag  = [System.Collections.ArrayList] @();
    }

    [void] set1( [String] $ssn ,  [String] $zparm ,  [String] $value,  [String] $online) {

      
    }


}


d:
cd \powershell\all-zparms

$PSDefaultParameterValues['*:Encoding'] = 'ascii';
$ErrorActionPreference = "Stop" 

$mypath1 = pwd;
$mypath = $mypath1.ToString();

$f1_name = $mypath + "\\" + $FileName 
$f1_lines = Get-content $f1_name

for ($x=0; $x -lt $f1_lines.Count; $x++ ) {
   $line = $f1_lines[$x];
   $line = $line.TrimEnd(" ")
   $cols=$line.Split(',');
   $ssid=$cols[0];

   if ( $x -eq 0 ) { $prev_ssid = $ssid; }

   $num  =$cols[1]
   $macro=$cols[2]
   $zparm=$cols[3]
   $panel=$cols[4]
   $desc =$cols[5]
   $loc  =$cols[6]
   $val  =$cols[7]
   $online=$cols[8]

   if ($online.Length -eq 11 ) {
     $zparm = $zparm.Substring(0,$zparm.Length-1)  + "(" + $online.Substring(9,1) + ")""" ;
   }
   
   # ="ONLINE=Y"
   # 0123456789a
   
   if ( $master_ssid.Contains($ssid) ) {
   } else {
      $nop = $master_ssid.add($ssid)
   }

   if ( $master_zparm.Contains($zparm) ) {
   } else {
      $nop = $master_zparm.add($zparm)
   }


   if ( $ssid -ne $prev_ssid ) {
      $ht_zparm.Add($prev_ssid,$ht_ssid);
      $msg = "                      " + $prev_ssid 
      Write-Host -ForegroundColor Yellow $msg
      $prev_ssid = $ssid
      $ht_ssid = @{};
   }

                           

   $ht_ssid.Add($zparm,$val);
    
   

}


# all done now we process the last record

$ht_zparm.Add($prev_ssid,$ht_ssid);



[string[]] $zparm_list_sorted = $master_zparm | Sort-Object
[string[]] $ssid_list_sorted = $master_ssid | Sort-Object

$tgt_file =  $mypath + "\\" + $fileout

if (Test-Path $tgt_file) {
  Remove-Item $tgt_file -Force
}


#################
$fileMode = [System.IO.FileMode]::OpenOrCreate
$fileAccess = [System.IO.FileAccess]::Write
$fileShare = [System.IO.FileShare]::Write
$file_out = $tgt_file
Write-Host -ForegroundColor Cyan $fileout
$fileStream = New-Object -TypeName System.IO.FileStream $file_out, $fileMode, $fileAccess, $fileShare
$encoding = [System.Text.Encoding]::ASCII
$writer = New-Object System.IO.StreamWriter $fileStream, $encoding

#############

$d1 = Get-Date -Format "yyyy-MM-dd"


   $msg =  "DB2-Sub-System"   + "," + "ZParm" + "," + "Value"

   put-line $msg




for ($x=0; $x -lt $ssid_list_sorted.Count; $x++ ) { 
   for ($y=0; $y -lt $zparm_list_sorted.Count; $y++ ) {
      $msg =  $ssid_list_sorted[$x] + ","
      $msg =  $msg + $zparm_list_sorted[$y] + ","
      $f = $ht_zparm.Item($ssid_list_sorted[$x]).Item($zparm_list_sorted[$y])
      $msg = $msg + $f
      put-line $msg 
   }

}


$writer.Flush();
$writer.Close();
$writer.Dispose();
$fileStream.Close();
$fileStream.Dispose();


Write-Host -ForegroundColor Magenta "Program ends ... out file is " $fileout ;

