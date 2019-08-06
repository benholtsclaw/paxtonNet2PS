<#
.SYNOPSIS
    Gets Access Levels
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Get-N2AccessLevel
    Returns Access level Names and IDs
.INPUTS
    # None
.OUTPUTS
    [Paxton.Net2.OemClientLibrary.AccessLevelsSet+AccessLevelRow]
.NOTES
    General notes
#>
function Get-N2AccessLevel{
    [CmdletBinding(DefaultParameterSetName="undefined")]
    param(
        # Parameter help description
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int]
        $accessLevelID,

        #Ideally used for receiving pipeline input from get-n2user
        [Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName="piped")]
        [int]
        $userID,
        
        #Ideally used for receiving pipeline input from get-n2user
        [Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName="piped")]
        [int]
        $isaccesslevelUser

    )
    begin{
        handleLogin
    }
    process{
        
        if ($PSCmdlet.ParameterSetName -eq "undefined" -AND $accessLevelID -eq 0){
            $N2Connect.ViewAccessLevels().internalDataSource.AccessLevel
        }
        elseif ($PSCmdlet.ParameterSetName -eq "piped"){
            ,$N2Connect.ViewUserAccessLevelsAdvancedPermissions($userid).internaldatasource.accesslevel
            
        }
        else{
            ,$N2Connect.ViewAccessLevelDetail($accessLevelID).AccessLevelDetailsDataSource.AccessLevelDetail
        }
    }

    
    
}
