#INCLUDE "RWMAKE.CH"
#include 'fivewin.ch'
#include 'topconn.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ recibpre ³ Autor ³ Agamenon Caldas       ³ Data ³ 08/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DOS RECIBOS    EM LASER                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Mauricea Alimentos                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                          


User Function RECIBPRE()

LOCAL   aCampos := {{"E1_NOMCLI","Cliente","@!"},{"E1_PREFIXO","Prefixo","@!"},{"E1_NUM","Titulo","@!"},;
{"E1_PARCELA","Parcela","@!"},{"E1_VALOR","Valor","@E 9,999,999.99"},{"E1_VENCTO","Vencimento"}}

LOCAL aMarked := {}
PRIVATE Exec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
lEnd     := .F.

dbSelectArea("SM0")
cCodFil := M0_CODFIL

dbSelectArea("SE1")

cPerg     := "BOLETO" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// ValidPerg()

If ( ! Pergunte(cPerg,.T.) )
   Return
Else

   cIndexName := Criatrab(Nil,.F.)
   cIndexKey  :=  "E1_PREFIXO+E1_NUM+E1_PARCELA"
   cFilter    :=  "E1_PREFIXO = '" + MV_PAR03 + "' .And. " + ;
   "E1_NUM     >= '" + MV_PAR01 + "' .And. E1_NUM     <= '" + MV_PAR02 + "' .And. " + ;
   "E1_FILIAL   = '"+xFilial()+"' .And. E1_SALDO > 0 .And. " + ;
   "SubsTring(E1_TIPO,3,1) != '-' "
   IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
   DbSelectArea("SE1")
   #IFNDEF TOP
      DbSetIndex(cIndexName + OrdBagExt())
   #ENDIF
   dbGoTop()


   If MV_PAR08 == 1
      @ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
      @ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
      @ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
      @ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
      ACTIVATE DIALOG oDlg CENTERED

      dbGoTop()
      Do While !Eof()
         If Marked("E1_OK")
            
            _lEncnota := .F.

            dbSelectArea("SF2")
            dbSetOrder(1)
            dbSeek(xFilial("SF2")+SE1->E1_NUM)
            IF .NOT. EOF()
               _lEncnota := .T.   
            ENDIF
            DbSelectArea("SE1")

*** FA€O ALGUNS TESTES NO REGISTRO PARA ANALISAR SE: 1- Jµ FOI GERADO ANTERIORMENTE
*** 2- SE COBRAN€A ERA DIFERENTE 

            DO CASE
            CASE _lEncnota == .T. .AND. SF2->F2_TIPCOB <> "2" .AND. SF2->F2_TIPCOB <> " " 
               ALERT("Nota: "+SF2->F2_DOC+" Cobranca nao e Tipo -> 2 (Carteira) e Sim Tipo -> "+SF2->F2_TIPCOB)
               AADD(aMarked,.F.)            
            CASE LEN(ALLTRIM(E1_PORTADOR)) > 0 .AND. E1_PORTADOR <> MV_PAR04 
               IF MsgBox("Titulo "+E1_NUM+"-"+E1_PREFIXO + " Anteriormente Gerado Para Portador -> "+E1_PORTADOR + CHR(13) +;
                     "Refaz Recibo ??","Escolha","YESNO")
                  AADD(aMarked,.T.)
               ELSE
                  AADD(aMarked,.F.)            
               ENDIF
            CASE LEN(ALLTRIM(E1_PORTADOR)) > 0 .AND. E1_PORTADOR == MV_PAR04 
               IF MsgBox("Titulo "+E1_NUM+"-"+E1_PREFIXO + " Ja' Foi Gerado Anteriormente, N.Numero -> "+E1_NUMBCO + CHR(13) +;
                     "Refaz Recibo ??","Escolha","YESNO")
                  AADD(aMarked,.T.)
               ELSE
                  AADD(aMarked,.F.)            
               ENDIF
            CASE LEN(ALLTRIM(E1_NUMBCO)) > 0 
               IF MsgBox("Titulo "+E1_NUM+"-"+E1_PREFIXO + " E' DE COBRANCA BANCARIA, N.Numero -> "+E1_NUMBCO + CHR(13) +;
                     "EMITE RECIBO ??","Escolha","YESNO")
                  AADD(aMarked,.T.)
               ELSE
                  AADD(aMarked,.F.)            
               ENDIF
            OTHERWISE
               AADD(aMarked,.T.)         
            ENDCASE
         Else
            AADD(aMarked,.F.)
         EndIf
         dbSkip()
      EndDo
   ELSE
      dbGoTop()
      Do While !Eof()

         _lEncnota := .F.

         dbSelectArea("SF2")
         dbSetOrder(1)
         dbSeek(xFilial("SF2")+SE1->E1_NUM)
         IF .NOT. EOF()
            _lEncnota := .T.   
         ENDIF
         DbSelectArea("SE1")

*** FA€O ALGUNS TESTES NO REGISTRO PARA ANALISAR SE: 1- Jµ FOI GERADO ANTERIORMENTE
*** 2- SE COBRAN€A ERA DIFERENTE 

         DO CASE
         CASE _lEncnota == .T. .AND. SF2->F2_TIPCOB <> "2" .AND. SF2->F2_TIPCOB <> " " 
            ALERT("Nota: "+SF2->F2_DOC+" Cobranca nao e Tipo -> 2 (Carteira) e Sim Tipo -> "+SF2->F2_TIPCOB)
            AADD(aMarked,.F.)            
         CASE LEN(ALLTRIM(E1_PORTADOR)) > 0 .AND. E1_PORTADOR <> MV_PAR04 
            IF MsgBox("Titulo "+E1_NUM+"-"+E1_PREFIXO + " Anteriormente Gerado Para Portador -> "+E1_PORTADOR + CHR(13) +;
                  "Refaz Recibo ??","Escolha","YESNO")
               AADD(aMarked,.T.)
               Exec := .T.
            ELSE
               AADD(aMarked,.F.)            
            ENDIF
         CASE LEN(ALLTRIM(E1_PORTADOR)) > 0 .AND. E1_PORTADOR == MV_PAR04 
            IF MsgBox("Titulo "+E1_NUM+"-"+E1_PREFIXO + " Ja' Foi Gerado Anteriormente, N.Numero -> "+E1_NUMBCO + CHR(13) +;
                  "Refaz Recibo ??","Escolha","YESNO")
               AADD(aMarked,.T.)
               Exec := .T.
            ELSE
               AADD(aMarked,.F.)            
            ENDIF
         CASE LEN(ALLTRIM(E1_NUMBCO)) > 0 
            IF MsgBox("Titulo "+E1_NUM+"-"+E1_PREFIXO + " E' DE COBRANCA BANCARIA, N.Numero -> "+E1_NUMBCO + CHR(13) +;
                  "EMITE RECIBO ??","Escolha","YESNO")
               AADD(aMarked,.T.)
               Exec := .T.
            ELSE
               AADD(aMarked,.F.)            
            ENDIF
         OTHERWISE
            AADD(aMarked,.T.)         
            Exec := .T.
         ENDCASE

         dbSkip()
      EndDo   
   ENDIF

   dbGoTop()

   If Exec
      RptStatus({ |lend| MontaRel(aMarked) })
   Endif

   RetIndex("SE1")
   fErase(cIndexName+OrdBagExt())

endif   

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  RBOL001 ³ Autor ³ Agamenon Caldas       ³ Data ³ 08/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DOS RECIBOS DE VENDA MERCANTIL                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel(aMarked)

LOCAL oPrint
LOCAL n := 0
LOCAL aDadosEmp
LOCAL aDadosTit
LOCAL aDatSacado
LOCAL i         := 1
LOCAL nRec      := 0
LOCAL _nVlrAbat := 0
LOCAL _nTotEnc  := 0
Local nVlAtraso := 0

DO CASE
CASE LEN(ALLTRIM(SM0->M0_INSC)) == 8
   _Cie := Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"-"+Subs(SM0->M0_INSC,7,2)
CASE LEN(ALLTRIM(SM0->M0_INSC)) == 9
   _Cie := Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+Subs(SM0->M0_INSC,7,3)
CASE LEN(ALLTRIM(SM0->M0_INSC)) == 12
   _Cie := Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)+"."+Subs(SM0->M0_INSC,10,3)
CASE LEN(ALLTRIM(SM0->M0_INSC)) == 14
   _Cie := Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)+"."+Subs(SM0->M0_INSC,10,3)+"-"+Subs(SM0->M0_INSC,13,2)
OTHERWISE
   _Cie := Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)
ENDCASE

aDadosEmp    := {SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                                            ,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
"IE: "+_Cie }  //[7]I.E


oPrint:= TMSPrinter():New( "Duplicata Mercantil" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página
oPrint:SetpaperSize(9) // <==== AJUSTE PARA PAPEL a4

dbGoTop()
Do While !EOF()

   nRec := nRec + 1

   If aMarked[nRec]
      n := n + 1
   endif
   dbSkip()

EndDo

IF n == 0
   oPrint:End()     // Finaliza Objeto
   ms_flush() // desativar impressora
   Return nil
ENDIF

dbGoTop()
ProcRegua(nRec)
Do While !EOF()

   //Posiciona o SA6 (Bancos)
   DbSelectArea("SA6")
   DbSetOrder(1)
   DbSeek(xFilial("SA6")+MV_PAR04+MV_PAR05+MV_PAR06,.T.)
   IF EOF()
      MsgBox ("Banco+Agencia+conta -> "+MV_PAR04+"-"+MV_PAR05+"-"+MV_PAR06+" Nao Encontrado!","Confirmando!","INFO")
      EXIT   
   ENDIF

   //Posiciona o SA1 (Cliente)
   DbSelectArea("SA1")
   DbSetOrder(1)
   DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
   
   DbSelectArea("SE1")
   
   aDatSacado   := {SUBSTR(SA1->A1_NOME,1,40)                           ,;      // [1]Razão Social
   AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA           ,;      // [2]Código
   Iif(Len(AllTrim(SA1->A1_ENDCOB))<5,AllTrim(SA1->A1_END) + " " + AllTrim(SA1->A1_BAIRRO),AllTrim(SA1->A1_ENDCOB)) ,;      // [3]Endereço
   AllTrim(SA1->A1_MUN )                            ,;      // [4]Cidade
   SA1->A1_EST                                      ,;      // [5]Estado
   SA1->A1_CEP                                      ,;      // [6]CEP
   SA1->A1_CGC                                      ,;      // [7]CGC
   SA1->A1_TEL                              }      // [8]FONE
   
   _nTotEnc :=    SE1->(E1_IRRF+E1_INSS+E1_PIS+E1_COFINS+E1_CSLL)
   _nVlrAbat   :=    _nTotEnc
   
   aDadosTit    := {" "+AllTrim(E1_NUM)+" "+AllTrim(E1_PARCELA)            ,;  // [1] Número do título
   E1_EMISSAO                                            ,;  // [2] Data da emissão do título
   Date()                                                ,;  // [3] Data da emissão do boleto
   E1_VENCREA                                      ,;  // [4] Data do vencimento
   E1_SALDO                                           ,;  // [5] Valor do título
   E1_PREFIXO                                            ,;  // [7] Prefixo da NF
   _nVlrAbat                                             }   // [15] Abatimentos


   cVend   :=  E1_VEND1
   dData   :=  dDatabase // E1_EMISSAO         // Data de Emissao
   cMes    :=  StrZero(Month(dData))
   cAno    :=  Str(Year(dData))
   cAnoMes :=  cAno+Subs(cMes,2,2)
   dVencto :=  E1_VENCTO
   nMes       := Month(dData)
   aMes := ""
   DO CASE
   CASE nMes == 01
      aMes := "Janeiro"
   CASE nMes == 02
      aMes := "Fevereiro"
   CASE nMes == 03
      aMes := "Março"
   CASE nMes == 04
      aMes := "Abril"
   CASE nMes == 05
      aMes := "Maio"
   CASE nMes == 06
      aMes := "Junho"
   CASE nMes == 07
      aMes := "Julho"
   CASE nMes == 08
      aMes := "Agosto"
   CASE nMes == 09
      aMes := "Setembro"
   CASE nMes == 10
      aMes := "Outubro"
   CASE nMes == 11
      aMes := "Novembro"
   CASE nMes == 12
      aMes := "Dezembro"
   ENDCASE

   dbSelectArea("SA3")
   dbSetOrder(1)
   dbSeek(xFilial("SA3")+cVend)
   If Found()
      cNomVen  := A3_NREDUZ
   Else
      cNomVen  := "  "
   Endif
   
   If aMarked[i]
      Impress(oPrint,aDadosEmp,aDadosTit,aDatSacado)

   EndIf

   DbSelectArea("SE1")
   dbSkip()
   IncProc()
   i := i + 1

ENDDO

IF MV_PAR07 == 1
   oPrint:Preview()     // Visualiza antes de imprimir
ELSE
   oPrint:setup()     // Escolher a impressora
   oPrint:Print()   // Imprime direto na impressora default do APx
ENDIF

oPrint:End()     // Finaliza Objeto
ms_flush() // desativar impressora

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  IMPRESS ³ Autor ³ Agamenon Caldas       ³ Data ³ 08/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO RECIBO                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDatSacado)
LOCAL i := 0
LOCAL cCGC := IIF(SA1->A1_PESSOA == "J",substr(SA1->A1_CGC,1,2) +"."+substr(SA1->A1_CGC,3,3) +"."+ substr(SA1->A1_CGC,6,3) +"/"+ substr(SA1->A1_CGC,9,4) +"-"+substr(SA1->A1_CGC,13,2),substr(SA1->A1_CGC,1,3) +"."+substr(SA1->A1_CGC,4,3) +"."+ substr(SA1->A1_CGC,7,3) +"-"+ substr(SA1->A1_CGC,10,2))

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

Private  oBrush      := TBrush():New(,CLR_LIGHTGRAY),;
      oPen     := TPen():New(0,5,CLR_BLACK),;
      cFileLogo   := GetSrvProfString('Startpath','') + 'msmdilogo' + '.bmp',;
      oFont5      := TFont():New( "Arial",,5,,.F.,,,,,.F. ),;
      oFont07     := TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
      oFont08     := TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
      oFont08n    := TFont():New('Courier New',08,08,,.T.,,,,.T.,.F.),;
      oFont09     := TFont():New('Tahoma',09,09,,.T.,,,,.T.,.F.),;
      oFont10     := TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
      oFont10n    := TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
      oFont10a    := TFont():New( "Arial",,10,,.t.,,,,,.f. ),;
      oFont11     := TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
      oFont11n    := TFont():New('Tahoma',11,11,,.T.,,,,.T.,.F.),;
      oFont12     := TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),;
      oFont12n    := TFont():New('Tahoma',12,12,,.F.,,,,.T.,.F.),;
      oFont13     := TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.),;
      oFont14     := TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
      oFont15     := TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
      oFont18     := TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
      oFont16     := TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
      oFont20     := TFont():New('Arial',20,20,,.F.,,,,.T.,.F.),;
      oFont22     := TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)

nLinha      := 3000   // Controla a linha por extenso
lPrintDesTab:= .f. // Imprime a Descricao da tabela (a cada nova pagina)
Private  _nQtdReg := 0      // Numero de registros para intruir a regua
Private _cNomecomp := ""

_nomeuser := substr(cUsuario,7,15)
PswOrder(2)
If PswSeek(_nomeuser,.T.)
   aRetUser := PswRet(1)
   _cNomecomp := aRetUser[1,04]
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Numero/Emissao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nNossoNu := 1

// Cadastro de Parametros
dbSelectArea("SX6")
dbSetOrder(1)
IF cCodfil $ "05/06/07/08"
   cVar := "05"+"MV_RECIBO"
ELSE
   cVar := cCodFil+"MV_RECIBO"
ENDIF
DBSEEK(cVar)
IF FOUND()
   nNossoNu := VAL(SX6->X6_CONTEUD)
   nNossoNu := nNossoNu + 1
   Reclock("SX6",.F.)
   REPLACE X6_CONTEUD WITH STR(nNossoNu,6)
   dbUnlock()
Endif

** IMPRIME DUAS VIAS

nLinha      := 50   // Controla a linha por extenso

FOR I := 1 TO 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime o cabecalho da empresa. !³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   oPrint:Box(nLinha,100,nLinha+220,1200)
   oPrint:Box(nLinha,1210,nLinha+220,1900)
   oPrint:Box(nLinha,1910,nLinha+220,2300)


   oPrint:SayBitmap(nLinha+5,110,cFileLogo,530,130)

   oPrint:Say(nLinha+130,110,AllTrim(Upper(aDadosEmp[1])),oFont11n) // 16
   oPrint:Say(nLinha+170,110,aDadosEmp[6]+" "+aDadosEmp[7],oFont11n)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   oPrint:Say(nLinha+70,1400,OemToAnsi('RECIBO'),oFont22)

   oPrint:Say(nLinha+10,1960,OemToAnsi('Número documento'),oFont08)
   oPrint:Say(nLinha+45,2000,STRZERO(nNossoNu,6),oFont18)
   oPrint:Say(nLinha+125,2000,Dtoc(dDatabase),oFont12)

//ÚÄÄÄÄÄÄÄÄÄÄ¿
//³Cliente   ³
//ÀÄÄÄÄÄÄÄÄÄÄÙ

   nLinha += 220 // 270

   oPrint:Box(nLinha+45,100,nLinha+215,2300)
   oPrint:Say(nLinha+60,0120,OemToAnsi('Cliente   :'),oFont12)
   oPrint:Say(nLinha+60,0500,AllTrim(aDatSacado[1]) + '  ('+AllTrim(aDatSacado[2])+') '+cCGC,oFont13)
   oPrint:Say(nLinha+110,0120,OemToAnsi('Endereço:'),oFont12)
   oPrint:Say(nLinha+110,0500,aDatSacado[3],oFont11)
   oPrint:Say(nLinha+160,0120,OemToAnsi('Município/U.F.:'),oFont12)
   oPrint:Say(nLinha+160,0500,AllTrim(aDatSacado[4])+'/'+AllTrim(aDatSacado[5]),oFont11)
   oPrint:Say(nLinha+160,1200,OemToAnsi('Cep:'),oFont12)
   oPrint:Say(nLinha+160,1370,TransForm(aDatSacado[6],'@R 99.999-999'),oFont11)
   oPrint:Say(nLinha+160,1700,OemToAnsi('Fone:'),oFont12)
   oPrint:Say(nLinha+160,1870,ALLTRIM(aDatSacado[8]),oFont11)
   nLinha += 250

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³RECIBO        ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   oPrint:Say(nLinha+60,1500,"V A L O R",oFont18)

   oPrint:Box(nLinha+50,1900,nLinha+170,2300)
   oPrint:FillRect({nLinha+50,1900,nLinha+170,2300},oBrush)
   oPrint:Say(nLinha+100,2000,"R$ "+TRANSFORM(aDadosTit[5],"@E 999,999.99"),oFont12)
   nLinha += 170
   nLinha += 45
   oPrint:Say(nLinha,0100,OemToAnsi("Recebi de   "+aDatSacado[1] + '  ('+aDatSacado[2]+')'),oFont12)
   nLinha += 45
   oPrint:Say(nLinha,0100,OemToAnsi("Referente a fatura número "+aDadosTit[1]+", a importância supra de R$ "+TRANSFORM(aDadosTit[5],"@E 999,999,999.99")),oFont12)

   oPrint:Box(nLinha+45,100,nLinha+130,2300)
   oPrint:FillRect({nLinha+45,100,nLinha+130,2300},oBrush)
   nLinha += 45
   oPrint:Say(nLinha,0100,OemToAnsi(ALLTRIM(SUBS(EXTENSO(aDadosTit[5]),1,083))+REPLICATE('*',083-LEN(ALLTRIM(SUBS(EXTENSO(aDadosTit[5]),1,083))))),oFont12)
   nLinha += 45
   oPrint:Say(nLinha,0100,OemToAnsi(ALLTRIM(SUBS(EXTENSO(aDadosTit[5]),084,083))+REPLICATE('*',081-LEN(ALLTRIM(SUBS(EXTENSO(aDadosTit[5]),084,083))))),oFont12)
   nLinha += 45
   oPrint:Say(nLinha,0100,OemToAnsi("Pelo que passo o presente recibo dando plena e geral quitação."),oFont12)
   nLinha += 45
   oPrint:Say(nLinha,1450,OemToAnsi("Vencimento: "+TRANSFORM(dVencto,"@D")),oFont12)
   nLinha += 45
   oPrint:Say(nLinha,0100,OemToAnsi(Capital(AllTrim(SM0->M0_CIDENT))+", "+Str(Day(ddata),2)+" de "+aMes+" de "+ Str(Year(ddata),4)+"."),oFont12)
   oPrint:Say(nLinha,1450,OemToAnsi("Vendedor    : "+cVend + "  "+LEFT(cNomVen,15)),oFont12)
   nLinha += 45

   IF I == 1
      nLinha += 45
      nLinha += 90
      nLinha += 90
      nLinha += 90

// assinatura

      oPrint:Say(nLinha,0100,OemToAnsi('ASS. Cliente:'),oFont12)
      oPrint:Say(nLinha,0400,'__________________________________',oFont12n)

      oPrint:Say(nLinha,1200,OemToAnsi('ASS. Responsável:'),oFont12)
      oPrint:Say(nLinha,1600,'_______________________________',oFont12n)
      nLinha += 45
      oPrint:Say(nLinha,1600,AllTrim(aDadosEmp[1]),oFont08n)

      nLinha += 140

   ELSE
      oPrint:Box(nLinha+45,100,nLinha+175,1200)
      oPrint:Line(nLinha+110,100,nLinha+110,1200)
      oPrint:Line(nLinha+45,600,nLinha+175,600)
      nLinha += 60
      oPrint:Say(nLinha,0110,OemToAnsi('TOTAL EM DINHEIRO'),oFont12)
      nLinha += 60
      oPrint:Say(nLinha,0110,OemToAnsi('TOTAL EM CHEQUES'),oFont12)

      oPrint:Say(nLinha,1230,OemToAnsi('ASS. Responsável:'),oFont12)
      oPrint:Say(nLinha,1620,'_____________________________',oFont12n)

      nLinha += 60

      oPrint:Box(nLinha,100,nLinha+300,2300)
      oPrint:FillRect({nLinha,100,nLinha+60,2300},oBrush)
      oPrint:Line(nLinha,500,nLinha+300,500)
      oPrint:Line(nLinha,800,nLinha+300,800)
      oPrint:Line(nLinha,1190,nLinha+300,1190)
      oPrint:Line(nLinha,1195,nLinha+300,1195)
      oPrint:Line(nLinha,1200,nLinha+300,1200)
      oPrint:Line(nLinha,1600,nLinha+300,1600)
      oPrint:Line(nLinha,1900,nLinha+300,1900)
      oPrint:Say(nLinha,0110,OemToAnsi('BANCO/AGÊNCIA'),oFont12)
      oPrint:Say(nLinha,0510,OemToAnsi('Nº CHEQUE'),oFont12)
      oPrint:Say(nLinha,0810,OemToAnsi('VALOR R$'),oFont12)
      oPrint:Say(nLinha,1210,OemToAnsi('BANCO/AGÊNCIA'),oFont12)
      oPrint:Say(nLinha,1610,OemToAnsi('Nº CHEQUE'),oFont12)
      oPrint:Say(nLinha,1910,OemToAnsi('VALOR R$'),oFont12)
      nLinha += 60
      oPrint:Line(nLinha,100,nLinha,2300)
      nLinha += 60
      oPrint:Line(nLinha,100,nLinha,2300)
      nLinha += 60
      oPrint:Line(nLinha,100,nLinha,2300)
      nLinha += 60
      oPrint:Line(nLinha,100,nLinha,2300)
      nLinha += 90

   ENDIF

** RODAP DA ORDEM

   oPrint:Line(nLinha,0100,nLinha,2300)
   nLinha += 15
   oPrint:Say(nLinha,120,AllTrim(SM0->M0_ENDENT)+" - "+Capital(AllTrim(SM0->M0_CIDENT))+'/'+AllTrim(SM0->M0_ESTENT)+ ' CEP.: ' + AllTrim(TransForm(SM0->M0_CEPENT,'@R 99.999-999')) + '  -  FONE: ' + AllTrim(SM0->M0_TEL),oFont11)

   IF I == 1
      oPrint:Say(nLinha,2050,"VIA CLIENTE",oFont11n)
      nLinha += 60
      oPrint:Say(nLinha,070,Repli('-',2000),oFont10a,100)
      oPrint:Say(nLinha+30,080,"CORTE AQUI",oFont5,100)  
      nLinha += 60
      nLinha += 60
   ELSE
      oPrint:Say(nLinha,2050,"VIA EMPRESA",oFont11n)
   ENDIF

NEXT

** GRAVO NUMERO DA DUPLICATA

/*

DbSelectArea("SE1")
RecLock("SE1",.f.)
SE1->E1_NUMBCO   := 
SE1->E1_PORTADOR := MV_PAR04
MsUnlock()

*/


oPrint:EndPage() // Finaliza a página


Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VALIDPERG ³ Autor ³ Agamenon Caldas       ³ Data ³ 12/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ INCLUI PERGUNTAS DO RELATORIO                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg()
_sAlias := Alias()
DBSelectArea("SX1")
DBSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Do Boleto          ?","","","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","SE1","",""})
aAdd(aRegs,{cPerg,"02","Ate o Boleto       ?","","","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","SE1","",""})
aAdd(aRegs,{cPerg,"03","Prefixo            ?","","","mv_ch3","C",3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Qual Banco         ?","","","mv_ch4","C",3,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Agencia            ?","","","mv_ch5","C",3,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Conta              ?","","","mv_ch6","C",3,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Tipo de Impressao    ?","","","mv_ch7","N", 1,0,0,"C","","mv_par07","Form.Proprio","","","","","Pre-Impresso","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Seleciona Titulos    ?","","","mv_ch8","N", 1,0,0,"C","","mv_par08","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
   If ! DBSeek(cPerg+aRegs[i,2])
      RecLock("SX1",.T.)
      For j:=1 to Max(39, Len(aRegs[i])) //fCount()
         FieldPut(j,aRegs[i,j])
      Next
      MsUnlock()
   Endif
Next

DBSkip()

do while x1_grupo == cPerg
   RecLock("SX1", .F.)
   DBDelete()
   DBSkip()
Enddo

DBSelectArea(_sAlias)

Return
