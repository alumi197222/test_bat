# ��ܿ�ܵ��
Write-Host "�п�ܤ@�ӥ\��:"
Write-Host "1. ��ܥ����� IP �a�}"
Write-Host "2. Ping Google DNS 8.8.8.8"

# ���ϥΪ̿�ܥ\��
$choice = Read-Host "�п�J�ﶵ (1 �� 2)"

# �ھڨϥΪ̿�ܰ���������\��
if ($choice -eq "1") {
    # �\�� 1: ��ܥ����� IP �a�}
    Write-Host "��ܥ����� IP �a�}:"
    $ipConfig = ipconfig | Select-String "IPv4"  # �z��X�]�t IPv4 �a�}����
    if ($ipConfig) {
        $ipConfig
    } else {
        Write-Host "�L�k��� IP �a�}�C"
    }
} elseif ($choice -eq "2") {
    # �\�� 2: Ping Google DNS�]8.8.8.8�^
    Write-Host "`nPing Google DNS 8.8.8.8:"
    $pingResult = Test-Connection -ComputerName 8.8.8.8 -Count 4 -WarningAction SilentlyContinue
    if ($pingResult) {
        $pingResult
    } else {
        Write-Host "Ping ���ѡA�L�k�s���� 8.8.8.8�C"
    }
} else{ Write-Host "�L�Ī��ﶵ�A�п�J 1 �� 2�C" }
    


# �O������x�}�ҡA���ϥΪ̬ݨ쵲�G
Read-Host "�� Enter ��h�X"