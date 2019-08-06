function New-N2Department {
    [CmdletBinding()]
    param (
        [String] $NewDepartmentName
    )
    handleLogin

    $N2Connect.AddDepartment($NewDepartmentName)
}