function Set-N2UserCard {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [int]  
        $CardNo,
        
        [Parameter(Mandatory=$false)]
        [int]  
        $CardTypeID,
        
        [Parameter(Mandatory=$true)]
        [int]  
        $userId
    )
    handleLogin

    $N2Connect.AddCard(
        $CardNo,
        $CardTypeID,
        $userId
    )
}