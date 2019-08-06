function Get-N2Department {
    [CmdletBinding()]
    param (
        
    )
    handleLogin

    $N2Connect.ViewDepartments().internaldatasource.department
    
}