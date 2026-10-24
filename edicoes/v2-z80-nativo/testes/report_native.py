from pathlib import Path
import re,json,hashlib,shutil,zipfile,struct,zlib
R=Path(__file__).resolve().parents[2];O=R/'outputs/MISTAR-MSX-Z80-nativo';P=O/'testes';S=O/'fontes'
assets=(S/'assets.bin').read_bytes()
font={assets[(c-32)*8:(c-31)*8]:chr(c)for c in range(32,127)}
def symbols(path):return {n:int(a,16)for a,n in re.findall(r'([0-9A-F]{8})\s+_(\w+)\s',path.read_text())}
def decode(ram,sym):
    v=ram[sym['video']-0xc000:sym['video']-0xc000+6144];lines=[]
    for y in range(0,192,8):
        line=''
        for x in range(32):
            b=bytes(v[y*32+x+i*32]for i in range(8));line+=font.get(b,font.get(bytes(a^255 for a in b),'?'))
        lines.append(line.rstrip())
    return '\n'.join(lines)
def png(path,v):
    colors=[(0,0,0),(0,128,255),(255,128,0),(255,255,255)];rows=[]
    for y in range(192):
        row=bytearray()
        for b in v[y*32:y*32+32]:
            if 9<=y<104:
                for s in [6,4,2,0]:row+=bytes(colors[(b>>s)&3])*2
            else:
                for s in range(7,-1,-1):row+=bytes(colors[3 if (b>>s)&1 else 0])
        rows.append(b'\0'+row)
    def chunk(n,d):return struct.pack('>I',len(d))+n+d+struct.pack('>I',zlib.crc32(n+d)&0xffffffff)
    path.write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',256,192,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(b''.join(rows)))+chunk(b'IEND',b''))
targets={'msx1':('MISTAR_MSX1_Z80.ROM','MISTAR_MSX1_Z80.map'),'msx2':('MISTAR_MSX2_Z80.ROM','MISTAR_MSX2_Z80.map'),'dsk-msx1':('MISTAR_MSX1_Z80.DSK','MISTAR_MSX1_Z80.map'),'panasonic-turbo':('MISTAR_MSX2PLUS_Z80_TURBO.ROM','MISTAR_MSX2PLUS_Z80_TURBO.map'),'msx2plus-512k':('MISTAR_MSX2PLUS_Z80_TURBO.ROM','MISTAR_MSX2PLUS_Z80_TURBO.map')}
records=[]
for target,(image,mapfile)in targets.items():
    sy=symbols(O/mapfile);ram=(P/(target+'-final-ram.bin')).read_bytes();screen=decode(ram,sy)
    assert 'THIS ADVENTURE IS OVER!'in screen and 'TRY AGAIN (Y/N)'in screen,target
    assert ram[sy['adventure']-0xc000+6]==1
    assert ram[sy['faultop']-0xc000]==0
    events=(P/(target+'-events.txt')).read_text();assert 'finish-commands-complete'in events
    assert len(re.findall(r'send-step\d+-',events))==206 and events.count('security-path-')==3
    assert 'COMBINE MUSHROOM'in events and 'finish-fault'not in events
    (P/(target+'-final-texto.txt')).write_text(screen,encoding='utf-8')
    v=ram[sy['video']-0xc000:sy['video']-0xc000+6144];png(P/(target+'-final-framebuffer.png'),v)
    vr=(P/(target+'-final-vram.bin')).read_bytes()
    if target not in ['msx1','dsk-msx1']:
        for i,b in enumerate(v):
            lut=[0x11,0x44,0x88,0xff]if 9<=i//32<104 else[0x11,0x1f,0xf1,0xff]
            assert vr[i*4:i*4+4]==bytes(lut[(b>>s)&3]for s in [6,4,2,0]),(target,i)
    else:
        tables=(S/'color_lut.h').read_text()
        def lut(n):return [int(x,16)for x in re.search(n+r'\[256\]\s*=\s*\{([^}]+)',tables)[1].replace('\n','').split(',')if x.strip()]
        pattern=lut('color_pattern');color=lut('color_attribute')
        for i,b in enumerate(v):
            p=(i&0x1f00)|((i&31)<<3)|((i>>5)&7);patt,col=(pattern[b],color[b])if 9<=i//32<104 else(b,0xf1)
            assert vr[p]==patt and vr[p+0x2000]==col,(target,i)
    smoke=(P/(target+'-smoke-final-ram.bin')).read_bytes();a=sy['adventure']-0xc000
    assert smoke[a]==1 and int.from_bytes(smoke[a+7:a+9],'little')==0
    hardware=(P/(target+'-hardware.txt')).read_text().splitlines();clock=int(hardware[0])
    if target=='msx2plus-512k':assert hardware[1]=='524288'
    prompts=sorted(P.glob(target+'-prompt-*-ram.bin'),key=lambda p:int(p.stem.split('-')[-2]))
    assert len(prompts)==207
    (P/(target+'-transcricao.txt')).write_text('\n\n'.join('['+p.name+']\n'+decode(p.read_bytes(),sy)for p in prompts),encoding='utf-8')
    keys=sorted(P.glob(target+'-key-*-ram.bin'),key=lambda p:int(p.stem.split('-')[-2]))
    keytexts=[decode(p.read_bytes(),sy)for p in keys];assert any('Thank you for saving me.'in s for s in keytexts)
    (P/(target+'-mensagens.txt')).write_text('\n\n'.join('['+p.name+']\n'+s for p,s in zip(keys,keytexts)),encoding='utf-8')
    forbidden={'cpu','step','fetch','fetch16','regget','regset','tick','patchcount','patchaddr','patchval'}
    assert not forbidden.intersection(sy)
    records.append({'target':target,'image':image,'sha256':hashlib.sha256((O/image).read_bytes()).hexdigest(),'ending':'THIS ADVENTURE IS OVER!','walkthrough_steps':78,'typed_commands':206,'security_segments':3,'save_load':'passed','vram':'byte-exact','clock_hz':clock,'ram_bytes_reported':int(hardware[1]),'native_no_6809_core':True})
assert not any((S/f).exists()for f in ['cpu.c','cpu.h','platform.c','MISTAR.raw'])
comparison=json.loads((P/'comparacao-hibrido.json').read_text());assert len(comparison)==207
assert all(not r['video_differences']and not r['object_differences']and r['state_matches']and r['turns_match']for r in comparison)
assert 'Native rules passed:'in(P/'testes-nativos-host.txt').read_text()
assert not any((O/'MISTAR_MSX1_Z80.DSK').read_bytes()[1400*512:1418*512])
save=(P/'dsk-msx1-smoke-test.DSK').read_bytes()[1400*512:1402*512];assert save[:4]==b'MIZ2'and sum(save[:1000])&65535==int.from_bytes(save[1000:1002],'little')
report={'result':'NATIVE_Z80_COMPLETED_ON_ALL_TARGETS','date':'2026-10-24','implementation':'manually rewritten C game rules compiled directly to native Z80; generated Z80 assembly included','runtime_6809_interpreter':False,'reference_comparison':{'prompts':207,'source_video_bytes_per_prompt':6144,'object_bytes_per_prompt':825,'video_differences':0,'object_differences':0,'room_inventory_flags_turn_differences':0},'unit_tests':'passed','physical_hardware_tested':False,'tests':records}
(O/'VALIDACAO.json').write_text(json.dumps(report,indent=2)+'\n')
# Human-readable game data for future native conversions.
def byte(a):return assets[a-0x3b26]if 0x3b26<=a<0x6c35 else 0
def word(a):return byte(a)*256+byte(a+1)
def string(a):
    s=[]
    while byte(a):s.append(byte(a));a+=1
    return bytes(s).decode('ascii','replace')
data=O/'dados';data.mkdir(exist_ok=True)
rooms=[{'id':i,'name':string(word(0x597f+i*2)),'exits':dict(zip('NSEWUD',[byte(0x5723+(i-1)*6+j)for j in range(6)])),'vector_art':hex(word(0x5cd0+i*2))}for i in range(1,102)]
objects=[{'id':i+1,'keyword':bytes(byte(0x4c7a+i*25+j)for j in range(4)).decode('ascii'),'name':string(word(0x4c7a+i*25+4)),'initial_room':byte(0x4c7a+i*25+6),'examination':string(word(0x4c7a+i*25+7)),'reading':string(word(0x4c7a+i*25+13)),'drawing':hex(word(0x4c7a+i*25+23))}for i in range(33)]
(data/'salas.json').write_text(json.dumps(rooms,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');(data/'objetos.json').write_text(json.dumps(objects,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
(O/'ARQUITETURA.md').write_text('''# Arquitetura nativa Z80

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
''',encoding='utf-8')
(S/'FERRAMENTAS-E-LICENCAS.md').write_text('''# Ferramentas e direitos

O código desta edição implementa regras próprias em C99 compilado diretamente para Z80, com inicialização e chamadas BIOS em assembly Z80. Não inclui núcleo de execução de outra CPU. O assembly produzido pelo SDCC acompanha os fontes.

Os textos, fontes, desenhos e dados em assets.bin foram extraídos do arquivo Major Istar fornecido para este projeto. O jogo original é de B. J. Chambless / Computerware (1984); os direitos desses recursos permanecem com seus titulares. A inclusão não concede uma nova licença sobre o jogo.

Foram usados SDCC 4.5.1 #15267 da distribuição GBDK/SDCC, cabeçalhos e bibliotecas Z80 do pacote oficial SDCC 4.5.0, Python, GCC para testes de regras e openMSX 21.0 para os percursos completos. REA/Ghidra e f9dasm apoiaram a extração e análise do original em etapas anteriores. Nenhum compilador, emulador ou BIOS é redistribuído neste pacote. SDCC-COPYING.txt documenta os termos da ferramenta; a licença e a exceção de ligação das bibliotecas permanecem nas respectivas distribuições.

Referências de BIOS e controle: https://map.grauw.nl/resources/msxbios.php e https://map.grauw.nl/resources/msx_io_ports.php .
''',encoding='utf-8')
(O/'LEIA-ME.md').write_text('''# Major Istar — edição nativa Z80 para MSX

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
''',encoding='utf-8')
for target,(image,mapfile)in targets.items():
    if target=='panasonic-turbo':label='Panasonic-FS-A1WSX';machine='Panasonic_FS-A1WSX'
    elif target=='msx2plus-512k':label='MSX2PLUS-512K';machine='MISTAR_MSX2PLUS_512K'
    elif target=='msx1':label='MSX1-ROM';machine='C-BIOS_MSX1'
    elif target=='msx2':label='MSX2-ROM';machine='C-BIOS_MSX2'
    else:label='MSX1-DSK';machine='MISTAR_MSX1'
    args=f'-diska "%~dp0{image}"'if image.endswith('.DSK')else f'-cart "%~dp0{image}" -romtype Normal'
    (O/('Jogar-'+label+'.cmd')).write_text('@echo off\nsetlocal\nset "OPENMSX_USER_DATA=%~dp0..\\..\\work\\msx\\emuhome"\nstart "" "C:\\Program Files\\openMSX\\openmsx.exe" -machine '+machine+' '+args+' -script "%~dp0jogar.tcl"\n')
(O/'jogar.tcl').write_text('set throttle on\nset speed 100\nset z80_freq_locked true\nset pause off\n')
for f in ['play_native.py','play_solution.py','compare_native.py','report_native.py','setup_native_512k.py']:
    shutil.copy2(R/'work/msx'/f,P/f)
shutil.copy2(R/'work/msx/emuhome/machines/MISTAR_MSX2PLUS_512K.xml',P/'MSX2PLUS-512K-config.xml')
metadata={'asset_bytes':len(assets),'asset_sha256':hashlib.sha256(assets).hexdigest(),'original_resource_identifiers':'3B26..6C34','excluded_original_executable_range':'2460..3B25','obsolete_function_tables_zeroed':['4B30..4C79','5C17..5C2A'],'no_original_bin_required_for_build':True,'rom_bytes':32768}
(O/'RECURSOS.json').write_text(json.dumps(metadata,indent=2)+'\n')
archive=R/'outputs/MISTAR-MSX-Z80-nativo-completo.zip'
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED)as z:
    for p in sorted(O.rglob('*')):
        if p.is_file()and'build'not in p.parts and not p.name.endswith(('-test.DSK','-pid.txt')):z.write(p,p.relative_to(O))
with zipfile.ZipFile(archive)as z:
    assert z.testzip()is None
    for p in O.glob('*.ROM'):assert z.read(p.name)==p.read_bytes()
print(json.dumps({'result':report['result'],'comparison':'207/207 prompts byte-exact','msx2plus_ram':524288,'archive':str(archive),'bytes':archive.stat().st_size},indent=2))
