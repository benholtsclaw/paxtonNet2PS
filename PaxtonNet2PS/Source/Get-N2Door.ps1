function Get-N2Door {
    [CmdletBinding()]
    param (
        [int] $addressID
        
    )
    handleLogin

    if($addressID -eq 0){
        $n2connect.ViewDoors().internaldatasource.door
    
    }else{
        $n2connect.ViewDoors($addressID).internaldatasource.door 
    }
}
