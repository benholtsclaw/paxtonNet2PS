
# Check for DLL in known path(s), grab only the first one in case of duplicates.
$dll = Get-ChildItem "C:\Program Files (x86)\Reference Assemblies\Paxton Access\Paxton.Net2.OEMClientLibrary.dll" | Select-Object -first 1
try{Test-Path $dll -ErrorAction Stop}
catch{Throw "DLL File not located. Please install the Paxton Net2 API Redistributable."}


Add-Type -Path $dll.fullname

$sourcePath = (Join-Path -path $psscriptRoot -childpath "Source")
foreach ($file in (Get-ChildItem -path $sourcePath *.ps1)){
    . $file.FullName
}