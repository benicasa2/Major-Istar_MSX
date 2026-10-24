from pathlib import Path
import re, subprocess, struct, hashlib, json
root=Path.cwd(); out=root/'outputs/MISTAR_fonte'; tool=root/'work/f9dasm/f9dasm.exe'
b=(root/'outputs/MISTAR.BIN').read_bytes(); n,base=struct.unpack('>HH',b[1:5]); entry=int.from_bytes(b[-2:],'big'); raw=b[5:5+n]; end=base+n-1
assert b[0]==0 and b[5+n:8+n]==b'\xff\0\0' and len(b)==n+10
(out/'MISTAR.raw').write_bytes(raw)
ins={}; pending=[entry]; unknown=[]; calls=set(); conflicts=[]
pat=re.compile(r'^.{8}([A-Z][A-Z0-9]*)\s*(.*?)\s*;([0-9A-F]{4}): ((?:[0-9A-F]{2} )+)')
def decode(a):
 text=subprocess.check_output([str(tool),'-noflex','-offset',f'{base:X}','-begin',f'{a:X}','-end',f'{a:X}',str(out/'MISTAR.raw')],stderr=subprocess.DEVNULL).decode('latin1')
 found={}
 for line in text.splitlines():
  m=pat.match(line)
  if m:
   op,arg,addr,h=m.groups(); found[int(addr,16)]=(op,arg,bytes.fromhex(h))
 return found
while pending:
 a=pending.pop()
 if a in ins or not base<=a<=end: continue
 listing=decode(a)
 while base<=a<=end and a not in ins:
  if a not in listing: listing=decode(a)
  if a not in listing: unknown.append([a,'decode failed']); break
  op,arg,data=listing[a]
  if op in ('FCB','FDB','FCC'): unknown.append([a,'invalid opcode']); break
  if any(x<a<x+len(v[2]) for x,v in ins.items()): conflicts.append(a); break
  ins[a]=(op,arg,data); nxt=a+len(data)
  target=None
  # Direct relative and extended branch/call targets only; indexed/indirect stay unresolved.
  if op in ('JMP','JSR') and data[0] in (0x7e,0xbd): target=int.from_bytes(data[1:3],'big')
  elif op.startswith('LB') and op not in ('LDB',):
   k=1 if data[0] in (0x16,0x17) else 2
   if len(data)==k+2: target=(nxt+int.from_bytes(data[k:],'big',signed=True))&65535
  elif op in ('BRA','BRN','BSR','BHI','BLS','BCC','BCS','BNE','BEQ','BVC','BVS','BPL','BMI','BGE','BLT','BGT','BLE','BHS','BLO'):
   target=(nxt+int.from_bytes(data[-1:],'big',signed=True))&65535
  if target is not None:
   if base<=target<=end: pending.append(target)
   if op in ('JSR','BSR','LBSR'): calls.add(target)
  if op in ('JSR','JMP') and target is None: unknown.append([a,op+' '+arg])
  if op in ('RTS','RTI','JMP','BRA','LBRA','SWI','SWI2','SWI3') or (op in ('PULS','PULU') and 'PC' in arg): break
  a=nxt
covered=set()
for a,v in ins.items(): covered.update(range(a,a+len(v[2])))
info=[f'DATA {base:04X}-{end:04X}',f'LABEL {entry:04X} ENTRY',f'LABEL 2610 MAIN_INIT']
for a,(_,_,d) in sorted(ins.items()): info.append(f'CODE {a:04X}-{a+len(d)-1:04X}')
(out/'MISTAR.info').write_text('\n'.join(info)+'\n')
for filename,opts in [('MISTAR.asm',['-noaddr','-nohex','-noasc']),('MISTAR.lst',[])]:
 subprocess.run([str(tool),'-noflex','-offset',f'{base:X}','-info',str(out/'MISTAR.info'),'-out',str(out/filename),*opts,str(out/'MISTAR.raw')],check=True,stdout=subprocess.DEVNULL)
# Byte-preserving source independent of instruction/data classification.
s=['; Exact byte-preserving 6809 source. No claim that all bytes are data.',f'        ORG ${base:04X}']
for i in range(0,n,16): s.append('        FCB '+','.join(f'${x:02X}' for x in raw[i:i+16])+f' ; {base+i:04X}')
s.append(f'        END ${entry:04X}')
(out/'MISTAR_exato.asm').write_text('\n'.join(s)+'\n')
rebuilt=bytes(int(h,16) for line in s if 'FCB ' in line for h in re.findall(r'\$([0-9A-F]{2})',line.split(';')[0]))
assert rebuilt==raw
assert b'\0'+struct.pack('>HH',len(rebuilt),base)+rebuilt+b'\xff\0\0'+struct.pack('>H',entry)==b
report={'bin_sha256':hashlib.sha256(b).hexdigest(),'payload_bytes':n,'load':hex(base),'end':hex(end),'entry':hex(entry),'reachable_instructions':len(ins),'reachable_bytes':len(covered),'unclassified_bytes':n-len(covered),'call_targets':list(map(hex,sorted(calls))),'unresolved_flow':unknown,'conflicts':conflicts,'exact_source_roundtrip':True,'rea_used_as_engine':False}
(out/'analise.json').write_text(json.dumps(report,indent=2))
print(json.dumps({k:v for k,v in report.items() if k not in ('call_targets','unresolved_flow')},indent=2))
