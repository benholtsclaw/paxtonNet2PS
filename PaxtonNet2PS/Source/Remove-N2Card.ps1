function Remove-N2Card {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [int] $cardId
    )
    handleLogin

    $n2connect.DeleteCard($cardId)
}