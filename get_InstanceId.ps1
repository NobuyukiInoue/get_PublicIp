# Write-Host "<"$MyInvocation.MyCommand.Name">" -ForegroundColor Yellow

$res = & "aws" ec2 describe-instances

for ($i = 0; $i -lt $res.Length; $i++) {
    ##--------------------------------------------------------------##
    ## InstanceId‚ªŒ©‚Â‚©‚Á‚½‚çpublicIp‚ð•Ô‚·
    ##--------------------------------------------------------------##
    if ($res[$i].IndexOf("`"InstanceId`"") -ge 0) {
        ## Write-Host $res[$i].Trim().Replace(",", "") -ForegroundColor Green
        $InstanceId = $res[$i].Trim().Replace("`"InstanceId`": ", "")
        $InstanceId = $InstanceId.Replace("`"", "")
        $InstanceId = $InstanceId.Replace(",", "")
        Write-Host $InstanceId -ForegroundColor Green
    }
}
