# Major Istar — edição nativa Z80 para MSX

Esta edição **não usa o núcleo 6809** das versões anteriores. A lógica foi reescrita em C e compilada diretamente para Z80. Os fontes C e o assembly Z80 gerado estão incluídos.

## Escolher o arquivo

| Computador | Arquivo |
|---|---|
| MSX2+ com 512 KB; opção principal | `MISTAR_MSX2PLUS_Z80_TURBO.ROM` |
| MSX2 | `MISTAR_MSX2_Z80.ROM` |
| MSX1 | `MISTAR_MSX1_Z80.ROM` |
| MSX1, disquete | `MISTAR_MSX1_Z80.DSK` |

Todas as ROMs são cartuchos normais de 32 KiB. A ROM principal também funciona em MSX2: ativa 5,37 MHz apenas quando detecta o protocolo turbo Panasonic. O teste principal usou MSX2+, V9958 e **524.288 bytes de RAM mapeada**, confirmados pelo emulador. A implementação coube sem precisar da RAM extra; 512 KB não são obrigatórios para jogar esta edição.

## Jogar

Pressione Espaço no título e nas instruções. Digite os comandos em inglês no aviso OK e confirme com Enter. Use as setas ou joystick da porta 1 nas fases de atracação e segurança. F1 alterna as fases de azul/laranja. Na edição principal, F2 alterna o turbo enquanto aguarda comando/tecla; Shift mantido ao iniciar conserva o clock normal.

Nas ROMs, SAVE 1 e LOAD 1 usam RAM; o ponto se perde ao reiniciar. No DSK, use os slots 1 a 9 numa cópia gravável da imagem, sem mover ou desfragmentar os arquivos reservados. **Os saves nativos usam formato MIZ2 e não são compatíveis com os saves da edição híbrida.** O DSK entregue tem os slots vazios.

## Fidelidade e validação

A aventura foi concluída até **THIS ADVENTURE IS OVER! / TRY AGAIN (Y/N)** em cinco configurações: MSX1 ROM, MSX1 DSK, MSX2, Panasonic FS-A1WSX e MSX2+ com 512 KB. Cada percurso executou as 78 etapas do walkthrough, 206 entradas de texto, atracação e três travessias das áreas de segurança. Os comandos e controles foram enviados ao teclado emulado; nenhum estado do jogo foi escrito pelo depurador e nenhuma etapa foi pulada.

Em **207 pontos de comando**, foram comparados o framebuffer completo de 6.144 bytes, os 825 bytes de objetos, a sala, o inventário, as condições relevantes e a contagem de jogadas com a edição corrigida anterior: **zero diferenças**. A comparação usou novamente o roteiro, incluindo a digitação integral de MUSHROOM. A VRAM final das cinco configurações também corresponde à conversão esperada.

SAVE/LOAD passou nas cinco configurações. Testes adicionais das regras nativas verificaram ferramentas, recipientes, capacidade do inventário, combinação da pílula, perigos, iluminação, reinício e rejeição de saves corrompidos. Relatórios, registros, transcrições e capturas estão em `testes/`; o resumo está em `VALIDACAO.json` e a integridade em `SHA256.json`.

O teste automatizado observa o estado para escolher as teclas dos minijogos; esse jogador está apenas nos scripts de teste, não nas ROMs. As imagens `*-final-framebuffer.png` vêm dos bytes efetivamente capturados; capturas do renderizador podem mostrar um quadro anterior ao executar fora da tela. A validação cobre o percurso descrito e os cenários adicionais; não garante todas as sequências possíveis de comandos. Não houve teste em MSX ou joystick físico. Os efeitos PSG são adaptados e não reproduzem exatamente o áudio do CoCo.

## Compilar

```powershell
python fontes/build.py --sdcc "C:/caminho/para/sdcc"
python fontes/test.py --gcc "C:/caminho/para/gcc.exe"
```

Foi usado SDCC 4.5.1 #15267 com as bibliotecas Z80 oficiais 4.5.0. Não é necessário obter ou executar o BIN 6809 para compilar: assets.bin contém apenas os recursos usados pelo motor nativo. `ARQUITETURA.md` explica os módulos e a disposição da memória; `dados/` contém salas e objetos legíveis. Os scripts de emulação preservam caminhos do ambiente de desenvolvimento e exigem configuração local do openMSX e dos BIOS, que não acompanham este pacote.

Os direitos sobre o jogo e seus recursos originais permanecem com seus titulares. As versões híbridas anteriores foram preservadas separadamente no computador.
