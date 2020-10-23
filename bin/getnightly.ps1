param(
  [ValidateRange(0,1)][int]$debug
)
$process=Get-Process -ID $PID
$process.PriorityClass='High'

# see https://search.maven.org/classic/#api
# see https://blogs.technet.microsoft.com/heyscriptingguy/2015/10/08/playing-with-json-and-powershell/
#

# $groupId='ch.epfl.lamp'
$groupId='org.scala-lang'
#$progressPreference='silentlyContinue'
$request='https://search.maven.org/solrsearch/select?q=g:"'+$groupId+'"%20AND%20p:"jar"&rows=1&wt=json'
$latest=Invoke-WebRequest -UseBasicParsing -Uri $request |
ConvertFrom-Json |
Select -expand response |
Select -expand docs |
# Where { $_.a -match "^scala3-compiler_3\.*" } |
Select-Object -first 1 |
# for instance: 0.28.0-bin-20200911-b226ff1-NIGHTLY
# for instance: 3.0.0-M1-bin-20201021-97da3cb-NIGHTLY
Foreach { $_.latestVersion }

if ($debug -eq 1) { [Console]::Error.WriteLine("[getnightly] latest=$latest") }

$request='https://search.maven.org/solrsearch/select?q=g:"'+$groupId+'"%20AND%20v:"'+$latest+'"%20AND%20p:"jar"&rows=20&wt=json'
Invoke-WebRequest -UseBasicParsing -Uri $request |
ConvertFrom-Json |
Select -expand response |
Select -expand docs |
Where { $_.a -match "^scala3.*" -or $_.a -match "^tasty.*" } |
# https://repo.maven.apache.org/maven2/ch/epfl/lamp/dotty-compiler_0.28/0.28.0-bin-20200911-b226ff1-NIGHTLY/dotty-compiler_0.28-0.28.0-bin-20200911-b226ff1-NIGHTLY.jar
# https://repo1.maven.org/maven2/org/scala-lang/scala3-compiler_3.0.0-M1/3.0.0-M1-bin-20201021-97da3cb-NIGHTLY/scala3-compiler_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
Foreach { ($_.g -replace "\.", "/")+'/'+$_.a+'/'+$latest+'/'+$_.a+'-'+$latest+'.jar' }
