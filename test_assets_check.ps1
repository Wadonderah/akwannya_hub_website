$files = @('roland_mawuli2.png','samuel_nartey.jpg','pritish_anand.jpg','paula_wakabi.jpg')
$base = 'http://localhost:3000/assets/'
foreach ($f in $files) {
  $u = $base + $f
  try {
    $r = Invoke-WebRequest -Uri $u -Method Head -UseBasicParsing -TimeoutSec 10
    Write-Output ($f + ' -> ' + $r.StatusCode)
  } catch {
    Write-Output ($f + ' -> ERR ' + $_.Exception.Message)
  }
}

