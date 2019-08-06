<#
.SYNOPSIS
    Used for creating an access level object containing multiple accesslevel IDs
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> Get-N2AccessLevel | Where-Object {$_.name -match "8000"} | New-N2AccessSet
    Creates an AccessLevelDataTable Object out of all Access levels that match '8000'. The resulting object can be used with Set-N2User in the accessLevels parameter.
.PARAMETER AccessLevelID
    Takes an array of access level ID's.
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function New-N2AccessSet {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
        [int[]]
        $AccessLevelID
    )
    
    begin {
        $thisN2Table = [Paxton.Net2.OemClientLibrary.AccessLevelsSet+AccessLevelDataTable]::new()
    }
    
    process {
        foreach($alid in $AccessLevelID){
            Write-Verbose "Processing Access Level ID $accessLevelID"
            $details = Get-N2AccessLevel | Where-Object {$_.AccessLevelID -eq $alid}
            $thisN2Table.AddAccessLevelRow($details.AccessLevelID, $details.Name) | Out-Null
        }
    }
    
    end {
        # if no conflicts, return the table. Else, return error. This may need revisiting depending upon what conflict resolution tools are available within the API
        if ($N2Connect.ValidateAccessLevels($thisN2Table).ConflictsByAreaID.count -eq 0){
            ,$thisN2Table
        }else{
            Throw "Access Level Set has conflicts."
        }
        
        
    }
}
