
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
set ::commands {{1 {D}} {1 {N}} {1 {E}} {1 {E}} {1 {S}} {1 {E}} {1 {N}} {1 {N}} {1 {D}} {1 {E}} {1 {D}} {1 {D}} {3 {N}} {3 {N}} {3 {N}} {3 {E}} {3 {S}} {4 {GET GRID}} {5 {N}} {5 {N}} {5 {W}} {5 {N}} {7 {N}} {7 {W}} {7 {W}} {7 {S}} {7 {W}} {8 {GET MIRROR}} {9 {E}} {9 {N}} {9 {E}} {9 {S}} {9 {S}} {9 {W}} {9 {S}} {9 {S}} {9 {E}} {9 {N}} {10 {OPEN CHEST}} {11 {LOOK CHEST}} {12 {LOOK CHEST}} {13 {GET CUTTERS}} {14 {GET CROWBAR}} {15 {S}} {15 {W}} {15 {W}} {15 {N}} {16 {GO POSTER}} {17 {N}} {18 {FIX COMPUTER}} {18 {GRID}} {19 {USE COMPUTER}} {20 {GET CARD}} {21 {W}} {21 {N}} {21 {E}} {22 {GET BLASTER}} {23 {W}} {23 {S}} {23 {E}} {23 {S}} {23 {E}} {23 {S}} {23 {E}} {23 {N}} {23 {N}} {23 {E}} {23 {N}} {23 {N}} {23 {E}} {23 {S}} {23 {S}} {23 {E}} {23 {E}} {23 {S}} {23 {E}} {24 {OPEN DOOR}} {24 {CARD}} {25 {GO DOOR}} {26 {OPEN BOX}} {26 {CROWBAR}} {27 {LOOK BOX}} {28 {LOOK BOX}} {29 {DROP CROWBAR}} {30 {GET HELMET}} {31 {S}} {31 {W}} {31 {N}} {32 {DROP MIRROR}} {33 {DROP CARD}} {34 {E}} {34 {N}} {34 {N}} {34 {W}} {34 {S}} {35 {GET FLASHLIGHT}} {36 {N}} {36 {E}} {36 {S}} {36 {S}} {36 {W}} {36 {W}} {36 {S}} {36 {W}} {36 {S}} {36 {S}} {37 {OPEN HATCH}} {38 {GO HATCH}} {39 {E}} {39 {S}} {39 {E}} {39 {N}} {39 {W}} {39 {N}} {40 {SHOOT MUTANT}} {41 {W}} {41 {N}} {41 {E}} {41 {S}} {42 {CUT SEAWEED}} {42 {CUTTERS}} {43 {DROP BLASTER}} {44 {DROP CUTTERS}} {45 {N}} {45 {W}} {45 {S}} {45 {W}} {45 {S}} {45 {E}} {46 {ON}} {47 {E}} {47 {N}} {47 {E}} {47 {E}} {47 {S}} {47 {W}} {48 {GET MUSH57454}} {49 {U}} {50 {OFF}} {51 {S}} {51 {S}} {51 {E}} {52 {GET MODULE}} {53 {W}} {53 {N}} {53 {N}} {54 {ON}} {55 {D}} {55 {E}} {55 {S}} {55 {W}} {55 {W}} {55 {N}} {55 {W}} {56 {OFF}} {57 {W}} {57 {N}} {57 {E}} {57 {E}} {57 {S}} {57 {E}} {57 {S}} {57 {W}} {57 {N}} {57 {W}} {57 {W}} {58 {COMBINE MUSH57454}} {58 {SEAWEED}} {59 {DROP HELMET}} {60 {N}} {60 {N}} {60 {E}} {60 {N}} {60 {E}} {61 {GET MIRROR}} {62 {GET CARD}} {63 {W}} {63 {W}} {63 {N}} {65 {N}} {66 {EAT PILL}} {67 {ON}} {68 {D}} {68 {N}} {68 {D}} {70 {OPEN DOOR}} {70 {CARD}} {71 {GO DOOR}} {72 {FIX REACTOR}} {72 {MODULE}} {73 {S}} {73 {U}} {73 {S}} {73 {U}} {74 {OFF}} {75 {W}} {75 {S}} {75 {S}} {75 {W}} {75 {S}} {75 {S}} {75 {W}} {75 {N}} {76 {GO POSTER}} {77 {N}} {78 {PUSH BUTTON}}}
proc byte {a} {debug read memory $a}
proc le {a} {expr {[byte $a]|([byte [expr {$a+1}]]<<8)}}
proc be {a} {expr {([byte $a]<<8)|[byte [expr {$a+1}]]}}
proc guest {a} {if {$a<1538} {return [byte [expr {49167+$a}]]};if {$a>=3584&&$a<9728} {return [byte [expr {51217+$a-3584}]]};return 0}
proc gw {a} {expr {([guest $a]<<8)|[guest [expr {$a+1}]]}}
proc event {name} {
 set e [list $name [machine_info time] [byte 57454] [be 57458] $::idx]
 lappend ::events $e
 set f [open {C:/Users/Anderson/Documents/Codex/2026-10-23/https-github-com-morluto-rea-https/outputs/MISTAR-MSX-controles-corrigidos/testes/panasonic-turbo-events.txt} a];puts $f $e;close $f
}
proc snapshot {label} {
 foreach {name device address length} {ram memory 49152 16384 vram VRAM 0 32768} {
  set f [open "C:/Users/Anderson/Documents/Codex/2026-10-23/https-github-com-morluto-rea-https/outputs/MISTAR-MSX-controles-corrigidos/testes/panasonic-turbo-$label-$name.bin" wb];puts -nonewline $f [debug read_block $device $address $length];close $f
 }
}
proc finish {reason} {
 if {$::finished} {return};set ::finished 1
 event "finish-$reason";snapshot final
 keymatrixup 8 240
 set throttle on
 after time 0.2 {screenshot -raw {C:/Users/Anderson/Documents/Codex/2026-10-23/https-github-com-morluto-rea-https/outputs/MISTAR-MSX-controles-corrigidos/testes/panasonic-turbo-final.png};quit}
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
 set room [byte 57454]
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
 set pc [le 49160]
 if {$pc==65296} {
  set ret [be [expr {50705+[le 49158]-3072}]]
  if {$ret!=$::waitkey} {
   set ::waitkey $ret
   incr ::keynum;event "key-wait-$ret";snapshot "key-$::keynum"
   after time 0.4 {type -release -freq 4 " "}
   after time 1 {set ::waitkey 0}
  }
 } elseif {$pc==41872} {
  set ::waitkey 0
  set turn [le 60439]
  if {$turn!=$::lastturn} {
   set ::lastturn $turn
   direction 0;event prompt;snapshot "prompt-$::idx"
   after time 0.3 {send}
  }
 }
 debug cont
}
proc fault {} {event "61222-pc[le 61222]-op[byte 61224]";finish fault;debug cont}
debug set_bp 0x6c1a {} {ready}
debug set_bp 0x6b73 {} {arcade}
debug set_bp 0x6e1a {} {fault}
after time 10000 {finish timeout}
