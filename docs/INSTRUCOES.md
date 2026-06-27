# JBL Parser Faturas v2.0 — Guia de Build e Instalador

## Arquivos do pacote (referenciados neste guia)

```
📁 JBL_Parser_v2/
├── parser_neoenergia.py      ← Engine de extração (em desenvolvimento, não publicado aqui)
├── jbl_parser_gui.py         ← Interface gráfica tkinter (em desenvolvimento, não publicado aqui)
├── build/BUILD.bat           ← Script de build (gera o .exe) — disponível neste repositório
├── JBLParser_Setup.iss       ← Script do instalador (Inno Setup) — ainda não publicado
└── jbl.ico                   ← Ícone do app — ainda não publicado
```

> Este guia documenta o processo completo de build, mesmo que alguns dos arquivos referenciados ainda não estejam publicados neste repositório.

---

## Passo 1 — Instalar dependências Python

```bash
pip install pyinstaller pillow pdfplumber openpyxl
```

---

## Passo 2 — Instalar Poppler standalone

Baixe a versão standalone (não o Git/mingw64):

**Link:** https://github.com/oschwartz10612/poppler-windows/releases

1. Baixe o arquivo `.zip` mais recente
2. Extraia para uma pasta de sua preferência
3. Ajuste a variável `POPPLER_BIN` em `build/BUILD.bat` para apontar para a pasta `bin` extraída

> ⚠️ Não use o `pdftotext.exe` do Git (`C:\Program Files\Git\mingw64\bin\`).
> Ele tem problemas de encoding com caracteres brasileiros no .exe empacotado.

---

## Passo 3 — Gerar o .exe

Coloque todos os arquivos necessários (`parser_neoenergia.py`, `jbl_parser_gui.py`, `jbl.ico`) na mesma pasta que `build/BUILD.bat` e execute:

```
BUILD.bat
```

O executável será gerado em `dist\JBLParser.exe`.

---

## Passo 4 — Gerar o instalador

1. Baixe o **Inno Setup**: https://jrsoftware.org/isdl.php
2. Abra o **Inno Setup Compiler**
3. `File → Open → JBLParser_Setup.iss`
4. `Build → Compile` (ou F9)
5. O instalador será gerado na mesma pasta

---

## Distribuidoras suportadas

| Distribuidora     | Detecção        | Abas geradas no Excel                                      |
|-------------------|-----------------|--------------------------------------------------|
| Neoenergia PE     | Automática      | Cadastro, Faturamento, Itens da Fatura, Medidor e Leituras, Demonstrativo Consumo, ICMS-CDE |
| Equatorial PA     | Automática      | Cadastro, Faturamento, Itens da Fatura, Medidor e Leituras, Resumo e Tarifas, Histórico Meses |
| Misto (ambas)     | Automática      | Todas as abas de ambas as distribuidoras          |

---

## Uso da ferramenta

1. Abra o **JBL Parser Faturas**
2. Selecione a **pasta** com os PDFs
3. Defina o **arquivo Excel de saída**
4. Deixe "Detectar automaticamente" ou escolha a distribuidora
5. Clique em **▶ Processar PDFs**

---

## Notas

- O nome do arquivo PDF vira a coluna "Arquivo PDF" no Excel — nomeie os PDFs com o nome do cliente
- Todos os PDFs da pasta são processados de uma só vez
- PDFs mistos (Neoenergia + Equatorial na mesma pasta) funcionam normalmente

---

## Status de publicação dos arquivos

Este repositório está em construção. Nem todos os arquivos do projeto foram publicados ainda — consulte o README principal para o status atualizado de cada componente.
