from pathlib import Path
root=Path(__file__).resolve().parent
rgb=[(0,0,0),(0,128,255),(255,128,0),(255,255,255)]
colors=[1,4,8,15];patterns=[];attrs=[];flipped=[]
for value in range(256):
    pixels=[(value>>shift)&3 for shift in [6,4,2,0]]
    bg,fg=sorted(range(4),key=lambda c:(-pixels.count(c),c))[:2];mask=0
    for c in pixels:
        dist=lambda k:sum((rgb[c][i]-rgb[k][i])**2 for i in range(3))
        mask=(mask<<2)|(3 if dist(fg)<dist(bg) else 0)
    patterns.append(mask);attrs.append((colors[fg]<<4)|colors[bg])
    swap=lambda c:8 if c==4 else 4 if c==8 else c
    flipped.append((swap(colors[fg])<<4)|swap(colors[bg]))
def array(name,values):
    return 'static const u8 '+name+'[256]={\n'+',\n'.join(','.join(f'0x{v:02x}' for v in values[i:i+16])for i in range(0,256,16))+'\n};\n'
(root/'color_lut.h').write_text(array('color_pattern',patterns)+array('color_attribute',attrs)+array('color_flipped',flipped))
