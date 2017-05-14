param (
    [string]$modlist = "mods.html",
    [string]$login = "LOGIN",
    [string]$password = "PASSWORD",
    [string]$armapath = "C:\Arma3",
    [string]$arma = "233780 -beta",
    [string]$steam = "C:\steamcmd"
)

#Get mods html file
$mods = Get-Content $modlist -Raw
#write-output $mods

#Find ID & modname in file
$modsid = ([regex]::Matches($mods,'=(\d{9})"'));
$modsname = ([regex]::Matches($mods,'e">(.*?)<'));

#login to steam
& $steam\steamcmd.exe +login $login $password +force_install_dir $armapath +"app_update $arma" validate +quit;


#loop loop
$y=0;

#MAKE SURE THAT DOWNLOAD IS EMPTY
Clear-Variable Download

#Make string of workshop IDs to download
foreach  ($value in $modsid) {
    $id = $modsid[$y].Groups[1].Value;
    $Download = $Download + '" +workshop_download_item 107410 ' + $id + '" '

    $y++
}

#Download workshop IDs
& $steam\steamcmd.exe +login $login $password $Download validate +quit;

$x=0;

#Create Symbolik links from SteamFolder to Arma Folder
foreach  ($value in $modsid) {
    $id = $modsid[$x].Groups[1].Value;
    $name = $modsname[$x].Groups[1].Value;
    New-Item -ItemType SymbolicLink -Force -Path $armapath\@$name -Value $steam\steamapps\workshop\content\107410\$id
    $x++ 
}
