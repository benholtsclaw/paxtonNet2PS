function Get-N2DoorGroup {
    [CmdletBinding()]
    param (
        
    )
    handleLogin

    $N2Connect.ViewDoorGroups().internaldatasource.doorgroups
}