function SkippingTestAssertion {
    [CmdletBinding()]
    Param(
        [ScriptBlock]$ActualValue,
        [switch]$Negate
    )

    [bool]$Pass = $false
    try {
        & $ActualValue
    } catch {
        $psitem.FullyQualifiedErrorID -eq "PesterTestSkipped"
        $Pass = $true 
    }

    If ( $Negate ) { $Pass = -not($Pass) }

    If ( -not($Pass) ) {
        If ( $Negate ) {
            $FailureMessage = 'Expected: test {{{0}}} should not skip.' -f $ActualValue
        }
        Else {
            $FailureMessage = 'Expected: test {{{0}}} should skip.' -f $ActualValue
        }
    }

    $ObjProperties = @{
        Succeeded      = $Pass
        FailureMessage = $FailureMessage
    }
    return New-Object PSObject -Property $ObjProperties
}

try { Add-AssertionOperator -Name 'Skip' -Test $Function:SkippingTestAssertion } catch {}