@echo off
setlocal enabledelayedexpansion

set _SIZE=0
for %%f in (
c:\opt\dotty-0.21.0-RC1\lib\commons-logging-1.2.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-all-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-abbreviation-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-admonition-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-aside-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-attributes-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-definition-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-enumerated-reference-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-escaped-character-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-footnotes-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-gfm-issues-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-gfm-users-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-gitlab-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-jekyll-front-matter-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-jekyll-tag-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-macros-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-media-tags-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-toc-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-typographic-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-xwiki-macros-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-ext-youtube-embedded-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-html-parser-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-pdf-converter-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-profile-pegdown-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\flexmark-youtrack-converter-0.42.12.jar
c:\opt\dotty-0.21.0-RC1\lib\fontbox-2.0.11.jar
c:\opt\dotty-0.21.0-RC1\lib\graphics2d-0.15.jar
c:\opt\dotty-0.21.0-RC1\lib\icu4j-59.1.jar
c:\opt\dotty-0.21.0-RC1\lib\openhtmltopdf-core-0.0.1-RC15.jar
c:\opt\dotty-0.21.0-RC1\lib\openhtmltopdf-jsoup-dom-converter-0.0.1-RC15.jar
c:\opt\dotty-0.21.0-RC1\lib\openhtmltopdf-pdfbox-0.0.1-RC15.jar
c:\opt\dotty-0.21.0-RC1\lib\openhtmltopdf-rtl-support-0.0.1-RC15.jar
c:\opt\dotty-0.21.0-RC1\lib\pdfbox-2.0.11.jar
c:\opt\dotty-0.21.0-RC1\lib\tasty-core_0.21-0.21.0-RC1.jar
c:\opt\dotty-0.21.0-RC1\lib\xmpbox-2.0.11.jar
) do (
    for /f %%i in ('powershell -c "'%%f'.Length"') do set __LEN=%%i
	if !__LEN! lss 48        ( set "__TABS=					"
	) else if !__LEN! lss 52 ( set "__TABS=				"
	) else if !__LEN! lss 56 ( set "__TABS=				"
	) else if !__LEN! lss 60 ( set "__TABS=			"
	) else if !__LEN! lss 64 ( set "__TABS=			"
	) else if !__LEN! lss 68 ( set "__TABS=		"
	) else if !__LEN! lss 72 ( set "__TABS=		"
	) else ( set "__TABS=	"
	)
	if %%~zf lss 10000 ( set "__SPACES=    "
	) else if %%~zf lss 100000 ( set "__SPACES=   "
	) else if %%~zf lss 1000000 ( set "__SPACES=  "
	) else if %%~zf lss 10000000 ( set "__SPACES= "
	) else ( set "__SPACES="
	)
    echo %%f!__TABS!!__SPACES!%%~zf bytes 
	set /a _SIZE+=%%~zf
)
set /a _TOTAL_MB=%_SIZE% / 1024 / 1024
echo Total size: %_TOTAL_MB% MB
exit /b 0
