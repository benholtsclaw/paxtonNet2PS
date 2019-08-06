<#
.SYNOPSIS
Adds a New User to Net2.

.DESCRIPTION
Adds a new user to Net2.

.PARAMETER accessLevels
List of AccessLevels. Build using New-N2AccessSet. Must use if Net2 has "advanced permissions enabled".

.PARAMETER readerAreas
Individual overriding area\door access. Must use if if Net2 has "advanced permissions enabled".

.PARAMETER accessLevelId
Access Level ID #. Choose from Get-AccessLevel. Not usable if Net2 has "advanced permissions enabled".

.PARAMETER departmentId
Department ID #. Choose from Get-N2Department.

.PARAMETER antiPassbackInd
User Obeys anti-passback rules?

.PARAMETER alarmUserInd
User can arm/disarm intruder alarm?

.PARAMETER firstName
First Name of User.

.PARAMETER middleName
Middle Name of User.

.PARAMETER surname
Last Name of User.

.PARAMETER telephoneNo
Telephone Number of user.

.PARAMETER telephoneExtension
Telephone Extension of user.

.PARAMETER pinCode
Pin access code.

.PARAMETER pictureFileName
Filename of user photo.

.PARAMETER activationDate
The date the user becomes active.

.PARAMETER cardNumber
User Access Token Number. Use 0 if not assigning a card at this time.

.PARAMETER cardTypeId
Card Type ID. Use 0 if not assigning a card at this time.

.PARAMETER active
True indicates this user can have cards issued.

.PARAMETER faxNo
User's Fax Number.

.PARAMETER expiryDate
Date when access is revoked.

.PARAMETER customFields
An array of custom user field values. Slot 0 is ignored, 1 relates to the first field, 2 to the second, and so on.

.PARAMETER lockdownExempt
Does this user obey lockdown status?

.EXAMPLE
New-N2User -accessLevels (New-N2AccessSet -AccessLevelID 4,5) -departmentId 0 -firstName "John" -surname "Smith" -activationDate (Get-Date 11/01/2018)

Adds a new user when advanced permissions are enabled.

.NOTES

#>
function New-N2User{
    [cmdletBinding()]
    param (
        #List of AccessLevels. Build using New-N2AccessSet. Must use if Net2 has "advanced permissions enabled".
        [Parameter(Mandatory=$true,ParameterSetName="advanced")]
        [Paxton.Net2.OemClientLibrary.AccessLevelsSet+AccessLevelDataTable]
        $accessLevels,

        #Individual overriding area\door access. Must use if if Net2 has "advanced permissions enabled".
        [Parameter(ParameterSetName="advanced")]
        [Paxton.Net2.OemClientLibrary.IndividualReaderAreasSet+IndividualReaderAreasDataTable]
        $readerAreas = [Paxton.Net2.OemClientLibrary.IndividualReaderAreasSet+IndividualReaderAreasDataTable]::new(),

        #Access Level ID #. Choose from Get-AccessLevel. Not usable if Net2 has "advanced permissions enabled".
        [Parameter(Mandatory=$true,ParameterSetName="simple")]
        [int]       
        $accessLevelId,
                
        [Parameter(Mandatory=$true)]
        [int]       
        $departmentId,

        [bool]      
        $antiPassbackInd = $false,

        [bool]      
        $alarmUserInd = $false,
        
        [Parameter(Mandatory=$true)]
        [string]   
        $firstName,
        
        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string]
        $middleName,

        [Parameter(Mandatory=$true)]
        [string]   
        $surname,
        
        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [alias("Telephone")]
        [string]
        $telephoneNo,
        
        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string]    
        $telephoneExtension,
        
        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string]    
        $pinCode,
        
        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string]    
        $pictureFileName,
        
        [Parameter(Mandatory=$true)]
        [DateTime]  
        $activationDate = (get-date),
        
        [parameter(Mandatory=$false)]
        [int]       
        $cardNumber = 0,
        
        [parameter(Mandatory=$false)]
        [int]       
        $cardTypeId = 0,
        
        [bool]      
        $active = $true,
        
        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string]    
        $faxNo,
        
        [Parameter(Mandatory=$false)]
        [DateTime]  
        $expiryDate = (New-Object System.Datetime),
        
        [parameter(Mandatory=$false)]
        [AllowEmptyString()]
        [string[]]  
        $customFields,

        # Parameter help description
        [Parameter(ParameterSetName="advanced")]
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

    # handle custom fields
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


    if ($PSCmdlet.ParameterSetName -eq "simple"){
            
        # Finally, call the method, presuming .AddNewUser()
        $N2Connect.AddNewUser(
            $accessLevelId,
            $departmentId,
            $antiPassbackInd,
            $alarmUserInd,
            $firstName,
            $middleName,
            $surname,
            $telephoneNo,
            $telephoneExtension,
            $pinCode,
            $pictureFileName,
            $activationDate,
            $cardNumber,
            $cardTypeId,
            $active,
            $faxNo,
            $expiryDate,
            $customFields
            )

    }elseif ($pscmdlet.ParameterSetName -eq "advanced") {
        $N2Connect.AddNewAdvancedPermissionsUser(
            $accessLevels,
            $readerAreas,
            $departmentId,
            $antiPassbackInd,
            $alarmUserInd,
            $firstName,
            $middleName,
            $surname,
            $telephoneNo,
            $telephoneExtension,
            $pinCode,
            $pictureFileName,
            $activationDate,
            $cardNumber,
            $cardTypeId,
            $active,
            $faxNo,
            $expiryDate,
            $customFields,
            $lockdownExempt
            )
    }
}