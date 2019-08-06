function New-N2AccessLevel {
    [CmdletBinding()]
    param (
        [string] $NewAccessLevel
    )
    handleLogin

    $N2Connect.AddAccessLevel($NewAccessLevel,$newset)
}