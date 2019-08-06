function Get-N2TimeZone {
    [CmdletBinding()]
    param (
        
    )
    handleLogin

    $n2connect.ViewTimezones().internaldatasource.timezones
}