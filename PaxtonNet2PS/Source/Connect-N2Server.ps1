function Connect-N2Server{
    [cmdletBinding()]
    param(
        # Parameter help description
        [Parameter(Mandatory)]
        [string]
        $server,
        [int]
        $port = "8025",
        [Parameter(Mandatory)]
        [pscredential]
        $Credential
    )
    $Global:N2Connect = New-Object -TypeName Paxton.Net2.OemClientLibrary.OemClient -ArgumentList $server,$port
    
    $userArray = $N2Connect.GetListOfOperators().usersDictionary()
    foreach ($UID in $userArray.keys ) {
        if ($userArray[$uid] -eq $Credential.UserName) {
            [void]$Global:N2Connect.AuthenticateUser($UID,$Credential.GetNetworkCredential().Password)
        }
    }

    # If login fails, 'isOperationLoggedon' is false. Throw error to stop the user.
    if ($Global:N2Connect.IsOperatorLoggedOn -eq $false){
        Throw "Connection Failed, please check server and credentials."
    }
    else {
        $true
    }
}
