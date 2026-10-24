# Ferramentas e direitos

O código desta edição implementa regras próprias em C99 compilado diretamente para Z80, com inicialização e chamadas BIOS em assembly Z80. Não inclui núcleo de execução de outra CPU. O assembly produzido pelo SDCC acompanha os fontes.

Os textos, fontes, desenhos e dados em assets.bin foram extraídos do arquivo Major Istar fornecido para este projeto. O jogo original é de B. J. Chambless / Computerware (1984); os direitos desses recursos permanecem com seus titulares. A inclusão não concede uma nova licença sobre o jogo.

Foram usados SDCC 4.5.1 #15267 da distribuição GBDK/SDCC, cabeçalhos e bibliotecas Z80 do pacote oficial SDCC 4.5.0, Python, GCC para testes de regras e openMSX 21.0 para os percursos completos. REA/Ghidra e f9dasm apoiaram a extração e análise do original em etapas anteriores. Nenhum compilador, emulador ou BIOS é redistribuído neste pacote. SDCC-COPYING.txt documenta os termos da ferramenta; a licença e a exceção de ligação das bibliotecas permanecem nas respectivas distribuições.

Referências de BIOS e controle: https://map.grauw.nl/resources/msxbios.php e https://map.grauw.nl/resources/msx_io_ports.php .
