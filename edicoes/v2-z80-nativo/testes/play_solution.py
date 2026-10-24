"""Read-only observation and keyboard-only player for the actual MSX images."""
from pathlib import Path
import os,subprocess,re,sys,json
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'outputs/MISTAR-MSX-controles-corrigidos'
target=sys.argv[1]if len(sys.argv)>1 else 'panasonic-turbo'
base=OUT/('panasonic-turbo'if target=='panasonic-turbo'else'padrao')
file={'panasonic-turbo':'MISTAR_MSX2_PANASONIC_TURBO.ROM','msx1':'MISTAR_MSX1.ROM','msx2':'MISTAR_MSX2.ROM','dsk-msx1':'MISTAR_MSX1.DSK'}[target]
machine={'panasonic-turbo':'Panasonic_FS-A1WSX','msx1':'C-BIOS_MSX1','msx2':'C-BIOS_MSX2','dsk-msx1':'MISTAR_MSX1'}[target]
mapfile=base/(file.replace('.ROM','.map').replace('.DSK','.map'))
m=mapfile.read_text()
def sym(n):return int(re.search(r'([0-9A-F]{8})\s+_'+n+r'\s',m)[1],16)
proof=OUT/'testes';proof.mkdir(exist_ok=True)
steps={1:'D,N,E,E,S,E,N,N,D,E,D,D',2:'@DOCKING',3:'N,N,N,E,S',4:'GET GRID',5:'N,N,W,N',6:'@SECURITY',7:'N,W,W,S,W',8:'GET MIRROR',9:'E,N,E,S,S,W,S,S,E,N',10:'OPEN CHEST',11:'LOOK CHEST',12:'LOOK CHEST',13:'GET CUTTERS',14:'GET CROWBAR',15:'S,W,W,N',16:'GO POSTER',17:'N',18:'FIX COMPUTER/GRID',19:'USE COMPUTER',20:'GET CARD',21:'W,N,E',22:'GET BLASTER',23:'W,S,E,S,E,S,E,N,N,E,N,N,E,S,S,E,E,S,E',24:'OPEN DOOR/CARD',25:'GO DOOR',26:'OPEN BOX/CROWBAR',27:'LOOK BOX',28:'LOOK BOX',29:'DROP CROWBAR',30:'GET HELMET',31:'S,W,N',32:'DROP MIRROR',33:'DROP CARD',34:'E,N,N,W,S',35:'GET FLASHLIGHT',36:'N,E,S,S,W,W,S,W,S,S',37:'OPEN HATCH',38:'GO HATCH',39:'E,S,E,N,W,N',40:'SHOOT MUTANT',41:'W,N,E,S',42:'CUT SEAWEED/CUTTERS',43:'DROP BLASTER',44:'DROP CUTTERS',45:'N,W,S,W,S,E',46:'ON',47:'E,N,E,E,S,W',48:'GET MUSHROOM',49:'U',50:'OFF',51:'S,S,E',52:'GET MODULE',53:'W,N,N',54:'ON',55:'D,E,S,W,W,N,W',56:'OFF',57:'W,N,E,E,S,E,S,W,N,W,W',58:'COMBINE MUSHROOM/SEAWEED',59:'DROP HELMET',60:'N,N,E,N,E',61:'GET MIRROR',62:'GET CARD',63:'W,W,N',64:'@SECURITY',65:'N',66:'EAT PILL',67:'ON',68:'D,N,D',69:'@SECURITY',70:'OPEN DOOR/CARD',71:'GO DOOR',72:'FIX REACTOR/MODULE',73:'S,U,S,U',74:'OFF',75:'W,S,S,W,S,S,W,N',76:'GO POSTER',77:'N',78:'PUSH BUTTON'}
commands=[]
for number,cmds in steps.items():
    if cmds.startswith('@'):continue
    for cmd in re.split('[,/]',cmds):commands.append([number,cmd])
if '--dock-only'in sys.argv:commands=[x for x in commands if x[0]<=1]
if '--smoke'in sys.argv:
    commands=[[0,c]for c in ['INVENTORY','SAVE 1','DOWN','LOAD 1','INVENTORY']]
    target+='-smoke'
script=r'''
set throttle off
set speed 100
set z80_freq_locked true
set ::idx 0
set ::events {}
set ::lastturn -1
set ::pending 0
set ::waitkey 0
set ::arcade 0
set ::finished 0
set ::keynum 0
set ::dockingpath {}
set ::securityframes 0
set ::securitypath {}
set ::securityroom 0
set ::commands COMMANDS
proc byte {a} {debug read memory $a}
proc le {a} {expr {[byte $a]|([byte [expr {$a+1}]]<<8)}}
proc be {a} {expr {([byte $a]<<8)|[byte [expr {$a+1}]]}}
proc guest {a} {if {$a<1538} {return [byte [expr {LOW+$a}]]};if {$a>=3584&&$a<9728} {return [byte [expr {VIDEO+$a-3584}]]};return 0}
proc gw {a} {expr {([guest $a]<<8)|[guest [expr {$a+1}]]}}
proc event {name} {
 set e [list $name [machine_info time] [byte ROOM] [be TURN] $::idx]
 lappend ::events $e
 set f [open {PROOF/TARGET-events.txt} a];puts $f $e;close $f
}
proc snapshot {label} {
 foreach {name device address length} {ram memory 49152 16384 vram VRAM 0 32768} {
  set f [open "PROOF/TARGET-$label-$name.bin" wb];puts -nonewline $f [debug read_block $device $address $length];close $f
 }
}
proc finish {reason} {
 if {$::finished} {return};set ::finished 1
 event "finish-$reason";snapshot final
 keymatrixup 8 240
 set throttle on
 after time 0.2 {screenshot -raw {PROOF/TARGET-final.png};quit}
}
proc direction {d} {
 keymatrixup 8 240
 set bits 0
 if {$d&8} {set bits [expr {$bits|16}]};if {$d&2} {set bits [expr {$bits|32}]}
 if {$d&1} {set bits [expr {$bits|64}]};if {$d&4} {set bits [expr {$bits|128}]}
 if {$bits} {keymatrixdown 8 $bits}
}
proc docking_plan {} {
 set start [gw 1051];set goal 6227
 set incoming {}
 if {([guest 1059]&7)==0} {
  for {set i 1024} {$i<1048} {incr i 2} {
   set p [expr {[gw $i]-256}];if {$p<4160} {incr p 2048}
   lappend incoming $p
  }
 }
 set todo [list $start];set parent [dict create $start [list -1 0]];set head 0
 while {$head<[llength $todo]} {
  set p [lindex $todo $head];incr head
  if {$p==$goal} {break}
  foreach {delta d} {1 4 256 1 -1 8 -256 2 257 5 -255 6 255 9 -257 10} {
   set q [expr {$p+$delta}];set col [expr {$q&31}]
   if {$q<4160||$q>6300||$col==0||$col>=29||[dict exists $parent $q]} {continue}
   if {$q in $incoming||[expr {$q+1}] in $incoming} {continue}
   set blocked 0
   for {set y 0} {$y<8} {incr y} {for {set x 0} {$x<2} {incr x} {
    set a [expr {$q+$y*32+$x}]
    set rel [expr {$a-$start}]
    if {$rel>=0&&$rel<226&&($rel%32)<2} {continue}
    if {[guest $a]!=0} {set blocked 1;break}
   };if {$blocked} {break}}
   if {!$blocked} {dict set parent $q [list $p $d];lappend todo $q}
  }
 }
 if {![dict exists $parent $goal]} {event docking-no-path;snapshot docking-no-path;return {}}
 set route {};set p $goal
 while {$p!=$start} {lassign [dict get $parent $p] p d;set route [linsert $route 0 $d]}
 return $route
}
proc security_plan {} {
 set start [gw 1039]
 set enemies {}
 for {set i 1024} {$i<1039} {incr i 3} {lappend enemies [list [gw $i] [expr {[guest [expr {$i+2}]]==255?-1:1}]]}
 set forecast [list $enemies]
 for {set t 0} {$t<180} {incr t} {
  set future {}
  foreach e $enemies {
   lassign $e p v
   if {[guest [expr {$p+256}]]==0} {incr p 512} else {
    set col [expr {($p&31)+$v}]
    if {$col==0||$col>=31} {
     if {($p>>8)==23} {set p [expr {$col==0?3997:3969}]} else {set v [expr {-$v}]}
    } else {incr p $v}
   }
   lappend future [list $p $v]
  }
  set enemies $future;lappend forecast $enemies
 }
 set todo [list [list $start 0]];set head 0
 set parent [dict create "$start,0" [list {} 0]];set goal {}
 while {$head<[llength $todo]} {
  lassign [lindex $todo $head] p t;incr head
  if {$t>=179} {continue}
  set blocked {}
  foreach e [lindex $forecast $t] {lappend blocked [lindex $e 0]}
  if {$p in $blocked} {continue}
  set nextblocked {}
  foreach e [lindex $forecast [expr {$t+1}]] {lappend nextblocked [lindex $e 0]}
  set moves [list $p 0]
  if {($p&31)>1} {lappend moves [expr {$p-1}] 8}
  if {($p&31)<30} {lappend moves [expr {$p+1}] 4}
  if {[guest [expr {$p-32}]]==0} {lappend moves [expr {$p-512}] 2}
  if {[guest [expr {$p+256}]]==0} {lappend moves [expr {$p+512}] 1}
  foreach {q d} $moves {
   if {$q in $blocked||$q in $nextblocked} {continue}
   set key "$q,[expr {$t+1}]"
   if {[dict exists $parent $key]} {continue}
   dict set parent $key [list "$p,$t" $d]
   if {$q<=4224} {set goal $key;break}
   lappend todo [list $q [expr {$t+1}]]
  }
  if {$goal ne {}} {break}
 }
 if {$goal eq {}} {event security-no-path;return {}}
 set route {};set key $goal
 while {$key ne "$start,0"} {lassign [dict get $parent $key] key d;set route [linsert $route 0 $d]}
 return $route
}
proc arcade {} {
 if {$::finished} {debug cont;return}
 set ::waitkey 0
 incr ::arcade
 set room [byte ROOM]
 if {$room==23} {
  set ::dockingpath [docking_plan]
  if {$::arcade==1} {event "docking-path-$::dockingpath";snapshot docking}
  if {$::dockingpath eq {}} {direction 0;finish no-docking-path;debug cont;return}
  set d [lindex $::dockingpath 0];set ::dockingpath [lrange $::dockingpath 1 end]
  direction $d;event "docking-[gw 1051]-move-$d";snapshot "docking-$::arcade"
 } else {
  incr ::securityframes
  if {$::securitypath eq {}||$::securityroom!=$room} {
   set ::securityroom $room;set ::securitypath [security_plan]
   event "security-path-$::securitypath";snapshot security
  }
  if {$::securitypath eq {}} {finish security-no-path;debug cont;return}
  set d [lindex $::securitypath 0];set ::securitypath [lrange $::securitypath 1 end]
  direction $d;event "security-room-$room-pos[gw 1039]-move-$d"
  if {$::securityframes>800} {finish security-excess-frames}
 }
 debug cont
}
proc send {} {
 if {$::finished} {return}
 if {$::idx>=[llength $::commands]} {finish commands-complete;return}
 lassign [lindex $::commands $::idx] step cmd
 incr ::idx;event "send-step$step-$cmd"
 set ::pending 1
 type -release -freq 5 [format {%s%c} $cmd 13]
}
proc ready {} {
 if {$::finished} {debug cont;return}
 set pc [le PC]
 if {$pc==65296} {
  set ret [be [expr {STACK+[le SP]-3072}]]
  if {$ret!=$::waitkey} {
   set ::waitkey $ret
   incr ::keynum;event "key-wait-$ret";snapshot "key-$::keynum"
   after time 0.4 {type -release -freq 4 " "}
   after time 1 {set ::waitkey 0}
  }
 } elseif {$pc==41872} {
  set ::waitkey 0
  set turn [le INPUTSEQ]
  if {$turn!=$::lastturn} {
   set ::lastturn $turn
   direction 0;event prompt;snapshot "prompt-$::idx"
   after time 0.3 {send}
  }
 }
 debug cont
}
proc fault {} {event "FAULT-pc[le FAULT]-op[byte FAULTOP]";finish fault;debug cont}
debug set_bp READY {} {ready}
debug set_bp ARCADEREADY {} {arcade}
debug set_bp FATAL {} {fault}
after time 10000 {finish timeout}
'''
script=script.replace('COMMANDS','{'+ ' '.join('{'+str(step)+' {'+cmd+'}}'for step,cmd in commands)+'}')
for a,b in [('PROOF',proof.as_posix()),('TARGET',target),('ROOM',sym('state')+0x5d),('TURN',sym('state')+0x61),('INPUTSEQ',sym('input_sequence')),('LOW',sym('cpu')+15),('VIDEO',sym('video')),('PC',sym('cpu')+8),('SP',sym('cpu')+6),('STACK',sym('video')-512),('ARCADEREADY',hex(sym('arcade_ready'))),('READY',hex(sym('host_ready'))),('FAULTOP',sym('faultop')),('FAULT',sym('faultpc')),('FATAL',hex(sym('hostfatal')))]:script=script.replace(a,str(b))
path=proof/(target+'-solution.tcl');path.write_text(script)
(proof/(target+'-events.txt')).write_text('')
env=os.environ.copy();env['OPENMSX_USER_DATA']=str(ROOT/'work/msx/emuhome')
startup=subprocess.STARTUPINFO();startup.dwFlags|=subprocess.STARTF_USESHOWWINDOW;startup.wShowWindow=0
args=['C:/Program Files/openMSX/openmsx.exe','-machine',machine]
if file.endswith('.DSK'):
    import shutil
    testdisk=proof/(target+'-test.DSK');shutil.copy2(base/file,testdisk)
    args+=['-diska',str(testdisk)]
else:args+=['-cart',str(base/file),'-romtype','Normal']
with(proof/(target+'-process.log')).open('w')as log:
    proc=subprocess.Popen([*args,'-script',str(path)],env=env,startupinfo=startup,stdout=log,stderr=log)
    (proof/(target+'-pid.txt')).write_text(str(proc.pid))
    proc.wait(timeout=300)
print((proof/(target+'-events.txt')).read_text()[-8000:])
print((proof/(target+'-process.log')).read_text())
