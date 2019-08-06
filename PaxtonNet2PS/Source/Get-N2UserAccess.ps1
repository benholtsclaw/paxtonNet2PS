function Get-N2UserAccess {
    [CmdletBinding()]
    param (
        [Parameter(mandatory=$true,Position=0,ValueFromPipelineByPropertyName=$true)]
        [int]$userID
    )
    begin {
        handleLogin
    }
    
    process {
        $N2Connect.ViewUserIndividualAccessAdvancedPermissions($userID).internalDataSource
    }
}