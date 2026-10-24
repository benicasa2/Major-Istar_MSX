"""Exercise the native Z80 engine through actual keyboard input in openMSX."""
from pathlib import Path
import ast,re,sys,subprocess,os,shutil
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'outputs/MISTAR-MSX-Z80-nativo'
source=(ROOT/'work/msx/play_solution.py').read_text();tree=ast.parse(source)
steps=None;script=None
for node in tree.body:
    if isinstance(node,ast.Assign):
        if any(isinstance(t,ast.Name)and t.id=='steps'for t in node.targets):steps=ast.literal_eval(node.value)
        if any(isinstance(t,ast.Name)and t.id=='script'for t in node.targets)and isinstance(node.value,ast.Constant):script=node.value.value
assert steps and script
target=sys.argv[1]if len(sys.argv)>1 else'panasonic-turbo'
file={'msx1':'MISTAR_MSX1_Z80.ROM','msx2':'MISTAR_MSX2_Z80.ROM','dsk-msx1':'MISTAR_MSX1_Z80.DSK','panasonic-turbo':'MISTAR_MSX2PLUS_Z80_TURBO.ROM','msx2plus-512k':'MISTAR_MSX2PLUS_Z80_TURBO.ROM'}[target]
machine={'msx1':'C-BIOS_MSX1','msx2':'C-BIOS_MSX2','dsk-msx1':'MISTAR_MSX1','panasonic-turbo':'Panasonic_FS-A1WSX','msx2plus-512k':'MISTAR_MSX2PLUS_512K'}[target]
mapname=file.replace('.ROM','.map').replace('.DSK','.map')
m=(OUT/mapname).read_text()
def sym(name):return int(re.search(r'([0-9A-F]{8})\s+_'+name+r'\s',m)[1],16)
commands=[]
for step,cmds in steps.items():
    if not cmds.startswith('@'):
        for cmd in re.split('[,/]',cmds):commands.append([step,cmd])
if '--smoke'in sys.argv:
    commands=[[0,c]for c in ['INVENTORY','SAVE 1','DOWN','LOAD 1','INVENTORY']];target+='-smoke'
if '--dock-only'in sys.argv:commands=[c for c in commands if c[0]<=1]
proof=OUT/'testes';proof.mkdir(exist_ok=True)
script=script.replace('set pc [le PC]','set pc [byte WAITING]').replace('if {$pc==65296}','if {$pc==1}').replace('} elseif {$pc==41872}','} elseif {$pc==2}')
script=script.replace('set ret [be [expr {STACK+[le SP]-3072}]]','set ret 1')
script=script.replace('[be TURN]','[le TURN]')
script=re.sub(r'proc guest \{a\} \{[^\n]+\}', 'proc guest {a} {if {$a>=3584&&$a<9728} {return [byte [expr {VIDEO+$a-3584}]]};return 255}',script)
script=script.replace('[gw 1051]','[le PLAYER]').replace('[gw 1039]','[le PLAYER]').replace('[guest 1059]','[byte TICK]')
script=script.replace('[gw $i]-256','[le [expr {ENEMIES+(($i-1024)/2)*2}]]-256')
script=script.replace('for {set i 1024} {$i<1039} {incr i 3} {lappend enemies [list [gw $i] [expr {[guest [expr {$i+2}]]==255?-1:1}]]}', 'for {set i 0} {$i<5} {incr i} {lappend enemies [list [le [expr {ENEMIES+$i*2}]] [expr {[byte [expr {VELOCITIES+$i}]]==255?-1:1}]]}')
script=script.replace('set room [byte ROOM]','set room [byte ROOM]')
script=script.replace('COMMANDS','{'+' '.join('{'+str(step)+' {'+cmd+'}}'for step,cmd in commands)+'}')
script=script.replace('event "finish-$reason";snapshot final', '''event "finish-$reason";snapshot final
 set f [open {PROOF/TARGET-hardware.txt} w];puts $f [machine_info z80_freq];catch {debug size {Main RAM}} size;puts $f $size;close $f''')
for a,b in [('PROOF',proof.as_posix()),('TARGET',target),('ROOM',sym('adventure')),('TURN',sym('adventure')+7),('WAITING',sym('waiting_kind')),('INPUTSEQ',sym('input_sequence')),('VIDEO',sym('video')),('PLAYER',sym('arcade_player')),('ENEMIES',sym('arcade_enemy')),('VELOCITIES',sym('arcade_velocity')),('TICK',sym('arcade_tick')),('ARCADEREADY',hex(sym('arcade_ready'))),('READY',hex(sym('host_ready'))),('FAULTOP',sym('faultop')),('FAULT',sym('faultpc')),('FATAL',hex(sym('hostfatal')))]:script=re.sub(r'\b'+a+r'\b',lambda _:str(b),script)
path=proof/(target+'-solution.tcl');path.write_text(script);(proof/(target+'-events.txt')).write_text('')
env=os.environ.copy();env['OPENMSX_USER_DATA']=str(ROOT/'work/msx/emuhome')
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
args=['C:/Program Files/openMSX/openmsx.exe','-machine',machine]
if file.endswith('.DSK'):
    image=proof/(target+'-test.DSK');shutil.copy2(OUT/file,image);args+=['-diska',str(image)]
else:args+=['-cart',str(OUT/file),'-romtype','Normal']
with(proof/(target+'-process.log')).open('w')as log:
    process=subprocess.Popen([*args,'-script',str(path)],env=env,startupinfo=startup,stdout=log,stderr=log);(proof/(target+'-pid.txt')).write_text(str(process.pid));process.wait(timeout=240)
print((proof/(target+'-events.txt')).read_text()[-6500:]);print((proof/(target+'-process.log')).read_text())
