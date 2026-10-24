# Teste do walkthrough — Major Istar MSX

Data: 24/10/2026. Resultado: **a versão atual não passou na validação até o final**.

O roteiro fornecido possui 78 etapas numeradas. A primeira foi executada integralmente: `D,N,E,E,S,E,N,N,D,E,D,D`. As quatro edições chegaram à tela DOCKING, etapa 2. Não foi possível concluir a atracação com os controles existentes; a tentativa termina novamente em OVER THE DOME. As etapas 3 a 78 **não foram validadas**.

## Edições testadas

| Imagem publicada | Máquina no openMSX | Resultado |
|---|---|---|
| MISTAR_MSX1.ROM | C-BIOS MSX1 | Falha na adaptação do controle da atracação |
| MISTAR_MSX1.DSK | MSX1 com BIOS de disco local | Mesma falha |
| MISTAR_MSX2.ROM | C-BIOS MSX2 | Mesma falha |
| MISTAR_MSX2_PANASONIC_TURBO.ROM | Panasonic FS-A1WSX, 5.369.318 Hz | Mesma falha |

Foram feitos dois percursos por edição: sem direções na fase arcade e exercitando as teclas direcionais direita/baixo. O segundo serve para confirmar a ausência de adaptação de entrada, não como uma estratégia para vencer as bolhas. Em todas as edições, as leituras do joystick permanecem em X=0, Y=0; a nave segue a mesma trajetória, com posições internas 0x1243, 0x1142 e 0x1041. Na última posição ocorre a saída pelos limites e o retorno à sala 22. O processador permanece no prompt de comando, sem falha fatal: não é um travamento da ROM.

## Causa encontrada nos fontes

Em `platform.c`, o vetor original `$A00A` da rotina de joystick é redirecionado para `$FF12`. Porém o tratamento de `$FF12` chama a impressão de caractere (`invoke(0x3990)`), sem ler joystick ou teclado direcional e sem preencher as coordenadas analógicas originais `$015A/$015B`.

No jogo original, a rotina `$2AC4` chama esse vetor e usa essas coordenadas para mover a nave e o personagem nas fases arcade. Elas permanecem zeradas na adaptação atual. A confirmação foi feita na execução das ROMs/DSK reais, por pontos de observação do emulador, e em teste auxiliar da lógica compilada no computador.

## Alcance e próximos reparos necessários

É necessário implementar a leitura do joystick MSX e/ou das setas para as fases arcade, atualizar as coordenadas esperadas e assegurar a atualização de vídeo durante essas fases. Depois, repetir o roteiro completo, incluindo docking, áreas de segurança, objetos, reator e botão final. O código também contém chamadas de serviços e som do CoCo que precisam ser verificadas quando essas áreas se tornarem acessíveis.

Nenhuma etapa foi pulada, nenhum estado foi alterado para forçar vitória e nenhuma ROM foi modificada neste teste. Não há evidência de finalização do jogo nesta versão. Este relatório substitui qualquer interpretação de que os testes anteriores de inicialização e movimento comprovavam a aventura inteira.

## Evidências

`RESULTADO.json` contém hashes das quatro imagens e o resumo por edição. Os arquivos `*-events.txt` registram comandos, salas, leituras de controle, frequência e tempo emulado. Os arquivos `*-ram.bin` e `*-vram.bin` preservam os estados finais; `*-final.png` mostra o retorno a OVER THE DOME. Os registros `*-controle-*` são os ensaios com direções acionadas. Os `*.tcl` são os roteiros efetivamente usados. Os scripts Python reproduzem os testes na estrutura original deste projeto, com openMSX e BIOS já instalados localmente. Nenhum BIOS acompanha as evidências.
