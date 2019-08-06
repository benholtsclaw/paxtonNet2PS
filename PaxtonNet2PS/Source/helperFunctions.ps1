function handleLogin{
    if ($N2Connect.IsOperatorLoggedOn){
        # Login valid, nothing to do here
    }ELSE{
        if ($Net2Globals.CredentialPath -ne $null -and $Net2Globals.CredentialPath -ne ""){
            # We seem to be scripting, do further checks.
            if (Test-Path $Net2Globals.CredentialPath){
                # If path is valid, attempt login recovery
                Try{
                    # Convert file in credential path to PSObject.
                    $theseCreds = Import-Clixml $Net2Globals.CredentialPath -ErrorAction stop
                }
                Catch{
                    Throw "Login Recovery Failed: Unable to import PSCredentials."
                }
                
                Try{
                    # Attempt login
                    Connect-N2Server -server $Net2Globals.server -Credential $theseCreds -ErrorAction stop
                }
                catch{
                    Throw "Login Recovery Failed: Unable to login with imported PSCredentials."
                }
            }

        }ELSE{
            # We are not scripting, just throw the dang error already!
            Throw "Login has timed out, please use 'Connect-N2Server' to reconnect, and then try again."
        }
    }
}