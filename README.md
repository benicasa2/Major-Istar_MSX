# Major Istar para MSX

Conversão experimental de **Major Istar — Under the Doomed Sea**, de B. J. Chambless / Computerware (1984), a partir do arquivo CoCo fornecido para este projeto. Publicação de 24/10/2026.

## Últimas versões para jogar

| Computador | Arquivo |
|---|---|
| MSX1 — cartucho de 32 KiB | [MISTAR_MSX1.ROM](roms/MISTAR_MSX1.ROM) |
| MSX1 — disquete de 720 KiB | [MISTAR_MSX1.DSK](roms/MISTAR_MSX1.DSK) |
| MSX2 — cartucho de 32 KiB | [MISTAR_MSX2.ROM](roms/MISTAR_MSX2.ROM) |
| MSX2 Panasonic — turbo automático | [MISTAR_MSX2_PANASONIC_TURBO.ROM](roms/MISTAR_MSX2_PANASONIC_TURBO.ROM) |

As quatro imagens acima são cópias exatas das últimas entregas, com integridade em [roms/SHA256.json](roms/SHA256.json). Os arquivos históricos estão identificados separadamente.

## Uso

Carregue a ROM como cartucho ou inicialize pelo DSK. Pressione Espaço no título e na apresentação; digite os comandos em inglês no aviso `OK`. F1 alterna a fase azul/laranja.

A edição Panasonic detecta o controlador compatível e ativa aproximadamente 5,37 MHz. F2, no prompt ou espera de teclado, alterna turbo/normal. Shift mantido ao iniciar conserva 3,58 MHz. Foi validada em FS-A1WSX e FS-A1WX emulados; em MSX2 sem esse turbo permanece no clock normal. Não ativa R800. SAVE/LOAD na ROM usa RAM e se perde ao reiniciar; a edição DSK oferece slots 1 a 9 no disquete.

## Fontes, análises e dados

- [Edição com cores e otimizações](edicoes/cores-otimizado/LEIA-ME.md): fontes reproduzíveis, mapas, testes, capturas e ROMs MSX1/MSX2 e DSK.
- [Edição Panasonic turbo](edicoes/panasonic-turbo/LEIA-ME.md): fontes, controle do turbo, medições e evidências.
- [Análise original 6809](analise/original-6809/) e arquivos REA/Ghidra em `analise/` e nas edições.
- [Pacotes completos ZIP](downloads/), incluindo a primeira entrega preservada também em `historico/primeira-versao/`.

Para compilar, use Python e SDCC conforme os LEIA-ME de cada edição e execute `python fontes/build.py --sdcc "CAMINHO/DO/SDCC"` dentro da edição escolhida. Os atalhos de emulador e alguns registros preservam caminhos do computador de desenvolvimento; ajuste os caminhos ao usar outra máquina.

## Estado da conversão

O programa executa em MSX com CPU Z80. A implementação é híbrida: inicialização, gráficos e texto foram convertidos para código nativo Z80, enquanto parte da lógica original roda em um núcleo de compatibilidade 6809 compilado para Z80. Não corresponde à recuperação integral do código-fonte original.

Foram verificados inicialização, telas, comandos, movimento, inventário, SAVE/LOAD e integridade de vídeo no openMSX. A edição Panasonic reduziu o tempo até o primeiro comando de 31,1 s para 23,5 s no FS-A1WSX emulado. Não foi realizado teste em hardware físico nem percurso completo até o final do jogo. Relatórios detalhados estão nos arquivos VALIDACAO.json das edições.

## Créditos e ferramentas

Os direitos sobre o jogo original permanecem com seus titulares. Esta publicação não concede uma nova licença sobre seus dados. Consulte [Ferramentas e licenças](edicoes/cores-otimizado/fontes/FERRAMENTAS-E-LICENCAS.md). Foram usados REA, Ghidra, f9dasm, SDCC e openMSX. BIOS, credenciais e instalações locais de ferramentas não fazem parte deste repositório.
