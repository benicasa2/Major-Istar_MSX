# Ferramentas e arquivos de origem

Os fontes de adaptação (`cpu.c`, `graphics.c`, `platform.c`, `msx.c`, inicialização e boot) foram escritos para este projeto. O núcleo de execução é específico desta adaptação e não substitui um emulador completo de CoCo.

`MISTAR.raw` contém os 19.361 bytes extraídos do arquivo fornecido pelo usuário. Seu SHA-256 é `28babf7eff9bd3a7e0c4f92620a5af258bb8bd43fdf1b4b1790c9478d9e04881`. O jogo original é Major Istar, Computerware, de B. J. Chambless. A inclusão desses dados não concede uma nova licença sobre o jogo.

O SDCC utilizado é o compilador 4.5.1 #15267 da distribuição [GBDK/SDCC](https://github.com/gbdk-2020/gbdk-2020-sdcc/releases/tag/sdcc-patched-gbdk-4.5.0), combinado com os cabeçalhos e bibliotecas Z80 da distribuição oficial SDCC 4.5.0. O compilador não é redistribuído neste ZIP. As bibliotecas de execução do SDCC usam GPL com a exceção de ligação descrita em seus próprios fontes. A cópia de `SDCC-COPYING.txt` acompanha este pacote como referência à licença da ferramenta; os termos específicos e avisos de cada rotina permanecem na distribuição do SDCC.

Ghidra 12.1.4 foi utilizado com o módulo 6809 instalado para produzir `analise/MISTAR-ghidra-reconstruido.c`. Os arquivos `REA-entrada.*` e `REA-mapeamento.json` preservam as evidências da análise prévia realizada com REA/Ghidra. O arquivo `MISTAR-6809.lst` foi gerado anteriormente com f9dasm. A listagem linear também interpreta regiões de dados como instruções e precisa de revisão humana.

Os testes de emulação usam C-BIOS para os cartuchos e BIOS já existentes no blueMSX desta máquina para o disquete. Nenhum BIOS foi incluído no pacote. As configurações locais e os atalhos não alteram as instalações desses emuladores.
