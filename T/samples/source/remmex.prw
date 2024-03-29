#include "rwmake.ch"   
     
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncion   � REMMEX   � Autor � Marcello Gabriel      � Data � 10.05.00 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao | Impresion de Remision   (Mexico)                           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Faturamento                                                潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/

User Function RemMex()
local cAreaA:=alias()
RemPerg()
cPerg:="REMMEX"
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variables utilizadas para parametros                         �
//� mv_par01             // Del Factura                          �
//� mv_par02             // Hasta el Factura                     �
//� mv_par03             // Serie                                �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
aDRIVER := READDRIVER()
cString:="SCN"
titulo :=PADC("Emisi de las Remisiones." ,74)
cDesc1 :=PADC("Ser� solicitado el Intervalo para la emisi de las",74)
cDesc2 :=PADC("Remisiones generadas",74)
cDesc3 :=""
aReturn := { OemToAnsi("Especial"), 1,OemToAnsi("Administraci"), 1, 2, 1,"",1 }
nomeprog:="REMMEX" 
nLin:=0
wnrel:= "REMMEX"     
cRemFin:=""
cRemIni:=""
if type("ParamIxb")=="A"
   wnrel:=SetPrint(cString,wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"G","",.F.)
   cRemIni:=ParamIxb[1]
   cRemFin:=ParamIxb[1]
else   
    PERGUNTE(cPerg,.F.)
    wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,"G","",.F.)
    cRemIni:=mv_par01
    cRemFin:=mv_par02
endif   
If nLastKey!=27
   SetDefault(aReturn,cString)
   If nLastKey!=27
      VerImp()       
      RptStatus({|| RptNota()})
   endif
endif   
dbselectarea(cAreaA)
Return

Static Function RptNota()
local nLin,nTotImp,nTotItem,nIndSCN,cRemAux
dbselectarea("SCN")
nIndSD2:=indexord()
dbsetorder(1)        
if val(cRemFin)==0
   dbgobottom()
   cRemFin:=CN_REMITO
endif
if val(cRemIni)==0
   dbgotop()
else 
    dbSeek(xFilial("SCN")+cRemIni,.T.)
endif    
cRemIni:=CN_REMITO
SetRegua(Val(cRemFin)-Val(cRemIni)+1)
while val(CN_REMITO)>=val(cRemIni) .and. val(CN_REMITO)<=val(cRemFin) .and. !eof()
      SA1->(dbseek(xFILIAL("SA1")+SCN->CN_CLIENTE+SCN->CN_LOJA))
      @006,092 psay CN_REMITO picture pesqpict("SCN","CN_REMITO")
      @008,000 psay SA1->A1_COD picture pesqpict("SA1","A1_COD")
      @008,pcol()+2 psay trim(SA1->A1_NOME) picture pesqpict("SA1","A1_NOME")
      @008,pcol()+3 psay "RFC "+transf(SA1->A1_CGC,pesqpict("SA1","A1_CGC"))
      @008,079 psay CN_EMISSAO
      @010,000 psay SA1->A1_ENDENT
      @011,000 psay trim(SA1->A1_MUNE)+" - "+trim(SA1->A1_ESTE)
      nLin:=17
      nTotImp:=(nTotItem:=0)
      cRemAux:=CN_REMITO
      while CN_REMITO==cRemAux .and. CN_FILIAL==cFilial
            @nLin,000 psay CN_PRODUTO picture pesqpict("SCN","CN_PRODUTO")
            @nLin,016 psay CN_QUANT picture "9999999.999"
            @nLin,028 psay CN_UM picture pesqpict("SCN","CN_UM")
            if (SC6->(dbseek(xFILIAL("SC6")+SCN->CN_PEDIDO+SCN->CN_ITEMPED)))
               @nLin,031 psay SC6->C6_DESCRI picture pesqpict("SC6","C6_DESCRI")
            else   
                SB1->(dbseek(xFILIAL("SB1")+SCN->CN_PRODUTO))
                @nLin,031 psay SB1->B1_DESC picture pesqpict("SB1","B1_DESC")
            endif    
            @nLin,062 psay CN_PEDIDO picture pesqpict("SCN","CN_PEDIDO")
            @nLin,069 psay CN_ITEMPED picture pesqpict("SCN","CN_ITEMPED")
            @nLin++,72 psay CN_TOTAL picture "99,999,999,999.99"
            nTotItem+=CN_TOTAL
            dbskip()
            incregua()
      enddo     
      @054,072 psay nTotItem picture "99,999,999,999.99"
      @056,072 psay nTotItem+nTotImp picture "99,999,999,999.99"
enddo
Set Device To Screen
If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif
MS_FLUSH()
dbselectarea("SCN")
dbsetorder(nIndSCN)
Return

Static Function VerImp()
nLin:= 0                
If aReturn[5]==2
   nOpc:= 1
   While .T.
      Eject
      dbCommitAll()
      SETPRC(0,0)
      IF MsgYesNo("Fomulario esta posicionado ? ")
         nOpc := 1
      ElseIF MsgYesNo("Intenta Nuevamente ? ")
             nOpc := 2
      Else
          nOpc := 3
      Endif
      Do Case
         Case nOpc==1
            lContinua:=.T.
            IF UPPER(ALLTRIM(aDRIVER[5])) <> "CHR(32)"
               @ PROW(),000 PSAY aDRIVER[5]
            END   
            Exit
         Case nOpc==2
            Loop
         Case nOpc==3
            lContinua:=.F.
            Return
      EndCase
   End
Endif
Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � FACPerg  � Autor � Jose Lucas            � Data � 22/02/99 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Verifica as perguntas includo-as caso n刼 existam...     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � 				                                               潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function RemPerg()
Local i:=0, j:=0
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg :="REMMEX"
aRegs:={}

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Factura De                           �
//� mv_par02             // Factura hasta                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
aAdd(aRegs,{cPerg,"01","≧emison de         ?","mv_ch1","C",tamsx3("CN_REMITO")[1],0,0,"G","","mv_par01","","            ","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","≧emison hasta      ?","mv_ch2","C",tamsx3("CN_REMITO")[1],0,0,"G","","mv_par02","","999999999999","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)
Return