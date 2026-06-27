# JBL Parser Faturas

Aplicação desktop para extração automatizada de dados de faturas de energia elétrica (PDF) de clientes do Grupo A, com geração de planilhas Excel consolidadas para uso em dashboards Power BI.

---

## Visão geral

O JBL Parser Faturas lê faturas de energia em PDF, identifica automaticamente a distribuidora emissora, extrai os dados estruturados (cadastro do cliente, tributos, itens de consumo/demanda, leituras de medidor) e gera um arquivo Excel com várias abas, pronto para ser consumido por um modelo de dados no Power BI.

### Problema que resolve

Empresas com múltiplas unidades consumidoras (UCs) recebem dezenas de faturas em PDF por mês, de diferentes distribuidoras, cada uma com layout próprio. Lançar esses dados manualmente em planilha é lento e sujeito a erro. Esta ferramenta automatiza a extração e padroniza a saída.

---

## Distribuidoras suportadas

| Distribuidora       | Estado | Detecção         |
|----------------------|--------|-------------------|
| Neoenergia           | PE     | Automática        |
| Equatorial            | PA     | Automática        |

O parser identifica a distribuidora pelo conteúdo do PDF (textos e padrões característicos de cada layout), sem precisar de configuração manual. Quando uma pasta contém faturas de mais de uma distribuidora, todas são processadas na mesma execução e consolidadas no mesmo arquivo de saída.

---

## Estrutura do repositório

```
.
├── README.md
├── build/
│   └── BUILD.bat          ← script de empacotamento (PyInstaller)
└── docs/
    └── INSTRUCOES.md      ← guia de build e instalador
```

---

## Arquitetura

```
┌─────────────────┐      ┌──────────────────────┐      ┌────────────────────┐
│   PDFs de       │ ───▶ │  Engine de extração   │ ───▶ │  Excel consolidado │
│   faturas       │      │  (detecção + parsing) │      │  (múltiplas abas)  │
└─────────────────┘      └──────────────────────┘      └────────────────────┘
                                    ▲
                                    │
                          ┌──────────────────┐
                          │  Interface gráfica│
                          │  (desktop, Tkinter)│
                          └──────────────────┘
```

### Componentes

- **Engine de extração** — módulo responsável por ler o texto do PDF, detectar a distribuidora e aplicar as regras de extração específicas de cada layout.
- **Gerador de Excel** — monta o arquivo de saída com abas padronizadas, formatação visual e fórmulas auxiliares.
- **Interface gráfica** — aplicação desktop (Windows) que permite selecionar a pasta de PDFs, escolher o destino do Excel e acompanhar o progresso do processamento.
- **Instalador** — empacotamento via PyInstaller + Inno Setup para distribuição como executável Windows, sem necessidade de instalar Python.

---

## Estrutura do Excel gerado

O arquivo de saída é organizado em abas temáticas, todas com cabeçalhos coloridos por seção e formatação consistente:

| Aba                  | Conteúdo                                                                 |
|-----------------------|---------------------------------------------------------------------------|
| **Cadastro**          | Dados do cliente, CNPJ, código de instalação/UC, endereço, classificação tarifária |
| **Faturamento**       | Nota fiscal, vencimento, tributos (PIS/COFINS/ICMS), bandeira tarifária, total a pagar |
| **Itens da Fatura**   | Linhas de demanda, consumo, reativos e encargos, com valores e tributos por item |
| **Medidor e Leituras**| Leituras anterior/atual, constante de medição e consumo por grandeza e posto horário |
| **Resumo e Tarifas**  | Consumo médio diário, demandas máximas e tarifas sem tributo (quando disponíveis na fatura) |
| **Histórico Meses**   | Série temporal de demanda e consumo dos últimos meses faturados |

> Algumas colunas variam conforme a distribuidora: nem toda fatura imprime os mesmos campos (por exemplo, tarifas sem tributo são exclusivas de alguns layouts).

---

## Stack técnica

- **Python 3.11**
- **pdfplumber** — extração de texto e tabelas do PDF
- **openpyxl** — geração do Excel com formatação avançada
- **Tkinter** — interface gráfica desktop
- **PyInstaller** — empacotamento em executável standalone
- **Inno Setup** — geração do instalador Windows
- **Poppler** — dependência de baixo nível para manipulação de PDF

---

## Como funciona o fluxo de uso

1. O usuário abre a aplicação e seleciona a pasta contendo os PDFs das faturas.
2. Define o caminho de saída do arquivo Excel.
3. A ferramenta detecta automaticamente a distribuidora de cada PDF (ou o usuário pode forçar uma distribuidora específica).
4. Cada fatura é processada individualmente; os dados extraídos são consolidados em uma única lista de faturas.
5. O Excel final é gerado com todas as abas, uma linha por fatura/mês em cada aba correspondente.
6. O log de execução mostra o progresso e eventuais erros por arquivo, sem interromper o processamento dos demais.

Detalhes de build e empacotamento: [`docs/INSTRUCOES.md`](docs/INSTRUCOES.md)

---

## Roadmap

- [x] Suporte a Neoenergia PE
- [x] Suporte a Equatorial PA
- [x] Interface gráfica desktop
- [x] Empacotamento em instalador Windows
- [ ] Suporte a distribuidoras adicionais
- [ ] Exportação direta para um modelo de dados Power BI (via API ou conector)
- [ ] Testes automatizados de regressão por layout de fatura

---

## Status de publicação

| Arquivo / Componente            | Status                          |
|----------------------------------|----------------------------------|
| `README.md`                      | ✅ Publicado |
| `docs/INSTRUCOES.md`             | ✅ Publicado |
| `build/BUILD.bat`                | ✅ Publicado |
| `parser_neoenergia.py` (engine)  | 🔧 Em desenvolvimento — não publicado |
| `jbl_parser_gui.py` (interface)  | 🔧 Em desenvolvimento — não publicado |
| `JBLParser_Setup.iss` (instalador)| 🔧 Em desenvolvimento — não publicado |
| Ícone e assets visuais           | 🔧 Em desenvolvimento — não publicado |

Este repositório é atualizado conforme o projeto avança.
