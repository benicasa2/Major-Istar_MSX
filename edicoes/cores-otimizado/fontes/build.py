"""Build the three MSX artifacts. Python 3 + SDCC Z80 (tested: 4.5.1 #15267)."""
from pathlib import Path
import argparse,subprocess,struct,hashlib,json
P=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--sdcc',required=True,help='SDCC installation directory, containing bin/, include/ and lib/')
ap.add_argument('--output',default=str(P.parent));args=ap.parse_args()
sdk=Path(args.sdcc).resolve();out=Path(args.output).resolve();out.mkdir(parents=True,exist_ok=True)
b=P/'build';b.mkdir(exist_ok=True)
def run(name,*args):subprocess.run([str(sdk/'bin'/name),*map(str,args)],cwd=b,check=True)
def ihx(path):
    result={}
    for line in path.read_text().splitlines():
        d=bytes.fromhex(line[1:]);assert sum(d)%256==0
        if d[3]==0:
            a=int.from_bytes(d[1:3],'big');result.update({a+i:v for i,v in enumerate(d[4:4+d[0]])})
    return result
run('sdasz80.exe','-plosgff','crt0.rel',P/'crt0.s')
for name in ['cpu','platform','graphics','text']:
    run('sdcc.exe','-mz80','--std-c99','--opt-code-speed','-c',P/(name+'.c'),'-o',name+'.rel')
payload=(P/'MISTAR.raw').read_bytes()
assert hashlib.sha256(payload).hexdigest()=='28babf7eff9bd3a7e0c4f92620a5af258bb8bd43fdf1b4b1790c9478d9e04881'
roms=[]
for target in [1,2]:
    flags=['-DMSX2_TARGET'] if target==2 else []
    run('sdcc.exe','-mz80','--std-c99','--opt-code-speed',*flags,'-c',P/'msx.c','-o','msx.rel')
    run('sdcc.exe','-mz80','--no-std-crt0','--code-loc','0x4080','--data-loc','0xc000','-Wl-m','crt0.rel','cpu.rel','platform.rel','graphics.rel','text.rel','msx.rel','-o','game.ihx')
    image=ihx(b/'game.ihx');assert min(image)>=0x4000 and max(image)<0x7400,hex(max(image))
    rom=bytearray([255])*32768
    for a,v in image.items():rom[a-0x4000]=v
    rom[13312:13312+len(payload)]=payload;roms.append(rom)
    (out/f'MISTAR_MSX{target}.ROM').write_bytes(rom)
    (out/f'MISTAR_MSX{target}.map').write_bytes((b/'game.map').read_bytes())
run('sdasz80.exe','-plosgff','boot.rel',P/'boot.s')
run('sdldz80.exe','-n','-i','boot.ihx','boot.rel')
disk=bytearray(737280);disk[:11]=b'\xeb\xfe\x90MISTAR  '
struct.pack_into('<HBHBHHBHHHH',disk,11,512,2,1,2,112,1440,0xf9,3,9,2,0)
for a,v in ihx(b/'boot.ihx').items():
    assert 0xc01e<=a<0xc100;disk[a-0xc000]=v
fat=bytearray(1536);fat[:3]=b'\xf9\xff\xff'
def entry(n,v):
    i=n*3//2;w=fat[i]|fat[i+1]<<8
    w=(w&15)|(v<<4) if n&1 else (w&0xf000)|v
    fat[i:i+2]=w.to_bytes(2,'little')
for n in range(2,34):entry(n,n+1 if n<33 else 0xfff)
for n in range(695,704):entry(n,0xfff)
disk[512:2048]=fat;disk[2048:3584]=fat
for slot in range(10):
    d=7*512+slot*32
    disk[d:d+11]=b'MISTAR  ROM' if slot==0 else f'SAVE{slot}   DAT'.encode()
    disk[d+11]=0x20
    struct.pack_into('<HI',disk,d+26,2 if slot==0 else 694+slot,32768 if slot==0 else 1024)
diskrom=bytearray(roms[0]);diskrom[0x7ffe]=0xa5
disk[14*512:14*512+32768]=diskrom
(out/'MISTAR_MSX1.DSK').write_bytes(disk)
manifest={name:{'bytes':(out/name).stat().st_size,'sha256':hashlib.sha256((out/name).read_bytes()).hexdigest()}for name in ['MISTAR_MSX1.ROM','MISTAR_MSX1.DSK','MISTAR_MSX2.ROM']}
(out/'SHA256.json').write_text(json.dumps(manifest,indent=2))
print(json.dumps(manifest,indent=2))
