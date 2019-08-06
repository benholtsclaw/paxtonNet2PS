function Remove-N2AccessLevel {
    [CmdletBinding()]
    param (
        [string] $DeleteAccessLevel
    )
    handleLogin

    $N2Connect.DeleteAccessLevel($DeleteAccessLevel)
}