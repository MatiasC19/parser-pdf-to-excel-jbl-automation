@echo off
:: ═══════════════════════════════════════════════════════════════════
::  JBL Parser Faturas v2.0 — Script de Build
::  Gera JBLParser.exe via PyInstaller
::
::  Estrutura esperada na mesma pasta:
::    parser_neoenergia.py
::    jbl_parser_gui.py
::    jbl.ico
::
::  Poppler: C:\poppler-26.02.0\Library\bin\pdftotext.exe
:: ═══════════════════════════════════════════════════════════════════

set POPPLER_BIN=C:\poppler-26.02.0\Library\bin
set PDFTOTEXT=%POPPLER_BIN%\pdftotext.exe

:: ── Verificar Poppler ─────────────────────────────────────────────
if not exist "%PDFTOTEXT%" (
    echo.
    echo [ERRO] pdftotext.exe nao encontrado em:
    echo   %POPPLER_BIN%
    echo.
    pause
    exit /b 1
)

:: ── Verificar arquivos necessarios ───────────────────────────────
if not exist "parser_neoenergia.py" (
    echo [ERRO] parser_neoenergia.py nao encontrado nesta pasta.
    pause
    exit /b 1
)
if not exist "jbl_parser_gui.py" (
    echo [ERRO] jbl_parser_gui.py nao encontrado nesta pasta.
    pause
    exit /b 1
)
if not exist "jbl.ico" (
    echo [AVISO] jbl.ico nao encontrado - o exe ficara sem icone personalizado.
)

:: ── Limpar build anterior ────────────────────────────────────────
echo.
echo Limpando builds anteriores...
if exist build   rmdir /s /q build
if exist dist    rmdir /s /q dist
if exist JBLParser.spec del /q JBLParser.spec

:: ── Gerar .exe ──────────────────────────────────────────────────
echo.
echo Gerando JBLParser.exe ...
echo.

pyinstaller ^
  --onefile ^
  --windowed ^
  --name JBLParser ^
  --icon jbl.ico ^
  --add-data "parser_neoenergia.py;." ^
  --add-binary "%PDFTOTEXT%;." ^
  --add-binary "%POPPLER_BIN%\pdfinfo.exe;." ^
  --hidden-import pdfplumber ^
  --hidden-import pdfplumber.page ^
  --hidden-import pdfplumber.display ^
  --hidden-import pdfminer ^
  --hidden-import pdfminer.high_level ^
  --hidden-import pdfminer.layout ^
  --hidden-import pdfminer.pdfpage ^
  --hidden-import openpyxl ^
  --hidden-import openpyxl.styles ^
  --hidden-import openpyxl.utils ^
  --hidden-import PIL ^
  --hidden-import PIL.Image ^
  --hidden-import PIL.ImageTk ^
  jbl_parser_gui.py

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERRO] Build falhou. Veja log acima.
    echo.
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════
echo  Build concluido com sucesso!
echo  Executavel: dist\JBLParser.exe
echo ════════════════════════════════════════
echo.
pause
