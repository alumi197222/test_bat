# �]�w�ܼ�
$installerExePath = "C:\Temp\AIDB_soft_107_2.exe"  # �������z���w���ɮצW��
# GitHub �W�� repository ZIP URL
$githubRepoZipUrl = "https://raw.github.com/alumi197222/test_bat/main/CNSFonts.zip"  # �������z�� GitHub �ܮw ZIP URL
$installerExeUrl = "https://www.cns11643.gov.tw/download/%E5%80%8B%E4%BA%BA%E9%9B%BB%E8%85%A6%E9%80%A0%E5%AD%97%E8%99%95%E7%90%86%E5%B7%A5%E5%85%B7%601q%60Unicode%E5%B9%B3%E5%8F%B0%601q%60%E5%85%A8%E5%AD%97%E5%BA%AB%E8%BB%9F%E9%AB%94%E5%8C%85%28Windows%E7%89%88%29/name/AIDB_soft_107_2.exe"  # �������w���ɮת� GitHub �U�� URL
$tempZipPath = "C:\Temp\CNSFonts.zip"       # �����Ȧs ZIP �ɮ׸��|
$sourceFolderPath = ".\CNSFonts"          # �������z��Ƨ����W��
$targetFolderPath = "C:\CNSFonts"         # ������Ƨ��ؼи��|
$regFiles = @{
  "7"  = "setup7.reg"
  "10" = "setup10.reg"
  "XP" = "setupXP.reg"
  "8"  = "win8Changjei.reg"
}


if (-Not (Test-Path -Path $targetFolderPath)) {
  # �ˬd�ؼи�Ƨ����s�b
  Write-Host "�ؼи�Ƨ����s�b�A����w���ɨ��л\��Ƨ�..." -ForegroundColor Green

  Write-Host "�w���ɥ��b�U��..." -ForegroundColor Green
  # �T�O C:\Temp ��Ƨ��s�b
  if (-Not (Test-Path -Path "C:\Temp")) {
    Write-Host "�إ� C:\Temp ��Ƨ�..." -ForegroundColor Yellow
    New-Item -Path "C:\Temp" -ItemType Directory
  }

  # ���դU���ɮ�
  Try {
    Invoke-WebRequest -Uri $installerExeUrl -OutFile $installerExePath -UseBasicParsing
    Write-Host "�ɮפU�������G$installerExePath" -ForegroundColor Green
  }
  Catch {
    Write-Host "�U�����ѡG" -ForegroundColor Red
    Write-Host $_.Exception.Message
    Exit
  }

  # ����w����

  Write-Host "���b����w�˵{��..." -ForegroundColor Green
  Write-Host "�Ш̷ӵ{�����ަw�˵{��..." -ForegroundColor Green
  Start-Process -FilePath $installerExePath -Wait -PassThru
  Write-Host "�w�˧����C" -ForegroundColor Green

  # �R�� exe �w���ɮ�
  Remove-Item -Path $installerExePath
  Write-Host "�w���ɮפw�R���C" -ForegroundColor Green
}
else {
  # �ˬd�ؼи�Ƨ��s�b
  Write-Host "�ؼи�Ƨ��w�s�b�A���л\��Ƨ����e..." -ForegroundColor Yellow
}
      
  # �U�� GitHub ZIP �ɮ�
  Write-Host "���b�U�� GitHub �x�s�w..." -ForegroundColor Green
  Invoke-WebRequest -Uri $githubRepoZipUrl -OutFile $tempZipPath
  Write-Host "�U�������C" -ForegroundColor Green
  Write-Host "�����N������..." -ForegroundColor Magenta
  # ���� ZIP �ɮר�ؼи�Ƨ�
  Write-Host "���b���� ZIP �ɮ�..." -ForegroundColor Green
  Expand-Archive -Path $tempZipPath -DestinationPath "C:\Temp\CNSFonts"
  Write-Host "ZIP �ɮ׸��������C" -ForegroundColor Green

  # �ˬd�����᪺��Ƨ��O�_�s�b
  $extractedFolderPath = "C:\Temp\CNSFonts"  # �T�O�o�O�����᪺��Ƨ��W��
  Write-Host "�����N������..." -ForegroundColor Magenta
  $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  if (Test-Path -Path $extractedFolderPath) {
    Write-Host "���b�N��������Ƨ����ʨ�ؼи��|..." -ForegroundColor Green
    Copy-Item -Path "$extractedFolderPath\*" -Destination $targetFolderPath -Recurse -Force
    Write-Host "��Ƨ��w���\���ʨ� $targetFolderPath" -ForegroundColor Green
  }
  else {
    Write-Host "�L�k�������᪺��Ƨ��G" -ForegroundColor Red
  }




# �R���{�� ZIP �ɮ�
Remove-Item -Path $tempZipPath
Write-Host "�{���ɮפw�R���C" -ForegroundColor Green
# �R�������Y�᪺��Ƨ�
Write-Host "���b�R�������Y�᪺�{�ɸ�Ƨ�..." -ForegroundColor Green
Remove-Item -Path $extractedFolderPath -Recurse -Force
Write-Host "�{�ɸ�Ƨ��w���\�R���C" -ForegroundColor Green

Write-Host "�����N������..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# ����ϥΪ̧@�~�t�Ϊ���
$osVersion = (Get-CimInstance Win32_OperatingSystem).Version
Write-Host "�˴���@�~�t�Ϊ����G$osVersion" -ForegroundColor Cyan

# �ھڧ@�~�t�Ϊ�����ܹ����� .reg �ɮ�
$regFileToUse = switch -regex ($osVersion) {
  "^6\.1" { $regFiles["7"] }  # Windows 7
  "^10\." { $regFiles["10"] } # Windows 10
  "^5\." { $regFiles["XP"] } # Windows XP
  "^6\.2|6\.3" { $regFiles["8"] }  # Windows 8 / 8.1
  # "^10\.0\.22" { $regFiles["10"] } # Windows 11 (Build 22000+)
  default { 
    Write-Host "�L�k�ѧO���@�~�t�Ϊ����A�N���w�� .reg �ɮסC" -ForegroundColor Red
    $null
  }
}

# ���� .reg �ɮ�
if ($regFileToUse -ne $null) {
  $regFilePath = Join-Path -Path $targetFolderPath -ChildPath $regFileToUse
  if (Test-Path -Path $regFilePath) {
    Write-Host "���b�פJ���������U���ɮסG$regFileToUse" -ForegroundColor Green
    Start-Process -FilePath "regedit.exe" -ArgumentList "/s $regFilePath" -Wait
    Write-Host "�w���\�פJ���U���ɮסG$regFileToUse" -ForegroundColor Green
  }
  else {
    Write-Host "�L�k�����U���ɮסG$regFilePath" -ForegroundColor Red
  }
}




# �����T��
Write-Host "�ާ@�����I" -ForegroundColor Cyan

# ���ݨϥΪ̫����N��
Write-Host "�����N������..." -ForegroundColor Magenta
$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")