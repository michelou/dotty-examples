param(
  [ValidateRange(0,1)][int]$debug
)
$process=Get-Process -ID $PID
$process.PriorityClass='High'

# see https://search.maven.org/classic/#api
# see https://blogs.technet.microsoft.com/heyscriptingguy/2015/10/08/playing-with-json-and-powershell/
#

#$progressPreference='silentlyContinue'
$request='https://search.maven.org/solrsearch/select?q=g:"ch.epfl.lamp"%20AND%20p:"jar"&rows=1&wt=json'
$latest=Invoke-WebRequest -UseBasicParsing -Uri $request |
ConvertFrom-Json |
Select -expand response |
Select -expand docs |
# Where { $_.a -match "^dotty-compiler_0\.28.*" } |
Select-Object -first 1 |
# for instance: 0.28.0-bin-20200911-b226ff1-NIGHTLY
Foreach { $_.latestVersion }

if ($debug -eq 1) { [Console]::Error.WriteLine("[getnightly] latest=$latest") }

$request='https://search.maven.org/solrsearch/select?q=g:"ch.epfl.lamp"%20AND%20v:"'+$latest+'"%20AND%20p:"jar"&rows=20&wt=json'
Invoke-WebRequest -UseBasicParsing -Uri $request |
ConvertFrom-Json |
Select -expand response |
Select -expand docs |
Where { $_.a -match "^dotty.*" -or $_.a -match "^tasty.*" } |
# https://repo.maven.apache.org/maven2/ch/epfl/lamp/dotty-compiler_0.28/0.28.0-bin-20200911-b226ff1-NIGHTLY/dotty-compiler_0.28-0.28.0-bin-20200911-b226ff1-NIGHTLY.jar
Foreach { ($_.g -replace "\.", "/")+'/'+$_.a+'/'+$latest+'/'+$_.a+'-'+$latest+'.jar' }
