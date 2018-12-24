function FailingTestAssertion {
    [CmdletBinding()]
    Param(
        [ScriptBlock]$ActualValue,
        [switch]$Negate
    )

    [bool]$Pass = $false
    try {
        & $ActualValue
    } catch {
        $psitem.FullyQualifiedErrorID -eq "PesterAssertionFailed"
        $Pass = $true 
    }

    If ( $Negate ) { $Pass = -not($Pass) }

    If ( -not($Pass) ) {
        If ( $Negate ) {
            $FailureMessage = 'Expected: test {{{0}}} should not fail.' -f $ActualValue
        }
        Else {
            $FailureMessage = 'Expected: test {{{0}}} should fail but it passed.' -f $ActualValue
        }
    }

    $ObjProperties = @{
        Succeeded      = $Pass
        FailureMessage = $FailureMessage
    }
    return New-Object PSObject -Property $ObjProperties
}

try { Add-AssertionOperator -Name 'Fail' -Test $Function:FailingTestAssertion } catch {}