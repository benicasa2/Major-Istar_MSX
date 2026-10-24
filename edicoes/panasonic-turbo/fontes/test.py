"""Host tests: GCC core checks and byte-exact video regression against 6809 execution."""
import argparse,subprocess,os,json
from pathlib import Path
p=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--gcc',default='gcc');args=ap.parse_args()
build=p/'build';build.mkdir(exist_ok=True)
def compile(name,files,flags=[]):
    path=build/(name+'.exe');subprocess.run([args.gcc,'-std=c99','-O2',*flags,*[str(p/f)for f in files],'-o',str(path)],check=True);return path
cpu=compile('test_cpu',['cpu.c','test_cpu.c']);subprocess.run([str(cpu)],check=True)
executables=[compile(name,['cpu.c','platform.c','graphics.c','text.c'],['-DHOST_TEST']+(['-DREFERENCE_GRAPHICS','-DREFERENCE_TEXT']if name=='reference'else[]))for name in ['reference','native']]
results=[]
for commands in [b' ',b'  ',b'   ',b'   LOOK\nINVENTORY\nDOWN\nLOOK\nUP\n',b'   SAVE 1\nDOWN\nLOAD 1\n']:
    images=[]
    for exe in executables:
        memory=build/(exe.stem+'.bin');env=os.environ.copy();env['MSX_MEMORY_PATH']=str(memory)
        r=subprocess.run([str(exe),str(p/'MISTAR.raw')],input=commands,capture_output=True,env=env,check=True)
        assert b'FAULT'not in r.stderr
        images.append(memory.read_bytes())
        (build/(exe.stem+'.log')).write_bytes(r.stdout+r.stderr)
    assert images[0][0xe00:0x2600]==images[1][0xe00:0x2600],commands
    results.append({'commands':commands.decode(),'video_bytes_equal':6144,'room':images[1][0x6c5d]})
(p.parent/'testes-host.json').write_text(json.dumps({'cpu':'passed','graphics_regressions':results},indent=2))
print('All core and graphics tests passed.')
