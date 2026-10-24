"""Build native Z80 ROMs and MSX1 DSK; no 6809 binary or CPU core is linked."""
from pathlib import Path
import argparse,subprocess,struct,hashlib,json,shutil
P=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--sdcc',required=True);ap.add_argument('--output',default=str(P.parent));args=ap.parse_args()
sdk=Path(args.sdcc).resolve();out=Path(args.output).resolve();out.mkdir(exist_ok=True,parents=True);b=P/'build';b.mkdir(exist_ok=True)
def run(tool,*args):subprocess.run([str(sdk/'bin'/tool),*map(str,args)],cwd=b,check=True)
def ihx(path):
    image={}
    for line in path.read_text().splitlines():
        d=bytes.fromhex(line[1:]);assert sum(d)%256==0
        if d[3]==0:
            a=int.from_bytes(d[1:3],'big');image.update({a+i:v for i,v in enumerate(d[4:4+d[0]])})
    return image
run('sdasz80.exe','-plosgff','crt0.rel',P/'crt0.s')
for name in ['adventure','screen','graphics','arcade','turbo']:
    run('sdcc.exe','-mz80','--std-c99','--opt-code-speed','-c',P/(name+'.c'),'-o',name+'.rel')
assets=(P/'assets.bin').read_bytes();assert len(assets)==0x6c35-0x3b26
manifest={};roms=[]
for name,flags in [('MISTAR_MSX1_Z80',[]),('MISTAR_MSX2_Z80',['-DMSX2_TARGET']),('MISTAR_MSX2PLUS_Z80_TURBO',['-DMSX2_TARGET','-DPANASONIC_TURBO'])]:
    run('sdcc.exe','-mz80','--std-c99','--opt-code-speed',*flags,'-c',P/'msx.c','-o','msx.rel')
    objs=['crt0.rel','adventure.rel','screen.rel','graphics.rel','arcade.rel','msx.rel']
    if '-DPANASONIC_TURBO'in flags:objs+=['turbo.rel']
    run('sdcc.exe','-mz80','--no-std-crt0','--code-loc','0x4080','--data-loc','0xc000','-Wl-m',*objs,'-o','game.ihx')
    image=ihx(b/'game.ihx');assert min(image)>=0x4000 and max(image)<0x8c00,hex(max(image))
    rom=bytearray([255])*32768
    for a,v in image.items():rom[a-0x4000]=v
    rom[0x4c00:0x4c00+len(assets)]=assets
    (out/(name+'.ROM')).write_bytes(rom);(out/(name+'.map')).write_bytes((b/'game.map').read_bytes());roms.append(rom)
    nativeasm=out/'assembly'/name;nativeasm.mkdir(exist_ok=True,parents=True)
    for source in b.glob('*.asm'):shutil.copy2(source,nativeasm/source.name)
run('sdasz80.exe','-plosgff','boot.rel',P/'boot.s');run('sdldz80.exe','-n','-i','boot.ihx','boot.rel')
disk=bytearray(737280);disk[:11]=b'\xeb\xfe\x90MISTAR  '
struct.pack_into('<HBHBHHBHHHH',disk,11,512,2,1,2,112,1440,0xf9,3,9,2,0)
for a,v in ihx(b/'boot.ihx').items():disk[a-0xc000]=v
fat=bytearray(1536);fat[:3]=b'\xf9\xff\xff'
def entry(n,v):
    i=n*3//2;w=fat[i]|fat[i+1]<<8;w=(w&15)|(v<<4)if n&1 else(w&0xf000)|v;fat[i:i+2]=w.to_bytes(2,'little')
for n in range(2,34):entry(n,n+1 if n<33 else 0xfff)
for n in range(695,704):entry(n,0xfff)
disk[512:2048]=fat;disk[2048:3584]=fat
for slot in range(10):
    d=7*512+slot*32;disk[d:d+11]=b'MISTAR  ROM'if slot==0 else f'SAVE{slot}   DAT'.encode();disk[d+11]=32
    struct.pack_into('<HI',disk,d+26,2 if slot==0 else 694+slot,32768 if slot==0 else 1024)
diskrom=roms[0];diskrom[0x7ffe]=0xa5;disk[14*512:14*512+32768]=diskrom
(out/'MISTAR_MSX1_Z80.DSK').write_bytes(disk)
for p in sorted(out.iterdir()):
    if p.suffix.upper()in['.ROM','.DSK']:manifest[p.name]={'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
(out/'SHA256.json').write_text(json.dumps(manifest,indent=2)+'\n');print(json.dumps(manifest,indent=2))
