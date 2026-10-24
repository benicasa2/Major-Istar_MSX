/* Pseudocodigo gerado pelo Ghidra 12.1.4 / REA 6809.
   Nao e o fonte original nem um programa C portavel/compilavel.
   Evidencia: ev_1e7321bc932a1bde31f52e9b4833a35d50cddd4054f2e58cd141b30b79702302 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void MISTAR_BOOT(undefined1 param_1,undefined1 param_2)

{
  undefined1 uVar1;
  byte bVar2;
  byte in_DP;
  code *pcVar3;
  code *pcVar4;
  code *pcVar5;
  
  pcVar3 = (code *)&DAT_0160;
  pcVar5 = entry;
  do {
    pcVar4 = pcVar5 + 1;
    *pcVar3 = *pcVar5;
    pcVar3 = pcVar3 + 1;
    pcVar5 = pcVar4;
  } while (pcVar4 != MISTAR_BOOT);
  FUN_38c2();
  DAT_ff40 = 0;
  DAT_ff03 = 0x34;
  *(undefined1 *)((ushort)in_DP * 0x100 + 0x71) = 0x55;
  *(undefined1 **)((ushort)in_DP * 0x100 + 0x72) = &LAB_2610;
  DAT_0182 = 0x39;
  FUN_38ee(0);
  DAT_6c35 = (undefined1 *)0xf00;
  DAT_6c37 = 0;
  DAT_6c5d = '\x16';
  do {
    FUN_3989();
    DAT_6c5d = DAT_6c5d + -1;
    bVar2 = (DAT_6c5d == '\0') << 2;
  } while (DAT_6c5d != '\0');
  do {
    (*_DAT_a000)();
  } while ((bool)(bVar2 >> 2 & 1));
  FUN_38ee(0);
  bVar2 = 0;
  FUN_369b();
  do {
    (*_DAT_a000)();
  } while ((bool)(bVar2 >> 2 & 1));
  FUN_38e9();
  uVar1 = FUN_38f6();
  DAT_6c35 = &DAT_0e20;
  uVar1 = FUN_3989(uVar1,param_2,s_Where__3e73);
  FUN_3989(uVar1,param_2,s_BEGINNING_5b49);
  FUN_369b();
  DAT_6c37 = ~DAT_6c37;
  uVar1 = FUN_3906();
  FUN_3607(uVar1,param_2,s_You_are_in_a_shuttle_sub_on_the_o_46f2);
  FUN_3906();
  DAT_0167 = 0x7e;
  _DAT_0168 = 0x398e;
  _DAT_016b = 0x3a3c;
  DAT_016a = 0x7e;
  _DAT_01a1 = 0x3904;
  DAT_6c5d = 1;
  DAT_6c63 = 0;
  DAT_6c65 = 0;
  DAT_6c66 = 0;
  DAT_6c64 = 0;
  DAT_6c67 = 0;
  DAT_6c60 = 0;
  _DAT_4dc3 = s_DAMAGED_COMPUTER_5203;
  _DAT_4f6c = s_DAMAGED_REACTOR_529f;
  DAT_4c91 = 0x542c;
  _DAT_4cdc = 0x54e3;
  DAT_6c61 = -1;
  *(undefined2 *)((ushort)in_DP * 0x100 + 0x72) = 0x34ca;
  *(undefined1 *)((ushort)in_DP * 0x100 + 0x71) = 0x55;
  FUN_2f3a();
  FUN_354d();
  FUN_35a9();
  FUN_32d9();
  FUN_3982();
  DAT_6c61 = DAT_6c61 + 1;
  FUN_2b45();
  return;
}

