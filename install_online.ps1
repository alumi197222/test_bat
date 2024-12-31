# 設定變數
$installerExePath = "C:\Temp\AIDB_soft_107_2.exe"  # 替換為您的安裝檔案名稱
# GitHub 上的 repository ZIP URL
$githubRepoZipUrl = "https://raw.github.com/alumi197222/test_bat/main/CNSFonts.zip"  # 替換為您的 GitHub 倉庫 ZIP URL
$installerExeUrl = "https://www.cns11643.gov.tw/download/%E5%80%8B%E4%BA%BA%E9%9B%BB%E8%85%A6%E9%80%A0%E5%AD%97%E8%99%95%E7%90%86%E5%B7%A5%E5%85%B7%601q%60Unicode%E5%B9%B3%E5%8F%B0%601q%60%E5%85%A8%E5%AD%97%E5%BA%AB%E8%BB%9F%E9%AB%94%E5%8C%85%28Windows%E7%89%88%29/name/AIDB_soft_107_2.exe"  # 替換為安裝檔案的 GitHub 下載 URL
$tempZipPath = "C:\Temp\CNSFonts.zip"       # 本機暫存 ZIP 檔案路徑
$sourceFolderPath = ".\CNSFonts"          # 替換為您資料夾的名稱
$targetFolderPath = "C:\CNSFonts"         # 本機資料夾目標路徑
$regFiles = @{
  "7"  = "setup7.reg"
  "10" = "setup10.reg"
  "XP" = "setupXP.reg"
  "8"  = "win8Changjei.reg"
}


if (-Not (Test-Path -Path $targetFolderPath)) {
  # 檢查目標資料夾不存在
  Write-Host "目標資料夾不存在，執行安裝檔並覆蓋資料夾..." -ForegroundColor Green

  Write-Host "安裝檔正在下載..." -ForegroundColor Green
  # 確保 C:\Temp 資料夾存在
  if (-Not (Test-Path -Path "C:\Temp")) {
    Write-Host "建立 C:\Temp 資料夾..." -ForegroundColor Yellow
    New-Item -Path "C:\Temp" -ItemType Directory
  }

  # 嘗試下載檔案
  Try {
    Invoke-WebRequest -Uri $installerExeUrl -OutFile $installerExePath -UseBasicParsing
    Write-Host "檔案下載完成：$installerExePath" -ForegroundColor Green
  }
  Catch {
    Write-Host "下載失敗：" -ForegroundColor Red
    Write-Host $_.Exception.Message
    Exit
  }

  # 執行安裝檔

  Write-Host "正在執行安裝程式..." -ForegroundColor Green
  Write-Host "請依照程式指引安裝程式..." -ForegroundColor Green
  Start-Process -FilePath $installerExePath -Wait -PassThru
  Write-Host "安裝完成。" -ForegroundColor Green

  # 刪除 exe 安裝檔案
  Remove-Item -Path $installerExePath
  Write-Host "安裝檔案已刪除。" -ForegroundColor Green
}
else {
  # 檢查目標資料夾存在
  Write-Host "目標資料夾已存在，僅覆蓋資料夾內容..." -ForegroundColor Yellow
}
      
  # 下載 GitHub ZIP 檔案
  Write-Host "正在下載 GitHub 儲存庫..." -ForegroundColor Green
  Invoke-WebRequest -Uri $githubRepoZipUrl -OutFile $tempZipPath
  Write-Host "下載完成。" -ForegroundColor Green
  Write-Host "按任意鍵關閉..." -ForegroundColor Magenta
  # 解壓 ZIP 檔案到目標資料夾
  Write-Host "正在解壓 ZIP 檔案..." -ForegroundColor Green
  Expand-Archive -Path $tempZipPath -DestinationPath "C:\Temp\CNSFonts"
  Write-Host "ZIP 檔案解壓完成。" -ForegroundColor Green

  # 檢查解壓後的資料夾是否存在
  $extractedFolderPath = "C:\Temp\CNSFonts"  # 確保這是解壓後的資料夾名稱
  Write-Host "按任意鍵關閉..." -ForegroundColor Magenta
  $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  if (Test-Path -Path $extractedFolderPath) {
    Write-Host "正在將解壓的資料夾移動到目標路徑..." -ForegroundColor Green
    Copy-Item -Path "$extractedFolderPath\*" -Destination "C:\" -Recurse -Force
    Write-Host "資料夾已成功移動到 $targetFolderPath" -ForegroundColor Green
  }
  else {
    Write-Host "無法找到解壓後的資料夾：" -ForegroundColor Red
  }




# 刪除臨時 ZIP 檔案
Remove-Item -Path $tempZipPath
Write-Host "臨時檔案已刪除。" -ForegroundColor Green
# 刪除解壓縮後的資料夾
Write-Host "正在刪除解壓縮後的臨時資料夾..." -ForegroundColor Green
Remove-Item -Path $extractedFolderPath -Recurse -Force
Write-Host "臨時資料夾已成功刪除。" -ForegroundColor Green

Write-Host "按任意鍵關閉..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# 獲取使用者作業系統版本
$osVersion = (Get-CimInstance Win32_OperatingSystem).Version
Write-Host "檢測到作業系統版本：$osVersion" -ForegroundColor Cyan

# 根據作業系統版本選擇對應的 .reg 檔案
$regFileToUse = switch -regex ($osVersion) {
  "^6\.1" { $regFiles["7"] }  # Windows 7
  "^10\." { $regFiles["10"] } # Windows 10
  "^5\." { $regFiles["XP"] } # Windows XP
  "^6\.2|6\.3" { $regFiles["8"] }  # Windows 8 / 8.1
  # "^10\.0\.22" { $regFiles["10"] } # Windows 11 (Build 22000+)
  default { 
    Write-Host "無法識別的作業系統版本，將不安裝 .reg 檔案。" -ForegroundColor Red
    $null
  }
}

# 執行 .reg 檔案
if ($regFileToUse -ne $null) {
  $regFilePath = Join-Path -Path $targetFolderPath -ChildPath $regFileToUse
  if (Test-Path -Path $regFilePath) {
    Write-Host "正在匯入相應的註冊表檔案：$regFileToUse" -ForegroundColor Green
    Start-Process -FilePath "regedit.exe" -ArgumentList "/s $regFilePath" -Wait
    Write-Host "已成功匯入註冊表檔案：$regFileToUse" -ForegroundColor Green
  }
  else {
    Write-Host "無法找到註冊表檔案：$regFilePath" -ForegroundColor Red
  }
}




# 結束訊息
Write-Host "操作完成！" -ForegroundColor Cyan

# 等待使用者按任意鍵
Write-Host "按任意鍵關閉..." -ForegroundColor Magenta
$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")