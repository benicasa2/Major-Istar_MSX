from pathlib import Path
import re
root=Path(__file__).resolve().parents[2]
s=Path('C:/Program Files/openMSX/share/machines/Panasonic_FS-A1WSX.xml').read_text()
s,n=re.subn(r'(<MemoryMapper id="Main RAM">[\s\S]*?<size>)64(</size>)',r'\g<1>512\2',s)
assert n==1
(root/'work/msx/emuhome/machines/MISTAR_MSX2PLUS_512K.xml').write_text(s)
print('MSX2+ V9958 with 512 KiB mapped RAM configured for local testing.')
