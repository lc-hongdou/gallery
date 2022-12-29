<# :
cls&echo off&cd /d "%~dp0"&mode con lines=5000
rem 将当前目录下的多个子文件夹里的文件以其所在子文件夹名称重命名
set #=Any question&set _=WX&set $=Q&set/az=0x000000
title %#% +%$%%$%/%_% %z%
set "current=%cd%"
powershell -NoProfile -ExecutionPolicy bypass "Get-Content -literal '%~f0'|Out-String|Invoke-Expression"
echo;%#% +%$%%$%/%_% %z%
pause
exit
#>
$current=$env:current;
$folders=@(dir -literal $current|?{$_ -is [System.IO.DirectoryInfo]});
for($i=0;$i -lt $folders.length;$i++){
    $files=@(dir -literal $folders[$i].FullName|?{$_ -is [System.IO.FileInfo]});
    for($j=0;$j -lt $files.length;$j++){
        $newfile=$files[$j].Directory.FullName+'\#'+$files[$j].Name;
        move-item -literal $files[$j].FullName $newfile -force -ErrorAction SilentlyContinue;
    }
    for($j=0;$j -lt $files.length;$j++){
        $oldfile=$files[$j].Directory.FullName+'\#'+$files[$j].Name;
        $newname=$folders[$i].Name+$files[$j].Extension;
        $newfile=$files[$j].Directory.FullName+'\'+$newname;
        $n=2;
        while(test-path -literal $newfile){
            $newname=$folders[$i].Name+''+$n.ToString()+''+$files[$j].Extension; 
            $newfile=$files[$j].Directory.FullName+'\'+$newname;
            $n++;
        }
        write-host ($files[$j].FullName.replace($current,'')+' --> '+$newname);
        move-item -literal $oldfile $newfile -force -ErrorAction SilentlyContinue;
    }
}