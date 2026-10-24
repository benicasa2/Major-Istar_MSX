# MISTAR — base de engenharia reversa para conversões

## O que foi recuperado
Desmontagem preliminar em Assembly Motorola 6809, não o fonte original do autor.
O binário não conserva nomes originais, comentários ou separação explícita de código e recursos.

- MISTAR.asm: desmontagem guiada a partir da entrada e dos desvios diretos.
- MISTAR.lst: a mesma análise com endereços e bytes.
- MISTAR_linear.lst: interpretação linear de TODO o conteúdo; inclui dados interpretados como instruções. Serve para investigação, não como fonte validado.
- MISTAR_exato.asm: ORG/FCB/END preservando integralmente os 19.361 bytes. É uma representação recompilável por diretivas, não código interpretado.
- MISTAR.raw: conteúdo sem cabeçalho e rodapé DECB; mapear em $2460.
- MISTAR.info: classificação inicial editável para f9dasm.
- analise.json: hash, cobertura, chamadas, conflitos e desvios não resolvidos.
- analisar_mistar.py: script usado, executável da raiz do workspace original; requer Python e work/f9dasm/f9dasm.exe compilado.

## Endereços e início observado
Carga: $2460–$7000, inclusivos. Entrada: $2540.
$2540: LDX #$0160
$2543: LDY #$2460
$2547: LDA ,Y+
$2549: STA ,X+
$254B: CMPY #$2540
$254F: BNE $2547
$2551: JMP $2610

Isso copia 224 bytes para $0160–$023F. Referências a essa região precisam ser analisadas também na posição de execução, não apenas na posição original do arquivo.
$2611 chama $38C2; $2614 escreve em $FF40; $2619 escreve em $FF03.
$264D e $2660 chamam indiretamente por [$A000]. Atribuir finalidade exata a esses acessos exige confrontar a ROM/hardware do modelo e observar execução.

## Cobertura e limites
A travessia estática inicial marcou 643 instruções candidatas / 1.579 bytes.
Os outros 17.782 bytes foram preservados; NÃO são todos dados confirmados.
Há conflitos de alinhamento e desvios indiretos registrados em analise.json.
A classificação é uma hipótese de análise, não prova de execução nem recuperação completa das rotinas do jogo.
Código realocado, ponteiros de funções, tabelas, instruções que manipulam o retorno e automodificação podem exigir revisão manual e rastreamento em emulador.
Não se atribuiu nomes semânticos às funções ainda desconhecidas.

## Validação executada
A representação FCB foi lida novamente e comparada byte a byte ao payload.
Reconstruir o envelope DECB com carga/entrada originais produziu exatamente MISTAR.BIN.
Não foi executado assembler externo, emulador nem teste do jogo. MISTAR.asm não teve recompilação validada.
O original CAS e o BIN não foram modificados.

## REA e ferramenta efetiva
Foi consultado o REA local 6.7.0, incluindo AGENTS.md, a skill reverse-engineer-anything e docs/raw-binary.md.
O adaptador raw admite x86/x86_64/arm/arm64/6502/m68k; não admite 6809. No Windows o raw está limitado a 6502.
Portanto NÃO houve execução de análise pelo REA nem produção de Evidence REA.
Não confundir Motorola 68000 (m68k) com Motorola 6809.
A desmontagem efetiva foi feita com f9dasm V1.83, compilado localmente com GCC.
Fontes: https://github.com/Arakula/f9dasm e https://github.com/morluto/rea/blob/main/docs/raw-binary.md

## Próximas etapas para portar
1. Validar o fluxo em emulador CoCo e mapear os bytes realocados em $0160.
2. Resolver saltos indiretos, conflitos e entradas ausentes; revisar MISTAR.info.
3. Identificar telas, fontes, sprites, sons, tabelas e estado do jogo.
4. Nomear rotinas após confirmação; separar lógica de vídeo, teclado, som e chamadas de ROM.
5. Escolher o computador de destino e reimplementar essas interfaces. Assembly 6809 não se converte automaticamente para outro processador.

## Reproduzir a desmontagem guiada
Na raiz do workspace original, após executar o script:
work/f9dasm/f9dasm.exe -noflex -offset 2460 -info outputs/MISTAR_fonte/MISTAR.info -out outputs/MISTAR_fonte/MISTAR.lst outputs/MISTAR_fonte/MISTAR.raw
