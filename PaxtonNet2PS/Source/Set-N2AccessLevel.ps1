function Set-N2AccessLevel {
    [CmdletBinding()]
    param (
        [int]       $AccID,
        [string]    $NewName
 
    )
    handleLogin
    
    $N2Connect.UpdateAccessLevel($AccID,$NewName,$newset)

}