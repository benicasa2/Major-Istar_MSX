from pathlib import Path
import re,json,hashlib,shutil,zipfile,struct,zlib
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'outputs/MISTAR-MSX-controles-corrigidos';proof=OUT/'testes'
raw=(OUT/'padrao/fontes/MISTAR.raw').read_bytes()
fonts={raw[0x3b26-0x2460+(c-32)*8:0x3b26-0x2460+(c-31)*8]:chr(c)for c in range(32,127)}
targets={'msx1':('padrao','MISTAR_MSX1.ROM','MISTAR_MSX1.map'),'msx2':('padrao','MISTAR_MSX2.ROM','MISTAR_MSX2.map'),'dsk-msx1':('padrao','MISTAR_MSX1.DSK','MISTAR_MSX1.map'),'panasonic-turbo':('panasonic-turbo','MISTAR_MSX2_PANASONIC_TURBO.ROM','MISTAR_MSX2_PANASONIC_TURBO.map')}
def symbols(base,mapfile):
    m=(base/mapfile).read_text()
    return {name:int(addr,16)for addr,name in re.findall(r'([0-9A-F]{8})\s+_(\w+)\s',m)}
def text(ram,sym):
    v=ram[sym['video']-0xc000:sym['video']-0xc000+6144]
    lines=[]
    for y in range(0,192,8):
        s=''
        for x in range(32):
            pixels=bytes(v[y*32+x+i*32]for i in range(8))
            s+=fonts.get(pixels,fonts.get(bytes(b^255 for b in pixels),'?'))
        lines.append(s.rstrip())
    return '\n'.join(lines)
def rgbpng(path,v):
    palette=[(0,0,0),(0,128,255),(255,128,0),(255,255,255)]
    scan=[]
    for y in range(192):
        line=bytearray()
        for b in v[y*32:y*32+32]:
            if 9<=y<104:
                for shift in [6,4,2,0]:line+=bytes(palette[(b>>shift)&3])*2
            else:
                for shift in range(7,-1,-1):line+=bytes(palette[3 if(b>>shift)&1 else 0])
        scan.append(b'\0'+bytes(line))
    def chunk(name,data):return struct.pack('>I',len(data))+name+data+struct.pack('>I',zlib.crc32(name+data)&0xffffffff)
    path.write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',256,192,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(b''.join(scan)))+chunk(b'IEND',b''))
results=[]
for target,(folder,file,mapfile)in targets.items():
    base=OUT/folder;sym=symbols(base,mapfile)
    ram=(proof/(target+'-final-ram.bin')).read_bytes();screen=text(ram,sym)
    (proof/(target+'-final-texto.txt')).write_text(screen,encoding='utf-8')
    assert 'THIS ADVENTURE IS OVER!'in screen and 'TRY AGAIN (Y/N)'in screen,target
    assert ram[sym['stopped']-0xc000]==0,target
    events=(proof/(target+'-events.txt')).read_text()
    assert 'finish-commands-complete'in events
    assert 'finish-fault'not in events and 'finish-security-no-path'not in events
    assert 'send-step78-PUSH BUTTON'in events
    assert events.count('security-path-')==3,(target,events.count('security-path-'))
    assert len(re.findall(r'send-step\d+-',events))==206
    keyfiles=sorted(proof.glob(target+'-key-*-ram.bin'),key=lambda p:p.stat().st_mtime)
    texts=[text(p.read_bytes(),sym)for p in keyfiles]
    assert any('Thank you for saving me.'in t for t in texts),target
    (proof/(target+'-mensagens.txt')).write_text('\n\n'.join(f'[{p.name}]\n{t}'for p,t in zip(keyfiles,texts)),encoding='utf-8')
    v=ram[sym['video']-0xc000:sym['video']-0xc000+6144]
    rgbpng(proof/(target+'-final-framebuffer.png'),v)
    # All actual bytes of VRAM match the conversion of the final guest screen.
    vr=(proof/(target+'-final-vram.bin')).read_bytes()
    if target in ['msx2','panasonic-turbo']:
        for i,b in enumerate(v):
            lut=[0x11,0x44,0x88,0xff]if 9<=i//32<104 else[0x11,0x1f,0xf1,0xff]
            assert vr[i*4:i*4+4]==bytes(lut[(b>>s)&3]for s in [6,4,2,0]),(target,i)
    else:
        lut=(base/'fontes/color_lut.h').read_text()
        def table(n):return [int(x,16)for x in re.search(n+r'\[256\]\s*=\s*\{([^}]+)',lut)[1].replace('\n','').split(',')if x.strip()]
        patterns=table('color_pattern');attrs=table('color_attribute')
        for i,b in enumerate(v):
            p=(i&0x1f00)|((i&31)<<3)|((i>>5)&7)
            pattern,color=(patterns[b],attrs[b])if 9<=i//32<104 else(b,0xf1)
            assert vr[p]==pattern and vr[p+0x2000]==color,(target,i)
    smoke=(proof/(target+'-smoke-final-ram.bin')).read_bytes()
    assert smoke[sym['state']-0xc000+0x5d]==1
    assert smoke[sym['stopped']-0xc000]==0
    if target=='dsk-msx1':
        image=(base/file).read_bytes();assert not any(image[1400*512:1418*512])
        saved=(proof/'dsk-msx1-smoke-test.DSK').read_bytes()[1400*512:1402*512]
        assert saved[:4]==b'MIS\x01'
        assert sum(saved[:840])&65535==int.from_bytes(saved[840:842],'little')
    results.append({'edition':target,'image':file,'sha256':hashlib.sha256((base/file).read_bytes()).hexdigest(),'walkthrough_steps':78,'typed_commands':206,'docking':'passed','security_segments_completed':3,'ending':'THIS ADVENTURE IS OVER!','director_rescued':True,'fatal_errors':0,'vram_verification':'6144 source bytes converted without differences','save_load_regression':'passed','clock_hz':5369318 if target=='panasonic-turbo' else 3579545})
    transcript=[]
    for p in sorted(proof.glob(target+'-prompt-*-ram.bin'),key=lambda p:int(p.stem.split('-')[-2])):
        transcript.append('['+p.name+']\n'+text(p.read_bytes(),sym))
    (proof/(target+'-comandos-telas.txt')).write_text('\n\n'.join(transcript),encoding='utf-8')
# Copies at the top level are the files to use; subfolders hold complete sources.
for target,(folder,file,mapfile)in targets.items():shutil.copy2(OUT/folder/file,OUT/file)
manifest={r['image']:{'bytes':(OUT/r['image']).stat().st_size,'sha256':r['sha256']}for r in results}
(OUT/'SHA256.json').write_text(json.dumps(manifest,indent=2)+'\n')
report={'date':'2026-10-24','emulator':'openMSX 21.0','result':'ALL_FOUR_EDITIONS_COMPLETED','input_method':'keyboard only; debugger observes memory to choose inputs; no game-memory writes, state injection or stage bypass','physical_hardware_tested':False,'tests':results}
(OUT/'VALIDACAO.json').write_text(json.dumps(report,indent=2)+'\n')
(OUT/'LEIA-ME.md').write_text('''# Major Istar MSX — controles corrigidos e aventura completa validada

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
''',encoding='utf-8')
shutil.copy2(ROOT/'work/msx/play_solution.py',proof/'play_solution.py')
shutil.copy2(ROOT/'work/msx/report_controls.py',proof/'report_controls.py')
for folder in ['padrao','panasonic-turbo']:
    for p in (OUT/folder).glob('*.cmd'):
        p.write_text(p.read_text().replace('..\\..\\work\\msx', '..\\..\\..\\work\\msx'))
archive=ROOT/'outputs/MISTAR-MSX-controles-corrigidos-completo.zip'
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED)as z:
    for p in sorted(OUT.rglob('*')):
        if p.is_file() and 'build' not in p.parts and (p.suffix.upper()!='.DSK' or p in [OUT/'MISTAR_MSX1.DSK',OUT/'padrao/MISTAR_MSX1.DSK']):
            z.write(p,p.relative_to(OUT))
with zipfile.ZipFile(archive)as z:assert z.testzip()is None
print(json.dumps({'result':report['result'],'archive':str(archive),'bytes':archive.stat().st_size},indent=2))
