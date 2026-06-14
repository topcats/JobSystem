param(
    [Parameter(Mandatory=$true)]
    [string]$smtpServer,

    [int]
    $smtpPort = 587,

    [string]
    $smtpUsername = '',

    [string]
    $smtpPassword = '',

    [Parameter(Mandatory=$true)]
    [string]
    $fromAddress,

    [Parameter(Mandatory=$true)]
    [string]
    $to,

    [string]
    $subject = '',

    [string]
    $body = '',

    [ValidateSet('plain','html')]
    [string]
    $bodyType = 'plain',

    [Parameter(Mandatory=$false)]
    [string]
    $useTls = 'true',

    [Parameter(Mandatory=$false)]
    [string]
    $useSsl = 'false'
)

function Convert-ToBool {
    param([string]$value)
    if ([string]::IsNullOrWhiteSpace($value)) { return $false }
    switch ($value.Trim().ToLowerInvariant()) {
        '1' { return $true }
        'true' { return $true }
        'yes' { return $true }
        'on' { return $true }
        '0' { return $false }
        'false' { return $false }
        'no' { return $false }
        'off' { return $false }
        default { throw "Invalid boolean value: $value" }
    }
}

$useTls = Convert-ToBool -value $useTls
$useSsl = Convert-ToBool -value $useSsl

$recipients = $to -split '[;,\n]+' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
if ($recipients.Count -eq 0) {
    Write-Error 'The -to parameter must include at least one email address.'
    exit 1
}

$message = New-Object System.Net.Mail.MailMessage
$message.From = $fromAddress
foreach ($recipient in $recipients) {
    $message.To.Add($recipient)
}
$message.Subject = $subject
$message.Body = $body
$message.IsBodyHtml = $bodyType -eq 'html'

$smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
$smtpClient.EnableSsl = $useSsl -or $useTls

if (-not [string]::IsNullOrWhiteSpace($smtpUsername)) {
    $smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUsername, $smtpPassword)
}

try {
    $smtpClient.Send($message)
    Write-Host "SMTP email sent to: $($recipients -join ', ')"
}
catch {
    Write-Error "Failed to send email: $($_.Exception.Message)"
    exit 1
}
