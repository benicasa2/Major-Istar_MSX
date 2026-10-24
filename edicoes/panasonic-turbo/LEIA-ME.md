# Major Istar — ROM MSX2 com turbo Panasonic automático

Arquivo: **MISTAR_MSX2_PANASONIC_TURBO.ROM**, cartucho normal de 32 KiB.

Esta edição mantém as cores e as otimizações da revisão anterior e ativa o modo Z80 de aproximadamente **5,37 MHz** em máquinas que confirmem o suporte ao protocolo turbo Panasonic, como a família FS-A1WX/WSX/FX. Foi testada em emulação de **FS-A1WSX e FS-A1WX**. O FS-A1FX não foi testado individualmente.

## Usar

Carregue a ROM como cartucho de 32 KiB e reinicie o computador/emulador. Na máquina compatível, a aceleração é ativada automaticamente antes de iniciar o jogo.

- **F2**, enquanto o jogo aguarda uma tecla ou comando: alterna entre 5,37 e 3,58 MHz.
- **Shift mantido durante a inicialização**: começa em 3,58 MHz. Solte Shift quando aparecer a apresentação. F2 pode ativar o turbo depois.
- **F1** mantém a troca das fases de azul/laranja.
- Pressione Espaço no título e na apresentação. Digite os comandos no aviso `OK`.
- `SAVE 1` e `LOAD 1` continuam salvando em RAM; o ponto se perde ao desligar/reiniciar.

`Jogar-Panasonic-FS-A1WSX.cmd` abre esta ROM no modelo Panasonic do openMSX já instalado nesta máquina. O atalho usa os BIOS existentes localmente, registrados durante os testes. Nenhum BIOS faz parte do pacote.

Em MSX2 sem o recurso turbo Panasonic, a ROM continua no clock normal. Esta é uma ROM **MSX2**, com vídeo SCREEN 5; não é a edição MSX1. Não ativa R800 nem turbos de outros protocolos.

## Funcionamento

A inicialização seleciona o fabricante Panasonic, ID 8, nas portas de I/O expandido. Confere a identificação e o bit de disponibilidade antes de alterar o bit de velocidade. Preserva os demais bits do controle e restaura a seleção anterior de I/O expandido. Caso o programa encerre ou detecte uma falha, tenta restaurar o modo de velocidade encontrado ao iniciar.

O turbo é controlado pelo hardware emulado/real, e não pelo ajuste de velocidade global do emulador. Não há modificação de BIOS ou firmware.

Referências técnicas: [protocolo de I/O expandido e turbo Panasonic](https://map.grauw.nl/resources/msx_io_ports.php), [implementação Matsushita do openMSX](https://github.com/openMSX/openMSX/blob/master/src/MSXMatsushita.cc).

## Resultado medido

Comparação da **mesma ROM no FS-A1WSX emulado**, com turbo automático e com Shift para manter o modo normal:

| Operação | 3,58 MHz | 5,37 MHz |
|---|---:|---:|
| Do ligar ao primeiro prompt de comando | 31,1 s | 23,5 s |
| Da entrada do jogo ao primeiro prompt | 25,9 s | 18,3 s |
| `DOWN`, incluindo a mesma digitação automática | 14,5 s | 11,2 s |

Os tempos são do relógio do MSX emulado, incluindo as esperas de apresentação e a entrada controlada. A frequência efetiva foi consultada no emulador: **3.579.545 Hz** e **5.369.318 Hz**. O ganho total é menor que a razão entre os clocks porque o acesso ao vídeo mantém suas próprias esperas.

## Verificação

- FS-A1WSX e FS-A1WX: detecção e ativação de 5,37 MHz confirmadas.
- FS-A1WSX com Shift: 3,58 MHz confirmado.
- F2: alternância de volta para 3,58 MHz e novamente para 5,37 MHz confirmada.
- C-BIOS MSX2: ausência do controlador e permanência no clock normal confirmadas.
- Configuração sintética com controlador Matsushita sem capacidade turbo: permanência no modo normal confirmada.
- A seleção anterior de I/O expandido foi preservada nos testes.
- As telas em VRAM nos modos turbo e normal foram idênticas. A conversão dos 24.576 bytes da tela SCREEN 5 foi conferida.
- Inventário, movimento e SAVE/LOAD em RAM passaram com turbo ativo.

Evidências em `VALIDACAO.json`, `testes/` e na captura `Panasonic-FS-A1WSX-turbo.png`. A integridade da ROM está em `SHA256.json`.

Não houve teste em computador físico nem percurso completo até o final do jogo. A edição continua usando o motor híbrido existente: inicialização, texto e gráficos são nativos Z80, e a lógica restante da aventura usa o núcleo de compatibilidade 6809.

## Fontes

`fontes/turbo.c` e `fontes/turbo.h` implementam a detecção e a seleção de velocidade. `fontes/msx.c` integra a inicialização e F2. Para reconstruir:

```powershell
python fontes/build.py --sdcc "C:/caminho/para/sdcc"
```

Foi utilizado SDCC 4.5.1 #15267 com os cabeçalhos/bibliotecas Z80 do pacote oficial 4.5.0, disponíveis localmente no diretório `tools/sdcc/sdcc` do projeto. Os dados do jogo original permanecem inalterados. Os direitos sobre Major Istar continuam com seus titulares; nenhum BIOS é redistribuído.
