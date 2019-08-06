function Remove-N2Department {
    [CmdletBinding()]
    param (
        [string] $N2DeleteDeptID
    )
handleLogin

$N2Connect.DeleteDepartment($N2DeleteDeptID)
    
}