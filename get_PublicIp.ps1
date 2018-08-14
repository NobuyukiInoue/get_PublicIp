param( $InstanceId )

if (-Not($InstanceId)) {
    Write-Host "Usage : "$MyInvocation.MyCommand.Name"InstanceId rdp_filePath" -ForegroundColor Red
    exit
}

Write-Host "<"$MyInvocation.MyCommand.Name">" -ForegroundColor Yellow
Write-Host "Searhing InstanceId = " -NoNewline
Write-Host $InstanceId -ForegroundColor Green

$res = & "aws" ec2 describe-instances

$Check_publicIp = $FALSE

for ($i = 0; $i -lt $res.Length; $i++) {
    ##--------------------------------------------------------------##
    ## PublicIpAddress�̒l���擾����
    ##--------------------------------------------------------------##
    if ($res[$i].IndexOf("`"PublicIpAddress`":") -ge 0) {
        $workStr = $res[$i].Replace(" ","").Replace("`"","").Replace(",","").split(":")
        if ($workStr.Length -gt 0) {
            $publicIpStr = $workStr[1]
            $Check_publicIp = $TRUE
        }
    }

    ##--------------------------------------------------------------##
    ## InstanceId������������publicIp��Ԃ�
    ##--------------------------------------------------------------##
    if ($Check_publicIp -eq $TRUE) {
        if ($res[$i].IndexOf("`"InstanceId`":") -ge 0) {
            if ($res[$i].IndexOf("`"$InstanceId`"") -ge 0) {
                Write-Host "publicIpAddress : " -NoNewline
                Write-Host $publicIpStr -ForegroundColor Cyan
                Write-Host

                return $publicIpStr
            }
            else {
               $Check_publicIp = $FALSE
            }
        }
    }
}

# ������Ȃ������ꍇ��null��Ԃ�
return $NULL
