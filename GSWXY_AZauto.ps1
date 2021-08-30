# 脚本说明
Write-Information -MessageData "
===========================================
  ____   ____   __        __ __  __ __   __
 / ___| / ___|  \ \      / / \ \/ / \ \ / /
| |  _  \___ \   \ \ /\ / /   \  /   \ V / 
| |_| |  ___) |   \ V  V /    /  \    | |  
 \____| |____/     \_/\_/    /_/\_\   |_|  `n
===========================================`n
该脚本为Azerothcore的一键编译脚本，由https://www.gswxy.com网站发布，Github库为GSWXY-Azauto，欢迎加QQ群938973736讨论！" -InformationAction Continue
# 修改系统Hosts以更快的下载Github资源
$Host_choice = Read-Host -Prompt "是否需要修改系统Hosts？请输入y或者n"
if ($Host_choice -eq "y") {
    $client = New-Object System.Net.WebClient
    $client.DownloadFile("https://raw.hellogithub.com/hosts","$env:windir\system32\drivers\etc\hosts")
    }
# 修改系统Hosts以更快的下载Github资源
$DNS_choice = Read-Host -Prompt "是否需要修改系统DNS为阿里云地址？请输入y或者n"
if ($DNS_choice -eq "y") {
    Get-DnsClientServerAddress -AddressFamily IPv4 |
    Out-GridView -PassThru |
    foreach {
        Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -Addresses '223.5.5.5','223.6.6.6'
        }
    ipconfig /flushdns
    }

# 检查是否可访问Github
Write-Information -MessageData "检查网络环境……" -InformationAction Continue
Write-Information -MessageData ".........................................................." -InformationAction Continue
ping github.com
Write-Information -MessageData "`n..........................................................`n" -InformationAction Continue
# 修改源码下载路径
$BaseLocation = Read-Host -Prompt "请输入源码下载路径，直接回车将为默认路径（D:\AzerothCore\AzerothCore-WotLK）"
if ($BaseLocation -eq "") {
    $BaseLocation = "D:\AzerothCore\AzerothCore-WotLK"
    } else {
            Write-Information -MessageData "你的源码下载路径为（$BaseLocation）" -InformationAction Continue
}

# 修改源码编译路径
$BuildFolder = Read-Host -Prompt "请输入源码编译路径，直接回车将为默认路径（D:\AzerothCore\Build-AzerothCore）"
if ($BuildFolder -eq "") {
    $BuildFolder = "D:\AzerothCore\Build-AzerothCore"
    } else {
            Write-Information -MessageData "你的源码编译路径为（$BuildFolder）" -InformationAction Continue
}

# 修改最终的服务端路径
$FinalServerFolder = Read-Host -Prompt "请输入最终的服务端路径，直接回车将为默认路径（D:\GSWXY）"
if ($FinalServerFolder -eq "") {
    $FinalServerFolder = "D:\GSWXY"
    } else {
            Write-Information -MessageData "你最终的服务端路径为（$FinalServerFolder）" -InformationAction Continue
}

# 设置MYSQL的root密码
$SQLRootPassword = Read-Host -Prompt "请输入MYSQL的root密码，直接回车将为默认密码（gswxy.com）"
if ($SQLRootPassword -eq "") {
    $SQLRootPassword = "gswxy.com"
    } else {
            Write-Information -MessageData "你MYSQL的root密码设置为（$SQLRootPassword）" -InformationAction Continue
}

# 设置是否下载官方Data文件
$Downloaddata = Read-Host -Prompt "是否下载官方的Data文件，请注意这是个大型文件，请输入Yes或者No（如果输入No请一定记得手动复制自己的Data文件到服务端内）"

# 设置各项文件下载路径
##Vcredist_x64下载路径
$Vcredist_x64Version = "https://download.microsoft.com/download/F/3/5/F3500770-8A08-488E-94B6-17A1E1DD526F/vcredist_x64.exe"
$Vcredist_x64FileName = $Vcredist_x64Version.Split("/")[-1]
$Vcredist_x64InstallFile = "$env:USERPROFILE\Downloads\$Vcredist_x64FileName"
## 源码下载路径
$AzerothCoreRepo = "git://github.com/azerothcore/azerothcore-wotlk.git"
## Git下载路径
$GitVersion = "https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.2/Git-2.33.0.2-64-bit.exe"
$GitFileName = $GitVersion.Split("/")[-1]
$GitInstallFile = "$env:USERPROFILE\Downloads\$GitFileName"
## Cmake下载路径
$CmakeVersion = "https://github.com/Kitware/CMake/releases/download/v3.21.2/cmake-3.21.2-windows-x86_64.msi"
$CmakeFileName = $CmakeVersion.Split("/")[-1]
$CmakeInstallFile = "$env:USERPROFILE\Downloads\$CmakeFileName"
## Visual Studio下载路径
$VisualStudioURL = "https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=Community&rel=16#"
$VSFileName = "vs_community.exe"
$VSInstallFile = "$env:USERPROFILE\Downloads\$VSFileName"
## OpenSSL下载路径
$OpenSSLURL = "https://slproweb.com/download/Win64OpenSSL-1_1_1L.exe"
$OpenSSLFileName = $OpenSSLURL.Split("/")[-1]
$OpenSSLInstallFile = "$env:USERPROFILE\Downloads\$OpenSSLFileName"
## Boost下载路径
$BoostURL = "https://jaist.dl.sourceforge.net/project/boost/boost-binaries/1.74.0/boost_1_74_0-msvc-14.2-64.exe"
$BoostFileName = $OpenSSLURL.Split("/")[-1]
$BoostInstallFile = "$env:USERPROFILE\Downloads\$BoostFileName"
## MySQL下载路径
$MySQLURL = "https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.29-winx64.zip"
$MySQLFileName = $MySQLURL.Split("/")[-1]
$MySQLZipFile = "$env:USERPROFILE\Downloads\$MySQLFileName"
## HeidiSQL下载路径
$HeidiURL = "https://www.heidisql.com/downloads/releases/HeidiSQL_11.3_64_Portable.zip"
$HeidiFileName = $HeidiURL.Split("/")[-1]
$HeidiZipFile = "$env:USERPROFILE\Downloads\$HeidiFileName"
## Data下载路径
$AZCoreDataURL = "https://link.jscdn.cn/1drv/aHR0cHM6Ly8xZHJ2Lm1zL3UvcyFBbk1vdV9Pa1h5eUxnNUpWbVg3WE9UZ0hMZ1JFWlE_ZT03RXZacmc.zip"
$AZCoreDataZipName = $AZCoreDataURL.Split("/")[-1]
$AZCoreDataZip = "$env:USERPROFILE\Downloads\data.zip"

# 系统环境部分
Write-Information -MessageData "开始系统环境的检查……`n安装任何缺失但需要的软件：`n" -InformationAction Continue

# 自动安装Vcredist_x64安装情况
if (!(Test-Path -Path "C:\Windows\System32\msvcp120.dll")) {
    Write-Information -MessageData "未找到Vcredist_x64，现在下载……" -InformationAction Continue
    Try {
        Invoke-WebRequest -Uri $Vcredist_x64Version -OutFile $Vcredist_x64InstallFile
    } Catch {
        Write-Error -Message "下载$Vcredist_x64FileName失败！" -InformationAction Stop
    }
    Write-Information -MessageData "下载完成，现在安装……" -InformationAction Continue
	    $Vcredist_x64Arguments = "/i `"$Vcredist_x64InstallFile`" /q /norestart"
    Try {
        Start-Process msiexec.exe -ArgumentList $Vcredist_x64Arguments -Wait
    } Catch {
        Write-Error -Message "Vcredist_x64安装失败！" -ErrorAction Stop
    }
    Write-Information -MessageData "Vcredist_x64安装完毕!" -InformationAction Continue
    $RestartRequired = $true
} else {
    Write-Information -MessageData "已经安装了Vcredist_x64，正在进行下一项检查……" -InformationAction Continue
}


if (!(Test-Path -Path "C:\Program Files\Git\git-cmd.exe")) {
    Write-Information -MessageData "没有找到Git 64bit，现在下载……" -InformationAction Continue
    Try {
        Invoke-WebRequest -Uri $GitVersion -OutFile $GitInstallFile
    } Catch {
        Write-Error -Message "下载$GitFileName失败！" -InformationAction Stop
    }
    Write-Information -MessageData "下载完成，现在安装……" -InformationAction Continue
# 为git静默安装创建.inf文件
    $GitINF = "$env:USERPROFILE\Downloads\gitinstall.inf"
    New-Item -Path $GitINF -ItemType File -Force
    Add-Content -Path $GitINF -Value "[Setup]
        Lang=default
        Dir=C:\Program Files\Git
        Group=Git
        NoIcons=0
        SetupType=default
        Components=ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh
        Tasks=
        EditorOption=Notepad++
        CustomEditorPath=
        PathOption=Cmd
        SSHOption=OpenSSH
        TortoiseOption=false
        CURLOption=OpenSSL
        CRLFOption=CRLFAlways
        BashTerminalOption=ConHost
        PerformanceTweaksFSCache=Enabled
        UseCredentialManager=Enabled
        EnableSymlinks=Disabled
        EnableBuiltinInteractiveAdd=Disabled
		http.postBuffer=524288000"
    $GitArguments = "/VERYSILENT /NORESTART /LOADINF=""$GitINF"""
    Try {
        Start-Process -FilePath $GitInstallFile -ArgumentList $GitArguments -Wait
    } Catch {
        Write-Error -Message "Git安装失败！" -ErrorAction Stop
    }
    Write-Information -MessageData "Git安装完毕！" -InformationAction Continue
    $RestartRequired = $true
} else {
    Write-Information -MessageData "已经安装了Git，正在进行下一项检查……" -InformationAction Continue
}

# 检查CMake 64bit安装情况
if (!(Test-Path -Path "C:\Program Files\CMake\bin\cmake.exe")) {
    Write-Information -MessageData "未找到CMake 64bit，现在下载……" -InformationAction Continue
    Try {
        Invoke-WebRequest -Uri $CmakeVersion -OutFile $CmakeInstallFile
    } Catch {
        Write-Error -Message "下载$CmakeFileName失败！" -InformationAction Stop
    }
    Write-Information -MessageData "下载完成，现在安装……" -InformationAction Continue
    $CmakeArguments = "/i `"$CmakeInstallFile`" /norestart /quiet"
    Try {
        Start-Process msiexec.exe -ArgumentList $CmakeArguments -Wait
    } Catch {
        Write-Error -Message "CMake安装失败！" -ErrorAction Stop
    }
    Write-Information -MessageData "CMake安装完毕!" -InformationAction Continue
    $RestartRequired = $true
} else {
    Write-Information -MessageData "已经安装了CMake，正在进行下一项检查……" -InformationAction Continue
}

# 检查Visual Studio安装情况
if (!(Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe")) {
    Write-Information -MessageData "没有找到Visual Studio，现在下载并安装……" -InformationAction Continue
    Try {
        Invoke-WebRequest -Uri $VisualStudioURL -OutFile "$VSInstallFile.txt"
    } Catch {
        Write-Error -Message "检索VS网页失败！" -ErrorAction Stop
    }
    $installerURL = Select-String -Path "$VSInstallFile.txt" -Pattern "vs_Community.exe"
    $installerURL = "https:" + ($installerURL -replace ".*:" -replace ".{1}$")
    Try {
        Invoke-WebRequest -Uri $installerURL -OutFile $VSInstallFile
    } Catch {
        Write-Error -Message "下载Visual Studio失败！" -ErrorAction Stop
    }
    $VSArguments = "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Workload.NativeDesktop;includeRecommended --quiet --norestart"
    Try {
        Start-Process -FilePath $VSInstallFile -ArgumentList $VSArguments -Wait
    } Catch {
        Write-Error -Message "Visual Studio安装失败！" -ErrorAction Stop
    }
    Write-Information -MessageData "Visual Studio安装完毕！" -InformationAction Continue
    $RestartRequired = $true
} else {
    Write-Information -MessageData "已经安装了Visual Studio，正在进行下一项检查……" -InformationAction Continue
}

# 检查OpenSSL 64bit安装情况
if (!(Test-Path -Path "C:\Program Files\OpenSSL-Win64\bin\openssl.exe")) {
    Write-Information -MessageData "没有找到OpenSSL，现在正在下载和安装……" -InformationAction Continue
    Try {
        Invoke-WebRequest -Uri $OpenSSLURL -OutFile $OpenSSLInstallFile
    } Catch {
        Write-Error -Message "下载$OpenSSLFileName失败！" -InformationAction Stop
    }
    Write-Information -MessageData "下载完成，现在安装……" -InformationAction Continue
    $OpenSSLArguments = "/VERYSILENT"
    Try {
        Start-Process -FilePath $OpenSSLInstallFile -ArgumentList $OpenSSLArguments -Wait
    } Catch {
        Write-Error -Message "OpenSSL 64位安装失败！" -ErrorAction Stop
    }
    Write-Information -MessageData "OpenSSL 64位安装完毕！" -InformationAction Continue
    $RestartRequired = $true
} else {
    Write-Information -MessageData "已经安装了OpenSSL，正在进行下一项检查……" -InformationAction Continue
}

# 检查Boost安装情况
if (!(Test-Path -Path "C:\local\boost_1_74_0\bootstrap.bat")) {
    Write-Information -MessageData "没有找到Boost，现在正在下载和安装……" -InformationAction Continue
    Try {
        Invoke-WebRequest -Uri $BoostURL -OutFile $BoostInstallFile
    } Catch {
        Write-Error -Message "下载$BoostFileName失败！" -InformationAction Stop
    }
    Write-Information -MessageData "下载完成，现在安装……" -InformationAction Continue
    $BoostArguments = "/VERYSILENT"
    Try {
        Start-Process -FilePath $BoostInstallFile -ArgumentList $BoostArguments -Wait
    } Catch {
        Write-Error -Message "Boost安装失败！" -ErrorAction Stop
    }
    Write-Information -MessageData "Boost安装完毕！" -InformationAction Continue
    $RestartRequired = $true
} else {
    Write-Information -MessageData "已经安装了Boost，正在进行下一项检查……" -InformationAction Continue
}

# 检查MySQL安装情况
if (!(Test-Path -Path C:\MySQL\bin\mysqld.exe)) {
    Write-Information -MessageData "正在下载MySQL安装包……`n温馨提醒：该脚本由GSWXY修订，欢迎访问https://www.gswxy.com" -InformationAction Continue
    Invoke-WebRequest -Uri $MySQLURL -OutFile $MySQLZipFile
    Try {
        Expand-Archive -Path $MySQLZipFile -DestinationPath "C:\MySQL"
    } catch {
        Write-Information -MessageData "提取$MySQLFileName失败，下载文件可能已损坏。删除并重试！" -InformationAction Continue
        break
    }
    Get-ChildItem -Path "C:\MySQL\mysql-5.7.29-winx64" | Move-Item -Destination "C:\MySQL"
    New-Item -Path "C:\MySQL\lib\debug" -ItemType Directory -Force
    Copy-Item -Path "C:\MySQL\lib\libmysql.lib" -Destination "C:\MySQL\lib\debug\libmysql.lib"
    Copy-Item -Path "C:\MySQL\lib\libmysql.dll" -Destination "C:\MySQL\lib\debug\libmysql.dll"
    Remove-Item -Path "C:\MySQL\mysql-5.7.29-winx64" -Force
} else {
    Write-Information -MessageData "MySQL已经存在于C:\MySQL！" -InformationAction Continue
}

# 程序安装完毕。 如果需要，现在重新启动。
if ($RestartRequired) {
    Write-Information -MessageData "`n`n`n一个或多个应用程序已被安装。`n并且完成了PATH变量的修改。`n您必须关闭并重新打开Powershell。`n然后重新运行脚本以继续！`n`n`n" -InformationAction Continue
    Break
}

# 下载AzerothCore核心资源库
if (!(Test-Path -Path "$BaseLocation\.git\HEAD")) {
    Write-Information -MessageData "创建文件夹`n下载核心文件。" -InformationAction Continue
    Try {
        New-Item -Path $BaseLocation -ItemType Directory
    } Catch {
        Write-Error -Message "无法创建文件夹！" -ErrorAction Stop
    }
    Write-Information -MessageData "创建了文件夹`n下载核心文件……" -InformationAction Continue
    Try {
        git clone $AzerothCoreRepo $BaseLocation --branch master
        if (-not $?) {
            throw "Git错误！下载AzerothCore失败！"
        }
    } Catch {
        throw
    }
    Write-Information -MessageData "下载成功！" -InformationAction Continue
} else {
    Write-Information -MessageData "AzerothCore已存在`n现在更新核心……" -InformationAction Continue
    Try {
        Set-Location $BaseLocation
        git pull
        if (-not $?) {
            throw "Git错误！更新AzerothCore失败！"
        }
    } Catch {
        throw
    }
}

# 下载模块功能
Function Get-AZModule {
    param (
        [Parameter(Mandatory = $true,Position = 0)]
        [string]$AZmodPath,
        [Parameter(Mandatory = $true,Position = 1)]
        [string]$AZmodURL
    )

    $AZmodname = ($AZmodURL -replace ".{4}$").Remove(0,31)
    if (Test-Path "$AZmodPath\.git\HEAD") {
        Write-Information -MessageData "$AZmodname模块已存在！`n现在开始更新……" -InformationAction Continue
        try {
            Set-Location $AZmodPath
            git pull
            if (-not $?) {
                throw "Git错误！更新$AZmodname模块失败！"
            }
        } Catch {
            throw
        }
    } else {
        Write-Information -MessageData "模块尚不存在！`n现在开始下载$AZmodname……" -InformationAction Continue
        Try {
            git clone $AZmodURL $AZmodPath
            if (-not $?) {
                throw "Git错误！下载$AZmodname失败！"
            }
        } Catch {
            throw
        }
    }
}

# 模块选择系统

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(700,380)
$Form.text ="选择你想要的AzerothCore模块"
$Form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(600,310)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = '确定'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Form.AcceptButton = $OKButton
$Form.Controls.Add($OKButton)

#$cancelButton = New-Object System.Windows.Forms.Button
#$cancelButton.Location = New-Object System.Drawing.Point(600,310)
#$cancelButton.Size = New-Object System.Drawing.Size(75,23)
#$cancelButton.Text = '取消'
#$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
#$Form.CancelButton = $cancelButton
#$Form.Controls.Add($cancelButton)

# 启动组合
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(20,20)
$groupBox.text = "可用的模块:"
$groupBox.size = New-Object System.Drawing.Size(660,275)
$Form.Controls.Add($groupBox)

# 创建复选框
$checklist = New-Object System.Windows.Forms.CheckedListBox
$checklist.Location = New-Object System.Drawing.Size(20,20)
$checklist.Size = New-Object System.Drawing.Size(620,250)
$checklist.CheckOnClick = $true
$checklist.MultiColumn = $true

# 获取可用模块
$uri = New-Object System.UriBuilder -ArgumentList 'https://api.github.com/search/repositories?q=topic%3Acore-module+fork%3Atrue+org%3Aazerothcore&type=Repositories&per_page=100'
$baseuri = $uri.uri
$acmods = Invoke-RestMethod -Method Get -Uri $baseuri
$acmodslist = $acmods.items | Select-Object -Property name, clone_url | Sort-Object Name

# 将模块添加到复选框列表中，任何已经存在的模块都默认为选中。
$CurrentModules = Get-ChildItem -Path "$BaseLocation\Modules" -Filter "mod*" | Select-Object -Property Name
$modnumber = 0
foreach ($acmod in $acmodslist) {
    if ($acmod.name -like "mod*") {
        $modsName = ($acmod.name).remove(0,4)
        $checklist.Items.Add($modsName) | Out-Null
        foreach ($CurrentModule in $CurrentModules) {
            if (($CurrentModule.Name).remove(0,4) -eq $modsName) {
                $checklist.SetItemChecked($modnumber,$true)
            }
        }
        $modnumber ++
    }
}

$groupBox.Controls.Add($checklist)

# 点击了 "确定"。
$OKButton.Add_Click({
    $Script:Cancel=$false
    $Form.Hide()
    foreach ($mod in $checklist.CheckedItems) {
        foreach ($acmod in $acmodslist) {
            if ($acmod.name -like "*$mod") {
                $modpath = "$BaseLocation\modules\" + $acmod.name
                Write-Progress -Activity "下载模块" -Status $acmod.name
                Get-AZModule -AZmodPath $modpath -AZmodURL $acmod.clone_url
            }
        }
        if ($mod -eq "eluna-lua-engine") {
            Write-Progress -Activity "下载模块" -Status "安装LUA Engine"
            Get-AZModule -AZmodPath "$BaseLocation\modules\mod-eluna-lua-engine\LuaEngine" -AZmodURL "https://github.com/ElunaLuaEngine/Eluna.git"
        }
    }
    $Form.Close()
})

#$cancelButton.Add_Click({
#    $Script:Cancel=$true
#    $Form.Close()
#})

# 显示表格
$Form.ShowDialog() | Out-Null

if ($Cancel -eq $true) {
    break
}

# 构建服务端
Set-Location 'C:\Program Files\CMake\bin'
Write-Progress -Activity "构建服务端" -Status "编译源代码"
Write-Information -MessageData "编译和构建将需要一些时间，去gswxy.com转转，学下手动编译吧！" -InformationAction Continue
$BuildArgs = "-G `"Visual Studio 16 2019`" -A x64 -S $BaseLocation -B $BuildFolder"
Start-Process -FilePath 'C:\Program Files\CMake\bin\cmake.exe' -ArgumentList $BuildArgs -Wait
Write-Progress -Activity "构建服务端" -Status "完成构建"
$FinalArgs = "--build $BuildFolder --config Release"
Start-Process -FilePath "C:\Program Files\CMake\bin\cmake.exe" -ArgumentList $FinalArgs -Wait

# 检查以确保构建完成
if ((Test-Path -Path "$BuildFolder\bin\Release\authserver.exe") -and (Test-Path -Path "$BuildFolder\bin\Release\worldserver.exe")) {
    Write-Information -MessageData "编译和构建成功! 继续……" -InformationAction Continue
} else {
    Write-Information -MessageData "编译和构建失败，检查cmake日志，再试一次！" -InformationAction Continue
    break
}

# 创建最终的服务端
Write-Information -MessageData "正在创建最终服务端……" -InformationAction Continue
if (Test-Path -Path $FinalServerFolder) {
    Write-Information -MessageData "服务端已经存在! 如果你继续，它将被删除!" -InformationAction Continue
    do {
        $Response = Read-Host -Prompt "继续吗？Y或N"
    } until (($Response -eq "y") -or ($Response -eq "n"))
    if ($Response -eq "y") {
        Remove-Item -Path "$FinalServerFolder" -Recurse -Force
    } else {
        Write-Information -MessageData "将你以前的服务端从$FinalServerFolder 内删除或者移动到别处，然后再试一次" -InformationAction Continue
        break
    }
}
New-Item -Path $FinalServerFolder -ItemType Directory
Move-Item -Path "$BuildFolder\bin\Release" -Destination "$FinalServerFolder\Server"

# 将所有conf.dist文件复制到.conf
$DistFiles = Get-ChildItem -Path "$FinalServerFolder\Server\configs" -Filter "*.dist"
foreach ($Dist in $DistFiles) {
    $Conf = $Dist -replace ".{5}$"
    Copy-Item -Path "$FinalServerFolder\Server\configs\$Dist" -Destination "$FinalServerFolder\Server\configs\$Conf"
}

# 改变.conf文件的设置
New-Item -Path "$FinalServerFolder\Server\Data" -ItemType Directory
New-Item -Path "$FinalServerFolder\Server\Logs" -ItemType Directory
$WorldServerConf = Get-Content -Path "$FinalServerFolder\Server\configs\worldserver.conf"
$NewDataDir = $WorldServerConf -replace "DataDir = `".`"", "DataDir = `"Data`""
$NewDataDir | Set-Content -Path "$FinalServerFolder\Server\configs\worldserver.conf"

$NewWorldServerConf = Get-Content -Path "$FinalServerFolder\Server\configs\worldserver.conf"
$NewLogDir = $NewWorldServerConf -replace "LogsDir = `".`"", "LogsDir = `"Logs`""
$NewLogDir | Set-Content -Path "$FinalServerFolder\Server\configs\worldserver.conf"
$NewWorldMySQLExecutable = $NewWorldServerConf -replace "MySQLExecutable = `"`"", "MySQLExecutable = `"database/bin/mysql.exe`""
$NewWorldMySQLExecutable | Set-Content -Path "$FinalServerFolder\Server\configs\worldserver.conf"

$AuthServerConf = Get-Content -Path "$FinalServerFolder\Server\configs\authserver.conf"
$NewAuthLogDir = $AuthServerConf -replace "LogsDir = `"`"", "LogsDir = `"Logs`""
$NewAuthLogDir | Set-Content -Path "$FinalServerFolder\Server\configs\authserver.conf"
$NewAuthMySQLExecutable = $NewWorldServerConf -replace "MySQLExecutable = `"`"", "MySQLExecutable = `"database/bin/mysql.exe`""
$NewAuthMySQLExecutable | Set-Content -Path "$FinalServerFolder\Server\configs\authserver.conf"

if ($Downloaddata -eq "Yes") {
    Write-Information -MessageData "正在下载Data文件，文件大小超过1G，所以需要一些时间，在此期间欢迎访问https://www.gswxy.com" -InformationAction Continue
        Try {
            Invoke-WebRequest -Uri $AZCoreDataURL -OutFile $AZCoreDataZip
        } Catch {
            Write-Error -Message "下载$AZCoreDataZipName失败！" -InformationAction Stop
        }
        Write-Information -MessageData "提取文件的时间有点长，来QQ群（938973736）聊天吹水吧！" -InformationAction Continue
        Expand-Archive -Path $AZCoreDataZip -DestinationPath "$FinalServerFolder\Server\Data"
}
if ($Downloaddata -eq "No") {
    Write-Information -MessageData "`n`n不要忘记手动复制数据文件！！！`n`n" -InformationAction Continue
    Start-Sleep -Seconds 3
}

# 将MySQL文件复制到服务器
New-Item -Path "$FinalServerFolder\Server\database\bin" -ItemType Directory
$SQLBinFilesToCopy = @(
    "C:\MySQL\lib\libmysql.dll"
    "C:\MySQL\lib\libmysqld.dll"
    "C:\MySQL\bin\mysql.exe"
    "C:\MySQL\bin\mysql_upgrade.exe"
    "C:\MySQL\bin\mysqladmin.exe"
    "C:\MySQL\bin\mysqlcheck.exe"
    "C:\MySQL\bin\mysqld.exe"
    "C:\MySQL\bin\mysqldump.exe"
)
foreach ($SQLBinFile in $SQLBinFilesToCopy) {
    Copy-Item -Path "$SQLBinFile" -Destination "$FinalServerFolder\Server\database\bin"
}
Copy-Item -Path "C:\MySQL\share" -Destination "$FinalServerFolder\Server\database" -Recurse
Copy-Item -Path 'C:\MySQL\lib\libmysql.dll' -Destination "$FinalServerFolder\Server"
Copy-Item -Path "C:\Program Files\OpenSSL-Win64\libcrypto-1_1-x64.dll" -Destination "$FinalServerFolder\Server"

# 初始化MySQL
New-Item -Path "$FinalServerFolder\Server\database\tmp" -ItemType Directory
New-Item -Path "$FinalServerFolder\Server\database\data" -ItemType Directory
Set-Location "$FinalServerFolder\Server\database\bin"
Start-Process -FilePath "mysqld.exe" -ArgumentList "--initialize-insecure" -Wait

# 创建MySQLini
$MySQLINI = "$FinalServerFolder\Server\database\my.ini"
    New-Item -Path $MySQLINI -ItemType File -Force
    Add-Content -Path $MySQLINI -Value "#Client Settings
    [client]
        default-character-set = utf8mb4
        port = 3306
        socket = /tmp/mysql.sock
# MySQL 5.7.29 Settings
    [mysqld]
        port = 3306
        basedir=`"..`"
        datadir=`"../data`"
        socket = /tmp/mysql.sock
        skip-external-locking
        skip_ssl
        skip-slave-start
        key_buffer_size = 256M
        max_allowed_packet = 256M
        table_open_cache = 256
        sort_buffer_size = 1M
        read_buffer_size = 1M
        read_rnd_buffer_size = 4M
        myisam_sort_buffer_size = 64M
        thread_cache_size = 8
        query_cache_size= 16M
        character-set-server=utf8mb4
        collation-server=utf8mb4_unicode_ci
        skip-character-set-client-handshake
        server-id = 1
        innodb_write_io_threads = 64
        innodb_read_io_threads = 64
        explicit_defaults_for_timestamp = 1
        sql-mode=`"NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION`"
    [mysqldump]
        quick
        max_allowed_packet = 256M
    [myisamchk]
        key_buffer_size = 128M
        sort_buffer_size = 128M
        read_buffer = 16M
        write_buffer = 16M
    [mysqlhotcopy]
        interactive-timeout"

# 创建MySQLcnf
$MySQLCNF = "$FinalServerFolder\Server\database\config.cnf"
    New-Item -Path $MySQLCNF -ItemType File -Force
    Add-Content -Path $MySQLCNF -Value "[client]
    user = root
    password = $SQLRootPassword
    host = 127.0.0.1
    port = 3306"

# 创建MySQLUpdatecnf
$MySQLCNF = "$FinalServerFolder\Server\database\mysqlupdate.cnf"
    New-Item -Path $MySQLCNF -ItemType File -Force
    Add-Content -Path $MySQLCNF -Value "[client]
    user = root
    password = $SQLRootPassword
    host = 127.0.0.1
    port = 3306"

# 创建MySQL.bat
$MySQLbat = "$FinalServerFolder\start_mysql.bat"
New-Item -Path $MySQLbat -ItemType File -Force
Add-Content -Path $MySQLbat -Value "@echo off
SET NAME=MyCustomServer - mysql-5.7.29-winx64
TITLE %NAME%

echo.
echo.
echo Starting MySQL. Press CTRL C for server shutdown
echo.
echo.
cd .\Server\database\bin
mysqld --defaults-file=..\my.ini --console --standalone"

# 启动MySQL服务器
Set-Location "$FinalServerFolder"
Start-Process -FilePath "start_mysql.bat"

# 设置MySQL root的密码
$sqlCMD = "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQLRootPassword';"
$SQLChangePWArgs = "-uroot --execute=`"$sqlCMD`""
Start-Process -FilePath "$FinalServerFolder\Server\database\bin\mysql.exe" -ArgumentList $SQLChangePWArgs -Wait -ErrorAction Stop
Write-Information -MessageData "Root密码设置为：$SQLRootPassword" -InformationAction Continue

# 创建数据库
$CreateDBCMD = Get-Content -Path "$BaseLocation\data\sql\create\create_mysql.sql"
$CreateDBArgs = "--defaults-file=$FinalServerFolder\Server\database\config.cnf --execute=`"$CreateDBCMD`""
Start-Process -FilePath "$FinalServerFolder\Server\database\bin\mysql.exe" -ArgumentList $CreateDBArgs -Wait

# 配置数据库
Function Import-SQLscripts {
    param (
        [Parameter(Mandatory = $true,Position = 0)]
        [string]$SQLDatabase,
        [Parameter(Mandatory = $true,Position = 1)]
        [string]$SQLScriptsPath
    )

    $SQLscripts = Get-ChildItem -Path $SQLScriptsPath -Filter "*.sql"
    foreach ($SQLscript in $SQLscripts) {
        $SQLscriptpath = $SQLScriptsPath + "\" + $SQLscript
        Write-Progress -Activity "为$SQLDatabase导入SQL文件" -Status "$SQLscript"
        Try {
            Get-Content $SQLscriptpath | &".\mysql.exe" --defaults-file=..\config.cnf $SQLDatabase 
        } catch {
            Write-Information -MessageData "$SQLscriptpath failed to import" -InformationAction Continue
        }
    }
}
Set-Location -Path "$FinalServerFolder\Server\database\bin"
$authDBScriptsPath = "$BaseLocation\data\sql\base\db_auth"
$authDBupdateScriptsPath = "$BaseLocation\data\sql\updates\db_auth"
$characterDBScriptsPath = "$BaseLocation\data\sql\base\db_characters"
$characterDBupdateScriptsPath = "$BaseLocation\data\sql\updates\db_characters"
$worldDBScriptsPath = "$BaseLocation\data\sql\base\db_world"
$worldDBupdateScriptsPath = "$BaseLocation\data\sql\updates\db_world"

Import-SQLscripts -SQLDatabase "acore_auth" -SQLScriptsPath $authDBScriptsPath
Import-SQLscripts -SQLDatabase "acore_auth" -SQLScriptsPath $authDBupdateScriptsPath
Import-SQLscripts -SQLDatabase "acore_characters" -SQLScriptsPath $characterDBScriptsPath
Import-SQLscripts -SQLDatabase "acore_characters" -SQLScriptsPath $characterDBupdateScriptsPath
Import-SQLscripts -SQLDatabase "acore_world" -SQLScriptsPath $worldDBScriptsPath
Import-SQLscripts -SQLDatabase "acore_world" -SQLScriptsPath $worldDBupdateScriptsPath

# 从模块中导入SQL脚本
$InstalledModules = Get-ChildItem -Path "$BaseLocation\modules" -Filter "mod*"
foreach ($InstalledModule in $InstalledModules) {
    Write-Progress -Activity "从已安装的模块中导入SQL文件" -Status "$InstalledModule"
    $Modfiles = Get-ChildItem -Path "$BaseLocation\modules\$InstalledModule" -Recurse -Filter "*.sql"
    foreach ($Modfile in $Modfiles) {
        $Modpath = $Modfile.FullName
        $SQLDatabase = $false
        if (($Modpath -like "*character*") -and ($Modpath -notlike "*world*") -and ($Modpath -notlike "*auth*")) {
            $SQLDatabase = "acore_characters"
        } elseif (($Modpath -like "*world*") -and ($Modpath -notlike "*auth*") -and ($Modpath -notlike "*characters*")) {
            $SQLDatabase = "acore_world"
        } elseif (($Modpath -like "*auth*") -and ($Modpath -notlike "*world*") -and ($Modpath -notlike "*characters*")) {
            $SQLDatabase = "acore_auth"
        } else {
            $SQLDatabase = $false
        }
        if ($SQLDatabase -eq $false) {
            Write-Information -MessageData "`n`n不能确定$Modpath的数据库" -InformationAction Continue
            Write-Information -MessageData "提供数据库sql脚本应适用于`n`"auth`", `"characters`", or `"world`"`n" -InformationAction Continue
            do {
                $SQLDatabase = Read-Host -Prompt "这个SQL脚本的数据库？"
            } until (($SQLDatabase -eq "auth") -or ($SQLDatabase -eq "characters") -or ($SQLDatabase -eq "world"))
            if ($SQLDatabase -eq "auth") {
                $SQLDatabase = "acore_auth"
            }
            if ($SQLDatabase -eq "character") {
                $SQLDatabase = "acore_characters"
            }
            if ($SQLDatabase -eq "world") {
                $SQLDatabase = "acore_world"
            }
        }
        Try {
            #Write-Host "$Modpath installing to $SQLDatabase"
            Get-Content $Modpath | &".\mysql.exe" --defaults-file=..\config.cnf $SQLDatabase 
        } catch {
            Write-Information -MessageData "$Modpath导入失败" -InformationAction Continue
        }
    }
}

# 数据库配置后停止SQL服务器
Start-Process -FilePath "$FinalServerFolder\Server\database\bin\mysqladmin.exe" -ArgumentList "--user=root --password=$SQLRootPassword shutdown"

# 下载HeidiSQL
$HeidiURL = "https://www.heidisql.com/downloads/releases/HeidiSQL_11.3_64_Portable.zip"
$HeidiFileName = $HeidiURL.Split("/")[-1]
$HeidiZipFile = "$env:USERPROFILE\Downloads\$HeidiFileName"
Try {
    Invoke-WebRequest -Uri $HeidiURL -OutFile $HeidiZipFile
} Catch {
    Write-Error -Message "下载$HeidiFileName失败" -InformationAction Stop
}
Expand-Archive -Path $HeidiZipFile -DestinationPath "$FinalServerFolder\Tools\HeidiSQL"

# 创建worldserver.bat
$WorldServerbat = "$FinalServerFolder\start_worldserver.bat"
New-Item -Path $WorldServerbat -ItemType File -Force
Add-Content -Path $WorldServerbat -Value "@echo off
echo.
echo 这个服务器是使用Windows PowerShell自动编译的
echo https://www.gswxy.com
echo.
echo 启动worldserver，按CTRL C进行服务器关闭
echo.
cd .\Server
start worldserver.exe"

# 创建authserver.bat
$AuthServerbat = "$FinalServerFolder\start_authserver.bat"
New-Item -Path $AuthServerbat -ItemType File -Force
Add-Content -Path $AuthServerbat -Value "@echo off
echo.
echo 这个服务器是使用Windows PowerShell自动编译的
echo https://www.gswxy.com
echo.
echo 启动authserver，按CTRL C进行服务器关闭
echo.
cd .\Server
start authserver.exe"

Write-Information -MessageData "`n`n服务器完成！打开$FinalServerFolder，依次运行：`nstart_mysql.bat`nstart_authserver.bat`nstart_worldserver.bat`n祝贺你搭建了属于你自己的魔兽世界服务端！欢迎访问https://www.gswxy.com，并加入QQ群938973736讨论交流！" -InformationAction Continue