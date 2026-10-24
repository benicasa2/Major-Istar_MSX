from pathlib import Path
import subprocess,argparse
P=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--gcc',default='gcc');args=ap.parse_args()
b=P/'build';b.mkdir(exist_ok=True)
subprocess.run([args.gcc,'-std=c99','-O2','-Wall','-Wextra',str(P/'test_native.c'),'-o',str(b/'test_native.exe')],check=True)
subprocess.run([str(b/'test_native.exe'),str(P/'assets.bin')],check=True)
