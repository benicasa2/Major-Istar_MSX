from pathlib import Path
import re,json
R=Path(__file__).resolve().parents[2];N=R/'outputs/MISTAR-MSX-Z80-nativo';H=R/'outputs/MISTAR-MSX-controles-corrigidos'
def symbols(p):return {n:int(a,16)for a,n in re.findall(r'([0-9A-F]{8})\s+_(\w+)\s',p.read_text())}
n=symbols(N/'MISTAR_MSX2PLUS_Z80_TURBO.map');h=symbols(H/'panasonic-turbo/MISTAR_MSX2_PANASONIC_TURBO.map')
raw=(H/'padrao/fontes/MISTAR.raw').read_bytes();records=[]
for i in range(207):
    np=N/f'testes/panasonic-turbo-prompt-{i}-ram.bin';hp=R/f'work/msx/native-reference/panasonic-turbo-prompt-{i}-ram.bin'
    if not np.exists()or not hp.exists():continue
    nr=np.read_bytes();hr=hp.read_bytes();nv=nr[n['video']-0xc000:n['video']-0xc000+6144];hv=hr[h['video']-0xc000:h['video']-0xc000+6144]
    count=int.from_bytes(hr[h['patchcount']-0xc000:h['patchcount']-0xc000+2],'little')
    addr=h['state']-0xc000+1281;values=addr+512;objects=bytearray(raw[0x4c7a-0x2460:0x4fb3-0x2460])
    for j in range(count):
        p=int.from_bytes(hr[addr+j*2:addr+j*2+2],'little')
        if 0x4c7a<=p<0x4fb3:objects[p-0x4c7a]=hr[values+j]
    native=nr[n['objects']-0xc000:n['objects']-0xc000+825]
    diffs=[(j,a,b)for j,(a,b)in enumerate(zip(native,objects))if a!=b]
    a=nr[n['adventure']-0xc000:n['adventure']-0xc000+9];s=hr[h['state']-0xc000:h['state']-0xc000+1281]
    ref=bytes([s[0x5d],s[0x63],s[0x60],s[0x64],s[0x65]])
    record={'prompt':i,'video_differences':sum(a!=b for a,b in zip(nv,hv)),'object_differences':diffs,'state_matches':a[:5]==ref,'turns_match':int.from_bytes(a[7:9],'little')==int.from_bytes(s[0x61:0x63],'big')}
    records.append(record)
(N/'testes/comparacao-hibrido.json').write_text(json.dumps(records,indent=2)+'\n')
print(json.dumps({'prompts':len(records),'video_nonzero':[r['prompt']for r in records if r['video_differences']],'objects_nonzero':[r for r in records if r['object_differences']][:5],'state_differences':[r['prompt']for r in records if not r['state_matches']],'turn_differences':[r['prompt']for r in records if not r['turns_match']]},indent=2))
