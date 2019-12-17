#INCLUDE "Eicpo552_AP5.ch"
#include "rwmake.ch"       
#include "avprint.ch"
#include "AVERAGE.CH"

#DEFINE DELMENSAGEM  IF SELECT("WORK_MEN")#0; Work_Men->(E_ERASEARQ(cFileMen));  ENDIF
#DEFINE DATA_ITEM    SUBSTR(DTOC(SW5->W5_DT_EMB),1,2)  + "/" + ;
                     SUBSTR(CMONTH(SW5->W5_DT_EMB),1,3)+ "/" + ;
                     Right(Dtoc(SW5->W5_DT_EMB),2)

#xtranslate   bSETGET(<uVar>)             => {|u| If(PCount() == 0, <uVar>, <uVar> := u) }

#define FIMDATA Work1->(DBGOTO(nRecno1)) ; RETURN .T.

User Function Eicpo552()   
LOCAL oDlg
Local oPanel //LRL 31/03/04

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
  
SetPrvt("OFONT>,OPRINT>,NOLDAREA,TB_CAMPOS,NOPCA,AVALID")
SetPrvt("BVALID,CMARCA,LINVERTE,AHEADER,ACAMPOS")
SetPrvt("ASEMSX3,CNOMARQ,CCADASTRO,CARQF3SW2,CFILEMEN,TPO_NUM")
SetPrvt("AMARCADOS,ATERMOS,LPOBRANCO,CJAEMITIDO,CNAOEMITIDO,CEMITIDO")
SetPrvt("AEMITIDO,ORAD1,NIDIOMA,BOK,BCANCEL")
SetPrvt("BINIT,BWHILE,BFLAG,OMARK,BINIT1")
SetPrvt("NRECNO,NPOS1,NTAM1,CNEWMARCA,CPOMARCADO,NRECNO1")
SetPrvt("DDATAEMB,DDATAENT,NLIN,NCOLS,NCOLG,I")
SetPrvt("CAUX,W,NLINHA2,NLINHA1,AFONTES")
SetPrvt("LINHA,NLINHA,P1,P2,PARTE2,MDESCRI")
SetPrvt("NTOTAL,CALIAS,LRETURN,NCONT,CVAUX1,CVAUX2")
SetPrvt("CVAUX3,CVAUX4,CVAUX5,CVAUX6,CVAUX7,CVAUX8")
SetPrvt("CVAUX9,CVAUX10,CVAUX11,")

#COMMAND E_RESET_AREA => SW5->(DBSETORDER(1)) ;
                       ; Work1->(E_EraseArq(cNomArq))          ;
                       ; FErase(cNomArq+".CDX")                ;
                       ; DBSELECTAREA(nOldArea)

#xtranslate :TIMES_NEW_ROMAN_12            => \[1\]
#xtranslate :COURIER_12                    => \[2\]
#xtranslate :TIMES_NEW_ROMAN_14_BOLD       => \[3\]
#xtranslate :TIMES_NEW_ROMAN_14_UNDERLINE  => \[4\]
#xtranslate :TIMES_NEW_ROMAN_12_UNDERLINE  => \[5\]
#xtranslate :TIMES_NEW_ROMAN_12_BOLD       => \[6\]
#xtranslate :TIMES_NEW_ROMAN_18_BOLD       => \[7\]
#xtranslate :COURIER_12_BOLD               => \[8\]

/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun�ao    � EICPO552 � Autor � VICTOR IOTTI          � Data � 03.12.97 ���
��+----------+------------------------------------------------------------���
���Descri��o � Emiss�o de Instrucao de Embarque /shipping Instructions   ���
��+----------+------------------------------------------------------------���
���Sintaxe   � EICPO552()                                                 ���
��+----------+------------------------------------------------------------���
��� Uso      � SIGAEIC                                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Private _PictPrUn := ALLTRIM(X3Picture("W3_PRECO"))
Private _PictPrTot := ALLTRIM(X3Picture("W2_FOB_TOT"))
Private _PictQtde := ALLTRIM(X3Picture("W3_QTDE"))
Private _PictPO := ALLTRIM(X3Picture("W2_PO_NUM"))

nOldArea:=SELECT()
TB_Campos:={}

nOpcA:=0

aValid:={'PO'}
bValid:= {|| PO552Val("PO") .AND. PO552Val("Emit")}

cMarca := GetMark()
lInverte := .F.

// definir sempre - fim

aHeader := {}

aCampos:={"W3_PO_NUM","W5_PGI_NUM","W5_COD_I","B1_DESC","A2_COD","A2_NREDUZ",;
          "W5_SALDO_Q","W5_DT_EMB","W5_DT_ENTR" }

aSemSX3:={{"WKREC_SW5","N",6,0},;
          {"WKFLAG"   ,"C",2,0}}

cNomArq:=E_CriaTrab(,aSemSX3,"Work1")

DBCREATEINDEX(cNomArq,"W3_PO_NUM+W5_PGI_NUM+W5_COD_I",;
                     {||W3_PO_NUM+W5_PGI_NUM+W5_COD_I} )

AADD(TB_Campos,{"WKFLAG"    ,"","  "})
AADD(TB_Campos,{"W3_PO_NUM" ,"",STR0001}) //"P.O."
AADD(TB_Campos,{"W5_PGI_NUM","",STR0002}) //"P.L.I."
AADD(TB_Campos,{"W5_COD_I"  ,"",STR0003}) //"Cod Item"
AADD(TB_Campos,{"B1_DESC"   ,"",STR0004}) //"Descri��o do Item"
AADD(TB_Campos,{"W5_DT_EMB" ,"",STR0005}) //"Embarque"
AADD(TB_Campos,{"W5_DT_ENTR","",STR0006}) //"Entrega"
AADD(TB_Campos,{"A2_COD"    ,"",STR0007 }) //"Cod For"
AADD(TB_Campos,{"A2_NREDUZ" ,"",STR0008}) //"Fornecedor"
AADD(TB_Campos,{"W5_SALDO_Q","",STR0009,AVSX3("W5_SALDO_Q",6)}) //"Saldo Quantidade"
cCadastro := STR0010 //"Shipping Instructions"

cArqF3SW2:="SW2"
cFileMen:=""

TPO_Num:=SW2->W2_PO_NUM
aMarcados:={}

aTermos := {}
lPOBranco:=.T.

cJaEmitido  := STR0011 //"1-Shipping ja Emitido "
cNaoEmitido := STR0012 //"2-Shipping nao Emitido"
aEmitido    := {cNaoEmitido,cJaEmitido}
cEmitido    := aEmitido[1]  

WHILE .T.
  DEFINE MSDIALOG oDlg TITLE cCadastro From 9, 0 To 20, 40 OF oMainWnd //PIXEL

  @ 16.0,5.0 SAY STR0013 SIZE 32,8 of oDlg Pixel //"Nro. do P.O."
  @ 16.0,40.5 GET TPO_Num F3 cArqF3SW2 PICTURE E_TrocaVP(nIdioma,_PictPO) ;
                                        VALID PO552Val('PO') SIZE 40,8
  
  @ 39,5.0 COMBOBOX cEmitido ITEMS aEmitido SIZE 80,40 of oDlg Pixel
  
  oRad1 := {STR0014,STR0015} //"Ingles   "###"Portugues    "
  @ 16.0 ,95.0 TO 52.0 ,155 TITLE STR0016  //"Idioma"
  @ 25,100.0 RADIO oRad1 VAR nIdioma SIZE 50,10 Pixel Prompt STR0014,STR0015 //"Ingles   "###"Portugues    "
 
  nIdioma:=1
  nOpca  :=0

  DEFINE SBUTTON FROM 65,35  TYPE 1 ACTION (nOpca := 1,If(EVAL(bValid),oDlg:End(),)) ENABLE OF oDlg
  DEFINE SBUTTON FROM 65,80  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
  
  ACTIVATE MSDIALOG oDlg Centered

  
  If nOpca == 0
     DELMENSAGEM
     E_RESET_AREA
     Return .F.
  ENDIF

  IF !EMPTY(TPO_Num)
     lPOBranco :=.F.
     SW5->(DBSETORDER(3))
     SW5->(DBSEEK(xFilial("SW5")+TPO_Num))
     bWhile:={||SW5->W5_FILIAL==xFilial("SW5") .AND. SW5->W5_PO_NUM==TPO_Num }

  ELSE
     lPOBranco:=.T.
     SW5->(DBSETORDER(6))
     SW5->(DBSEEK(xFilial("SW5")+" 0        0.001",.T.))
     bWhile:={||SW5->W5_FILIAL==xFilial("SW5")}
  ENDIF

  bFlag := {||PO552Wk1Grv()}
  Processa({|lEnd|ProcRegua(SW5->(LASTREC())),;
  SW5->(DBEVAL(bFlag,,bWhile))},STR0017) //"Pesquisando Informa��es..."

  nOpca:=0

  IF Work1->(LASTREC()) > 0
     DO WHILE .T.
        oMainWnd:ReadClientCoors()
        DEFINE MSDIALOG oDlg TITLE cCadastro ;
            FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-60,oMainWnd:nRight-10 ;
    	           OF oMainWnd PIXEL  

        IF nOpca #2
           Work1->(DBGOTOP())
        ENDIF
        nOpca:=0
        @ 00,00 MsPanel oPanel Prompt "" Size 60,22 of oDlg //LRL 31/03/04 - Painel para Alinhamento MDI
        @ 05,(oDlg:nClientWidth-84)/2-30 BUTTON STR0018 SIZE 36,13 ACTION (PO552AterData(),oMark:oBrowse:Refresh(),oMark:oBrowse:Reset(),SysRefresh()) OF oPanel PIXEL //"Alterar Datas"
        @ 05,(oDlg:nClientWidth-164)/2-30 BUTTON STR0019     SIZE 36,13 ACTION (IF(PO552Verifica(),(nOpca:=2,oDlg:End()),)) OF oPanel PIXEL //"Mensagens"
        @ 05,(oDlg:nClientWidth-245)/2-30 BUTTON STR0020         SIZE 36,13 ACTION PO552AllMark() OF oPanel PIXEL

        oMark:= MsSelect():New("Work1","WKFLAG",,TB_Campos,@lInverte,@cMarca,{34,1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-4)/2})
        e_markbAval(oMark,{||PO552Mark()})

        DEFINE SBUTTON FROM 05,(oDlg:nClientWidth-4)/2-30 TYPE 6 ACTION (PO552ProcRel()) ENABLE OF oPanel
        oDlg:lMaximized:=.T. //LRL 31/03/04 - Maximiliza Janela na Vers�o Mdi
        ACTIVATE MSDIALOG oDlg ON INIT ;  
                 (EnchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},;
                                  {||nOpca:=0,oDlg:End()}),;
    oPanel:Align:=CONTROL_ALIGN_TOP, oMark:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT) //LRL 31/03/04 -Alinhamento MDI                 
           IF nOpca == 0
              DELMENSAGEM
              E_RESET_AREA
              Return .F.
           ENDIF
           IF nOpca == 2
           PO552ProcMen()
              LOOP
           ENDIF
        EXIT
     ENDDO
  ELSE
     Help("", 1, "AVG0000136")
  ENDIF

  Work1->(__DBZAP())
  aMarcados:={}

ENDDO

*-------------------------------*
Static FUNCTION PO552Val(MFlag)
*-------------------------------*
Do Case
   Case MFlag == 'PO'
        IF cEmitido == cJaEmitido
           IF EMPTY(TPO_Num)
              Help("", 1, "AVG0000120")
              Return .F.
           ENDIF
        ENDIF
        IF EMPTY(TPO_Num)
           Return .T.
        ENDIF
        IF ! SW2->(DBSEEK(xFilial("SW2")+TPO_Num))
           Help("", 1, "AVG0000121")
           Return .F.
        ENDIF
        SW3->(DBSETORDER(1))
        SW3->(DBSEEK(xFilial("SW3")+TPO_Num))
        IF SW3->W3_FLUXO == "5"
           Help("", 1, "AVG0000121")
           Return .F.
        ENDIF
        SW5->(DBSETORDER(3))
        IF !SW5->(DBSEEK(xFilial("SW5")+TPO_Num))
           Help("", 1, "AVG0000137")
           Return .F.
        ENDIF
        SYT->(DBSETORDER(1))
        IF ! SYT->(DBSEEK(xFilial("SYT")+SW2->W2_IMPORT))
           Help("", 1, "AVG0000138")
           RETURN .F.
        ENDIF
        SY6->(DBSETORDER(1))
        IF ! SY6->(DBSEEK(xFilial("SY6")+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0)))
           Help("", 1, "AVG0000139")
           RETURN .F.
        ENDIF
        SY4->(DBSETORDER(1))
        IF ! SY4->(DBSEEK(xFilial("SY4")+SW2->W2_AGENTE))
           Help("", 1, "AVG0000140")
           RETURN .F.
        ENDIF
        SA2->(DBSETORDER(1))
        IF ! SA2->(DBSEEK(xFilial("SA2")+SW2->W2_FORN))
           Help("", 1, "AVG0000141")
           RETURN .F.
        ENDIF
        SY1->(DBSETORDER(1))
        IF ! SY1->(DBSEEK(xFilial("SY1")+SW2->W2_COMPRA))
           Help("", 1, "AVG0000142")
           RETURN .F.
        ENDIF
        
   Case MFlag == "Emit"
        IF Empty(cEmitido)
           Help("", 1, "AVG0000143")
           Return .F.
        EndIf
        
   Case MFlag == "DatEmb"
        IF EMPTY(dDataEmb)
           Help("", 1, "AVG0000144")
           Return .F.
        ENDIF

   Case MFlag == "DatEnt"
        IF EMPTY(dDataEnt)
           Help("", 1, "AVG0000145")
           Return .F.
        ENDIF

        IF dDataEnt < dDataEmb
           Help("", 1, "AVG0000146")
           Return .F.
        ENDIF
   
ENDCASE

Return .T.

*--------------------------*
Static FUNCTION PO552Mark()
*--------------------------*
nRecno:=Work1->(RECNO())
nPos1:=0
nTam1:=0

IF Work1->WKFLAG == cMarca

   IF (nPos1:=ASCAN(aMarcados,{|cRec| cRec[2]==Work1->WKREC_SW5 })) != 0
      nTam1:=LEN(aMarcados)
      ADEL(aMarcados,nPos1)
      ASIZE(aMarcados,(nTam1-1))
      Work1->WKFLAG:=SPACE(02)
   ENDIF

   IF EMPTY(aMarcados)
      DELMENSAGEM
   ENDIF
ELSE
   IF !EMPTY(aMarcados)
      IF ASCAN(aMarcados,{|cPO| cPO[1]==Work1->W3_PO_NUM }) != 0
         AADD(aMarcados,{Work1->W3_PO_NUM,Work1->WKREC_SW5})
         Work1->WKFLAG:=cMarca
      ELSE
         Help("", 1, "AVG0000147")
      ENDIF
   ELSE
      AADD(aMarcados,{Work1->W3_PO_NUM,WKREC_SW5})
      Work1->WKFLAG:=cMarca
   ENDIF
ENDIF

Work1->(DBGOTO(nRecno))

oMark:oBrowse:Refresh()
oMark:oBrowse:Reset()
SysRefresh()

RETURN NIL

*-----------------------------*
Static FUNCTION PO552AllMark()
*-----------------------------*
cNewMarca := ''
cPOMarcado:=Work1->W3_PO_NUM

aMarcados:={}

IF Work1->WKFLAG == cMarca
   cNewMarca:=SPACE(02)
ELSE
   cNewMarca:=cMarca
ENDIF

Work1->(DBGOTOP())

WHILE ! Work1->(EOF())
  IF cPOMarcado == Work1->W3_PO_NUM
     Work1->WKFLAG :=cNewMarca
     IF !EMPTY(cNewMarca)
        AADD(aMarcados,{Work1->W3_PO_NUM,Work1->WKREC_SW5})
     ENDIF
  ELSE
     Work1->WKFLAG :=SPACE(02)
  ENDIF
  Work1->(DBSKIP())
END

IF EMPTY(aMarcados)
   DELMENSAGEM
ENDIF

Work1->(DBSEEK(cPOMarcado))

oMark:oBrowse:Refresh()
oMark:oBrowse:Reset()
SysRefresh()

RETURN NIL

*----------------------------*
Static FUNCTION PO552Wk1Grv()
*----------------------------*

IncProc(STR0036) //"Gravando Informa��es..."

IF !lPOBranco
   IF SW5->W5_SALDO_Q==0
      RETURN NIL
   ENDIF
ENDIF

IF SW5->W5_SEQ <> 0
   RETURN NIL
ENDIF

IF cEmitido==cJaEmitido
   IF EMPTY(SW5->W5_DT_SHIP)
      RETURN NIL
   ENDIF
ENDIF

IF cEmitido==cNaoEmitido
   IF !EMPTY(SW5->W5_DT_SHIP)
      RETURN NIL
   ENDIF
ENDIF

SA2->(DBSEEK(xFilial("SA2")+SW5->W5_FORN))
SB1->(DBSEEK(xFilial("SB1")+SW5->W5_COD_I))

Work1->(DBAPPEND())
Work1->W3_PO_NUM  :=SW5->W5_PO_NUM
Work1->W5_PGI_NUM :=SW5->W5_PGI_NUM
Work1->W5_COD_I   :=SW5->W5_COD_I
Work1->B1_DESC    :=SB1->B1_DESC
Work1->A2_COD     :=SA2->A2_COD
Work1->A2_NREDUZ  :=SA2->A2_NREDUZ
Work1->W5_SALDO_Q :=SW5->W5_SALDO_Q
Work1->W5_DT_EMB  :=SW5->W5_DT_EMB
Work1->W5_DT_ENTR :=SW5->W5_DT_ENTR
Work1->WKREC_SW5  :=SW5->(RECNO())
Work1->WKFLAG     :=SPACE(02)

RETURN NIL
*-------------------------------*
Static FUNCTION PO552AterData()
*-------------------------------*
LOCAL oDlg
nRecno1  := Work1->(RECNO())
cCadastro:= STR0037 //"Altera��o de Datas"

IF EMPTY(aMarcados)
   Help("", 1, "AVG0000127")
   FIMDATA
ENDIF

SW5->(DBGOTO(aMarcados[1][2]))

dDataEmb   := SW5->W5_DT_EMB
dDataEnt   := SW5->W5_DT_ENTR

DO WHILE .T.

   nOpca:= 0

   DEFINE MSDIALOG oDlg TITLE cCadastro From 9,0 To 18,45 OF oMainWnd //OF PIXEL

   nLin:=20.4
   nColS:=5.9
   nColG:=65.5

   nLin := nLin + 1
   @ nLin,nColS SAY STR0039 SIZE 128,8 PIXEL //"Data de Embarque"
   MFLAG := "DatEmb"
   @ nLin,nColG GET dDataEmb VALID PO552Val() SIZE 32,8 PIXEL// Substituido pelo assistente de conversao do AP5 IDE em 24/11/99 ==>    @ nLin,nColG GET dDataEmb VALID Execute(PO552Val) SIZE 32,8

   nLin := nLin + 15
   @ nLin,nColS SAY STR0040 SIZE 128,8 PIXEL //"Data de Entrega"
   MFLAG := "DatEnt"
   @ nLin,nColG GET dDataEnt VALID PO552Val() SIZE 32,8 PIXEL

   ACTIVATE MSDIALOG oDlg ON INIT ;
            EnchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},;
                             {||nOpca:=0,oDlg:End()}) CENTERED

   IF nOpca == 0
      FIMDATA
   ENDIF

   IF MSGYESNO(STR0041,STR0037) #.T. //"CONFIRMA A ALTERA��O DAS DATAS ?"###"ALTERA��O DE DATAS"
      LOOP
   ENDIF

   Processa({|lEnd|PO552GrvDatas()})

   EXIT
ENDDO

oMark:oBrowse:Refresh()
oMark:oBrowse:Reset()
SysRefresh()

FIMDATA

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 24/11/99

*-------------------------------*
Static FUNCTION PO552GrvDatas()
*-------------------------------*
Work1->(DBGOTOP())

ProcRegua(Work1->(LASTREC()))

WHILE ! Work1->(EOF())

   IncProc(STR0042) //"Gravando Datas..."

   IF EMPTY(Work1->WKFLAG)
      Work1->(DBSKIP())
      LOOP
   ENDIF

   SW5->(DBGOTO(Work1->WKREC_SW5))
   SW5->(RecLock("SW5",.F.))
   SW5->W5_DT_EMB    := dDataEmb
   SW5->W5_DT_ENTR   := dDataEnt
   SWB->(MsUNLOCK())
   Work1->W5_DT_EMB  := dDataEmb
   Work1->W5_DT_ENTR := dDataEnt
   Work1->(DBSKIP())

ENDDO

RETURN NIL

*-----------------------------*
Static FUNCTION PO552ProcRel()
*-----------------------------*
nRecno1  := Work1->(RECNO())

IF EMPTY(aMarcados)
   Help("", 1, "AVG0000127")
   RETURN NIL
ENDIF

SW2->(DBSEEK(xFilial("SW2")+aMarcados[1][1]))
SYT->(DBSEEK(xFilial("SYT")+SW2->W2_IMPORT))
SY6->(DBSEEK(xFilial("SY6")+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0)))
SY4->(DBSEEK(xFilial("SY4")+SW2->W2_AGENTE))
SA2->(DBSEEK(xFilial("SA2")+SW2->W2_FORN))
SY1->(DBSEEK(xFilial("SY1")+SW2->W2_COMPRA))

Processa({|lEnd|PO552_REL()},STR0017) //"Pesquisando Informa��es..."

DBSELECTAREA("Work1")
Work1->(DBGOTO(nRecno1))

oMark:oBrowse:Refresh()
oMark:oBrowse:Reset()
SysRefresh()

RETURN NIL

*--------------------------*
Static FUNCTION PO552_REL()
*--------------------------*
LOCAL aIncoterm := {},W
I        := 0
cAux     := ''
W        := 0

ProcRegua(5)

nLinha2:=nLinha1:=0

AVPRINT oPrn NAME STR0043 //"Emiss�o de Instru��o de Embarque / Shipping Instructions"

   DEFINE FONT oFont1  NAME "Times New Roman"    SIZE 0,12                  OF oPrn
   DEFINE FONT oFont2  NAME "Courier"            SIZE 0,12                  OF oPrn
   DEFINE FONT oFont3  NAME "Times New Roman"    SIZE 0,14  BOLD            OF oPrn
   DEFINE FONT oFont4  NAME "Times New Roman"    SIZE 0,14  BOLD UNDERLINE  OF oPrn
   DEFINE FONT oFont5  NAME "Times New Roman"    SIZE 0,12       UNDERLINE  OF oPrn
   DEFINE FONT oFont6  NAME "Times New Roman"    SIZE 0,12  BOLD            OF oPrn
   DEFINE FONT oFont7  NAME "Times New Roman"    SIZE 0,18  BOLD            OF oPrn
   DEFINE FONT oFont8  NAME "Courier"            SIZE 0,12  BOLD            OF oPrn

   aFontes := { oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8 }

   AVPAGE

        Linha:=nLinha
        IncProc(STR0044) //"Imprimindo..."
        PrintCab(oPrn,TPO_Num,oPrn:nPage,@Linha,,"EICPO552")
        nLinha:=Linha

        IF nIdioma==1
           nLinha := nLinha + 190
           oPrn:Say( nLinha, 1230 , "SHIPPING INSTRUCTIONS",;
                     aFontes:TIMES_NEW_ROMAN_18_BOLD,,,,2 )
           nLinha := nLinha + 80
           p1 := "CONCERNING THE ABOVE MENTIONED ORDER, "
           p2 := "PLEASE TAKE THE FOLLOWING INSTRUCTIONS:"
           oPrn:Say( nLinha, 100 , p1 + p2, aFontes:TIMES_NEW_ROMAN_12)
        ELSE
           nLinha := nLinha + 190
           oPrn:Say( nLinha, 1225 , STR0045, aFontes:TIMES_NEW_ROMAN_18_BOLD,,,,2 ) //"INSTRU�iES DE EMBARQUE"
           nLinha := nLinha + 80
           p1 := STR0046 //"CONFORME NOSSO PEDIDO ACIMA MENCIONADO, "
           p2 := STR0047 //"POR FAVOR SIGA AS SEGUINTES INSTRU�iES:"
           oPrn:Say( nLinha, 100 , p1 + p2, aFontes:TIMES_NEW_ROMAN_12 )
        ENDIF
        nLinha := nLinha + 70

        PO552CAB_QUAD()

        IncProc(STR0044) //"Imprimindo..."              
        
        Work1->(DBGOTOP())
        
        DO WHILE ! Work1->(EOF())

           IF EMPTY(Work1->WKFLAG)
              Work1->(DBSKIP())
              LOOP                                                 
           ENDIF

           SW5->(DBGOTO(Work1->WKREC_SW5))
           SB1->(DBSEEK(xFilial("SB1")+SW5->W5_COD_I))
           SA5->(DBSEEK(xFilial("SA5")+SW5->W5_COD_I+SW5->W5_FABR+SW5->W5_FORN))
           SYG->(DBSEEK(xFilial("SYG")+SW2->W2_IMPORT+SW5->W5_FABR+SW5->W5_COD_I))
           SW4->(DBSEEK(xFilial("SW4")+SW5->W5_PGI_NUM))
           IF !EMPTY(SW4->W4_INCOTER) .AND. LEN(aIncoterm) < 3 .AND. ASCAN(aIncoterm,SW4->W4_INCOTER)==0 
           // Pode haver mais de um incoterm por Pedido para certos clientes e, para embarques consolidados
             AADD(aIncoterm , SW4->W4_INCOTER)
           ENDIF  
           Parte2 := 1
           PO552VERFIM()
           mDescri := ''
           mDescri := MSMM(IF(nIdioma==1,SB1->B1_DESC_I,SB1->B1_DESC_P),36)
           STRTRAN(mDescri,CHR(13)+CHR(10)," ")

           IF EMPTY(ALLTRIM(mDescri))
              mDescri:='.'
           ENDIF
           BateTraco(70)

           nLinha := nLinha + 10
           oPrn:Say( nLinha    ,465  ,TRANS(SW5->W5_QTDE,E_TrocaVP(nIdioma,_PictQtde)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
           oPrn:Say( nLinha    ,490  ,memoline(mDescri,25,1),ofont1)
           oPrn:Say( nLinha    ,1680 ,trans(SW5->W5_PRECO,E_TrocaVP(nIdioma,_PictPrUn)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
           oPrn:Say( nLinha    ,2075 ,trans(SW5->W5_QTDE*SW5->W5_PRECO,E_TrocaVP(nIdioma,_PictPrUn)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
           oPrn:Say( nLinha    ,2120 ,DATA_ITEM, aFontes:TIMES_NEW_ROMAN_12)
           
           nLinha := nLinha + 50 
           
           FOR W:=2 TO MLCOUNT(mDescri,25)
               IF ! EMPTY(ALLTRIM(memoline(mDescri,25,W)))
	      						     Parte2 := 3
							           PO552VERFIM()
							           BateTraco()
                  oPrn:Say( nLinha,490  ,memoline(mDescri,25,W), aFontes:TIMES_NEW_ROMAN_12)
																		nLinha := nLinha + 50
               ENDIF
           NEXT
           nLinha := nLinha + 10
           oPrn:Line( nLinha    ,0100 , nLinha , 2320 )
           Work1->(DBSKIP())
        ENDDO

								nLinha := nLinha - 60
        IncProc(STR0044) //"Imprimindo..."
        nLinha2:=nLinha1:=nLINHA
        Parte2 := 1
        PO552VERFIM()
        nLinha := nLinha + 100
        nBoxCol:=1320
        
        oPrn:Say( nLinha     ,nBoxCol,STR0048, aFontes:TIMES_NEW_ROMAN_12) //"TOTAL "
        oPrn:Say( nLinha     ,1815 ,SW2->W2_MOEDA, aFontes:TIMES_NEW_ROMAN_12)
        oPrn:Say( nLinha     ,2270 ,trans(SW2->W2_FOB_TOT,E_TrocaVP(nIdioma,_PictPrTot)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
        nLinha := nLinha + 50 
        
        nBoxLine:=1300
        
        oPrn:Line( nLinha    ,nBoxLine, nLinha, 2320)
        oPrn:Line( nLinha    ,nBoxLine, nLinha, 2321)
        
        nLinha2:=nLINHA
        Parte2 := 1
        PO552VERFIM()
        IF nIdioma==1
           nLinha := nLinha + 20
           oPrn:Say( nLinha ,nBoxCol ,"INLAND CHARGES", aFontes:TIMES_NEW_ROMAN_12)
        ELSE
           nLinha := nLinha + 20
           oPrn:Say( nLinha ,nBoxCol ,STR0049, aFontes:TIMES_NEW_ROMAN_12) //"FRETE INTERNO"
        ENDIF
        oPrn:Say( nLinha ,2270 ,trans(SW2->W2_INLAND,E_TrocaVP(nIdioma,AVSX3("W2_INLAND",6))),aFontes:TIMES_NEW_ROMAN_12,,,,1)
        nLinha := nLinha + 50
        oPrn:Box( nLinha ,nBoxLine, nLinha+1, 2320)
        nLinha2:=nLINHA
        Parte2 := 1
        PO552VERFIM()
        nLinha := nLinha + 20
        IF nIdioma==1
           oPrn:Say( nLinha ,nBoxCol ,"PACKING CHARGES", aFontes:TIMES_NEW_ROMAN_12)
        ELSE
           oPrn:Say( nLinha ,nBoxCol ,STR0050, aFontes:TIMES_NEW_ROMAN_12) //"EMBALAGEM"
        ENDIF
        oPrn:Say( nLinha    ,2270 ,trans(SW2->W2_PACKING,E_TrocaVP(nIdioma,AVSX3("W2_PACKING",6))),aFontes:TIMES_NEW_ROMAN_12,,,,1)
        nLinha := nLinha + 50
        oPrn:Box( nLinha ,nBoxLine, nLinha+1, 2320)
        nLinha2:=nLINHA
        Parte2 := 1
        PO552VERFIM()
        IF nIdioma==1
           nLinha := nLinha + 20
           oPrn:Say( nLinha ,nBoxCol ,"INT'L FREIGHT", aFontes:TIMES_NEW_ROMAN_12)
        ELSE
           nLinha := nLinha + 20
           oPrn:Say( nLinha ,nBoxCol ,STR0051, aFontes:TIMES_NEW_ROMAN_12) //"FRETE INTERNAC."
        ENDIF
        oPrn:Say( nLinha    ,2270 ,trans(SW2->W2_FRETEIN,E_TrocaVP(nIdioma,AVSX3("W2_FRETEIN",6))),aFontes:TIMES_NEW_ROMAN_12,,,,1)
        nLinha := nLinha + 50
        oPrn:Box( nLinha ,nBoxLine, nLinha+1, 2320)
        nLinha2:=nLINHA
        Parte2 := 1
        PO552VERFIM()
        IF nIdioma==1
           nLinha := nLinha + 20
           oPrn:Say( nLinha ,nBoxCol ,"DISCOUNT",aFontes:TIMES_NEW_ROMAN_12)
        ELSE
           nLinha := nLinha + 20
           oPrn:Say( nLinha ,nBoxCol ,STR0052,aFontes:TIMES_NEW_ROMAN_12) //"DESCONTO"
        ENDIF
        oPrn:Say( nLinha    ,2270 ,trans(SW2->W2_DESCONT,E_TrocaVP(nIdioma,AVSX3("W2_DESCONT",6)));
                   ,,,,,1)
        nLinha := nLinha + 50
        oPrn:Box( nLinha , nBoxLine, nLinha+1, 2320)
        nLinha2:=nLINHA
        Parte2 := 1
        PO552VERFIM()
        nLinha := nLinha + 20
        oPrn:Say( nLinha ,nBoxCol ,STR0048+IF(LEN(aIncoterm)==1,aIncoterm[1],SW2->W2_INCOTER),aFontes:TIMES_NEW_ROMAN_12) //"TOTAL "
        oPrn:Say( nLinha ,1815 ,SW2->W2_MOEDA,aFontes:TIMES_NEW_ROMAN_12)
        nTotal := SW2->W2_FOB_TOT+SW2->W2_INLAND+SW2->W2_PACKING+SW2->W2_FRETEIN-SW2->W2_DESCONT

        oPrn:Say( nLinha    ,2270 ,trans(nTotal,E_TrocaVP(nIdioma,_PictPrTot)),aFontes:TIMES_NEW_ROMAN_12,,,,1)

        nLinha := nLinha + 50
        oPrn:Box( nLinha , nBoxLine, nLinha+1, 2320)
        nLinha2:=nLINHA
        
        oPrn:Box(nLinha1, 100 , nLinha2, 101)
        
        oPrn:Box(nLinha1, 2320, nLinha2, 2321)
        oPrn:Box(nLinha1, nBoxLine, nLinha2, nBoxLine+1)
        oPrn:Box(nLinha2, 100 , nLinha2+1, 2320)
        
        IncProc(STR0044) //"Imprimindo..."
        cAlias:=Alias()

        IF SELECT("WORK_MEN") #0
           Work_Men->(DBGOTOP())
           DO WHILE ! Work_Men->(EOF()) .AND. Work_Men->WKORDEM<'zzzzz'
              nLinha := nLinha + 60
              Parte2 := 0
              PO552VERFIM()

              FOR W := 1 TO MLCOUNT(RTRIM(Work_Men->WKOBS),75)
                     Parte2 := 0
                     PO552VERFIM()
                     nLinha := nLinha + 50
                     oPrn:Say( nLinha ,100  ,memoline(RTRIM(Work_Men->WKOBS),75,W),afontes:COURIER_12_BOLD)
              NEXT

              Work_Men->(DBSKIP())
           ENDDO
        ENDIF

        IF ExistBlock("IC195PO1")
           // Rdmake para Klabin
           ExecBlock("IC195PO1",.F.,.F.)
        Else
           Parte2 := 0
           PO552VERFIM()
           nLinha := nLinha + 150
           oPrn:Say( nLinha ,100 ,SY1->Y1_NOME, afontes:COURIER_12)
           Parte2 := 0
           PO552VERFIM()
           nLinha := nLinha + 50
           oPrn:Say( nLinha ,100 ,"IMPORT DEPT.",afontes:COURIER_12)
        EndIf

   AVENDPAGE

AVENDPRINT

oFont1:End()
oFont2:End()
oFont3:End()
oFont4:End()
oFont5:End()
oFont6:End()
oFont7:End()
oFont8:End()

Processa({|lEnd|PO552AtuDatas()},STR0053)

RETURN NIL

*-------------------------------*
Static FUNCTION BateTraco(nAltura)
*-------------------------------*

nAltura := If(nAltura == Nil, 60, nAltura)

oPrn:Line( nLinha    ,0100 , nLinha+nAltura , 0100 )//1
oPrn:Line( nLinha    ,0101 , nLinha+nAltura , 0101 )
 
oPrn:Line( nLinha    ,475  , nLinha+nAltura , 475  )//2
oPrn:Line( nLinha    ,476  , nLinha+nAltura , 476  )
         
oPrn:Line( nLinha    ,1300 , nLinha+nAltura , 1300 )//3
oPrn:Line( nLinha    ,1300 , nLinha+nAltura , 1301 )
           
oPrn:Line( nLinha    ,1710 , nLinha+nAltura , 1710 )//4
oPrn:Line( nLinha    ,1711 , nLinha+nAltura , 1711 )

oPrn:Line( nLinha    ,2090 , nLinha+nAltura , 2090 )//5
oPrn:Line( nLinha    ,2091 , nLinha+nAltura , 2091 )
  
oPrn:Line( nLinha    ,2320 , nLinha+nAltura , 2320 )//6
oPrn:Line( nLinha    ,2321 , nLinha+nAltura , 2321 )

Return Nil
*-------------------------------*
Static FUNCTION PO552AtuDatas()
*-------------------------------*
SW2->(RECLOCK("SW2",.F.))
SW2->W2_DT_SHIP:= dDataBase
SW2->(MSUNLOCK())

Work1->(DBGOTOP())

ProcRegua(Work1->(LASTREC()))

WHILE ! Work1->(EOF())

   IncProc(STR0054) //"Gravando..."

   IF EMPTY(Work1->WKFLAG)
      Work1->(DBSKIP())
      LOOP
   ENDIF

   SW5->(DBGOTO(Work1->WKREC_SW5))
   SW5->(RecLock("SW5",.F.))
   SW5->W5_DT_SHIP := dDataBase
   SWB->(MsUNLOCK())
   Work1->(DBSKIP())

END

RETURN NIL

*-----------------------------*
Static FUNCTION PO552CAB_QUAD()
*-----------------------------*

oPrn:Line( nLinha    ,0100 , nLinha , 2320 )
BateTraco()
   nLinha := nLinha + 10
IF nIdioma==2
   oPrn:Say( nLinha     , 180 ,STR0055, afontes:TIMES_NEW_ROMAN_12) //"QTD."
   oPrn:Say( nLinha     , 640 ,STR0056,afontes:TIMES_NEW_ROMAN_12 ) //"DESCRI��O"
  oPrn:Say( nLinha     , 1480,STR0057,afontes:TIMES_NEW_ROMAN_12 ) //"UNIT "
   oPrn:Say( nLinha     , 1840,STR0048,afontes:TIMES_NEW_ROMAN_12 ) //"TOTAL "
   oPrn:Say( nLinha     , 2140,STR0058,afontes:TIMES_NEW_ROMAN_12 ) //"EMB."
	nLinha := nLinha + 50
	BateTraco()
   oPrn:Say( nLinha  , 1490,SW2->W2_MOEDA,afontes:TIMES_NEW_ROMAN_12 )
   oPrn:Say( nLinha  , 1850,SW2->W2_MOEDA,afontes:TIMES_NEW_ROMAN_12 )
   oPrn:Say( nLinha  , 2135,STR0059,afontes:TIMES_NEW_ROMAN_12 ) //"DATA"
ELSE
   oPrn:Say( nLinha     , 180 ,"QTY.", afontes:TIMES_NEW_ROMAN_12)
   oPrn:Say( nLinha     , 640 ,"DESCRIPTION", afontes:TIMES_NEW_ROMAN_12)
   oPrn:Say( nLinha     , 1480,"UNIT ", afontes:TIMES_NEW_ROMAN_12)
   oPrn:Say( nLinha     , 1840,"TOTAL ", afontes:TIMES_NEW_ROMAN_12)
   oPrn:Say( nLinha     , 2140,"SHIP.", afontes:TIMES_NEW_ROMAN_12)
nLinha := nLinha + 50
			BateTraco()
   oPrn:Say( nLinha  , 1490,SW2->W2_MOEDA, afontes:TIMES_NEW_ROMAN_12)
   oPrn:Say( nLinha  , 1850,SW2->W2_MOEDA, afontes:TIMES_NEW_ROMAN_12)
   oPrn:Say( nLinha  , 2135,"DATE", afontes:TIMES_NEW_ROMAN_12)
ENDIF
nLinha := nLinha + 60
oPrn:Line( nLinha    ,0100 , nLinha , 2320 )
RETURN NIL

*---------------------------*
Static FUNCTION PO552VERFIM()
*---------------------------*
IF nLinha >= 3000

			If PARTE2 == 3
						nLinha := nLinha + 10
						oPrn:Line( nLinha    ,0100 , nLinha , 2320 )
			EndIf
   
   IF PARTE2 > 0
      oPrn:Box(nLinha1, 100 , nLinha2, 101)
      oPrn:Box(nLinha1, 2320, nLinha2, 2321)
      oPrn:Box(nLinha1, 1490, nLinha2, 1491)
      oPrn:Box(nLinha2, 100 , nLinha2+1, 2320)
   ENDIF
   
   AVNEWPAGE

   nLinha:=100
   oPrn:Say( nLinha  , 2120,"Page "+StrZero(oPrn:nPage,3), afontes:TIMES_NEW_ROMAN_12)
   nLinha := 200
   IF PARTE2 > 0
      PO552CAB_QUAD()
   ENDIF
   nLinha2:=nLinha1:=nLINHA
   RETURN .T.
ENDIF
RETURN .F.
*-----------------------------*
Static FUNCTION PO552ProcMen()
*-----------------------------*
nRecno1:= Work1->(RECNO())

IF(nIdioma==1,PO552MENI(),PO552MENP())
Work1->(DBGOTO(nRecno1))

RETURN NIL

*------------------------------*
Static FUNCTION PO552Verifica()
*------------------------------*
lReturn:=.T.

IF EMPTY(aMarcados)
   Help("", 1, "AVG0000127")
   lReturn:=.F.
ENDIF

oMark:oBrowse:Refresh()
oMark:oBrowse:Reset()
SysRefresh()

RETURN lReturn

*--------------------------*
Static FUNCTION PO552MENP()
*--------------------------*
Local nCont
SW2->(DBSEEK(xFilial("SW2")+aMarcados[1][1]))
SY6->(DBSEEK(xFilial("SY6")+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0)))

aTermos:={}
aadd(aTermos,{STR0060,1} ) //"01) SEGURO.........: SERA PROVIDENCIADO POR NOS."

SYT->(DBSETORDER(1))
SYT->(DBSEEK(xFilial("SYT")+SW2->W2_CONSIG))
aadd(aTermos,{STR0061+ALLTRIM(SYT->YT_NOME)+CHR(13)+CHR(10)+; //"02) CONSIGNATARIO..: "
        IF(!EMPTY(SYT->YT_ENDE),spac(21)+ALLTRIM(SYT->YT_ENDE)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_CIDADE)),spac(21)+ALLTRIM(SYT->YT_CIDADE)+"-","")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_ESTADO)),ALLTRIM(SYT->YT_ESTADO)+"-","")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_PAIS)),ALLTRIM(SYT->YT_PAIS)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_CEP)),spac(21)+TRANS(SYT->YT_CEP,'@R 99.999-99'),""),2} ) // 2

SYT->(DBSEEK(xFilial("SYT")+SW2->W2_IMPORT))
aadd(aTermos,{STR0062+SYT->YT_NOME,3}) //"03) LABEL PARA EMBARQUE.: "

aadd(aTermos,{STR0063+CHR(13)+CHR(10),4} ) //"04) LICENCA DE IMPORTACAO...:"

SW5->(DBSETORDER(3))
cAux:=''
IF ! SW5->(DBSEEK(xFilial("SW5")+SW2->W2_PO_NUM))
   aTermos[4,1] := aTermos[4,1] +STR0064+CHR(13)+CHR(10) //"    NUMERO..................: NAO REQUERIDO"
ELSE
   DO WHILE ! SW5->(EOF()) .AND. SW5->W5_FILIAL==xFilial("SW5") .AND. SW5->W5_PO_NUM==TPO_Num
      IF LEFT(SW5->W5_PGI_NUM,1)#'*' .AND. SW5->W5_PGI_NUM $ cAux
         IF ! EMPTY(cAux)
            cAux:=cAux+' / '
         ENDIF
         cAux := cAux + SW5->W5_PGI_NUM
      ENDIF
      SW5->(DBSKIP())
   ENDDO
   IF EMPTY(cAux)
      aTermos[4,1] := aTermos[4,1]+STR0064+CHR(13)+CHR(10) //"    NUMERO..................: NAO REQUERIDO"
   ELSE
      aTermos[4,1] := aTermos[4,1]+STR0065 //"    NUMERO..................: "

      FOR nCont:=1 TO MLCOUNT(cAux,30)+1
          IF ! EMPTY(ALLTRIM(MEMOLINE(cAux,30,nCont)))
             IF nCont #1
                aTermos[4,1] := aTermos[4,1] + SPAC(27)
             ENDIF
             aTermos[4,1] := aTermos[4,1] + MEMOLINE(cAux,30,nCont)+CHR(13)+CHR(10)
          ENDIF
      NEXT
   ENDIF
ENDIF
SW5->(DBSETORDER(1))
aTermos[4,1] := aTermos[4,1] + STR0066 +CHR(13)+CHR(10) //"    EMISSAO.................: "

aTermos[4,1] := aTermos[4,1] + STR0067 +CHR(13)+CHR(10) //"    VALIDADE................: "

aTermos[4,1] := aTermos[4,1] + STR0068+SW2->W2_INCOTER+STR0069+SW2->W2_MOEDA+" "+; //"    TOTAL "###" VALOR....: "
                ALLTRIM(TRANS((SW2->W2_FOB_TOT+SW2->W2_INLAND+SW2->W2_PACKING+;
                SW2->W2_FRETEIN-SW2->W2_DESCONT),E_TrocaVP(nIdioma,_PictPrTot))) // 4


cAux:=''
cAux :=MSMM(SY6->Y6_DESC_P,48)
STRTRAN(cAux,CHR(13)+CHR(10)," ")

aadd(aTermos,{STR0070,5} ) //"05) TERMOS DE PAGAMENTO.....: "
FOR nCont:=1 TO MLCOUNT(cAux,30)+1
    IF ! EMPTY(ALLTRIM(MEMOLINE(cAux,30,nCont)))
       IF nCont #1
          aTermos[5,1] := aTermos[5,1] + SPAC(30)
       ENDIF
       aTermos[5,1] := aTermos[5,1] + MEMOLINE(cAux,30,nCont)+CHR(13)+CHR(10)
    ENDIF
NEXT

aadd(aTermos,{STR0071,6} ) //"06) CONDICOES DE EMBARQUE...: "
aadd(aTermos,{STR0072+CHR(13)+CHR(10)+; //"6.1.) ARRUMACAO DE CONTAINERS "
              STR0073,7} ) //"PARA MERCADORIAS ESTUFADAS EM CONTAINERS, USE SOMENTE 'HOUSE TO PEER'"

SY4->(DBSETORDER(1))
SY4->(DBSEEK(xFilial("SY4")+SW2->W2_FORWARD))
cVAux1 := IF(!EMPTY(SY4->Y4_END),spac(30)+ALLTRIM(SY4->Y4_END)+CHR(13)+CHR(10),"")
cVAux2 := IF(!EMPTY(ALLTRIM(SY4->Y4_BAIRRO)),spac(30)+ALLTRIM(SY4->Y4_BAIRRO)+"-","")
cVAux3 := IF(!EMPTY(ALLTRIM(SY4->Y4_CIDADE)),ALLTRIM(SY4->Y4_CIDADE)+"-","")
cVAux4 := IF(!EMPTY(ALLTRIM(SY4->Y4_ESTADO)),ALLTRIM(SY4->Y4_ESTADO)+CHR(13)+CHR(10),"")
cVAux5 := IF(!EMPTY(ALLTRIM(SY4->Y4_CEP)),spac(30)+TRANS(SY4->Y4_CEP,'@R 99.999-99')+CHR(13)+CHR(10),"")
cVAux6 := IF(!EMPTY(ALLTRIM(SY4->Y4_FONE)),spac(30)+SY4->Y4_FONE,"")

aadd(aTermos,{STR0074+ALLTRIM(SY4->Y4_NOME)+CHR(13)+CHR(10)+; //"FRETE SERA PROVIDENCIADO POR: "
     cVAux1 + cVAux2 + cVAux3 + cVAux4 + cVAux5 + cVAux6,8} )

cVAux1 := STR0075+CHR(13)+CHR(10) //"      ( ) MARITIMO - EMBARQUE DEVERA SER EFETUADO EM NAVIO DE BANDEIRA"
cVAux2 := STR0076+CHR(13)+CHR(10) //"          BRASILEIRA COM B/L EMITIDO POR UM AGENTE BRASILEIRO."
cVAux3 := STR0077+CHR(13)+CHR(10) //"          EM CASO DE FALTA DE ESPACO, SERA NECESSARIO O MANIFESTO DE "
cVAux4 := STR0078+CHR(13)+CHR(10) //"          CARGA EMITIDO PELO -DEPARTAMENTO NACIONAL DE TRANSPORTES "
cVAux5 := STR0079+CHR(13)+CHR(10) //"          AQUAVIARIOS COMMAM - COORDENACAO GERAL DA MARINHA MERCANTE "
cVAux6 := STR0080+CHR(13)+CHR(10) //"          BRASIL TELEX: 021-38859 / 30150 - FAX: 021 - 252-3254."
cVAux7 := STR0081+CHR(13)+CHR(10) //"      ( ) MARITIMO - QUALQUER BANDEIRA."
cVAux8 := STR0082+CHR(13)+CHR(10) //"      ( ) RODOVIARIO"
cVAux9 := STR0083 //"      ( ) FERROVIARIO"


aadd(aTermos,{STR0084+CHR(13)+CHR(10)+; //"6.2.) ( ) AEREO, COM QUALQUER BANDEIRA;"
     cVAux1 + cVAux2 + cVAux3 + cVAux4 + cVAux5 + cVAux6 + cVAux7 + cVAux8 +;
     cVaux9, 9})

SY9->(DBSETORDER(1))
SY9->(DBSEEK(xFilial("SY9")+SW2->W2_DEST))
aadd(aTermos,{STR0085+SW2->W2_DEST+" "+SY9->Y9_DESCR+CHR(13)+CHR(10)+; //"6.3.) DESTINO FINAL.......:"
             STR0086+CHR(13)+CHR(10)+; //"      EMBARQUE PARCIAL....: (  ) PERMITIDO   (  ) NAO PERMITIDO"
             STR0087,10}) //"      TRANSBORDO..........: (  ) PERMITIDO   (  ) NAO PERMITIDO"

IF GetMv("MV_ID_EMPR") == 'S'
   aadd(aTermos,{STR0088+ALLTRIM(SM0->M0_NOME)+CHR(13)+CHR(10)+; //"NOSSO ESCRITORIO: "
        IF(!EMPTY(SM0->M0_ENDCOB),spac(18)+ALLTRIM(SM0->M0_ENDCOB)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SM0->M0_CIDCOB)),spac(18)+ALLTRIM(SM0->M0_CIDCOB)+"-","")+;
        IF(!EMPTY(ALLTRIM(SM0->M0_ESTCOB)),ALLTRIM(SM0->M0_ESTCOB)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SM0->M0_CEPCOB)),spac(18)+TRANS(SM0->M0_CEPCOB,'@R 99.999-99')+CHR(13)+CHR(10),""),11} )
ELSE
   aadd(aTermos,{STR0088+ALLTRIM(SYT->YT_NOME)+CHR(13)+CHR(10)+; //"NOSSO ESCRITORIO: "
        IF(!EMPTY(SYT->YT_ENDE),spac(18)+ALLTRIM(SYT->YT_ENDE)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_CIDADE)),spac(18)+ALLTRIM(SYT->YT_CIDADE)+"-","")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_ESTADO)),ALLTRIM(SYT->YT_ESTADO)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_CEP)),spac(18)+TRANS(SYT->YT_CEP,'@R 99.999-99')+CHR(13)+CHR(10),""),11} )
ENDIF

aadd(aTermos,{STR0089,12}) //"NOSSO BANCO: "

If ExistBlock("EICPPO01")
   ExecBlock("EICPPO01",.F.,.F.,"P")
Endif

AV_ESC_OBS('8',aTermos)
RETURN NIL

*-------------------------*
Static FUNCTION PO552MENI()
*-------------------------*
Local nCont
IF EMPTY(aMarcados)
   Help("", 1, "AVG0000127")
   RETURN NIL
ENDIF

SW2->(DBSEEK(xFilial("SW2")+aMarcados[1][1]))
SY6->(DBSEEK(xFilial("SY6")+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0)))

aTermos:={}
aadd(aTermos,{STR0090,1} ) //"01) INSURANCE......: TO BE COVERED BY US."

SYT->(DBSETORDER(1))
SYT->(DBSEEK(xFilial("SYT")+SW2->W2_CONSIG))
aadd(aTermos,{STR0091+ALLTRIM(SYT->YT_NOME)+CHR(13)+CHR(10)+; //"02) CONSIGNEE......: "
        IF(!EMPTY(SYT->YT_ENDE),spac(21)+ALLTRIM(SYT->YT_ENDE)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_CIDADE)),spac(21)+ALLTRIM(SYT->YT_CIDADE)+"-","")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_ESTADO)),ALLTRIM(SYT->YT_ESTADO)+"-","")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_PAIS)),ALLTRIM(SYT->YT_PAIS)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_CEP)),spac(21)+TRANS(SYT->YT_CEP,'@R 99.999-99'),""),2} ) // 2

SYT->(DBSEEK(xFilial("SYT")+SW2->W2_IMPORT))
aadd(aTermos,{STR0092+SYT->YT_NOME,3}) //"03) SHIPPING MARKS.: "

aadd(aTermos,{STR0093+CHR(13)+CHR(10),4} ) //"04) IMPORT-LICENCE'S DETAILS:"

SW5->(DBSETORDER(3))
cAux:=''
IF ! SW5->(DBSEEK(xFilial("SW5")+SW2->W2_PO_NUM))
   aTermos[4,1] := aTermos[4,1] + STR0094+CHR(13)+CHR(10) //"    IMPORT LICENCE..........: Not Requerid"
ELSE
   DO WHILE ! SW5->(EOF()) .AND. SW5->W5_FILIAL==xFilial("SW5") .AND. SW5->W5_PO_NUM==TPO_Num
      IF LEFT(SW5->W5_PGI_NUM,1)#'*' .AND. SW5->W5_PGI_NUM $ cAux
         IF ! EMPTY(cAux)
            cAux := cAux + ' / '
         ENDIF
         cAux := cAux + SW5->W5_PGI_NUM
      ENDIF
      SW5->(DBSKIP())
   ENDDO
   IF EMPTY(cAux)
      aTermos[4,1] := aTermos[4,1] + STR0094+CHR(13)+CHR(10) //"    IMPORT LICENCE..........: Not Requerid"
   ELSE
      aTermos[4,1] := aTermos[4,1] + STR0095 //"    IMPORT LICENCE..........: "
      FOR nCont:=1 TO MLCOUNT(cAux,30)+1
          IF ! EMPTY(ALLTRIM(MEMOLINE(cAux,30,nCont)))
             IF nCont #1
                aTermos[4,1] := aTermos[4,1] + SPAC(27)
             ENDIF
             aTermos[4,1] := aTermos[4,1] + MEMOLINE(cAux,30,nCont)+CHR(13)+CHR(10)
          ENDIF
      NEXT
   ENDIF
ENDIF
SW5->(DBSETORDER(1))

aTermos[4,1] := aTermos[4,1] + STR0096 +CHR(13)+CHR(10) //"    ISSUED ON...............: "
aTermos[4,1] := aTermos[4,1] + STR0097 +CHR(13)+CHR(10) //"    VALID FOR SHIPMENT TILL.: "
aTermos[4,1] := aTermos[4,1] + STR0068+SW2->W2_INCOTER+STR0098+SW2->W2_MOEDA+" "+; //"    TOTAL "###" VALUE....: "
                ALLTRIM(TRANS((SW2->W2_FOB_TOT+SW2->W2_INLAND+SW2->W2_PACKING+SW2->W2_FRETEIN-SW2->W2_DESCONT),;
                E_TrocaVP(nIdioma,_PictPrTot))) // 4

cAux:=''
cAux :=MSMM(SY6->Y6_DESC_I,48)
STRTRAN(cAux,CHR(13)+CHR(10)," ")

aadd(aTermos,{STR0099,5} ) //"05) PAYMENT TERMS...........: "
FOR nCont:=1 TO MLCOUNT(cAux,30)+1
    IF ! EMPTY(ALLTRIM(MEMOLINE(cAux,30,nCont)))
       IF nCont #1
          aTermos[5,1] := aTermos[5,1] + SPAC(30)
       ENDIF
       aTermos[5,1] := aTermos[5,1] + MEMOLINE(cAux,30,nCont)+CHR(13)+CHR(10)
    ENDIF
NEXT

aadd(aTermos,{STR0100,6} ) //"06) SHIPPING CONDITIONS.....: "
aadd(aTermos,{STR0101+CHR(13)+CHR(10)+; //"6.1.) BOOKING OF CONTAINER / SPACE TO BE ARRANGED: "
              STR0102,7} ) //"FOR GOODS STUFFED IN CONTAINER, ONLY USE HOUSE TO PIER."

SY4->(DBSETORDER(1))
SY4->(DBSEEK(xFilial("SY4")+SW2->W2_FORWARD))

cVAux1 := IF(!EMPTY(SY4->Y4_END),spac(27)+ALLTRIM(SY4->Y4_END)+CHR(13)+CHR(10),"")
cVAux2 := IF(!EMPTY(ALLTRIM(SY4->Y4_BAIRRO)),spac(27)+ALLTRIM(SY4->Y4_BAIRRO)+"-","")
cVAux3 := IF(!EMPTY(ALLTRIM(SY4->Y4_CIDADE)),ALLTRIM(SY4->Y4_CIDADE)+"-","")
cVAux4 := IF(!EMPTY(ALLTRIM(SY4->Y4_ESTADO)),ALLTRIM(SY4->Y4_ESTADO)+CHR(13)+CHR(10),"")
cVAux5 := IF(!EMPTY(ALLTRIM(SY4->Y4_CEP)),spac(27)+TRANS(SY4->Y4_CEP,'@R 99.999-99')+CHR(13)+CHR(10),"")
cVAux6 := IF(!EMPTY(ALLTRIM(SY4->Y4_FONE)),spac(27)+SY4->Y4_FONE,"")

aadd(aTermos,{STR0103+ALLTRIM(SY4->Y4_NOME)+CHR(13)+CHR(10)+; //"FREIGHT TO BE PROVIDED BY: "
     cVAux1 + cVAux2 + cVAux3 + cVAux4 + cVAux5 + cVAux6,8} )

cVAux1 := STR0104+CHR(13)+CHR(10) //"      ( ) BY SEAFREIGHT - SHIPMENT MUST BE EFFECTED UNDER A BRAZILIAN"
cVAux2 := STR0105+CHR(13)+CHR(10) //"          FLAG VESSEL WITH BILL OF LADING ISSUED BY A BRAZILIAN AGENT"
cVAux3 := STR0106+CHR(13)+CHR(10) //"          IN CASE THERE IS NO SPACE AVALAIBLE, A 'CARGO WAIVER' MUST "
cVAux4 := STR0107+CHR(13)+CHR(10) //"          BE REQUIRED, WHICH WILL BE ISSUED BY THE DNTA -DEPARTAMENTO"
cVAux5 := STR0108+CHR(13)+CHR(10) //"          NACIONAL DE TRANSPORTES AQUAVIARIOS COMMAM - COORDENACAO "
cVAux6 := STR0109+CHR(13)+CHR(10) //"          GERAL DA MARINHA MERCANTE ADDRESS: AV. RIO BRANCO, 103 - "
cVAux7 := STR0110+CHR(13)+CHR(10) //"          8o ANDAR - RIO DE JANEIRO - BRASIL TELEX: 021-38859 / 30150"
cVAux8 := STR0111+CHR(13)+CHR(10) //"          - FAX: 021 - 252-3254."
cVAux9 := STR0112+CHR(13)+CHR(10) //"      ( ) BY SEAFREIGHT - ANY FLAG WILL BE ACCEPTED."
cVAux10 :=STR0113+CHR(13)+CHR(10) //"      ( ) BY TRUCK"
cVAux11 :=STR0114 //"      ( ) BY TRAIN"

aadd(aTermos,{STR0115+CHR(13)+CHR(10)+; //"6.2.) ( ) BY AIRFREIGHT, ANY FLAG WILL BE ACCEPTED;"
     cVAux1 + cVAux2 + cVAux3 + cVAux4 + cVAux5 + cVAux6 + cVAux7 + cVAux8 + cVAux9+;
     cVAux10 + cVAux11, 9})

SY9->(DBSETORDER(1))
SY9->(DBSEEK(xFilial("SY9")+SW2->W2_DEST))
aadd(aTermos,{STR0116+SW2->W2_DEST+" "+SY9->Y9_DESCR+CHR(13)+CHR(10)+; //"6.3.) FINAL DESTINATION:"
             STR0117+CHR(13)+CHR(10)+; //"      PARTIAL SHIPMENT....: (  ) ALLOWED   (  ) NOT ALLOWED"
             STR0118,10}) //"      TRANSHIPMENT........: (  ) ALLOWED   (  ) NOT ALLOWED"

IF GetMv("MV_ID_EMPR") == 'S'
   aadd(aTermos,{STR0119+ALLTRIM(SM0->M0_NOME)+CHR(13)+CHR(10)+; //"OUR OFFICE: "
        IF(!EMPTY(SM0->M0_ENDCOB),spac(12)+ALLTRIM(SM0->M0_ENDCOB)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SM0->M0_CIDCOB)),spac(12)+ALLTRIM(SM0->M0_CIDCOB)+"-","")+;
        IF(!EMPTY(ALLTRIM(SM0->M0_ESTCOB)),ALLTRIM(SM0->M0_ESTCOB)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SM0->M0_CEPCOB)),spac(12)+TRANS(SM0->M0_CEPCOB,'@R 99.999-99')+CHR(13)+CHR(10),""),11} )
ELSE
   aadd(aTermos,{STR0119+ALLTRIM(SYT->YT_NOME)+CHR(13)+CHR(10)+; //"OUR OFFICE: "
        IF(!EMPTY(SYT->YT_ENDE),spac(12)+ALLTRIM(SYT->YT_ENDE)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_CIDADE)),spac(12)+ALLTRIM(SYT->YT_CIDADE)+"-","")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_ESTADO)),ALLTRIM(SYT->YT_ESTADO)+CHR(13)+CHR(10),"")+;
        IF(!EMPTY(ALLTRIM(SYT->YT_CEP)),spac(12)+TRANS(SYT->YT_CEP,'@R 99.999-99')+CHR(13)+CHR(10),""),11} )
ENDIF

aadd(aTermos,{STR0120,12}) //"OUR BANK: "

If ExistBlock("EICPPO01")
   ExecBlock("EICPPO01",.F.,.F.,"I")
Endif

AV_ESC_OBS('8',aTermos)
RETURN NIL

