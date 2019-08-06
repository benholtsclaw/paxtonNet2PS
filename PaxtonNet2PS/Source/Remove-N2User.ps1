function Remove-N2User {
    [CmdletBinding()]
    param (
            [int] $RemoveUser
    )
    handleLogin

    $N2Connect.PurgeUser($RemoveUser)
}