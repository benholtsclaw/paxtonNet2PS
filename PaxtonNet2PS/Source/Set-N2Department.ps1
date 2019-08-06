function Set-N2Department {
    [CmdletBinding()]
    param (
        [int]      $deptID,
        [string]   $newdept
    )
    handleLogin

    $N2Connect.UpdateDepartment($deptID,$newdept)

}