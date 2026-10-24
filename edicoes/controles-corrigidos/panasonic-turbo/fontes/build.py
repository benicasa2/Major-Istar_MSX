"""Build the 32 KiB MSX2 ROM with automatic Panasonic turbo detection."""
from pathlib import Path
import argparse,subprocess,hashlib,json
P=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--sdcc',required=True);ap.add_argument('--output',default=str(P.parent));args=ap.parse_args()
sdk=Path(args.sdcc).resolve();out=Path(args.output).resolve();out.mkdir(parents=True,exist_ok=True);b=P/'build';b.mkdir(exist_ok=True)
def run(tool,*args):subprocess.run([str(sdk/'bin'/tool),*map(str,args)],cwd=b,check=True)
run('sdasz80.exe','-plosgff','crt0.rel',P/'crt0.s')
for name in ['cpu','platform','graphics','text','msx','turbo']:
    run('sdcc.exe','-mz80','--std-c99','--opt-code-speed','-DMSX2_TARGET','-c',P/(name+'.c'),'-o',name+'.rel')
run('sdcc.exe','-mz80','--no-std-crt0','--code-loc','0x4080','--data-loc','0xc000','-Wl-m','crt0.rel','cpu.rel','platform.rel','graphics.rel','text.rel','msx.rel','turbo.rel','-o','game.ihx')
rom=bytearray([255])*32768
for line in(b/'game.ihx').read_text().splitlines():
    d=bytes.fromhex(line[1:]);assert sum(d)%256==0
    if d[3]==0:
        a=int.from_bytes(d[1:3],'big');assert 0x4000<=a and a+d[0]<=0x7400
        rom[a-0x4000:a-0x4000+d[0]]=d[4:4+d[0]]
raw=(P/'MISTAR.raw').read_bytes()
assert hashlib.sha256(raw).hexdigest()=='28babf7eff9bd3a7e0c4f92620a5af258bb8bd43fdf1b4b1790c9478d9e04881'
rom[13312:13312+len(raw)]=raw
name='MISTAR_MSX2_PANASONIC_TURBO.ROM';(out/name).write_bytes(rom)
(out/'MISTAR_MSX2_PANASONIC_TURBO.map').write_bytes((b/'game.map').read_bytes())
manifest={name:{'bytes':len(rom),'sha256':hashlib.sha256(rom).hexdigest()}}
(out/'SHA256.json').write_text(json.dumps(manifest,indent=2));print(json.dumps(manifest,indent=2))
