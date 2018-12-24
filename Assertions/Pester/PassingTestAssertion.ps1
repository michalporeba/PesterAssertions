function PassingTestAssertion {
    [CmdletBinding()]
    Param(
        [ScriptBlock]$ActualValue,
        [switch]$Negate
    )

    [bool]$Pass = $true
    try {
        & $ActualValue
    } catch {
        $Pass = $false 
    }

    If ( $Negate ) { $Pass = -not($Pass) }

    If ( -not($Pass) ) {
        If ( $Negate ) {
            $FailureMessage = 'Expected: test {{{0}}} should fail but it passed.' -f $ActualValue
        }
        Else {
            $FailureMessage = 'Expected: test {{{0}}} should pass.' -f $ActualValue
        }
    }

    $ObjProperties = @{
        Succeeded      = $Pass
        FailureMessage = $FailureMessage
    }
    return New-Object PSObject -Property $ObjProperties
}

try { Add-AssertionOperator -Name 'Pass' -Test $Function:PassingTestAssertion } catch {}