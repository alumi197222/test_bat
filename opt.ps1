# 顯示選擇菜單
Write-Host "請選擇一個功能:"
Write-Host "1. 顯示本機的 IP 地址"
Write-Host "2. Ping Google DNS 8.8.8.8"

# 讓使用者選擇功能
$choice = Read-Host "請輸入選項 (1 或 2)"

# 根據使用者選擇執行相應的功能
if ($choice -eq "1") {
    # 功能 1: 顯示本機的 IP 地址
    Write-Host "顯示本機的 IP 地址:"
    $ipConfig = ipconfig | Select-String "IPv4"  # 篩選出包含 IPv4 地址的行
    if ($ipConfig) {
        $ipConfig
    } else {
        Write-Host "無法找到 IP 地址。"
    }
} elseif ($choice -eq "2") {
    # 功能 2: Ping Google DNS（8.8.8.8）
    Write-Host "`nPing Google DNS 8.8.8.8:"
    $pingResult = Test-Connection -ComputerName 8.8.8.8 -Count 4 -WarningAction SilentlyContinue
    if ($pingResult) {
        $pingResult
    } else {
        Write-Host "Ping 失敗，無法連接到 8.8.8.8。"
    }
} else{ Write-Host "無效的選項，請輸入 1 或 2。" }
    


# 保持控制台開啟，讓使用者看到結果
Read-Host "按 Enter 鍵退出"