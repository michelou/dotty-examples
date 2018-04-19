# see https://search.maven.org/#api
# see https://blogs.technet.microsoft.com/heyscriptingguy/2015/10/08/playing-with-json-and-powershell/
#
$request='https://search.maven.org/solrsearch/select?q=g:"ch.epfl.lamp"%20AND%20p:"jar"&wt=json'
Invoke-WebRequest -Uri $request |
ConvertFrom-Json |
Select -expand response |
Select -expand docs |
Where { $_.a -match "dotty.*" } |
# http://central.maven.org/maven2/ch/epfl/lamp/dotty-compiler_0.8/0.8.0-bin-20180418-553ead0-NIGHTLY/dotty-compiler_0.8-0.8.0-bin-20180418-553ead0-NIGHTLY.jar
Foreach { ($_.g -replace "\.", "/")+'/'+$_.a+'/'+$_.latestVersion+'/'+$_.a+'-'+$_.latestVersion+'.jar' }
