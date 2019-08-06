function New-N2DoorGroup {
    [CmdletBinding()]
    param (
        [string] $NewDoorName
    )
    handleLogin

    $N2Connect.AddDoorGroup($NewDoorName)
    
}