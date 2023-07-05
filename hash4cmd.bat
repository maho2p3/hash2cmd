@echo off
chcp 65001
set d1=%date:~0,4%%date:~5,2%%date:~8,2%
set t1=%time:~0,2%%time:~3,2%%time:~6,2%
set a1=1
set var0=sha512
set hexFN=8
set var1=log
set /p var0=请输入哈希类型：md2\4\5或sha1\256\384\512（默认%var0%） :
set /p hex0=请输入文件名中的哈希字符数（默认%hexFN%）：
for /r %%n in (*.*) do (
	set /a a1+=1
	set "str0=%%n"
	set "str00=%%~dpn"
	set "str01=%%~nxn"
	set "str02=%%~xn"
	set "size0=%%~zn"
	set "dt0=%%~tn"
	setlocal EnableDelayedExpansion
	if !str02:~1! NEQ %var0% (
		if !str02:~1! NEQ %var1% (
			certutil -hashfile "!str0!" %var0% | findstr /v ":">temp.txt
			set /p hex0=<temp.txt
			echo !str0!的%var0%值为：!hex0:~0,8!...!hex0:~-8!
			(
				echo %var0%
				echo !hex0!
				echo !str00!
				echo !str01!
				echo !size0!
				echo !dt0!
			)>temp.txt
			set d2=%date%
			set t2=%time%
			if exist "!str0!*.%var0%" (
				set r1=0
				for /f "usebackq tokens=*" %%i in ("!str0!.!hex0:~0,%hexFN%!.%var0%") do (
					set /a r1+=1
					if !r1!==2 set "hex1=%%i"
				)
				if !hex0!==!hex1! (
					echo 文件校验成功
					echo=
					echo !d2! !t2! "!str0!">>哈希校验记录[%d1%_%t1%].log
				) else (
					move /Y temp.txt "!str0!".!hex0:~0,%hexFN%![%d1%_%t1%].%var0%
					echo 文件校验和出错
					echo=
					echo !d2! !t2! "!str0!">>哈希校验出错记录[%d1%_%t1%].log
				)
			) else (
				move /Y temp.txt "!str0!".!hex0:~0,%hexFN%!.%var0%
				echo !d2! !t2! "!str0!">>哈希创建记录[%d1%_%t1%].log
			)
		)
	)
	endlocal
)
del temp.txt
pause
