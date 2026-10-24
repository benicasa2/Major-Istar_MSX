import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import java.nio.file.*;
public class ExportMistar extends GhidraScript {
 public void run() throws Exception {
  Path output=Paths.get(getScriptArgs()[0]);Files.createDirectories(output);
  long[] seeds={0x2540,0x2610,0x2708,0x2f3a,0x32d9,0x352d,0x354d,0x35a9,0x3607,0x369b,0x36d7,0x377d,0x37ac,0x37f1,0x38a7,0x38c2,0x38ee,0x391a,0x3989,0x3990,0x3a1e,0x3a3e,0x3ad6};
  DecompInterface d=new DecompInterface();d.openProgram(currentProgram);
  StringBuilder all=new StringBuilder("/* Ghidra 12.1.4 / 6809. Decompiled reconstruction, not original source. */\n");
  for(long s:seeds){Address a=toAddr(s);disassemble(a);Function f=getFunctionAt(a);if(f==null)f=createFunction(a,"MISTAR_"+Long.toHexString(s));if(f==null)continue;DecompileResults r=d.decompileFunction(f,45,monitor);if(r.decompileCompleted())all.append(r.getDecompiledFunction().getC()).append("\n");else all.append("/* unavailable "+Long.toHexString(s)+": "+r.getErrorMessage()+" */\n");}
  Files.writeString(output.resolve("MISTAR-ghidra-reconstruido.c"),all.toString());d.dispose();
  println("MISTAR decompilation exported to "+output);
 }
}
