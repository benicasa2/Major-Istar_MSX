# Major Istar — revisão com cores e otimizações

Use os arquivos desta pasta, que substituem a versão monocromática anterior:

- `MISTAR_MSX1.ROM`: cartucho normal de 32 KiB para MSX1.
- `MISTAR_MSX1.DSK`: disquete inicializável de 720 KiB para MSX1 com Disk ROM e RAM nas páginas 1, 2 e 3; testado com 64 KiB.
- `MISTAR_MSX2.ROM`: cartucho normal de 32 KiB para MSX2, agora em SCREEN 5.

Os atalhos `Jogar-*.cmd` abrem o openMSX instalado nesta máquina. A imagem DSK continua sem precisar de MSX-DOS. Se estiver usando outro emulador, remova o cartucho antigo e carregue o novo arquivo desta pasta.

## Cores recuperadas dos dados do jogo

O programa original configura o MC6847 em RG6/PMODE 4. Seus pares de pixels produzem cores de artefato em vídeo composto. As imagens fornecidas pelo usuário confirmam a fase com **01 = azul** e **10 = laranja**, além de preto e branco. Não foram redesenhados os cenários: os padrões originais são convertidos durante a exibição.

Na referência `images.png`, as amostras das faixas são azul RGB `(0,128,255)` e laranja `(255,128,0)`. No MSX2, essas cores foram aproximadas à paleta de três bits por componente do V9938, preservando as quatro identidades de cor em cada par de pixels. O título usa cores na tela inteira; durante a aventura, o cabeçalho e a área de texto mantêm sua resolução e legibilidade.

No MSX1, a paleta fixa e o limite de duas cores por grupo horizontal de oito pixels exigem aproximação. Azul e vermelho quente substituem os tons do composto; grupos com três ou quatro cores selecionam duas delas. O MSX2 tem a reprodução mais próxima das referências enviadas. As capturas `msx1-final.png` e `msx2-final.png` mostram essa diferença.

**F1** troca as fases azul/laranja, como ocorre entre as duas fases possíveis do vídeo composto do CoCo. A fase inicial é a que corresponde às imagens enviadas.

Referência técnica sobre o comportamento do vídeo composto: [manual do XRoar](https://www.6809.org.uk/xroar/doc/xroar.shtml#Composite-rendering). A configuração `$F8` em `$FF22` está no próprio código do jogo, a partir de `$38C2`.

## Velocidade

Foram substituídas por rotinas compiladas para Z80 a impressão de textos, a quebra de palavras, a rolagem e a limpeza da área de texto. O motor vetorial acessa diretamente seu framebuffer e sua área de trabalho. O vídeo recebe apenas os bytes alterados, em lotes; a versão MSX2 transmite sequências contíguas à VRAM. A inicialização nativa abre diretamente o título, sem a animação decorativa de borda do CoCo.

Medições no mesmo MSX1 emulado, com CPU e velocidade do MSX inalteradas:

| Operação | Versão anterior | Esta revisão | Ganho |
|---|---:|---:|---:|
| Chegar ao primeiro prompt de comando | 197,4 s | 28,6 s | 6,9× |
| `DOWN`, incluindo a mesma digitação automática | 63,0 s | 14,6 s | 4,3× |

A primeira medição também inclui a remoção da etapa decorativa e de sua espera por tecla. A segunda usa exatamente a mesma entrada automática a 2 Hz. São segundos do relógio do MSX emulado; a comparação não usa turbo do emulador para produzir o ganho. O título aparece em cerca de seis segundos no teste MSX1.

Ainda há latência em ações da aventura. **A lógica restante do jogo continua no núcleo de compatibilidade 6809.** Esta revisão torna nativos a inicialização e os caminhos de gráficos/texto/vídeo; ela não é uma conversão integral de todo o programa para Z80.

## Jogar e salvar

Pressione Espaço no título e na apresentação para continuar. Ao aparecer `OK`, digite um comando e pressione Enter. Exemplos: `LOOK`, `INVENTORY`, `DOWN`, `UP`, `GET`, `DROP`, `OPEN`, `READ`. As setas, no início da linha, enviam as direções correspondentes. Backspace corrige o texto.

No cartucho, `SAVE 1` e `LOAD 1` usam RAM e o ponto salvo se perde ao desligar. No DSK, `SAVE 1` a `SAVE 9` e `LOAD 1` a `LOAD 9` usam os arquivos reservados no disquete. A imagem deve aceitar escrita. Não mova nem desfragmente esses arquivos: o acesso usa seus setores previamente reservados. Saves do CoCo não são compatíveis.

## Fontes e validação

`fontes/` contém a reconstrução compilável, os dados extraídos e os scripts de geração. Exemplo:

```powershell
python fontes/build.py --sdcc "C:/caminho/para/sdcc"
python fontes/test.py --gcc "C:/caminho/para/gcc.exe"
```

Foi usado SDCC 4.5.1 #15267, com cabeçalhos/bibliotecas do pacote oficial 4.5.0. A instalação portátil desta máquina está em `tools/sdcc/sdcc` na pasta principal do projeto. Os testes do host comparam todos os 6.144 bytes do framebuffer em cinco sequências com a execução de referência.

As três versões passaram no openMSX por inicialização, inventário, movimento, SAVE e LOAD. As ROMs também foram testadas com digitação automática a 10 Hz. A VRAM foi comparada byte a byte com a conversão esperada a partir do framebuffer do jogo, sem divergências. O SAVE do DSK teve cabeçalho, cenário e checksum conferidos; a imagem entregue foi restaurada com os slots vazios.

`VALIDACAO.json`, `testes-host.json`, `testes/` e `SHA256.json` registram essas verificações. As evidências de extração e decompilação REA/Ghidra estão em `analise/`; os dados originais do BIN permanecem inalterados.

Não foi completada uma partida até o fim nem realizado teste em MSX físico. Os cenários e minijogos mostrados nas referências não foram todos percorridos; a conversão de cores é aplicada aos dados gráficos, incluindo essas telas quando alcançadas.

O jogo e seus dados continuam pertencendo aos titulares originais. Nenhum BIOS é distribuído neste pacote. Os atalhos usam C-BIOS e, para o DSK, arquivos de BIOS já existentes no blueMSX desta máquina. O projeto não foi publicado no GitHub.
