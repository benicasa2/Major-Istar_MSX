# Major Istar para MSX — versão inicial jogável

Arquivos preparados em 24/10/2026 a partir do `MISTAR.BIN` fornecido pelo usuário (Major Istar, Computerware). O nome citado como `MISTER.BIN` foi entendido como esse mesmo arquivo.

## Os três formatos

| Arquivo | Destino | Como iniciar |
|---|---|---|
| `MISTAR_MSX1.ROM` | MSX1, cartucho de 32 KiB, pelo menos 16 KiB de RAM | Inserir como cartucho normal de 32 KiB e reiniciar |
| `MISTAR_MSX1.DSK` | MSX1 com drive, Disk ROM e RAM nas páginas 1, 2 e 3; testado com 64 KiB | Inserir no drive A: antes de ligar/reiniciar |
| `MISTAR_MSX2.ROM` | MSX2 com V9938, cartucho de 32 KiB | Inserir como cartucho; esta versão configura uma paleta azul e branca |

O DSK é um disquete FAT12 de 720 KiB com carregador próprio. Não precisa de MSX-DOS. Contém o jogo e nove arquivos `SAVE1.DAT` a `SAVE9.DAT`, já reservados no sistema de arquivos.

Nesta máquina, abra `Jogar-ROM-MSX1.cmd`, `Jogar-DSK-MSX1.cmd` ou `Jogar-ROM-MSX2.cmd`. Os atalhos usam o openMSX já instalado. O atalho de disquete usa uma configuração local com os arquivos de BIOS já existentes na instalação do blueMSX. Os BIOS não estão incluídos neste pacote.

## Controles e comandos

Pressione Espaço nas telas de apresentação e aguarde o aviso para continuar. Quando aparecer `OK`, digite um comando e pressione Enter. O jogo mantém seus textos originais em inglês.

- `LOOK` ou `L`: observar; `INVENTORY` ou `I`: inventário.
- `NORTH`, `SOUTH`, `EAST`, `WEST`, `UP`, `DOWN`: movimento. Também aceita as abreviações do original.
- Setas, quando usadas no início da linha, enviam a direção correspondente.
- `GET`, `DROP`, `OPEN`, `READ`, `USE` e outros verbos continuam sob a lógica original.
- Backspace corrige a linha digitada.

No cartucho, `SAVE` / `SAVE 1` e `LOAD` / `LOAD 1` usam um ponto salvo em RAM. Ele se perde ao desligar ou reiniciar. Para preservá-lo entre sessões, use também o recurso de salvar estado do emulador.

No DSK, `SAVE 1` a `SAVE 9` e `LOAD 1` a `LOAD 9` gravam/leem os arquivos reservados no próprio disquete. A imagem precisa estar com escrita permitida. Não desfragmente nem mova esses arquivos: este carregador acessa seus setores previamente reservados. Não há compatibilidade com os saves do CoCo.

## O que foi convertido

Esta é uma adaptação híbrida: um núcleo 6809 compilado para Z80 executa a lógica e os dados do jogo, e rotinas reconstruídas em C substituem o vídeo, teclado, entrada de comandos e salvamento do CoCo. O motor gráfico vetorial foi reconstruído em C e comparado com a execução das rotinas 6809. O vídeo usa SCREEN 2, com padrões monocromáticos; o MSX2 acrescenta uma paleta própria.

Isso preserva o programa fornecido sem depender de uma ROM de sistema do CoCo. Não é uma tradução integral de todo o motor para assembly Z80. Os nomes, comentários e arquivos de fonte originais de 1984 não são recuperáveis do BIN; o pseudocódigo do Ghidra é uma reconstrução para estudo e não compila diretamente.

## Fontes e compilação

`fontes/` contém o núcleo 6809 em C, motor gráfico, adaptação MSX, inicialização de cartucho, boot de disquete, dados extraídos, compilador de imagens e testes.

Exemplo no PowerShell, a partir desta pasta:

```powershell
python fontes/build.py --sdcc "C:/caminho/para/sdcc"
python fontes/test.py --gcc "C:/caminho/para/gcc.exe"
```

O diretório do SDCC deve conter `bin`, `include` e `lib/z80`. Foi utilizado SDCC 4.5.1 #15267, do projeto GBDK, com cabeçalhos/bibliotecas do pacote oficial SDCC 4.5.0. O instalador oficial 4.5.0 apresentou uma geração incorreta observada em uma condição do protótipo; use a versão testada. O SDCC fica instalado localmente no diretório `tools/sdcc/sdcc` do projeto desta máquina.

Referências das ferramentas: [SDCC](https://sdcc.sourceforge.net/), [compilador GBDK/SDCC utilizado](https://github.com/gbdk-2020/gbdk-2020-sdcc/releases/tag/sdcc-patched-gbdk-4.5.0), [Ghidra](https://github.com/NationalSecurityAgency/ghidra), [REA adaptado](https://github.com/benicasa2/rea-retro_7), [controle e comandos do openMSX](https://openmsx.org/manual/commands.html).

## Validação e limites

- Compilação dos dois cartuchos de 32 KiB e do DSK de 720 KiB.
- Testes do núcleo: flags aritméticas, ordem dos bytes, endereçamento indexado/relativo e pilha.
- Comparações dos 6.144 bytes da tela entre motor gráfico reconstruído e execução das rotinas 6809 em cinco sequências, incluindo apresentação, inventário, movimento e SAVE/LOAD.
- Testes no openMSX: ROM MSX1 em C-BIOS MSX1; ROM MSX2 em C-BIOS MSX2; DSK em MSX1 com BIOS/Disk ROM locais.
- SAVE/LOAD no DSK: registro gravado na imagem, deslocamento para outro cenário e retorno ao cenário salvo. No cartucho, recuperação do ponto em RAM também testada.

Os cenários iniciais e os comandos descritos foram exercitados. Não foi realizado um percurso completo até o final do jogo nem teste em hardware físico. Esta entrega deve ser tratada como uma versão inicial jogável para testes. A lógica 6809 interpretada pode responder mais lentamente que o original.

As evidências estão em `analise/`, `testes-host.json`, `testes-emulador.json`, capturas PNG e mapas de ligação. `SHA256.json` identifica os três arquivos entregues. A análise usa carga em `$2460`, entrada em `$2540` e arquitetura `6809:BE:16:default`.

O jogo e seus dados continuam pertencendo aos titulares originais. O pacote foi preparado localmente a partir do arquivo fornecido. Não foi publicado no GitHub. Nenhum BIOS de MSX ou CoCo é distribuído aqui.
