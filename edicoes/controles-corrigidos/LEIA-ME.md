# Major Istar MSX — controles corrigidos e aventura completa validada

Revisão de 24/10/2026. As quatro imagens na raiz são as versões atuais para jogar:

- `MISTAR_MSX1.ROM`: cartucho MSX1 de 32 KiB.
- `MISTAR_MSX1.DSK`: disquete MSX1 de 720 KiB, com slots de save vazios.
- `MISTAR_MSX2.ROM`: cartucho MSX2 de 32 KiB, cores SCREEN 5.
- `MISTAR_MSX2_PANASONIC_TURBO.ROM`: MSX2, ativa turbo Z80 Panasonic quando disponível.

## Como jogar

Pressione Espaço no título e nos avisos de continuação. Digite comandos em inglês no aviso OK e confirme com Enter. Nas fases de atracação e segurança, **use as quatro setas ou o joystick da porta 1**. Também são aceitas diagonais. O botão A do joystick ou Espaço continua as instruções das fases de ação.

F1 alterna a fase azul/laranja. Na edição Panasonic, F2 alterna turbo/normal enquanto aguarda tecla ou comando; Shift mantido ao iniciar conserva o clock normal. A versão MSX2 requer MSX2 ou superior; a edição MSX1 usa a paleta fixa de seu vídeo.

SAVE 1 e LOAD 1 no cartucho guardam o ponto apenas na RAM, que se perde ao reiniciar. No DSK, SAVE 1 a SAVE 9 usam os arquivos reservados da imagem, que precisa aceitar escrita. Não mova nem desfragmente esses arquivos. Os testes de save foram feitos em cópias do DSK; a imagem entregue continua com os slots vazios.

## Correções

A chamada original de joystick era encaminhada para impressão de texto, deixando as coordenadas sem atualização. Ela agora lê as setas e o serviço BIOS GTSTCK para a porta 1, traduzindo as direções para os valores esperados pelo jogo. GTTRIG adapta o botão de continuação. IX/IY são preservados nos acessos ao BIOS.

O framebuffer é enviado ao vídeo a cada leitura de controle nas fases arcade. Os laços de espera de milhares de instruções 6809 dessas fases foram substituídos por uma espera mínima de seis VBlanks, além do tempo de processamento e desenho. Isso evita que o atraso original domine o movimento e mantém uma base de tempo de vídeo ao usar turbo. Chamadas de som exclusivas do CoCo foram substituídas por um efeito breve no PSG, sem tentar executar o BIOS de outro computador. O áudio não é uma reprodução exata do original.

Também foi incluído o ponteiro temporário de objetos nos endereços virtuais 0600–0601, usado ao desenhar itens em etapas posteriores. Os dados originais do jogo permanecem intactos.

## Teste até o final

As **quatro edições completaram a aventura no openMSX 21.0**, seguindo o walkthrough fornecido pelo usuário. Foram executadas as 78 etapas: 206 entradas de texto, a atracação e três travessias das áreas de segurança. As interações com a grade, computador, cartão, caixa, mutante, alga, cogumelo, pílula, módulo e reator foram percorridas, chegando ao botão final e às mensagens de resgate do diretor.

Todas chegaram a **THIS ADVENTURE IS OVER!**, com **TRY AGAIN (Y/N)**. O teste usou somente entradas de teclado para jogar; o depurador leu o estado para escolher os movimentos automáticos, sem alterar a memória do jogo, injetar saves ou pular minijogos. O jogador automático pertence aos testes, não à ROM.

Foram conferidos também SAVE/LOAD nas quatro edições, os testes do núcleo 6809 e as cinco regressões gráficas de 6.144 bytes contra a execução de referência. A VRAM final de cada edição corresponde byte a byte à conversão do framebuffer. A frequência Panasonic permaneceu em aproximadamente 5,37 MHz.

`VALIDACAO.json`, `testes/`, os textos extraídos das telas, as capturas e `SHA256.json` preservam as evidências. Capturas do emulador podem mostrar um quadro anterior devido ao processamento gráfico fora da tela; os arquivos `*-final-framebuffer.png` foram gerados diretamente do framebuffer capturado, e os dumps de VRAM permitem conferir o resultado real. Não houve teste em computador físico nem com joystick físico; o percurso completo foi realizado por teclado emulado. Isso valida esse percurso, sem garantir todas as combinações possíveis de comandos.

## Fontes

`padrao/fontes/` gera MSX1 ROM, DSK e MSX2 ROM; `panasonic-turbo/fontes/` gera a edição Panasonic. Exemplo, dentro da edição desejada:

```powershell
python fontes/build.py --sdcc "C:/caminho/para/sdcc"
python fontes/test.py --gcc "C:/caminho/para/gcc.exe"
```

Foram usados SDCC 4.5.1 #15267, Python, GCC para os testes auxiliares e openMSX. O motor continua híbrido: inicialização, texto e gráficos nativos Z80 e parte da lógica no núcleo de compatibilidade 6809 compilado para Z80. Os fontes e as análises REA/Ghidra estão nas duas edições. Os direitos do jogo original continuam com seus titulares; nenhum BIOS acompanha este pacote.

Referência dos serviços de controle: https://map.grauw.nl/resources/msxbios.php . As versões anteriores foram preservadas separadamente no computador.
