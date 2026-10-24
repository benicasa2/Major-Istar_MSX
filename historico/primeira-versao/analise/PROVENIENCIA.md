# Proveniência da análise

- Entrada: payload do MISTAR.BIN fornecido pelo usuário; SHA-256 `28babf7eff9bd3a7e0c4f92620a5af258bb8bd43fdf1b4b1790c9478d9e04881`, 19.361 bytes, carga `$2460`, execução `$2540`.
- `REA-mapeamento.json`, `REA-entrada.json` e `REA-entrada.c` foram preservados da análise prévia com o REA/Ghidra instalado neste projeto. O mapeamento contém o resultado verificado dessa análise.
- `MISTAR-ghidra-reconstruido.c` foi exportado nesta etapa por Ghidra 12.1.4 headless, usando o processador `6809:BE:16:default` e o script `fontes/ExportMistar.java`. O log de execução acompanha o resultado.
- Uma nova tentativa de abrir a sessão via cliente MCP local do REA atingiu o limite de 240 segundos, inclusive após redirecionar os diretórios de configuração para o projeto. Ela não produziu evidência nova. A exportação adicional foi concluída diretamente no Ghidra, sem depender dessa reabertura.
- `MISTAR-6809.lst` é a listagem linear previamente gerada por f9dasm. Regiões de dados também aparecem como instruções e não devem ser consideradas código confirmado.
- A reconstrução gráfica compilável está em `fontes/graphics.c`. As regressões compararam seus 6.144 bytes de tela com a execução das rotinas 6809 em cinco sequências; os resultados estão em `testes-host.json`.

O pseudocódigo e as listagens são reconstruções parciais. Não contêm os nomes, comentários ou estrutura dos fontes originais e não substituem a validação do jogo completo.
