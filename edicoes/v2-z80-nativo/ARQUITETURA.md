# Arquitetura nativa Z80

O jogo foi reescrito em C99 e compilado pelo SDCC para instruções nativas Z80. O assembly gerado está em `assembly/`. Os fontes não incluem `cpu.c`, `cpu.h`, um decodificador de opcodes 6809, registradores de CPU virtual, contador de programa virtual, pilha virtual ou tabelas de remendos de instruções.

- `adventure.c`: parser, verbos, salas, inventário, objetos, ferramentas, iluminação, perigos, gravação e final da aventura. As regras são funções próprias de jogo.
- `arcade.c`: navegação entre bolhas, robôs, escadas, colisões e vidas, escritas como regras nativas.
- `screen.c`: texto, entrada de linha, fontes bitmap e framebuffer.
- `graphics.c`: primitivas nativas que desenham os recursos vetoriais e padrões originais. O fluxo de comandos é um formato de imagem; não é código de processador 6809.
- `msx.c`: vídeo TMS9918/V9938/V9958, teclado, joystick, som PSG e disco BIOS.
- `turbo.c`: controle opcional do turbo Z80 Panasonic.

`assets.bin` contém apenas os recursos originais entre os identificadores 3B26 e 6C34. A área de código executável original anterior a 3B26 foi excluída. As antigas tabelas de ponteiros de funções em 4B30–4C79 e 5C17–5C2A foram zeradas, pois a execução agora usa funções e enumerações nativas. Os identificadores históricos que permanecem nos fontes designam textos, figuras ou tabelas de dados, sem despacho para instruções de outra CPU.

O cartucho ocupa 32 KiB e não precisa de MegaROM. Código nativo e dados constantes são ligados a partir de 4080; recursos ocupam a região 8C00–BD0E; RAM de trabalho começa em C000. Os mapas de ligação acompanham cada edição. O build verifica que não há sobreposição. Os dados legíveis em `dados/` ajudam a revisar salas e objetos em futuras conversões.

O alvo principal foi validado num MSX2+ V9958 com 512 KiB de RAM mapeada e turbo Panasonic. A reescrita coube nos limites menores sem sacrificar os recursos deste percurso, por isso não foi necessário consumir a RAM adicional ou exigir um mapper de cartucho. A mesma ROM roda em MSX2/MSX2+ com 64 KiB de RAM; em máquinas sem turbo Panasonic continua com o clock normal. Há ainda compilações MSX1 e DSK, validadas separadamente.

Os dados gráficos, textos, objetos e conexões vieram da extração e análise anterior do arquivo fornecido pelo usuário, apoiada por REA/Ghidra e f9dasm. O motor de regras e as fases arcade desta edição são implementações nativas próprias. Isso preserva os dados do jogo sem executar o código 6809 original.
