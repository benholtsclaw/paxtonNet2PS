function Get-N2CardType {
    [CmdletBinding()]
    param (
        
    )
    handleLogin

    $n2connect.ViewCardTypes().internaldatasource.cardtype
}
