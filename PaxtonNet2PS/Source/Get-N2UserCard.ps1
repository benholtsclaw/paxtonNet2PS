function Get-N2UserCard {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [int] $UserId
    )
    handleLogin

    $n2connect.viewcards($UserId)
}