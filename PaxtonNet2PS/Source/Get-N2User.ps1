<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Get-N2User
    Returns All Users
.EXAMPLE
    PS C:\> Get-N2User -userID 45
    Returns the user with the ID 45
.EXAMPLE
    PS C:\> Get-N2User -filter "surname = 'Smith'"
    Returns any user with the surname of 'smith'. Strings must be quoted.
.PARAMETER UserID
    The Paxton N2 User ID.
.PARAMETER Filter
    An SQL style 'where' filter, but without the 'where'
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Get-N2User {
    [CmdletBinding(DefaultParameterSetName="All")]
    param (
        [Parameter(mandatory=$false,ParameterSetName="userID",Position=0)]
        [int]$userID = "",
        [Parameter(mandatory=$false,ParameterSetName="filter",position=0)]
        [string]$filter
    )
    
    handleLogin
    
    if ($userID -ne ""){
        $N2Connect.ViewUserRecords('userID = ' + $userID).UsersDataSource.user
    }elseif ($filter -ne "") {
        $N2Connect.ViewUserRecords($filter,$true).UsersDataSource.user
    }
    ELSE{
        $N2Connect.ViewUserRecords().UsersDataSource.user 
    }

    
    
}