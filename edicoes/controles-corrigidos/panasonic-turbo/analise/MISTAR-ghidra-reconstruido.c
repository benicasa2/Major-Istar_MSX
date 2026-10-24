/* Ghidra 12.1.4 / 6809. Decompiled reconstruction, not original source. */

void MISTAR_2540(void)

{
  bool bVar1;
  ushort uVar2;
  byte bVar3;
  byte in_DP;
  code *pcVar4;
  code *pcVar5;
  short *psVar7;
  code *pcVar6;
  
  pcVar4 = (code *)0x160;
  pcVar6 = (code *)0x2460;
  do {
    pcVar5 = pcVar6 + 1;
    *pcVar4 = *pcVar6;
    pcVar4 = pcVar4 + 1;
    pcVar6 = pcVar5;
  } while (pcVar5 != MISTAR_2540);
  (*(code *)0x38c2)();
  uRAMff40 = 0;
  uRAMff03 = 0x34;
  *(undefined1 *)((ushort)in_DP * 0x100 + 0x71) = 0x55;
  *(undefined2 *)((ushort)in_DP * 0x100 + 0x72) = 0x2610;
  uRAM0182 = 0x39;
  (*(code *)0x38ee)(0);
  uRAM6c35 = 0xf00;
  bRAM6c37 = 0;
  cRAM6c5d = '\x16';
  do {
    (*(code *)0x3989)();
    cRAM6c5d = cRAM6c5d + -1;
    bVar3 = (cRAM6c5d == '\0') << 2;
  } while (cRAM6c5d != '\0');
  do {
    (*pcRAMa000)();
  } while ((bool)(bVar3 >> 2 & 1));
  (*(code *)0x38ee)(0);
  bVar3 = 0;
  (*(code *)0x369b)();
  do {
    (*pcRAMa000)();
  } while ((bool)(bVar3 >> 2 & 1));
  (*(code *)0x38e9)();
  (*(code *)0x38f6)();
  uRAM6c35 = 0xe20;
  (*(code *)0x3989)();
  (*(code *)0x3989)();
  (*(code *)0x369b)();
  bRAM6c37 = ~bRAM6c37;
  (*(code *)0x3906)();
  (*(code *)0x3607)();
  (*(code *)0x3906)();
  uRAM0167 = 0x7e;
  uRAM0168 = 0x398e;
  uRAM016b = 0x3a3c;
  uRAM016a = 0x7e;
  uRAM01a1 = 0x3904;
  cRAM6c5d = 1;
  uRAM6c63 = 0;
  uRAM6c65 = 0;
  uRAM6c66 = 0;
  uRAM6c64 = 0;
  uRAM6c67 = 0;
  uRAM6c60 = 0;
  pcRAM4dc3 = s_DAMAGED_COMPUTER_5203;
  pcRAM4f6c = s_DAMAGED_REACTOR_529f;
  uRAM4c91 = 0x542c;
  uRAM4cdc = 0x54e3;
  sRAM6c61 = -1;
  *(undefined2 *)((ushort)in_DP * 0x100 + 0x72) = 0x34ca;
  *(undefined1 *)((ushort)in_DP * 0x100 + 0x71) = 0x55;
  do {
    (*(code *)0x2f3a)();
    (*(code *)0x354d)();
    (*(code *)0x35a9)();
    (*(code *)0x32d9)();
    (*(code *)0x3982)();
    sRAM6c61 = sRAM6c61 + 1;
    bVar3 = bRAM4e34;
    if (cRAM4e33 == '\0') {
code_r0x2708:
      do {
        bRAM4e34 = bVar3;
        (*(code *)0x3989)();
        (*(code *)0x3ad6)();
        (*(code *)0x3ae2)();
        psVar7 = (short *)0x4b30;
        do {
          if ((sRAM6c53 == *psVar7) && (sRAM6c55 == psVar7[1])) {
            pcRAM6c57 = (code *)psVar7[2];
            bVar1 = pcRAM6c57 == (code *)0x0;
            goto code_r0x273e;
          }
          psVar7 = psVar7 + 3;
        } while (psVar7 < (short *)0x4c7a);
        (*(code *)0x3989)();
        bVar3 = bRAM4e34;
      } while( true );
    }
    if (bRAM4e34 != 0) {
      bVar3 = bRAM4e34 - 1;
      if ((char)((bRAM4e34 < bRAM4e35) + (bRAM4e34 == bRAM4e35)) != '\0') {
        uVar2 = (ushort)bRAM4e34;
        bRAM4e34 = bRAM4e34 - 1;
        *(ushort *)((ushort)in_DP * 0x100 + 0x68) = uVar2;
        (*(code *)0x3989)();
        (*(code *)0xbdca)();
        (*(code *)0x3989)();
        bVar3 = bRAM4e34;
      }
      goto code_r0x2708;
    }
    cRAM4e33 = '\0';
    (*(code *)0x3989)();
    (*(code *)0x38de)();
  } while( true );
code_r0x273e:
  bVar3 = bVar1 << 2;
  (*(code *)0x3ae7)();
  if ((bool)(bVar3 >> 2 & 1)) {
code_r0x275e:
                    /* WARNING: Could not recover jumptable at 0x2763. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    (*pcRAM6c57)(sRAM6c59._0_1_);
    return;
  }
  psVar7 = (short *)0x52f6;
  while ((sRAM6c59 != *psVar7 || (bVar1 = true, sRAM6c5b != psVar7[1]))) {
    psVar7 = psVar7 + 2;
    if ((short *)0x5365 < psVar7) goto code_r0x275e;
  }
  goto code_r0x273e;
}



/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void MISTAR_2610(void)

{
  bool bVar1;
  ushort uVar2;
  byte bVar3;
  byte in_DP;
  short *psVar4;
  
  (*(code *)0x38c2)();
  DAT_ff40 = 0;
  DAT_ff03 = 0x34;
  *(undefined1 *)((ushort)in_DP * 0x100 + 0x71) = 0x55;
  *(code **)((ushort)in_DP * 0x100 + 0x72) = MISTAR_2610;
  DAT_0182 = 0x39;
  (*(code *)0x38ee)(0);
  _DAT_6c35 = 0xf00;
  DAT_6c37 = 0;
  DAT_6c5d = '\x16';
  do {
    (*(code *)0x3989)();
    DAT_6c5d = DAT_6c5d + -1;
    bVar3 = (DAT_6c5d == '\0') << 2;
  } while (DAT_6c5d != '\0');
  do {
    (*pcRAMa000)();
  } while ((bool)(bVar3 >> 2 & 1));
  (*(code *)0x38ee)(0);
  bVar3 = 0;
  (*(code *)0x369b)();
  do {
    (*pcRAMa000)();
  } while ((bool)(bVar3 >> 2 & 1));
  (*(code *)0x38e9)();
  (*(code *)0x38f6)();
  _DAT_6c35 = 0xe20;
  (*(code *)0x3989)();
  (*(code *)0x3989)();
  (*(code *)0x369b)();
  DAT_6c37 = ~DAT_6c37;
  (*(code *)0x3906)();
  (*(code *)0x3607)();
  (*(code *)0x3906)();
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
  _DAT_4c91 = 0x542c;
  _DAT_4cdc = 0x54e3;
  _DAT_6c61 = -1;
  *(undefined2 *)((ushort)in_DP * 0x100 + 0x72) = 0x34ca;
  *(undefined1 *)((ushort)in_DP * 0x100 + 0x71) = 0x55;
  do {
    (*(code *)0x2f3a)();
    (*(code *)0x354d)();
    (*(code *)0x35a9)();
    (*(code *)0x32d9)();
    (*(code *)0x3982)();
    _DAT_6c61 = _DAT_6c61 + 1;
    bVar3 = bRAM4e34;
    if (cRAM4e33 == '\0') {
code_r0x2708:
      do {
        bRAM4e34 = bVar3;
        (*(code *)0x3989)();
        (*(code *)0x3ad6)();
        (*(code *)0x3ae2)();
        psVar4 = (short *)0x4b30;
        do {
          if ((sRAM6c53 == *psVar4) && (sRAM6c55 == psVar4[1])) {
            pcRAM6c57 = (code *)psVar4[2];
            bVar1 = pcRAM6c57 == (code *)0x0;
            goto code_r0x273e;
          }
          psVar4 = psVar4 + 3;
        } while (psVar4 < (short *)0x4c7a);
        (*(code *)0x3989)();
        bVar3 = bRAM4e34;
      } while( true );
    }
    if (bRAM4e34 != 0) {
      bVar3 = bRAM4e34 - 1;
      if ((char)((bRAM4e34 < bRAM4e35) + (bRAM4e34 == bRAM4e35)) != '\0') {
        uVar2 = (ushort)bRAM4e34;
        bRAM4e34 = bRAM4e34 - 1;
        *(ushort *)((ushort)in_DP * 0x100 + 0x68) = uVar2;
        (*(code *)0x3989)();
        (*(code *)0xbdca)();
        (*(code *)0x3989)();
        bVar3 = bRAM4e34;
      }
      goto code_r0x2708;
    }
    cRAM4e33 = '\0';
    (*(code *)0x3989)();
    (*(code *)0x38de)();
  } while( true );
code_r0x273e:
  bVar3 = bVar1 << 2;
  (*(code *)0x3ae7)();
  if ((bool)(bVar3 >> 2 & 1)) {
code_r0x275e:
                    /* WARNING: Could not recover jumptable at 0x2763. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    (*pcRAM6c57)(sRAM6c59._0_1_);
    return;
  }
  psVar4 = (short *)0x52f6;
  while ((sRAM6c59 != *psVar4 || (bVar1 = true, sRAM6c5b != psVar4[1]))) {
    psVar4 = psVar4 + 2;
    if ((short *)0x5365 < psVar4) goto code_r0x275e;
  }
  goto code_r0x273e;
}



/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void MISTAR_2708(void)

{
  bool bVar1;
  byte bVar2;
  short *psVar3;
  
  do {
    (*(code *)0x3989)();
    (*(code *)0x3ad6)();
    (*(code *)0x3ae2)();
    psVar3 = (short *)0x4b30;
    do {
      if ((_DAT_6c53 == *psVar3) && (_DAT_6c55 == psVar3[1])) {
        _DAT_6c57 = (code *)psVar3[2];
        bVar1 = _DAT_6c57 == (code *)0x0;
        goto LAB_273e;
      }
      psVar3 = psVar3 + 3;
    } while (psVar3 < (short *)0x4c7a);
    (*(code *)0x3989)();
  } while( true );
LAB_273e:
  bVar2 = bVar1 << 2;
  (*(code *)0x3ae7)();
  if ((bool)(bVar2 >> 2 & 1)) {
LAB_275e:
                    /* WARNING: Could not recover jumptable at 0x2763. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    (*_DAT_6c57)(DAT_6c59);
    return;
  }
  psVar3 = (short *)0x52f6;
  do {
    if (_DAT_6c59 == *psVar3) {
      bVar1 = true;
      if (_DAT_6c5b == psVar3[1]) goto LAB_273e;
    }
    psVar3 = psVar3 + 2;
    if ((short *)0x5365 < psVar3) goto LAB_275e;
  } while( true );
}



/* WARNING: Control flow encountered bad instruction data */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined1 MISTAR_2f3a(void)

{
  undefined2 uVar1;
  bool bVar2;
  undefined1 uVar3;
  ushort uVar4;
  byte bVar5;
  byte in_DP;
  char *pcVar6;
  char *pcVar7;
  code *pcVar8;
  undefined1 *puVar9;
  code *pcVar10;
  short *psVar11;
  undefined1 *puVar12;
  
  if (((DAT_6c5d < 0x43) || (DAT_4cb2 == '\0')) &&
     ((bVar5 = (DAT_6c5d == 0x20) << 2, DAT_6c5d != 0x20 ||
      ((bVar5 = (DAT_6c63 == '!') << 2, DAT_6c63 != '!' ||
       (bVar5 = (DAT_4d93 == '\0') << 2, DAT_4d93 == '\0')))))) {
    (*(code *)0x352d)();
    if ((bVar5 >> 2 & 1) == 0) {
      DAT_6c64 = 0;
    }
    else {
      DAT_6c64 = DAT_6c64 + 1;
      if (!(bool)((DAT_6c64 < 2) + (DAT_6c64 == 2))) goto LAB_2f89;
    }
    if ((DAT_6c5d != 0x42) || (DAT_6c65 != '\0')) {
      if (MISTAR_2610 == (code)0x12) {
        return 0;
      }
      goto LAB_2f8c;
    }
  }
LAB_2f89:
  (*(code *)0x3607)();
LAB_2f8c:
  (*(code *)0x38f6)();
  _DAT_6c35 = 0xe20;
  (*(code *)0x3989)();
  (*(code *)0x3989)();
  (*(code *)0x3906)();
  (*(code *)0x369b)();
  (*(code *)0x3989)();
  (*(code *)0x3ad6)();
  (*(code *)0x3ae2)();
  if (DAT_6c53 != 'Y') {
    *(undefined2 *)((ushort)in_DP * 0x100 + 0x72) = 0x3501;
    *(undefined1 *)((ushort)in_DP * 0x100 + 0x71) = 0x55;
    pcVar10 = MISTAR_2610;
    do {
      pcVar8 = pcVar10 + 1;
      *pcVar10 = (code)0x0;
      pcVar10 = pcVar8;
    } while (pcVar8 < (code *)0x3501);
    puVar12 = (undefined1 *)0x352d;
    do {
      puVar9 = puVar12 + 1;
      *puVar12 = 0;
      puVar12 = puVar9;
    } while (puVar9 < (undefined1 *)0xf200);
    pcVar10 = (code *)0x0;
    do {
      pcVar8 = pcVar10 + 1;
      *pcVar10 = (code)0x0;
      pcVar10 = pcVar8;
    } while ((bool)((pcVar8 < MISTAR_2610) + (pcVar8 == MISTAR_2610)));
                    /* WARNING: Bad instruction - Truncating control flow here */
    halt_baddata();
  }
  pcVar6 = (char *)0x4fb3;
  puVar12 = (undefined1 *)0x4c7a;
  do {
    uVar1 = *(undefined2 *)pcVar6;
    *puVar12 = (char)((ushort)uVar1 >> 8);
    puVar12[6] = (char)uVar1;
    *(undefined2 *)(puVar12 + 9) = *(undefined2 *)(pcVar6 + 2);
    *(undefined2 *)(puVar12 + 0xb) = *(undefined2 *)(pcVar6 + 4);
    *(undefined2 *)(puVar12 + 0xf) = *(undefined2 *)(pcVar6 + 6);
    *(undefined2 *)(puVar12 + 0x11) = *(undefined2 *)(pcVar6 + 8);
    pcVar7 = pcVar6 + 0xc;
    *(undefined2 *)(puVar12 + 0x13) = *(undefined2 *)(pcVar6 + 10);
    pcVar6 = pcVar6 + 0xe;
    *(undefined2 *)(puVar12 + 0x15) = *(undefined2 *)pcVar7;
    puVar12 = puVar12 + 0x19;
  } while (*pcVar6 != '\0');
  (*(code *)0x3906)();
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
  _DAT_4c91 = 0x542c;
  _DAT_4cdc = 0x54e3;
  _DAT_6c61 = -1;
  *(undefined2 *)((ushort)in_DP * 0x100 + 0x72) = 0x34ca;
  *(undefined1 *)((ushort)in_DP * 0x100 + 0x71) = 0x55;
  do {
    MISTAR_2f3a();
    (*(code *)0x354d)();
    (*(code *)0x35a9)();
    (*(code *)0x32d9)();
    (*(code *)0x3982)();
    _DAT_6c61 = _DAT_6c61 + 1;
    bVar5 = bRAM4e34;
    if (cRAM4e33 == '\0') {
MISTAR_2708:
      do {
        bRAM4e34 = bVar5;
        (*(code *)0x3989)();
        (*(code *)0x3ad6)();
        (*(code *)0x3ae2)();
        psVar11 = (short *)0x4b30;
        do {
          if ((_DAT_6c53 == *psVar11) && (_DAT_6c55 == psVar11[1])) {
            _DAT_6c57 = (code *)psVar11[2];
            bVar2 = _DAT_6c57 == (code *)0x0;
            goto LAB_273e;
          }
          psVar11 = psVar11 + 3;
        } while (psVar11 < (short *)0x4c7a);
        (*(code *)0x3989)();
        bVar5 = bRAM4e34;
      } while( true );
    }
    if (bRAM4e34 != 0) {
      bVar5 = bRAM4e34 - 1;
      if ((char)((bRAM4e34 < bRAM4e35) + (bRAM4e34 == bRAM4e35)) != '\0') {
        uVar4 = (ushort)bRAM4e34;
        bRAM4e34 = bRAM4e34 - 1;
        *(ushort *)((ushort)in_DP * 0x100 + 0x68) = uVar4;
        (*(code *)0x3989)();
        (*(code *)0xbdca)();
        (*(code *)0x3989)();
        bVar5 = bRAM4e34;
      }
      goto MISTAR_2708;
    }
    cRAM4e33 = '\0';
    (*(code *)0x3989)();
    (*(code *)0x38de)();
  } while( true );
LAB_273e:
  bVar5 = bVar2 << 2;
  (*(code *)0x3ae7)();
  if ((bool)(bVar5 >> 2 & 1)) {
LAB_275e:
                    /* WARNING: Could not recover jumptable at 0x2763. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    uVar3 = (*_DAT_6c57)(DAT_6c59);
    return uVar3;
  }
  psVar11 = (short *)0x52f6;
  while ((_DAT_6c59 != *psVar11 || (bVar2 = true, _DAT_6c5b != psVar11[1]))) {
    psVar11 = psVar11 + 2;
    if ((short *)0x5365 < psVar11) goto LAB_275e;
  }
  goto LAB_273e;
}



/* WARNING: Possible PIC construction at 0x3987: Changing call to branch */
/* WARNING: Heritage AFTER dead removal. Example location: B : 0x39d9 */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: register */

void MISTAR_32d9(void)

{
  byte extraout_A;
  undefined2 in_D;
  undefined1 extraout_B;
  byte bVar1;
  char *pcVar2;
  short sVar3;
  ushort uVar4;
  undefined2 in_Y;
  char *pcVar5;
  byte abStack_a [8];
  undefined2 uStack_2;
  
  pcVar2 = s_You_see__3e88;
  uStack_2 = 0x32df;
  (*(code *)0x3989)();
  DAT_6c52 = '\0';
  pcVar5 = (char *)0x4c7a;
  bVar1 = 0;
  uStack_2 = 0x32e8;
  (*(code *)0x352d)();
  if ((bVar1 >> 2 & 1) == 0) {
    do {
      if ((char)((DAT_6c5d < 0x16) + (DAT_6c5d == 0x16)) != '\0') {
        in_D = CONCAT11(0x67,(char)in_D);
      }
      if (((char)((ushort)in_D >> 8) == pcVar5[6]) && (*pcVar5 != ' ')) {
        if (DAT_6c52 != '\0') {
          uStack_2 = 0x330e;
          (*(code *)0x3989)();
        }
        DAT_6c52 = DAT_6c52 + '\x01';
        pcVar2 = *(char **)(pcVar5 + 4);
        uStack_2 = 0x3316;
        (*(code *)0x3989)();
        if ((0x16 < DAT_6c5d) && (pcVar2 = *(char **)(pcVar5 + 0x17), pcVar2 != (char *)0x0)) {
          uStack_2 = 0x332a;
          _DAT_0600 = pcVar5;
          (*(code *)0x369b)();
          pcVar5 = _DAT_0600;
        }
      }
      pcVar5 = pcVar5 + 0x19;
    } while (pcVar5 < (char *)0x4fb3);
    if (DAT_6c52 == '\0') goto code_r0x3989;
  }
  else {
code_r0x3989:
    pcVar2 = s_Nothing__3ebf + 1;
    if (s_Nothing__3ebf[0] == '\0') {
      return;
    }
    register0x18 = (BADSPACEBASE *)&uStack_2;
    uStack_2 = 0x3989;
  }
  *(undefined2 *)((short)register0x18 + -2) = 0x3993;
  (*(code *)0x391a)();
  extraout_B = (undefined1)in_D;
  extraout_A = (byte)((ushort)in_D >> 8);
  *(char **)((short)register0x18 + -2) = pcVar5;
  *(undefined2 *)((short)register0x18 + -4) = in_Y;
  *(char **)((short)register0x18 + -6) = pcVar2;
  *(undefined1 *)((short)register0x18 + -7) = extraout_B;
  *(byte *)((short)register0x18 + -8) = extraout_A;
  if (extraout_A == 8) {
    if (_DAT_6c35 == 0x1b00) {
code_r0x39d9:
                    /* WARNING: Could not recover jumptable at 0x39d9. Too many branches */
                    /* WARNING: Treating indirect jump as call */
      (**(code **)register0x18)
                ((char)((ushort)*(undefined2 *)((short)register0x18 + -8) >> 8),extraout_B,
                 *(undefined2 *)((short)register0x18 + -6),*(undefined2 *)((short)register0x18 + -4)
                 ,*(undefined2 *)((short)register0x18 + -2));
      return;
    }
    *(undefined2 *)((short)register0x18 + -10) = 0x39a6;
    uVar4 = _DAT_6c35;
    (*(code *)0x3a1e)();
    sVar3 = uVar4 - 1;
    if ((char)sVar3 < '\0') {
      sVar3 = uVar4 - 0xe1;
    }
    *(undefined2 *)((short)register0x18 + -10) = 0x39b6;
    (*(code *)0x3a1e)(0x20,extraout_B,sVar3);
  }
  else {
    uVar4 = _DAT_6c35;
    if (extraout_A != 0xd) {
      if (0x1f < extraout_A) {
        *(undefined2 *)((short)register0x18 + -10) = 0x39d7;
        func_0x3a1e();
        *(undefined2 *)((short)register0x18 + -10) = 0x39d9;
        func_0x39df();
      }
      goto code_r0x39d9;
    }
    do {
      *(undefined2 *)((short)register0x18 + -10) = 0x39c3;
      func_0x3a1e();
      uVar4 = uVar4 + 1;
    } while ((uVar4 & 0x1f) != 0);
  }
  *(undefined2 *)((short)register0x18 + -10) = 0x39dd;
  func_0x39e1();
                    /* WARNING: Could not recover jumptable at 0x39dd. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **)register0x18)
            ((char)((ushort)*(undefined2 *)((short)register0x18 + -8) >> 8),extraout_B,
             *(undefined2 *)((short)register0x18 + -6),*(undefined2 *)((short)register0x18 + -4),
             *(undefined2 *)((short)register0x18 + -2));
  return;
}



/* WARNING: Instruction at (RAM,0x3549) overlaps instruction at (RAM,0x3548)
    */

undefined1 MISTAR_352d(void)

{
  return 0;
}



/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void MISTAR_354d(void)

{
  undefined1 uVar1;
  byte bVar2;
  undefined1 *puVar3;
  char *pcVar5;
  char *pcVar6;
  undefined1 *puVar4;
  
  if (DAT_6c67 == '\0') {
    (*(code *)0x38f6)();
  }
  else {
    DAT_6c37 = 0;
    puVar4 = (undefined1 *)0xe00;
    do {
      puVar3 = puVar4 + 1;
      *puVar4 = 0;
      puVar4 = puVar3;
    } while (puVar3 < (undefined1 *)0xf20);
  }
  _DAT_6c35 = 0xe20;
  bVar2 = 0;
  (*(code *)0x3989)();
  uVar1 = MISTAR_352d();
  if ((bVar2 >> 2 & 1) == 0) {
    (*(code *)0x3989)(uVar1,DAT_6c5d << 1,*(undefined2 *)((byte)(DAT_6c5d << 1) + 0x597f));
    (*(code *)0x3906)();
    if (DAT_6c67 != '\0') {
      DAT_6c67 = 0;
      return;
    }
    pcVar5 = *(char **)((byte)(DAT_6c5d << 1) + 0x5cd0);
  }
  else {
    (*(code *)0x3989)();
    (*(code *)0x3906)();
    pcVar5 = (char *)0x6a7d;
  }
  while( true ) {
    pcVar6 = pcVar5 + 1;
    if (*pcVar5 == '\0') break;
    (**(code **)((byte)(*pcVar5 << 1) + 0x5c17))();
    pcVar5 = pcVar6;
  }
  return;
}



/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void MISTAR_35a9(void)

{
  ushort uVar1;
  char *pcVar2;
  char *pcVar3;
  
  _DAT_6c5e = (char *)((ushort)(byte)(DAT_6c5d - 1) * 6 + 0x5723);
  uVar1 = 0x5b88;
  pcVar2 = _DAT_6c5e;
  do {
    uVar1 = uVar1 + 1;
    pcVar3 = pcVar2 + 1;
    if (*pcVar2 != '\0') {
      (*(code *)0x3a1e)();
    }
    pcVar2 = pcVar3;
  } while (uVar1 < 0x5b8e);
  DAT_6c37 = ~DAT_6c37;
  return;
}



/* WARNING: Heritage AFTER dead removal. Example location: B : 0x39d9 */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: register */

void MISTAR_3607(void)

{
  byte extraout_A;
  undefined2 in_D;
  undefined1 uVar1;
  char *pcVar2;
  short sVar3;
  ushort uVar4;
  undefined2 in_Y;
  undefined2 in_U;
  code *UNRECOVERED_JUMPTABLE_00;
  
  (*(code *)0x3989)();
  pcVar2 = s__PRESS_ANY_KEY_TO_CONTINUE__4062;
  (*(code *)0x3989)();
  (*(code *)0x3a3e)();
  (*(code *)0x3982)();
  (*(code *)0x391a)();
  extraout_A = (byte)((ushort)in_D >> 8);
  uVar1 = (undefined1)in_D;
  if (extraout_A == 8) {
    if (_DAT_6c35 == 0x1b00) {
code_r0x39d9:
                    /* WARNING: Could not recover jumptable at 0x39d9. Too many branches */
                    /* WARNING: Treating indirect jump as call */
      (*UNRECOVERED_JUMPTABLE_00)(extraout_A,uVar1,pcVar2,in_Y,in_U);
      return;
    }
    uVar4 = _DAT_6c35;
    (*(code *)0x3a1e)();
    sVar3 = uVar4 - 1;
    if ((char)sVar3 < '\0') {
      sVar3 = uVar4 - 0xe1;
    }
    (*(code *)0x3a1e)(0x20,uVar1,sVar3);
  }
  else {
    uVar4 = _DAT_6c35;
    if (extraout_A != 0xd) {
      if (0x1f < extraout_A) {
        func_0x3a1e();
        func_0x39df();
      }
      goto code_r0x39d9;
    }
    do {
      func_0x3a1e();
      uVar4 = uVar4 + 1;
    } while ((uVar4 & 0x1f) != 0);
  }
  func_0x39e1();
                    /* WARNING: Could not recover jumptable at 0x39dd. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*UNRECOVERED_JUMPTABLE_00)(extraout_A,uVar1,pcVar2,in_Y,in_U);
  return;
}



void MISTAR_369b(void)

{
  char *in_U;
  char *pcVar1;
  
  while( true ) {
    pcVar1 = in_U + 1;
    if (*in_U == '\0') break;
    (**(code **)((byte)(*in_U << 1) + 0x5c17))();
    in_U = pcVar1;
  }
  return;
}



/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void MISTAR_36d7(void)

{
  char cVar1;
  char cVar2;
  byte bVar3;
  undefined2 *in_U;
  
  _DAT_6c6d = *in_U;
  bVar3 = (byte)((ushort)_DAT_6c6d >> 8);
  DAT_6c72 = bVar3 - DAT_6c6b;
  DAT_6c73 = (byte)_DAT_6c6d - DAT_6c6c;
  DAT_6c75 = '\0';
  DAT_6c76 = '\x01';
  DAT_6c77 = '\x01';
  DAT_6c71 = 1;
  DAT_6c78 = '\0';
  if (bVar3 < DAT_6c6b) {
    DAT_6c77 = -1;
    DAT_6c72 = -DAT_6c72;
  }
  if ((byte)_DAT_6c6d < DAT_6c6c) {
    DAT_6c73 = -DAT_6c73;
    DAT_6c76 = -1;
  }
  bVar3 = DAT_6c73;
  if (DAT_6c72 < DAT_6c73) {
    DAT_6c73 = DAT_6c72;
    DAT_6c72 = bVar3;
    DAT_6c75 = DAT_6c77;
    DAT_6c77 = '\0';
    DAT_6c78 = DAT_6c76;
    DAT_6c76 = '\0';
  }
  DAT_6c74 = DAT_6c72 >> 1;
  while( true ) {
    func_0x377d();
    if (!(bool)((DAT_6c71 < DAT_6c72) + (DAT_6c71 == DAT_6c72))) break;
    cVar1 = (char)((ushort)_DAT_6c6b >> 8) + DAT_6c77;
    cVar2 = (char)_DAT_6c6b + DAT_6c78;
    _DAT_6c6b = CONCAT11(cVar1,cVar2);
    DAT_6c74 = DAT_6c74 + DAT_6c73;
    DAT_6c71 = DAT_6c71 + 1;
    if (!(bool)((DAT_6c74 < DAT_6c72) + (DAT_6c74 == DAT_6c72))) {
      DAT_6c74 = DAT_6c74 - DAT_6c72;
      _DAT_6c6b = CONCAT11(cVar1 + DAT_6c75,cVar2 + DAT_6c76);
    }
  }
  return;
}



/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void MISTAR_377d(void)

{
  byte *pbVar1;
  byte bVar2;
  
  pbVar1 = (byte *)((CONCAT11(0x20,DAT_6c6c) >> 8) * (ushort)DAT_6c6c +
                   CONCAT11((char)((ushort)_DAT_6c6a >> 8),(byte)_DAT_6c6a >> 2) + 0xf20);
  bVar2 = (byte)_DAT_6c6a & 3;
  DAT_6c4b = *pbVar1 & *(byte *)((char)bVar2 + 0x5b95);
  *pbVar1 = DAT_6c69 & *(byte *)((char)bVar2 + 0x5b91) | DAT_6c4b;
  return;
}



/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void MISTAR_37ac(void)

{
  undefined1 uVar1;
  char cVar2;
  undefined1 *puVar3;
  undefined1 *puVar4;
  ushort *in_U;
  
  _DAT_6c6a = CONCAT12(DAT_6c6a,*in_U);
  puVar3 = (undefined1 *)((*in_U & 0xff) * 0x20 + _DAT_6c6a + 0xf20);
  _DAT_6c72 = in_U[1];
  DAT_6c71 = *(char *)(in_U + 2) * '\b';
  do {
    uVar1 = *(undefined1 *)((byte)((DAT_6c6c & 7) + DAT_6c71) + 0x5b99);
    puVar4 = puVar3;
    cVar2 = DAT_6c72;
    do {
      *puVar4 = uVar1;
      cVar2 = cVar2 + -1;
      puVar4 = puVar4 + 1;
    } while (cVar2 != '\0');
    DAT_6c6c = DAT_6c6c + '\x01';
    puVar3 = puVar3 + 0x20;
    DAT_6c73 = DAT_6c73 + -1;
  } while (DAT_6c73 != '\0');
  return;
}



/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void MISTAR_37f1(void)

{
  char cVar1;
  byte bVar2;
  ushort *in_U;
  ushort *puVar3;
  
  puVar3 = in_U + 1;
  _DAT_6c6b = *in_U;
  DAT_6c73 = *(byte *)puVar3 & DAT_5b91;
  DAT_6c74 = *(byte *)puVar3 & DAT_5b92;
  DAT_6c75 = *(byte *)puVar3 & DAT_5b93;
  DAT_6c76 = (byte)(*puVar3 >> 8) & DAT_5b94;
  DAT_6c71 = (char)*puVar3 * '\b';
  do {
    DAT_6c72 = *(undefined1 *)((byte)((DAT_6c6c & 7) + DAT_6c71) + 0x5b99);
    _DAT_6c78 = (CONCAT11(0x20,DAT_6c6c) >> 8) * (_DAT_6c6b & 0xff) + 0xf20;
    DAT_6c77 = DAT_6c6b;
    cVar1 = DAT_6c6b;
    do {
      bVar2 = (cVar1 == '\0') << 2;
      func_0x3873();
      if ((bool)(bVar2 >> 2 & 1)) break;
      func_0x388f();
      DAT_6c6b = DAT_6c6b + '\x01';
      cVar1 = DAT_6c6b;
    } while (-1 < DAT_6c6b);
    if (DAT_6c77 == DAT_6c6b) {
      return;
    }
    DAT_6c6b = DAT_6c77;
    while( true ) {
      DAT_6c6b = DAT_6c6b + -1;
      bVar2 = (DAT_6c6b == '\0') << 2;
      if ((DAT_6c6b < '\0') || (func_0x3873(), (bool)(bVar2 >> 2 & 1))) break;
      func_0x388f();
    }
    _DAT_6c6b = CONCAT11(DAT_6c77,1);
  } while( true );
}



void MISTAR_38a7(void)

{
  ushort uVar1;
  char cVar2;
  undefined1 uVar4;
  byte bVar5;
  undefined1 *puVar6;
  undefined1 *puVar7;
  ushort *puVar8;
  undefined2 *in_U;
  ushort uVar3;
  ushort *puVar9;
  
  puVar6 = (undefined1 *)*in_U;
  puVar8 = (ushort *)in_U[1] + 1;
  uVar3 = *(ushort *)in_U[1];
  do {
    uVar4 = (undefined1)uVar3;
    uVar1 = uVar3 >> 8;
    puVar7 = puVar6;
    puVar9 = puVar8;
    do {
      puVar8 = (ushort *)((short)puVar9 + 1);
      *puVar7 = *(undefined1 *)puVar9;
      puVar7 = puVar7 + 0x20;
      bVar5 = (char)uVar3 - 1;
      uVar3 = (ushort)bVar5;
      puVar9 = puVar8;
    } while (bVar5 != 0);
    puVar6 = puVar6 + 1;
    cVar2 = (char)uVar1 + -1;
    uVar3 = CONCAT11(cVar2,uVar4);
  } while (cVar2 != '\0');
  return;
}



/* WARNING: Instruction at (RAM,0x38d6) overlaps instruction at (RAM,0x38d5)
    */

void MISTAR_38c2(void)

{
  byte bVar1;
  byte bVar2;
  undefined1 *puVar3;
  undefined1 *puVar4;
  
  DAT_ff22 = 0xf8;
  puVar3 = (undefined1 *)0xffc0;
  bVar2 = 0x3e;
  do {
    bVar1 = bVar2 & 1;
    bVar2 = (char)bVar2 >> 1;
    puVar4 = puVar3;
    if (bVar1 == 0) {
      puVar4 = puVar3 + 2;
      *puVar3 = 0;
    }
    puVar3 = puVar4 + 2;
    puVar4[1] = 0;
  } while (puVar3 < (undefined1 *)0xffd3);
  return;
}



void MISTAR_38ee(undefined1 param_1,undefined1 param_2,undefined1 *param_3)

{
  undefined1 *puVar1;
  
  do {
    puVar1 = param_3 + 1;
    *param_3 = param_1;
    param_3 = puVar1;
  } while ((bool)((puVar1 < (undefined1 *)0x25ff) + (puVar1 == (undefined1 *)0x25ff)));
  return;
}



/* WARNING: Instruction at (RAM,0x397b) overlaps instruction at (RAM,0x397a)
    */
/* WARNING: Heritage AFTER dead removal. Example location: B : 0x3980 */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: register */

void MISTAR_391a(undefined2 param_1,undefined2 param_2,undefined2 param_3)

{
  byte bVar1;
  undefined2 in_D;
  code *UNRECOVERED_JUMPTABLE;
  
  bVar1 = (byte)((ushort)in_D >> 8);
  if (!(bool)((bVar1 < 0x20) + (bVar1 == 0x20))) {
    if ((char)((DAT_6c39 < 0xe) + (DAT_6c39 == 0xe)) != '\0') {
      *(byte *)((char)DAT_6c39 + 0x6c3b) = bVar1;
      DAT_6c39 = DAT_6c39 + 1;
    }
    if ((((_DAT_6c35 & 0x1f) == 0) && (DAT_6c3a != '\0')) &&
       ((char)((DAT_6c39 < 0xe) + (DAT_6c39 == 0xe)) != '\0')) {
      do {
        (*(code *)0x3a1e)();
      } while ((char)in_D != '\x01');
      _DAT_6c50 = param_3;
      (*(code *)0x3a1e)();
      _DAT_6c35 = _DAT_6c35 + 1;
      param_3 = _DAT_6c50;
    }
  }
  _DAT_6c38 = _DAT_6c38 & 0xff00;
  DAT_6c3a = '\0';
                    /* WARNING: Could not recover jumptable at 0x3980. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*UNRECOVERED_JUMPTABLE)(bVar1,(char)in_D,param_1,param_2,param_3);
  return;
}



void MISTAR_3989(undefined1 param_1,undefined1 param_2,char *param_3)

{
  char *pcVar1;
  
  while (pcVar1 = param_3 + 1, *param_3 != '\0') {
    func_0x3990();
    param_3 = pcVar1;
  }
  return;
}



/* WARNING: Heritage AFTER dead removal. Example location: B : 0x39d9 */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: register */

void MISTAR_3990(undefined2 param_1,undefined2 param_2,undefined2 param_3)

{
  byte extraout_A;
  undefined2 in_D;
  undefined1 uVar1;
  short sVar2;
  ushort uVar3;
  code *UNRECOVERED_JUMPTABLE_00;
  
  MISTAR_391a();
  extraout_A = (byte)((ushort)in_D >> 8);
  uVar1 = (undefined1)in_D;
  if (extraout_A == 8) {
    if (_DAT_6c35 == 0x1b00) {
LAB_39d9:
                    /* WARNING: Could not recover jumptable at 0x39d9. Too many branches */
                    /* WARNING: Treating indirect jump as call */
      (*UNRECOVERED_JUMPTABLE_00)(extraout_A,uVar1,param_1,param_2,param_3);
      return;
    }
    uVar3 = _DAT_6c35;
    (*(code *)&SUB_3a1e)();
    sVar2 = uVar3 - 1;
    if ((char)sVar2 < '\0') {
      sVar2 = uVar3 - 0xe1;
    }
    (*(code *)&SUB_3a1e)(0x20,uVar1,sVar2);
  }
  else {
    uVar3 = _DAT_6c35;
    if (extraout_A != 0xd) {
      if (0x1f < extraout_A) {
        func_0x3a1e();
        func_0x39df();
      }
      goto LAB_39d9;
    }
    do {
      func_0x3a1e();
      uVar3 = uVar3 + 1;
    } while ((uVar3 & 0x1f) != 0);
  }
  func_0x39e1();
                    /* WARNING: Could not recover jumptable at 0x39dd. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*UNRECOVERED_JUMPTABLE_00)(extraout_A,uVar1,param_1,param_2,param_3);
  return;
}



/* WARNING: Heritage AFTER dead removal. Example location: B : 0x3a3a */
/* WARNING: Removing unreachable block (RAM,0x3a3a) */
/* WARNING: Restarted to delay deadcode elimination for space: register */

void MISTAR_3a1e(byte *param_1)

{
  undefined2 in_D;
  byte *pbVar1;
  
  pbVar1 = (byte *)((ushort)(byte)((char)((ushort)in_D >> 8) - 0x20) * 8 + 0x3b26);
  do {
    *param_1 = *pbVar1 ^ DAT_6c37;
    param_1 = param_1 + 0x20;
    pbVar1 = pbVar1 + 1;
  } while( true );
}



/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void MISTAR_3a3e(undefined1 param_1,undefined1 param_2,undefined2 param_3)

{
  char cVar1;
  undefined1 uVar2;
  byte bVar3;
  undefined1 *puVar4;
  code *UNRECOVERED_JUMPTABLE;
  
  do {
    do {
      (*(code *)0x3a6a)();
      (*(code *)0x3a76)();
      DAT_6c68 = DAT_6c68 + '\x01';
      bVar3 = (DAT_6c68 == '\0') << 2;
      cVar1 = (*pcRAMa000)();
    } while ((bool)(bVar3 >> 2 & 1));
  } while ((cVar1 == '\f') || (cVar1 == '\x03'));
  uVar2 = func_0x3a9e();
  cVar1 = '\b';
  puVar4 = _DAT_6c35;
  do {
    *puVar4 = 0xff;
    puVar4 = puVar4 + 0x20;
    cVar1 = cVar1 + -1;
  } while (cVar1 != '\0');
                    /* WARNING: Could not recover jumptable at 0x3a68. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (*UNRECOVERED_JUMPTABLE)(uVar2,param_2,param_3);
  return;
}



void MISTAR_3ad6(void)

{
  byte in_DP;
  
  (*(code *)0xa390)();
  *(undefined2 *)((ushort)in_DP * 0x100 + 0xa6) = 0x2dd;
  DAT_037d = 0;
  return;
}


