@echo off
chcp 65001 >nul
title 自动检测 Firehose 并加载 lk2nd

setlocal enabledelayedexpansion

echo ================================
echo  自动检测 Firehose 并加载 lk2nd
echo ================================
echo.

:: 检查必要文件
if not exist "edl-ng.exe" (
    echo [错误] 找不到 edl-ng.exe
    pause
    exit /b
)

if not exist "lk2nd.img" (
    echo [错误] 找不到 lk2nd.img
    pause
    exit /b
)

:: 定义搜索模式（按优先级排序）
set "patterns=prog_emmc_firehose_8916.mbn prog_emmc_firehose_8916.elf prog_firehose_8916.mbn prog_firehose_8916.elf *8916*.mbn *8916*.elf *emmc*.mbn *emmc*.elf *firehose*.mbn *firehose*.elf"

echo [信息] 正在搜索可用 Firehose 文件...
echo.

set FOUND_LOADER=
set LOADER_FILE=

:: 尝试每个模式
for %%p in (%patterns%) do (
    for /r %%f in (%%p) do (
        if not defined FOUND_LOADER (
            echo [测试] %%f
            edl-ng --loader "%%f" printgpt >nul 2>&1
            if not errorlevel 1 (
                echo [成功] %%f 可用
                set FOUND_LOADER=1
                set LOADER_FILE=%%f
            ) else (
                echo [失败] %%f 不可用
            )
        )
    )
)

:: 如果没有找到，尝试无后缀文件
if not defined FOUND_LOADER (
    echo [信息] 尝试搜索无后缀文件...
    for %%f in (MSM8916 8916 8916_loader) do (
        if exist "%%f" (
            echo [测试] %%f
            edl-ng --loader "%%f" printgpt >nul 2>&1
            if not errorlevel 1 (
                echo [成功] %%f 可用
                set FOUND_LOADER=1
                set LOADER_FILE=%%f
            ) else (
                echo [失败] %%f 不可用
            )
        )
    )
)

:: 判断结果
if not defined FOUND_LOADER (
    echo.
    echo [结果] 所有 Firehose 文件均无法加载。
    echo 可能原因：
    echo   1. 设备未进入 9008 (EDL) 模式
    echo   2. 安全启动已开启，拒绝加载未签名 Firehose
    echo   3. 当前目录下没有匹配的 Firehose 文件
    echo.
    echo 请检查设备连接，或手动指定正确的 Firehose 文件。
    pause
    exit /b
)

:: 加载 lk2nd
echo.
echo [信息] 正在加载 lk2nd.img 到内存...
edl-ng --loader "!LOADER_FILE!" boot lk2nd.img

if errorlevel 1 (
    echo [错误] 加载 lk2nd 失败，请检查 lk2nd.img 是否有效。
) else (
    echo [成功] lk2nd 已加载到内存，设备应进入 Fastboot 模式。
    echo [结论] 安全启动状态：关闭
)

echo.
pause
