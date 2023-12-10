
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega64
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _key=R4
	.DEF _key_msb=R5
	.DEF _player=R6
	.DEF _player_msb=R7
	.DEF _state=R8
	.DEF _state_msb=R9
	.DEF _count=R10
	.DEF _count_msb=R11
	.DEF _i=R12
	.DEF _i_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x52,0x65,0x61,0x64,0x79,0x0,0x74,0x6F
	.DB  0x0,0x53,0x74,0x61,0x72,0x74,0x0,0x58
	.DB  0x20,0x54,0x75,0x72,0x6E,0x0,0x4F,0x20
	.DB  0x54,0x75,0x72,0x6E,0x0,0x4F,0x20,0x57
	.DB  0x49,0x4E,0x4E,0x45,0x52,0x21,0x0,0x58
	.DB  0x20,0x57,0x49,0x4E,0x4E,0x45,0x52,0x21
	.DB  0x0,0x47,0x61,0x6D,0x65,0x20,0x4F,0x76
	.DB  0x65,0x72,0x2E,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  _0x54
	.DW  _0x0*2

	.DW  0x03
	.DW  _0x54+6
	.DW  _0x0*2+6

	.DW  0x06
	.DW  _0x54+9
	.DW  _0x0*2+9

	.DW  0x07
	.DW  _0x5D
	.DW  _0x0*2+15

	.DW  0x07
	.DW  _0x5D+7
	.DW  _0x0*2+22

	.DW  0x0A
	.DW  _0x94
	.DW  _0x0*2+29

	.DW  0x0A
	.DW  _0x94+10
	.DW  _0x0*2+39

	.DW  0x0B
	.DW  _0x94+20
	.DW  _0x0*2+49

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <mega64.h>
;#include <alcd.h>
;#include <stdio.h>
;#include <delay.h>
;
;int key,game[9]={0},sum[8]={0},player,state,count,i,x,y,j,f=0,s;
;
;int get_key(void){
; 0000 000A int get_key(void){

	.CSEG
_get_key:
; .FSTART _get_key
; 0000 000B delay_ms(10);
	CALL SUBOPT_0x0
; 0000 000C //0 , 1 , 2 , 10(START)
; 0000 000D PORTC=0B11111110;
	LDI  R30,LOW(254)
	OUT  0x15,R30
; 0000 000E if(PINC.7==0){
	SBIC 0x13,7
	RJMP _0x3
; 0000 000F delay_ms(10);
	CALL SUBOPT_0x0
; 0000 0010 if(PINC.7==0)
	SBIC 0x13,7
	RJMP _0x4
; 0000 0011 while(!PINC.7){}
_0x5:
	SBIS 0x13,7
	RJMP _0x5
; 0000 0012 return 0;
_0x4:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0000 0013 }
; 0000 0014 if(PINC.6==0){
_0x3:
	SBIC 0x13,6
	RJMP _0x8
; 0000 0015 delay_ms(10);
	CALL SUBOPT_0x0
; 0000 0016 if(PINC.6==0)
	SBIC 0x13,6
	RJMP _0x9
; 0000 0017 while(!PINC.6){}
_0xA:
	SBIS 0x13,6
	RJMP _0xA
; 0000 0018 return 1;
_0x9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 0019 }
; 0000 001A if(PINC.5==0){
_0x8:
	SBIC 0x13,5
	RJMP _0xD
; 0000 001B delay_ms(10);
	CALL SUBOPT_0x0
; 0000 001C if(PINC.5==0)
	SBIC 0x13,5
	RJMP _0xE
; 0000 001D while(!PINC.5){}
_0xF:
	SBIS 0x13,5
	RJMP _0xF
; 0000 001E return 2;
_0xE:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET
; 0000 001F }
; 0000 0020 if(PINC.4==0){
_0xD:
	SBIC 0x13,4
	RJMP _0x12
; 0000 0021 delay_ms(10);
	CALL SUBOPT_0x0
; 0000 0022 if(PINC.4==0)
	SBIC 0x13,4
	RJMP _0x13
; 0000 0023 while(!PINC.4){}
_0x14:
	SBIS 0x13,4
	RJMP _0x14
; 0000 0024 return 10;
_0x13:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET
; 0000 0025 }
; 0000 0026 
; 0000 0027 //3 , 4 , 5, 11(PAUS)
; 0000 0028 delay_ms(10);
_0x12:
	CALL SUBOPT_0x0
; 0000 0029 PORTC=0B11111101;
	LDI  R30,LOW(253)
	OUT  0x15,R30
; 0000 002A if(PINC.7==0){
	SBIC 0x13,7
	RJMP _0x17
; 0000 002B delay_ms(10);
	CALL SUBOPT_0x0
; 0000 002C if(PINC.7==0)
	SBIC 0x13,7
	RJMP _0x18
; 0000 002D while(!PINC.7){}
_0x19:
	SBIS 0x13,7
	RJMP _0x19
; 0000 002E return 3;
_0x18:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RET
; 0000 002F }
; 0000 0030 if(PINC.6==0){
_0x17:
	SBIC 0x13,6
	RJMP _0x1C
; 0000 0031 delay_ms(10);
	CALL SUBOPT_0x0
; 0000 0032 if(PINC.6==0)
	SBIC 0x13,6
	RJMP _0x1D
; 0000 0033 while(!PINC.6){}
_0x1E:
	SBIS 0x13,6
	RJMP _0x1E
; 0000 0034 return 4;
_0x1D:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET
; 0000 0035 }
; 0000 0036 if(PINC.5==0){
_0x1C:
	SBIC 0x13,5
	RJMP _0x21
; 0000 0037 delay_ms(10);
	CALL SUBOPT_0x0
; 0000 0038 if(PINC.5==0)
	SBIC 0x13,5
	RJMP _0x22
; 0000 0039 while(!PINC.5){}
_0x23:
	SBIS 0x13,5
	RJMP _0x23
; 0000 003A return 5;
_0x22:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET
; 0000 003B }
; 0000 003C if(PINC.4==0){
_0x21:
	SBIC 0x13,4
	RJMP _0x26
; 0000 003D delay_ms(10);
	CALL SUBOPT_0x0
; 0000 003E if(PINC.4==0)
	SBIC 0x13,4
	RJMP _0x27
; 0000 003F while(!PINC.4){}
_0x28:
	SBIS 0x13,4
	RJMP _0x28
; 0000 0040 return 11;
_0x27:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RET
; 0000 0041 }
; 0000 0042 
; 0000 0043 //6 , 7 , 8 , 12(RESTART)
; 0000 0044 delay_ms(10);
_0x26:
	CALL SUBOPT_0x0
; 0000 0045 PORTC=0B11111011;
	LDI  R30,LOW(251)
	OUT  0x15,R30
; 0000 0046 if(PINC.7==0){
	SBIC 0x13,7
	RJMP _0x2B
; 0000 0047 delay_ms(10);
	CALL SUBOPT_0x0
; 0000 0048 if(PINC.7==0)
	SBIC 0x13,7
	RJMP _0x2C
; 0000 0049 while(!PINC.7){}
_0x2D:
	SBIS 0x13,7
	RJMP _0x2D
; 0000 004A return 6;
_0x2C:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RET
; 0000 004B }
; 0000 004C if(PINC.6==0){
_0x2B:
	SBIC 0x13,6
	RJMP _0x30
; 0000 004D delay_ms(10);
	CALL SUBOPT_0x0
; 0000 004E if(PINC.6==0)
	SBIC 0x13,6
	RJMP _0x31
; 0000 004F while(!PINC.6){}
_0x32:
	SBIS 0x13,6
	RJMP _0x32
; 0000 0050 return 7;
_0x31:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RET
; 0000 0051 }
; 0000 0052 if(PINC.5==0){
_0x30:
	SBIC 0x13,5
	RJMP _0x35
; 0000 0053 delay_ms(10);
	CALL SUBOPT_0x0
; 0000 0054 if(PINC.5==0)
	SBIC 0x13,5
	RJMP _0x36
; 0000 0055 while(!PINC.5){}
_0x37:
	SBIS 0x13,5
	RJMP _0x37
; 0000 0056 return 8;
_0x36:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RET
; 0000 0057 }
; 0000 0058 if(PINC.4==0){
_0x35:
	SBIC 0x13,4
	RJMP _0x3A
; 0000 0059 delay_ms(10);
	CALL SUBOPT_0x0
; 0000 005A if(PINC.4==0)
	SBIC 0x13,4
	RJMP _0x3B
; 0000 005B while(!PINC.4){}
_0x3C:
	SBIS 0x13,4
	RJMP _0x3C
; 0000 005C return 12;
_0x3B:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RET
; 0000 005D }
; 0000 005E 
; 0000 005F //16(UNDO) , 15(GIVE UP) , 14(TURN) , 13(STOP)
; 0000 0060 delay_ms(10);
_0x3A:
	CALL SUBOPT_0x0
; 0000 0061 PORTC=0B11110111;
	LDI  R30,LOW(247)
	OUT  0x15,R30
; 0000 0062 if(PINC.7==0){
	SBIC 0x13,7
	RJMP _0x3F
; 0000 0063 delay_ms(10);
	CALL SUBOPT_0x0
; 0000 0064 if(PINC.7==0)
	SBIC 0x13,7
	RJMP _0x40
; 0000 0065 while(!PINC.7){}
_0x41:
	SBIS 0x13,7
	RJMP _0x41
; 0000 0066 return 16;
_0x40:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RET
; 0000 0067 }
; 0000 0068 if(PINC.6==0){
_0x3F:
	SBIC 0x13,6
	RJMP _0x44
; 0000 0069 delay_ms(10);
	CALL SUBOPT_0x0
; 0000 006A if(PINC.6==0)
	SBIC 0x13,6
	RJMP _0x45
; 0000 006B while(!PINC.6){}
_0x46:
	SBIS 0x13,6
	RJMP _0x46
; 0000 006C return 15;
_0x45:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	RET
; 0000 006D }
; 0000 006E if(PINC.5==0){
_0x44:
	SBIC 0x13,5
	RJMP _0x49
; 0000 006F delay_ms(10);
	CALL SUBOPT_0x0
; 0000 0070 if(PINC.5==0)
	SBIC 0x13,5
	RJMP _0x4A
; 0000 0071 while(!PINC.5){}
_0x4B:
	SBIS 0x13,5
	RJMP _0x4B
; 0000 0072 return 14;
_0x4A:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RET
; 0000 0073 }
; 0000 0074 if(PINC.4==0){
_0x49:
	SBIC 0x13,4
	RJMP _0x4E
; 0000 0075 delay_ms(10);
	CALL SUBOPT_0x0
; 0000 0076 if(PINC.4==0)
	SBIC 0x13,4
	RJMP _0x4F
; 0000 0077 while(!PINC.4){}
_0x50:
	SBIS 0x13,4
	RJMP _0x50
; 0000 0078 return 13;
_0x4F:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RET
; 0000 0079 }
; 0000 007A 
; 0000 007B }
_0x4E:
	RET
; .FEND
;
;//Initialing
;void get_started(int k){
; 0000 007E void get_started(int k){
_get_started:
; .FSTART _get_started
; 0000 007F if(k==1){              //k=1:STOP KEY
	ST   -Y,R27
	ST   -Y,R26
;	k -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x53
; 0000 0080 lcd_clear();
	CALL _lcd_clear
; 0000 0081 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0082 lcd_puts("Ready");
	__POINTW2MN _0x54,0
	CALL _lcd_puts
; 0000 0083 lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x1
; 0000 0084 lcd_puts("to");
	__POINTW2MN _0x54,6
	CALL _lcd_puts
; 0000 0085 lcd_gotoxy(11,2);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
; 0000 0086 lcd_puts("Start");
	__POINTW2MN _0x54,9
	CALL _lcd_puts
; 0000 0087 while(key!=10){
_0x55:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x57
; 0000 0088 key=get_key();
	RCALL _get_key
	MOVW R4,R30
; 0000 0089 }
	RJMP _0x55
_0x57:
; 0000 008A }
; 0000 008B player=0;
_0x53:
	CLR  R6
	CLR  R7
; 0000 008C state=0;
	CLR  R8
	CLR  R9
; 0000 008D count=0;
	CLR  R10
	CLR  R11
; 0000 008E f=0;
	CALL SUBOPT_0x2
; 0000 008F for(i=0;i<9;i++){
	CLR  R12
	CLR  R13
_0x59:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x5A
; 0000 0090     game[i]=0;
	CALL SUBOPT_0x3
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0000 0091     }
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RJMP _0x59
_0x5A:
; 0000 0092 
; 0000 0093 }
	JMP  _0x2080002
; .FEND

	.DSEG
_0x54:
	.BYTE 0xF
;
;void show(){
; 0000 0095 void show(){

	.CSEG
_show:
; .FSTART _show
; 0000 0096 lcd_clear();
	CALL _lcd_clear
; 0000 0097 x=y=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _y,R30
	STS  _y+1,R31
	STS  _x,R30
	STS  _x+1,R31
; 0000 0098 if(f==1){                   //f=1:TURN KEY
	LDS  R26,_f
	LDS  R27,_f+1
	SBIW R26,1
	BRNE _0x5B
; 0000 0099     if(player==0){
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x5C
; 0000 009A     lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x1
; 0000 009B     lcd_puts("X Turn");
	__POINTW2MN _0x5D,0
	RJMP _0x9D
; 0000 009C     }
; 0000 009D     else{
_0x5C:
; 0000 009E     lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x1
; 0000 009F     lcd_puts("O Turn");
	__POINTW2MN _0x5D,7
_0x9D:
	CALL _lcd_puts
; 0000 00A0     }
; 0000 00A1 }
; 0000 00A2 
; 0000 00A3 for(i=0;i<9;i++)
_0x5B:
	CLR  R12
	CLR  R13
_0x60:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R12,R30
	CPC  R13,R31
	BRLT PC+2
	RJMP _0x61
; 0000 00A4     {
; 0000 00A5     if(i%3==0 && i!=0){
	MOVW R26,R12
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MODW21
	SBIW R30,0
	BRNE _0x63
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BRNE _0x64
_0x63:
	RJMP _0x62
_0x64:
; 0000 00A6         y+=1;
	LDS  R30,_y
	LDS  R31,_y+1
	ADIW R30,1
	STS  _y,R30
	STS  _y+1,R31
; 0000 00A7         x=0;
	LDI  R30,LOW(0)
	STS  _x,R30
	STS  _x+1,R30
; 0000 00A8         }
; 0000 00A9     lcd_gotoxy(x,y);
_0x62:
	LDS  R30,_x
	ST   -Y,R30
	LDS  R26,_y
	RCALL _lcd_gotoxy
; 0000 00AA     switch (game[i]){
	CALL SUBOPT_0x3
	CALL __GETW1P
; 0000 00AB     case 0:
	SBIW R30,0
	BRNE _0x68
; 0000 00AC     lcd_putchar('-');
	LDI  R26,LOW(45)
	RJMP _0x9E
; 0000 00AD     break;
; 0000 00AE 
; 0000 00AF     case 1:
_0x68:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x69
; 0000 00B0     lcd_putchar('X');
	LDI  R26,LOW(88)
	RJMP _0x9E
; 0000 00B1     break;
; 0000 00B2 
; 0000 00B3     case -1:
_0x69:
	CPI  R30,LOW(0xFFFFFFFF)
	LDI  R26,HIGH(0xFFFFFFFF)
	CPC  R31,R26
	BRNE _0x67
; 0000 00B4     lcd_putchar('O');
	LDI  R26,LOW(79)
_0x9E:
	RCALL _lcd_putchar
; 0000 00B5     break;
; 0000 00B6     }
_0x67:
; 0000 00B7     x++;
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00B8     }
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RJMP _0x60
_0x61:
; 0000 00B9 }
	RET
; .FEND

	.DSEG
_0x5D:
	.BYTE 0xE
;
;void winner_check(){
; 0000 00BB void winner_check(){

	.CSEG
_winner_check:
; .FSTART _winner_check
; 0000 00BC sum[0]=game[0]+game[1]+game[2];
	__GETW1MN _game,2
	CALL SUBOPT_0x4
	__GETW1MN _game,4
	ADD  R30,R26
	ADC  R31,R27
	STS  _sum,R30
	STS  _sum+1,R31
; 0000 00BD sum[1]=game[3]+game[4]+game[5];
	__GETW2MN _game,6
	CALL SUBOPT_0x5
	__GETW1MN _game,10
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _sum,2
; 0000 00BE sum[2]=game[6]+game[7]+game[8];
	__GETW2MN _game,12
	__GETW1MN _game,14
	CALL SUBOPT_0x6
	__PUTW1MN _sum,4
; 0000 00BF sum[3]=game[0]+game[3]+game[6];
	__GETW1MN _game,6
	CALL SUBOPT_0x4
	CALL SUBOPT_0x7
	__PUTW1MN _sum,6
; 0000 00C0 sum[4]=game[1]+game[4]+game[7];
	__GETW2MN _game,2
	CALL SUBOPT_0x5
	__GETW1MN _game,14
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _sum,8
; 0000 00C1 sum[5]=game[2]+game[5]+game[8];
	__GETW2MN _game,4
	__GETW1MN _game,10
	CALL SUBOPT_0x6
	__PUTW1MN _sum,10
; 0000 00C2 sum[6]=game[0]+game[4]+game[8];
	__GETW1MN _game,8
	CALL SUBOPT_0x4
	__GETW1MN _game,16
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _sum,12
; 0000 00C3 sum[7]=game[2]+game[4]+game[6];
	__GETW2MN _game,4
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
	__PUTW1MN _sum,14
; 0000 00C4 }
	RET
; .FEND
;
;void main(void)
; 0000 00C7 {
_main:
; .FSTART _main
; 0000 00C8 DDRC=0X0F;             //PORTC For Keypad HIGH Nibble Input,Low Nibble Output
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 00C9 PORTC=0XF0;            //PORTC For Keypad HIGH Nibble Input,Pull-Up Low Nibble Output Zero
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 00CA 
; 0000 00CB DDRE=0xF7;             //PORTD Output
	LDI  R30,LOW(247)
	OUT  0x2,R30
; 0000 00CC 
; 0000 00CD lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00CE 
; 0000 00CF get_started(1);
	CALL SUBOPT_0x8
; 0000 00D0 
; 0000 00D1 Label:
_0x6B:
; 0000 00D2 while(state==0){
_0x6C:
	MOV  R0,R8
	OR   R0,R9
	BREQ PC+2
	RJMP _0x6E
; 0000 00D3     key=get_key();
	CALL SUBOPT_0x9
; 0000 00D4     if(key==11){        //PAUSE
	BRNE _0x6F
; 0000 00D5     j=0;
	LDI  R30,LOW(0)
	STS  _j,R30
	STS  _j+1,R30
; 0000 00D6     while(j==0){
_0x70:
	LDS  R30,_j
	LDS  R31,_j+1
	SBIW R30,0
	BRNE _0x72
; 0000 00D7     key=get_key();
	CALL SUBOPT_0x9
; 0000 00D8     if(key==11)
	BRNE _0x73
; 0000 00D9         j=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _j,R30
	STS  _j+1,R31
; 0000 00DA     }}
_0x73:
	RJMP _0x70
_0x72:
; 0000 00DB 
; 0000 00DC     else if(key==12){   //RESTART
	RJMP _0x74
_0x6F:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x75
; 0000 00DD     get_started(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _get_started
; 0000 00DE     }
; 0000 00DF 
; 0000 00E0     else if(key==13){   //STOP
	RJMP _0x76
_0x75:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x77
; 0000 00E1     get_started(1);
	CALL SUBOPT_0x8
; 0000 00E2     }
; 0000 00E3 
; 0000 00E4     else if(key==14){   //TURN
	RJMP _0x78
_0x77:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x79
; 0000 00E5     f=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _f,R30
	STS  _f+1,R31
; 0000 00E6     }
; 0000 00E7 
; 0000 00E8     else if(key==15){   //GIVE UP
	RJMP _0x7A
_0x79:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x7B
; 0000 00E9         if(player==0)
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x7C
; 0000 00EA             state=-1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x9F
; 0000 00EB         else
_0x7C:
; 0000 00EC             state=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x9F:
	MOVW R8,R30
; 0000 00ED     }
; 0000 00EE 
; 0000 00EF     else if(key==16){   //UNDO
	RJMP _0x7E
_0x7B:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x7F
; 0000 00F0         player=!player;
	MOVW R30,R6
	CALL __LNEGW1
	MOV  R6,R30
	CLR  R7
; 0000 00F1         game[s]=0;
	LDS  R30,_s
	LDS  R31,_s+1
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0000 00F2     }
; 0000 00F3 
; 0000 00F4     if(key<9){
_0x7F:
_0x7E:
_0x7A:
_0x78:
_0x76:
_0x74:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x80
; 0000 00F5         if(game[key]==0){
	MOVW R30,R4
	CALL SUBOPT_0xA
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x81
; 0000 00F6             s=key;
	__PUTWMRN _s,0,4,5
; 0000 00F7             switch (player){
	MOVW R30,R6
; 0000 00F8             case 0:
	SBIW R30,0
	BRNE _0x85
; 0000 00F9             game[key]=1;
	MOVW R30,R4
	CALL SUBOPT_0xA
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xA0
; 0000 00FA             break;
; 0000 00FB 
; 0000 00FC             case 1:
_0x85:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x84
; 0000 00FD             game[key]=-1;
	MOVW R30,R4
	CALL SUBOPT_0xA
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0xA0:
	ST   X+,R30
	ST   X,R31
; 0000 00FE             break;
; 0000 00FF             }
_0x84:
; 0000 0100             count++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0101             player=!player;
	MOVW R30,R6
	CALL __LNEGW1
	MOV  R6,R30
	CLR  R7
; 0000 0102      }   }
_0x81:
; 0000 0103 show();
_0x80:
	RCALL _show
; 0000 0104 
; 0000 0105 winner_check();
	RCALL _winner_check
; 0000 0106 
; 0000 0107 for(i=0;i<8;i++){
	CLR  R12
	CLR  R13
_0x88:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x89
; 0000 0108 if(sum[i]==3)
	CALL SUBOPT_0xB
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8A
; 0000 0109     state=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xA1
; 0000 010A 
; 0000 010B else if(sum[i]==-3)
_0x8A:
	CALL SUBOPT_0xB
	CPI  R30,LOW(0xFFFD)
	LDI  R26,HIGH(0xFFFD)
	CPC  R31,R26
	BRNE _0x8C
; 0000 010C     state=-1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0xA1:
	MOVW R8,R30
; 0000 010D 
; 0000 010E if(count==9 && state==0)
_0x8C:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x8E
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BREQ _0x8F
_0x8E:
	RJMP _0x8D
_0x8F:
; 0000 010F     state=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R8,R30
; 0000 0110 }
_0x8D:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RJMP _0x88
_0x89:
; 0000 0111 
; 0000 0112 lcd_gotoxy(4,3);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _lcd_gotoxy
; 0000 0113 switch (state){
	MOVW R30,R8
; 0000 0114     case -1:
	CPI  R30,LOW(0xFFFFFFFF)
	LDI  R26,HIGH(0xFFFFFFFF)
	CPC  R31,R26
	BRNE _0x93
; 0000 0115     lcd_puts("O WINNER!");
	__POINTW2MN _0x94,0
	RJMP _0xA2
; 0000 0116     break;
; 0000 0117 
; 0000 0118     case 1:
_0x93:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x95
; 0000 0119     lcd_puts("X WINNER!");
	__POINTW2MN _0x94,10
	RJMP _0xA2
; 0000 011A     break;
; 0000 011B 
; 0000 011C     case 2:
_0x95:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x92
; 0000 011D     lcd_puts("Game Over.");
	__POINTW2MN _0x94,20
_0xA2:
	RCALL _lcd_puts
; 0000 011E     break;
; 0000 011F     }
_0x92:
; 0000 0120 }
	RJMP _0x6C
_0x6E:
; 0000 0121 
; 0000 0122 while (1)
_0x97:
; 0000 0123     {
; 0000 0124     key=get_key();
	RCALL _get_key
	MOVW R4,R30
; 0000 0125     if(key==12){
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x9A
; 0000 0126         get_started(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _get_started
; 0000 0127         f=0;
	CALL SUBOPT_0x2
; 0000 0128         goto Label;
	RJMP _0x6B
; 0000 0129     }
; 0000 012A     if(key==13){
_0x9A:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x9B
; 0000 012B         get_started(1);
	CALL SUBOPT_0x8
; 0000 012C         f=0;
	CALL SUBOPT_0x2
; 0000 012D         goto Label;
	RJMP _0x6B
; 0000 012E     }
; 0000 012F     }
_0x9B:
	RJMP _0x97
; 0000 0130 }
_0x9C:
	RJMP _0x9C
; .FEND

	.DSEG
_0x94:
	.BYTE 0x1F
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x3
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x3,R30
	__DELAY_USB 13
	SBI  0x3,2
	__DELAY_USB 13
	CBI  0x3,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xC
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xC
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080001
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x3,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x3,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x2
	ORI  R30,LOW(0xF0)
	OUT  0x2,R30
	SBI  0x2,2
	SBI  0x2,0
	SBI  0x2,1
	CBI  0x3,2
	CBI  0x3,0
	CBI  0x3,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xD
	CALL SUBOPT_0xD
	CALL SUBOPT_0xD
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_game:
	.BYTE 0x12
_sum:
	.BYTE 0x10
_x:
	.BYTE 0x2
_y:
	.BYTE 0x2
_j:
	.BYTE 0x2
_f:
	.BYTE 0x2
_s:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STS  _f,R30
	STS  _f+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	MOVW R30,R12
	LDI  R26,LOW(_game)
	LDI  R27,HIGH(_game)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDS  R26,_game
	LDS  R27,_game+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	__GETW1MN _game,8
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	ADD  R26,R30
	ADC  R27,R31
	__GETW1MN _game,16
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__GETW1MN _game,12
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _get_started

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	CALL _get_key
	MOVW R4,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_game)
	LDI  R27,HIGH(_game)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	MOVW R30,R12
	LDI  R26,LOW(_sum)
	LDI  R27,HIGH(_sum)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LNEGW1:
	OR   R30,R31
	LDI  R30,1
	BREQ __LNEGW1F
	LDI  R30,0
__LNEGW1F:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:
