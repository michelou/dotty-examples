# see https://search.maven.org/classic/#api
# see https://blogs.technet.microsoft.com/heyscriptingguy/2015/10/08/playing-with-json-and-powershell/
#
$request='https://search.maven.org/solrsearch/select?q=g:"ch.epfl.lamp"%20AND%20p:"jar"&rows=1&wt=json'
$latest=Invoke-WebRequest -UseBasicParsing -Uri $request |
ConvertFrom-Json |
Select -expand response |
Select -expand docs |
Where { $_.a -match "^dotty-compiler_0\.18.*" } |
# for instance: 0.18.0-bin-20190802-95ae77c-NIGHTLY
Foreach { $_.latestVersion }

$request='https://search.maven.org/solrsearch/select?q=g:"ch.epfl.lamp"%20AND%20p:"jar"&rows=20&wt=json'
Invoke-WebRequest -UseBasicParsing -Uri $request |
ConvertFrom-Json |
Select -expand response |
Select -expand docs |
Where { $_.a -match "^dotty.*" -and $_.latestVersion -match "$latest" } |
# http://central.maven.org/maven2/ch/epfl/lamp/dotty-compiler_0.13/0.13.0-bin-20190217-2b0e4a1-NIGHTLY/dotty-compiler_0.13-0.13.0-bin-20190217-2b0e4a1-NIGHTLY.jar
Foreach { ($_.g -replace "\.", "/")+'/'+$_.a+'/'+$_.latestVersion+'/'+$_.a+'-'+$_.latestVersion+'.jar' }
