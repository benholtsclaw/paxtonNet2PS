function Set-N2User {
    [cmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [int]
        $userId,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int]
        $departmentId,

        [Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName="accessLevelID")]
        [int]
        $accessLevelId,
        
        [Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName="advancedPermissions")]
        [Paxton.Net2.OemClientLibrary.AccessLevelsSet+AccessLevelDataTable]
        $accessLevels,

        [Parameter(ValueFromPipelineByPropertyName=$true,ParameterSetName="advancedPermissions")]
        [Paxton.Net2.OemClientLibrary.IndividualReaderAreasSet+IndividualReaderAreasDataTable]
        $readerAreas = [Paxton.Net2.OemClientLibrary.IndividualReaderAreasSet+IndividualReaderAreasDataTable]::new(),

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [bool]
        $antiPassbackUser,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [bool]
        $alarmUser,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]
        $firstName = $null,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]
        $middleName = $null,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]
        $surName = $null,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias('TelephoneNo')]
        [string]
        $telephone = $null,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias('TelephoneExtension')]
        [string]
        $Extension = $null,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]
        $pinCode = $null,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]
        $pictureFileName = $null,

        [Parameter()]
        [datetime]
        $activationDate = (New-Object System.datetime),

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [bool]
        $activeInd = $true,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]
        $faxNo = $null,

        [Parameter()]
        [datetime]
        $expiryDate = (New-Object System.datetime),

        # Parameter help description
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [bool]
        $lockdownExempt = $false,

        # CustomField Handling Parameters
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("Site")]
        [string] 
        $Field1_100,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("Address1")]
        [string]
        $Field2_100,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("Address2")]
        [string]
        $Field3_50,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("POBox")]
        [string]
        $Field4_50,
        
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("City")]
        [string]
        $Field5_50,
        
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("State")]
        [string]
        $Field6_50,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("Zip")]
        [string]
        $Field7_50,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("County")]
        [string]
        $Field8_50,
        
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("Other")]
        [string]
        $Field9_50,
        
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("Position")]
        [string]
        $Field10_50,
        
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("Username","samaccountname")]
        [string]
        $Field11_50,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("email")]
        [string]
        $Field12_50,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("notes")]
        [string]
        $Field13_Memo,
        
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [alias("EIN")]
        [string]
        $Field14_50
        )
        Begin{
            handleLogin
        }
        Process{
            
            # Possible Solution to the 'updateUserRecord' method nulling stuff out.
            # Get the existing User data.
            $oldUserData = Get-N2User -userID $userID
            # Get the proeprties of the user object.
            $Properties = $oldUserData | Get-Member -MemberType 'Property' | Select-Object -expand Name
            # If the property value is not provided as a parameter input, set the property value from the existing data.
            Write-Verbose ("First name is " + $oldUserData.firstName)

            foreach ($p in $Properties){
                # Check if parameter is defined, set old value if not
                if ($PSBoundParameters.ContainsKey($p) -eq $false){
                    # Switch block for dealing with different variable types, handle each type differently
                    switch ($oldUserData.($p).getType().name)
                    {
                        Int32{
                            Write-Verbose "Setting $($p) from pre-existing data."
                            Set-Variable $p $oldUserData.($p)
                            }
                        String{
                            Write-Verbose "Setting $($p) from pre-existing data."
                            Set-Variable $p $oldUserData.($p)
                        }
                        Boolean{
                            Write-Verbose "Setting $($p) from pre-existing data."
                            Set-Variable $p $oldUserData.($p)
                        }
                        DateTime{}
                    }
                }
                
            } 

            # Join CustomField Strings into an array, cause that's how they want them.
            $customFields = ("blank", # Dead Field
                $Field1_100,  # Site
                $Field2_100, # Address 1
                $Field3_50, # Address 2
                $Field4_50, # P.O. Box
                $Field5_50, # City
                $Field6_50, # State
                $Field7_50, # Zip/Postal Code
                $Field8_50, # County
                $Field9_50, # Other
                $Field10_50, # Position
                $Field11_50, # Username
                $Field12_50, # Email
                $Field13_Memo, # Notes
                $Field14_50 # EIN
            )

            Write-Verbose "Attempting to update User $userid - $Firstname $Surname"
            # Finally, Call the Method, based on which parameter set was used
            if ($PSCmdlet.ParameterSetName -eq "accesslevelID"){
                $N2Connect.UpdateUserRecord(
                    $userId,
                    $accessLevelId,
                    $departmentId,
                    $antiPassbackUser,
                    $alarmUser,
                    $firstName,
                    $middleName,
                    $surName,
                    $telephone,
                    $Extension,
                    $pinCode,
                    $pictureFileName,
                    $activationDate,
                    $activeInd,
                    $faxNo,
                    $expiryDate,
                    $customFields
                )
            }elseif ($PSCmdlet.ParameterSetName -eq "advancedPermissions"){
                $N2Connect.UpdateUserRecord(
                    $userId,
                    $accesslevels,
                    $readerAreas,
                    $departmentId,
                    $antiPassbackUser,
                    $alarmUser,
                    $firstName,
                    $middleName,
                    $surName,
                    $telephone,
                    $Extension,
                    $pinCode,
                    $pictureFileName,
                    $activationDate,
                    $activeInd,
                    $faxNo,
                    $expiryDate,
                    $customFields,
                    $lockdownExempt
                )

            }
        }
    }