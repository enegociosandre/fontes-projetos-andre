#INCLUDE "Eicpo557.ch"
#include "rwmake.ch"     
#INCLUDE "avprint.ch"
#INCLUDE "average.ch"

#DEFINE     DATA_ATUAL        UPPER(CMONTH(dDataAtu))+", "+;
                              STRZERO(DAY(dDataAtu),2)+", "+;
                              STR(YEAR(dDataAtu),4)

User Function Eicpo557() 

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("UVAR>,OPRINT>,OFONT>,ACLOSE,CALIASOLD,NOLDAREA")
SetPrvt("TB_CAMPOS,_PICTPO,_PICTPRTOT,_PICTPRUN,_PICTQTDE,_PICTITEM")
SetPrvt("CCADASTRO,CMARCA,LINVERTE,NUSADO,CARQF3SW2,CARQF3SYT")
SetPrvt("CARQF3SY4,CARQF3SYQ,CCAMPOF3SW2,CCAMPOF3SYT,CCAMPOF3SY4,CCAMPOF3SYQ")
SetPrvt("TPO_NUM,TIMPORT,TCONDPG,TDIASPG,TAGENTE,TTIPO_EMB")
SetPrvt("TNR_PRO,TID_PRO,TDT_PRO,TPAIS,NSPREAD,MTOTAL")
SetPrvt("AMSG,CPOINTS,ACAMPOS,AHEADER,STRUCT1,FILEWORK")
SetPrvt("PAGINA,ODLG,OFNTDLG,NLIN,NCOLS1,NCOLG1")
SetPrvt("NCOLS2,NCOLG2,NCOLS3,NCOLG3,NCOLG4,NCOLS4")
SetPrvt("NCOLS5,MFLAG,V,NOPCAO,BOK,BCANCEL")
SetPrvt("BINIT,CALIAS,NTIPOIMP,ARAD1,OMARK,NNETWEIGHT")
SetPrvt("MDESCRI,I,AVETOR,W,CENDSA2,LCOMISSAORETIDA")
SetPrvt("NVAL_COM,CNOMEBANCO,CPAYMENT,CEXPORTA,CFORN,DDATAATU")
SetPrvt("DDATASHIP,NLI_INI,NLI_FIM,NLI_FIM2,AFONTES,PARTE2")
SetPrvt("NLINHA,LBATEBOX,NLINPAY,")


#COMMAND E_RESET_AREA                      => SA5->(DBSETORDER(1)) ;
                                           ;  Work->(E_EraseArq(FileWork)) ;
                                           ;  DBSELECTAREA(nOldArea)

#xtranslate :TIMES_NEW_ROMAN_12            => \[1\]
#xtranslate :TIMES_NEW_ROMAN_14_BOLD       => \[2\]

#xtranslate   bSETGET(<uVar>)              => {|u| If(PCount() == 0, <uVar>, <uVar> := u) }

#xtranslate   AVPict(<Cpo>)                => AllTrim(X3Picture(<Cpo>))


/*
___________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun�ao    � EICPO557 � Autor � JOS� M�RCIO SOLER     � Data � 26.10.96 ���
��+----------+------------------------------------------------------------���
���Descri��o � Emiss�o da Proforma                                        ���
��+----------+------------------------------------------------------------���
���Sintaxe   � #EICPO557                                                  ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

aClose:={"B3","B4","B5","B6"}
cAliasOld := Alias()

IF RddName() != "TOPCONN"
   E_OpenFile({},{||PO557()},aClose)
ELSE
   PO557()
ENDIF
dbSelectArea( cAliasOld )
Return(.T.)        

*-----------------------*
Static Function PO557()
*-----------------------*
LOCAL cMoeDolar:=GETMV("MV_SIMB2",,"US$")
PRIVATE oPanel  //LRL 19/03/04
nOldArea := SELECT()
TB_Campos:= {}
_PictPO   :=ALLTRIM(X3Picture("W2_PO_NUM" ))
_PictPrTot:=ALLTRIM(X3Picture("W2_FOB_TOT"))
_PictPrUn :=ALLTRIM(X3Picture("W3_PRECO"  ))
_PictQtde :=ALLTRIM(X3Picture("W3_QTDE"   ))
_PictItem :=ALLTRIM(X3Picture("B1_COD"    ))


cCadastro     := STR0001 //"Emiss�o da Proforma"
cMarca        := GetMark()
lInverte      := .F.
nUsado        := 0
cArqF3SW2     := "SW2"
cArqF3SYT     := "SYT"
cArqF3SY4     := "SY4"
cArqF3SYQ     := "SYQ"
cCampoF3SW2   := "W2_PO_NUM"
cCampoF3SYT   := "YT_COD"
cCampoF3SY4   := "Y4_COD"
cCampoF3SYQ   := "YQ_VIA"
TPO_Num       := SW2->W2_PO_NUM
TImport       := SW2->W2_IMPORT
TCondPg       := SW2->W2_COND_PA
TDiasPg       := SW2->W2_DIAS_PA
TAgente       := SW2->W2_AGENTE
TTipo_Emb     := SW2->W2_TIPO_EM
TNr_Pro       := SW2->W2_NR_PRO
TId_Pro       := "P"
TDt_Pro       := SW2->W2_DT_PRO
nSpread       := 0
MTotal        := 0
aMsg          := {}

SA2->(DBSETORDER(1))
SA2->(DBSEEK(xFilial("SA2")+SW2->W2_FORN))
SYA->(DBSETORDER(1))
SYA->(DBSEEK(xFilial("SYA")+SA2->A2_PAIS))
TPais:=ALLTRIM(SYA->YA_DESCR)+SPACE(10)

cPointS := "EICPO57S"
If ExistBlock(cPointS)
   ExecBlock(cPointS,.f.,.f.)
Endif

SA5->(DBSETORDER(3))

AADD(TB_Campos,{"WKUNI"   ,"",STR0002}) //"UNID"
AADD(TB_Campos,{"WKNET_W" ,"",STR0003,"@ 999,999,999.9999"}) //"NET WEIGHT (KG)"
AADD(TB_Campos,{"WKQTDE"  ,"",STR0004,"@ 999,999,999"}) //"QUANTITY ORDERED"
AADD(TB_Campos,{"WKCOD_I" ,"",ALLTRIM(SM0->M0_NOME)+" CODE",_PictItem})
AADD(TB_Campos,{"WKDESCR" ,"",STR0005}) //"DESCRIPTION"
//AADD(TB_Campos,{"WKPRECO" ,"",STR0006+IF(SW2->W2_PARID_U==0,SW2->W2_MOEDA,cMoeDolar),E_TrocaVP(1,_PictPrUn)}) //"UNIT PRICE "
//AADD(TB_Campos,{"WKAMOUNT","",STR0007+IF(SW2->W2_PARID_U==0,SW2->W2_MOEDA,cMoeDolar),E_TrocaVP(1,_PictPrUn)}) //"AMOUNT "
AADD(TB_Campos,{"WKPRECO" ,"",STR0006+SW2->W2_MOEDA,E_TrocaVP(1,_PictPrUn)}) //"UNIT PRICE "
AADD(TB_Campos,{"WKAMOUNT","",STR0007+SW2->W2_MOEDA,E_TrocaVP(1,_PictPrUn)}) //"AMOUNT "
aCAMPOS:= {}
aHEADER:= {}
Struct1:= {  {"WKNET_W","N",14,4} , {"WKQTDE"  ,"N",13,3} ,;
             {"WKCOD_I","C",AVSX3("W3_COD_I",3),0} , {"WKDESCR" ,"C",26,0} ,;
             {"WKPRECO","N",15,5} , {"WKAMOUNT","N",15,5} ,;
             {"WKFLAG" ,"C",02,0} , {"WKUNI"   ,"C",03,0} ,;
             {"WKFABR" ,"C",AVSX3("A2_COD",3),0} , {"WKFORN","C",AVSX3("A2_COD",3),0} ,;
             {"WKRECNO","N",05,0} }

FileWork:=E_CriaTrab(,Struct1,"Work")
IF ! USED()
   MSGINFO(OemToAnsi(STR0008),OemToAnsi(STR0009)) //"N�o h� �rea dispon�vel para abertura do Cadastro de Work"###"Informa��o"
   Return .F.
ENDIF

IndRegua("Work",FileWork+OrdBagExt(),"WKFABR + WKCOD_I",;
         "AllwaysTrue()",;
         "AllwaysTrue()",;
         STR0010) //"Processando Arquivo Tempor�rio..."


WHILE .T.
   PAGINA := 0

   oDlg:= oSend( MSDialog(), "New", 6.5, 0, 26.5, 80,;
                 cCadastro,,,.F.,,,,,oMainWnd,.F.,,,.F.)

    oFntDlg := NIL
    DEFINE FONT oFntDlg  NAME "Ms Sans Serif" SIZE 0,-9


  nLin:=1.4 ; nColS1:=1.0  ; nColG1:=7.0 ; nColS2:=17.0 ; nColG2:=21.0
              nColS3:=10.0 ; nColG3:=9.0 ; nColG4:=11.0
              nColS4:=25.0 ; nColS5:=29.0


      oSend(TSay(),"New",nLin         ,nColS1,{|| OemToAnsi(STR0011)},oDlg,,oFntdlg,,,,.F. ) //"Nro. do P.O.:"
      oSend(TGet(),"New",nLin         ,nColG1 ,bSetGet(TPO_Num)   ,oDlg,60,8,;
                                       AVPict("W2_PO_NUM"),{||MFLAG:="PO", PO557Val()        },,,oFntDlg,,,.F.,,,,,,,,,"SW2") 


      oSend(TSay(),"New",nLin         ,nColS2,{|| STR0012            },oDlg,,oFntdlg,,,,.F. ) //"Importador"
   V:=oSend(TGet(),"New",nLin         ,nColG2 ,bSetGet(TImport)   ,oDlg,10,8,;
                                       AVPict("W2_IMPORT"),{||MFLAG:=STR0013, PO557Val()    },,,oFntDlg,,,.F.,,,,,,,,,"SYT")
      oSend(V,"DISABLE")


      oSend(TSay(),"New",nLin:=nLin+1 ,nColS1,{|| STR0014            },oDlg,,oFntdlg,,,,.F. ) //"Nro. Prof."
      oSend(TGet(),"New",nLin         ,nColG1 ,bSetGet(TNr_Pro)   ,oDlg,60,8,;
                                       AVPict("W2_NR_PRO"),{||MFLAG:="Nr_Pro", PO557Val()    },,,oFntDlg,,,.F.,,,,,,,,,)


      oSend(TSay(),"New",nLin         ,nColS2,{|| STR0015                 },oDlg,,oFntdlg,,,,.F. ) //"Date "
      oSend(TGet(),"New",nLin         ,nColG2 ,bSetGet(TDt_Pro)   ,oDlg,40,8,;
                                       AVPict("W2_DT_PRO"),{||MFLAG:="Dt_Pro", PO557Val()    },,,oFntDlg,,,.F.,,,,,,,,,)


      oSend(TSay(),"New",nLin:=nLin+1 ,nColS1,{|| STR0016      },oDlg,,oFntdlg,,,,.F. ) //"Terms of Payment"
   V:=oSend(TGet(),"New",nLin         ,nColG1 ,bSetGet(TCondPg)   ,oDlg,20,8,;
                                       AVPict("W2_COND_PA"),{||MFLAG:="CPagto", PO557Val()   },,,oFntDlg,,,.F.,,,,,,,,,)
      oSend(V,"DISABLE")


      oSend(TSay(),"New",nLin         ,nColS3,{|| "/"                     },oDlg,,oFntdlg,,,,.F. )
   V:=oSend(TGet(),"New",nLin         ,nColG4 ,bSetGet(TDiasPg)   ,oDlg,10,8,;
                                       AVPict("W2_DIAS_PA"),{||MFLAG:="CDiasPg", PO557Val()   },,,oFntDlg,,,.F.,,,,,,,,,)
      oSend(V,"DISABLE")


      oSend(TSay(),"New",nLin         ,nColS2,{|| STR0017             },oDlg,,oFntdlg,,,,.F. ) //"Forwarder"
   V:=oSend(TGet(),"New",nLin         ,nColG2 ,bSetGet(TAgente)   ,oDlg,10,8,;
                                       AVPict("W2_AGENTE"),{||MFLAG:="Agente", PO557Val()     },,,oFntDlg,,,.F.,,,,,,,,,"SY4")
      oSend(V,"DISABLE")

      oSend(TSay(),"New",nLin:=nLin+1 ,nColS1,{|| STR0018               },oDlg,,oFntdlg,,,,.F. ) //"Country"
   V:=oSend(TGet(),"New",nLin         ,nColG1 ,bSetGet(TPais)   ,oDlg,60,8,,,,,oFntDlg,,,.F.,,,,,,,,,)
      oSend(V,"DISABLE")

      oSend(TSay(),"New",nLin         ,nColS2,{|| STR0019              },oDlg,,oFntdlg,,,,.F. ) //"Delivery"
   V:=oSend(TGet(),"New",nLin         ,nColG2 ,bSetGet(TTipo_Emb)   ,oDlg,10,8,;
                                       AVPict("W2_TIPO_EM"),{||MFLAG:="Embar", PO557Val()     },,,oFntDlg,,,.F.,,,,,,,,,"SYQ")
      oSend(V,"DISABLE")

      aadd(aMsg,spac(45))
      aadd(aMsg,spac(45))
      aadd(aMsg,spac(45))
      aadd(aMsg,spac(45))
      aadd(aMsg,spac(45))

      oSend(TSay(),"New",5.5,nColS1,{|| STR0020 },oDlg,,oFntdlg,,,,.F. ) //"Observa��o.:"
      oSend(TGet(),"New",70 ,56 ,bSetGet(aMsg[1]) ,oDlg,190,10,,,,,oFntDlg,,,.T.,,,,,,,,,)
      oSend(TGet(),"New",85 ,56 ,bSetGet(aMsg[2]) ,oDlg,190,10,,,,,oFntDlg,,,.T.,,,,,,,,,)
      oSend(TGet(),"New",100,56 ,bSetGet(aMsg[3]) ,oDlg,190,10,,,,,oFntDlg,,,.T.,,,,,,,,,)
      oSend(TGet(),"New",115,56 ,bSetGet(aMsg[4]) ,oDlg,190,10,,,,,oFntDlg,,,.T.,,,,,,,,,)
      oSend(TGet(),"New",130,56 ,bSetGet(aMsg[5]) ,oDlg,190,10,,,,,oFntDlg,,,.T.,,,,,,,,,)

  nOpcao:=0

        bOk    := {||nOpcao:=1,oSend(oDlg,"End")}
        bCancel:= {||nOpcao:=0,oSend(oDlg,"End")}

        bInit  := {|| EnchoiceBar(oDlg,bOk,bCancel) }

        oSend( oDlg, "Activate",,,,.T.,,, bInit )

        If nOpcao == 1
           MsAguarde({||Po557Grava()},STR0021)

        Endif

        If nOpcao == 0
                   E_RESET_AREA
                   Return .F.
                Endif

  IF Work->(LASTREC()) > 0

     nOpcao:=0
     cAlias:=ALIAS()
     Reclock("SW2",.F.)
     SW2->W2_NR_PRO:=TNr_Pro
     DBSELECTAREA(cAlias)

    oMainWnd:ReadClientCoors()
    DEFINE MSDIALOG oDlg TITLE cCadastro;
            FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-60,oMainWnd:nRight-10 ;
    	           OF oMainWnd PIXEL  

    oFntDlg := NIL
    DEFINE FONT oFntDlg  NAME "Ms Sans Serif" SIZE 0,-9

   nLin:=1.4 ; nColS1:=1.0  ; nColG1:=7.0 ; nColS2:=17.0 ; nColG2:=21.0
               nColS3:=10.0 ; nColG3:=9.0 ; nColG4:=11.0
               nColS4:=25.0 ; nColS5:=29.0

@ 01,01 MSPANEL oPanel PROMPT "" SIZE 30,70 OF oDlg //LRL 19/03/04 - Painel para Alinhamento MDI

      oSend(TSay(),"New",nLin         ,nColS1,{|| OemToAnsi(STR0022)},oPanel,,oFntdlg,,,,.F. ) //"N� do P.O.:"
   V:=oSend(TGet(),"New",nLin         ,nColG1 ,bSetGet(TPO_Num)   ,oPanel,40,8,;
                                       AVPict("W2_PO_NUM"),{||MFLAG:="PO", PO557Val()    },,,oFntDlg,,,.F.,,,,,,,,,"SW2")// Substituido pelo assistente de conversao do AP5 IDE em 25/11/99 ==>                                        AVPict("W2_PO_NUM"),{||MFLAG:="PO", Execute(PO557Val)    },,,oFntDlg,,,.F.,,,,,,,,,"SW2")
      oSend(V,"DISABLE")


      oSend(TSay(),"New",nLin         ,nColS2,{|| STR0012            },oPanel,,oFntdlg,,,,.F. ) //"Importador"
   V:=oSend(TGet(),"New",nLin         ,nColG2 ,bSetGet(TImport)   ,oPanel,10,8,;
                                       AVPict("W2_IMPORT"),{||MFLAG:="Import", PO557Val()    },,,oFntDlg,,,.F.,,,,,,,,,"SYT")// Substituido pelo assistente de conversao do AP5 IDE em 25/11/99 ==>                                        AVPict("W2_IMPORT"),{||MFLAG:="Import", Execute(PO557Val)    },,,oFntDlg,,,.F.,,,,,,,,,"SYT")
      oSend(V,"DISABLE")


      oSend(TSay(),"New",nLin:=nLin+1 ,nColS1,{|| STR0014            },oPanel,,oFntdlg,,,,.F. ) //"Nro. Prof."
   V:=oSend(TGet(),"New",nLin         ,nColG1 ,bSetGet(TNr_Pro)   ,oPanel,50,8,;
                                       AVPict("W2_NR_PRO"),{||MFLAG:="Nr_Pro", PO557Val()   },,,oFntDlg,,,.F.,,,,,,,,,)// Substituido pelo assistente de conversao do AP5 IDE em 25/11/99 ==>                                        AVPict("W2_NR_PRO"),{||MFLAG:="Nr_Pro", Execute(PO557Val)   },,,oFntDlg,,,.F.,,,,,,,,,)
      oSend(V,"DISABLE")


      oSend(TSay(),"New",nLin         ,nColS2,{|| STR0015                 },oPanel,,oFntdlg,,,,.F. ) //"Date "
   V:=oSend(TGet(),"New",nLin         ,nColG2 ,bSetGet(TDt_Pro)   ,oPanel,40,8,;
                                       AVPict("W2_DT_PRO"),{||MFLAG:="Dt_Pro", PO557Val()   },,,oFntDlg,,,.F.,,,,,,,,,)// Substituido pelo assistente de conversao do AP5 IDE em 25/11/99 ==>                                        AVPict("W2_DT_PRO"),{||MFLAG:="Dt_Pro", Execute(PO557Val)   },,,oFntDlg,,,.F.,,,,,,,,,)
      oSend(V,"DISABLE")


      oSend(TSay(),"New",nLin:=nLin+1 ,nColS1,{|| STR0016      },oPanel,,oFntdlg,,,,.F. ) //"Terms of Payment"
   V:=oSend(TGet(),"New",nLin         ,nColG1 ,bSetGet(TCondPg)   ,oPanel,20,8,;
                                       AVPict("W2_COND_PA"),{||MFLAG:="CPagto", PO557Val()  },,,oFntDlg,,,.F.,,,,,,,,,)// Substituido pelo assistente de conversao do AP5 IDE em 25/11/99 ==>                                        AVPict("W2_COND_PA"),{||MFLAG:="CPagto", Execute(PO557Val)  },,,oFntDlg,,,.F.,,,,,,,,,)
      oSend(V,"DISABLE")


      oSend(TSay(),"New",nLin         ,nColS3,{|| "/"                     },oPanel,,oFntdlg,,,,.F. )
   V:=oSend(TGet(),"New",nLin         ,nColG4 ,bSetGet(TDiasPg)   ,oPanel,10,8,;
                                       AVPict("W2_DIAS_PA"),{||MFLAG:="CDiasPg", PO557Val()  },,,oFntDlg,,,.F.,,,,,,,,,)// Substituido pelo assistente de conversao do AP5 IDE em 25/11/99 ==>                                        AVPict("W2_DIAS_PA"),{||MFLAG:="CDiasPg", Execute(PO557Val)  },,,oFntDlg,,,.F.,,,,,,,,,)
      oSend(V,"DISABLE")

      oSend(TSay(),"New",nLin         ,nColS2,{|| STR0017             },oPanel,,oFntdlg,,,,.F. ) //"Forwarder"
   V:=oSend(TGet(),"New",nLin         ,nColG2 ,bSetGet(TAgente)   ,oPanel,10,8,;
                                       AVPict("W2_AGENTE"),{||MFLAG:="Agente", PO557Val()   },,,oFntDlg,,,.F.,,,,,,,,,"SY4")// Substituido pelo assistente de conversao do AP5 IDE em 25/11/99 ==>                                        AVPict("W2_AGENTE"),{||MFLAG:="Agente", Execute(PO557Val)   },,,oFntDlg,,,.F.,,,,,,,,,"SY4")
      oSend(V,"DISABLE")

      oSend(TSay(),"New",nLin:=nLin+1 ,nColS1,{|| STR0018               },oPanel,,oFntdlg,,,,.F. ) //"Country"
   V:=oSend(TGet(),"New",nLin         ,nColG1 ,bSetGet(TPais)   ,oPanel,50,8,,,,,oFntDlg,,,.F.,,,,,,,,,"SW2")
      oSend(V,"DISABLE")


      oSend(TSay(),"New",nLin         ,nColS2,{|| STR0019              },oPanel,,oFntdlg,,,,.F. ) //"Delivery"
   V:=oSend(TGet(),"New",nLin         ,nColG2 ,bSetGet(TTipo_Emb)   ,oPanel,10,8,;
                                       AVPict("W2_TIPO_EM"),{||MFLAG:="Embar", PO557Val()   },,,oFntDlg,,,.F.,,,,,,,,,"SYQ")// Substituido pelo assistente de conversao do AP5 IDE em 25/11/99 ==>                                        AVPict("W2_TIPO_EM"),{||MFLAG:="Embar", Execute(PO557Val)   },,,oFntDlg,,,.F.,,,,,,,,,"SYQ")
      oSend(V,"DISABLE")

      oSend(TSay(),"New",nLin, nColS4,{|| STR0023                  },oPanel,,oFntdlg,,,,.F. ) //"Total FOB"
      oSend(TSay(),"New",nLin, nColS5,{||  MTotal                      },oPanel,_PictPrUn,oFntdlg,,,,.F. )

     nTipoImp:=1

     @ 14, 212 TO 50, 280 TITLE STR0024  //"Sele��o" 

     aRad1 := {OemToAnsi(STR0025),OemToAnsi(STR0026)} //"Impressao  "###"Reimpressao  "
     @ 25,213 RADIO aRad1 VAR nTipoImp SIZE 50,10 of oPanel PIXEL Prompt aRad1[1],aRad1[2]  //LRL 11/02/04  

     oSend( SButton(), "New", 18,(oDlg:nClientWidth-4)/2-30 , 6 ,{||nOpcao:=1,oSend(oDlg,"End") }, oPanel, .T.,,)
     oSend( SButton(), "New", 31,(oDlg:nClientWidth-4)/2-30 , 2 ,{||nOpcao:=0,oSend(oDlg,"End") }, oPanel, .T.,,)

     oMark:=oSend(MsSelect(),"New","Work",,,TB_Campos,@lInverte,@cMarca,{70, 1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-4)/2})

   
     oDlg:lMaximized:=.T.
     oSend( oDlg, "Activate",,,,,,,{|| oPanel:Align:=CONTROL_ALIGN_TOP, oMark:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT}) //bInit )  
                                   //LRL 19/03/04 - Para alinhamento na vers�o MDI
     If nOpcao == 1
        Processa({|| PO557_REL()},STR0027) //"Processando Relatorio..."
        LOOP
     Endif

     If nOpcao == 0
        E_RESET_AREA
        Return .F.
     Endif

  ENDIF

END
RETURN .T.

*------------------------*
Static FUNCTION PO557Val()
*------------------------*
DO CASE
   CASE MFlag == "PO"
        IF EMPTY(TPO_Num)
           MSGINFO(OemToAnsi(STR0028),OemToAnsi(STR0009)) //"N�mero do P.O. deve ser preenchido"###"Informa��o"
           Return .F.
        Endif

        DBSELECTAREA("SW2")
        IF ! DBSEEK(xFilial("SW2")+TPO_Num)
           MSGINFO(OemToAnsi(STR0029),OemToAnsi(STR0009)) //"N�mero do P.O. n�o cadastrado"###"Informa��o"
           Return .F.
        Endif

        SW3->(DBSEEK(xFilial("SW3")+TPO_Num))
        IF SW3->W3_FLUXO == "5"
           MSGINFO(OemToAnsi(STR0029),OemToAnsi(STR0009)) //"N�mero do P.O. n�o cadastrado"###"Informa��o"
           Return .F.
        Endif

        TImport  := W2_IMPORT
        TNr_Pro  := W2_NR_PRO
        TId_Pro  := "P"
        IF EMPTY(W2_DT_PRO)
           TDt_Pro  := dDataBase
        ELSE
           TDt_Pro  := W2_DT_PRO
        ENDIF
        IF EMPTY(SW2->W2_EXPORTA)
           TCondPg  := SW2->W2_COND_PA
           TDiasPg  := SW2->W2_DIAS_PA
        ELSE
           TCondPg  := SW2->W2_COND_EX
           TDiasPg  := SW2->W2_DIAS_EX
        ENDIF
        TAgente  := SW2->W2_AGENTE
        TTipo_Emb:= SW2->W2_TIPO_EM

        SA2->(DBSETORDER(1))
        SA2->(DBSEEK(xFilial("SA2")+SW2->W2_FORN))
        SYA->(DBSETORDER(1))
        SYA->(DBSEEK(xFilial("SYA")+SA2->A2_PAIS))
        TPais:=ALLTRIM(SYA->YA_DESCR)+SPACE(10)

   CASE MFlag == "Import"

        IF EMPTY(TImport)
           MSGINFO(OemToAnsi(STR0030),OemToAnsi(STR0009)) //"C�digo do Importador deve ser informado"###"Informa��o"
           RETURN .F.
        ELSEIF ! SYT->(DBSEEK(xFilial("SYT")+TImport))
           MSGINFO(OemToAnsi(STR0031),OemToAnsi(STR0009)) //"C�digo do Importador n�o cadastrado"###"Informa��o"
           RETURN .F.
        ENDIF

   CASE MFlag == "Id_Pro"
        IF TId_Pro $ "PI"
           RETURN .T.
        ELSE
           MSGINFO(OemToAnsi(STR0032),OemToAnsi(STR0009)) //"Identifi��o inv�lida ( P - Proforma / I - Invoice)"###"Informa��o"
           RETURN .F.
        ENDIF

   CASE MFlag == "Dt_Pro"

        IF EMPTY(TDt_Pro)
           MSGINFO(STR0033,OemToAnsi(STR0009)) //"Data da Proforma deve ser informada"###"Informa��o"
           RETURN .F.
        ENDIF

   CASE MFlag == "CPagto"

        IF EMPTY( TCondPg )
           MSGINFO(OemToAnsi(STR0034),OemToAnsi(STR0009)) //"Condi��o de Pagamento deve ser informada"###"Informa��o"
           RETURN .F.
        ELSE
           IF ! SY6->(DBSEEK(xFilial("SY6")+TCondPg))
              MSGINFO(OemToAnsi(STR0035),OemToAnsi(STR0009)) //"Condi��o de Pagamento n�o cadastrada"###"Informa��o"
              RETURN .F.
           ENDIF
        ENDIF

   CASE MFlag == "CDiasPg"

        IF ! SY6->(DBSEEK(xFilial("SY6")+TCondPg+STR(TDiasPg,3,0)))
           MSGINFO(OemToAnsi(STR0036),OemToAnsi(STR0009)) //"Condi��o de Pagamento n�o encontrada"###"Informa��o"
           RETURN .F.
        ENDIF

   CASE MFlag == "Agente"
        IF EMPTY(TAgente)
           MSGINFO(OemToAnsi(STR0037),OemToAnsi(STR0009)) //"C�digo do Agente deve ser informado"###"Informa��o"
           RETURN .F.
        ELSE
           IF ! SY4->(DBSEEK(xFilial("SY4")+TAgente))
              MSGINFO(OemToAnsi(STR0038),OemToAnsi(STR0009)) //"Agente n�o cadastrado"###"Informa��o"
              RETURN .F.
           ENDIF
        ENDIF

   CASE MFlag == "Embar"
        IF ! SYQ->(DBSEEK(xFilial("SYQ")+TTipo_Emb))
             MSGINFO(OemToAnsi(STR0039),OemToAnsi(STR0009)) //"Via de Transporte n�o cadastrada"###"Informa��o"
             RETURN .F.
        ENDIF

   CASE MFlag == "Qtde"
        IF TQtde <= 0
           MSGINFO(STR0040,OemToAnsi(STR0009)) //"Quantidade deve ser maior que zero"###"Informa��o"
           RETURN .F.
        ENDIF
ENDCASE

RETURN .T.

*----------------------------*
Static FUNCTION PO557Grava()
*----------------------------*
DBSELECTAREA("Work")
ZAP

SW2->(DBSEEK(xFilial("SW2")+TPO_Num))
nTaxaRel:=1//BuscaTaxa(SW2->W2_MOEDA,SW2->W2_DT_PAR) // AWR - 28/06/2006 - A proforma tem que ser na moeda do Pedido e nao em Reais

SW3->(DBSEEK(xFilial("SW3")+TPO_Num))
MTotal:= 0

WHILE !SW3->(EOF()) .AND. SW3->W3_PO_NUM==TPO_Num .AND. SW3->W3_FILIAL==xFilial("SW3")

   MSProcTXT(STR0041+Tran(SW3->W3_COD_I,_PictItem)) //"Processamento Item   "

   IF SW3->W3_SEQ <> 0
      SW3->(DBSKIP())
      LOOP
   ENDIF

   SB1->(DBSEEK(xFilial("SB1")+SW3->W3_COD_I))
   SA5->(DBSEEK(xFilial("SA5")+SW3->W3_COD_I+SW3->W3_FABR+SW3->W3_FORN))

   Work->(DBAPPEND())
   Work->WKCOD_I := SW3->W3_COD_I
   Work->WKNET_W := B1Peso(SW3->W3_CC,SW3->W3_SI_NUM,SW3->W3_COD_I,SW3->W3_REG,SW3->W3_FABR,SW3->W3_FORN) * SW3->W3_QTDE    //  LDR - OS 1203/03
   Work->WKUNI   := BUSCA_UM(SW3->W3_COD_I+SW3->W3_FABR +SW3->W3_FORN,SW3->W3_CC+SW3->W3_SI_NUM)//SO.:00022/02 OS.:0149/02 IF(! EMPTY(SA5->A5_UNID),SA5->A5_UNID,SB1->B1_UM)
   Work->WKQTDE  := SW3->W3_QTDE
   Work->WKFABR  := SW3->W3_FABR
   Work->WKFORN  := SW3->W3_FORN
   Work->WKFLAG  := cMarca
   Work->WKRECNO := SW3->(RECNO())
   Work->WKPRECO := SW3->W3_PRECO * nTaxaRel//IF(SW2->W2_PARID_U==0,1,SW2->W2_PARID_U)
   Work->WKAMOUNT:= SW3->W3_QTDE * ( SW3->W3_PRECO * nTaxaRel/*IF(SW2->W2_PARID_U==0,1,SW2->W2_PARID_U)*/ )
   Work->WKDESCR := MSMM( SB1->B1_DESC_GI,26,1 )

   MTotal:= MTotal + WKAMOUNT
   SW3->(DBSKIP())
END

DBGOTOP()
IF EOF() .AND. BOF()
   MSGINFO(OemToAnsi(STR0042),OemToAnsi(STR0009)) //"N�O EXISTEM REGISTROS PARA ESTE P.O."###"Informa��o"
ENDIF
Return .T.


*--------------------------*
Static FUNCTION PO557_REL()
*--------------------------*
LOCAL cMoeDolar:=GETMV("MV_SIMB2",,"US$"), W, I
nNetWeight := 0
mDescri    := ""
I          := 0
aVetor     := {}
W          := 0
cEndSA2    := ""
lComissaoRetida:=.F.
nVal_Com   := SW2->W2_VAL_COM
cNomeBanco := ""

nTaxaRel:=1//BuscaTaxa(SW2->W2_MOEDA,SW2->W2_DT_PAR)// AWR - 28/06/2006 - A proforma tem que ser na moeda do Pedido e nao em Reais

//IF nTipoImp == 1
//   cAlias:=ALIAS()
//   Reclock("SW2",.F.)
//   SW2->W2_PARID_U:= (BuscaTaxa(W2_MOEDA,TDt_Pro) / BuscaTaxa("US$",TDt_Pro)) + nSpread
//   SW2->W2_DT_PRO := TDt_Pro
//   DBSELECTAREA(cAlias)
//ENDIF

SY6->(DBSEEK(xFilial("SY6")+TCondPg+STR(TDiasPg,3,0)))

cPayment:=""
cPayment:=MSMM(SY6->Y6_DESC_I ,48 )
STRTRAN(cPayment,CHR(13)+CHR(10)," ")

SYT->(DBSETORDER(1))
SYT->(DBSEEK(xFilial("SYT")+TImport))

SW3->(DBSEEK(xFilial("SW3")+TPO_Num))
IF EMPTY(SW2->W2_EXPORTA)
   cEXPORTA:=SW2->W2_FORN
ELSE
   cEXPORTA:=SW2->W2_EXPORTA
ENDIF

cFORN    :=SW2->W2_FORN
dDataAtu :=TDt_Pro
dDataShip:=SW3->W3_DT_EMB
nLi_Ini  := 0
nLi_Fim  := 0
nLi_Fim2 := 0

AVPRINT oPrn NAME STR0043 //"Proforma Invoice"
   oPrn:Rebuild()
   ProcRegua(5+WORK->(LASTREC()))

   DEFINE FONT oFont1  NAME "Times New Roman"    SIZE 0,12           OF oPrn
   DEFINE FONT oFont2  NAME "Times New Roman"    SIZE 0,14  BOLD     OF oPrn

   aFontes := { oFont1, oFont2 }

   AVPAGE

        IncProc(STR0044) //"Imprimindo..."

        PO557CAB_INI()

        nLi_Ini:=nLinha

        PO557_CAB2()

        WHILE !SW3->(EOF()) .AND. SW3->W3_FILIAL==xFilial("SW3") .AND. ;
                                  SW3->W3_PO_NUM==TPO_Num
           IF SW3->W3_SEQ <> 0
              SW3->(DBSKIP())
              LOOP
           ENDIF

           IncProc(STR0044) //"Imprimindo..."
           SysRefresh()
           PARTE2:=1
           PO557VERFIM()
           SB1->(DBSEEK(xFilial("SB1")+SW3->W3_COD_I))
           SA5->(DBSEEK(xFilial("SA5")+SW3->W3_COD_I+SW3->W3_FABR+SW3->W3_FORN))
           SYG->(DBSEEK(xFilial("SYG")+SW2->W2_IMPORT+SW3->W3_FABR+SW3->W3_COD_I))

           mDescri := ""
           mDescri := MSMM(SB1->B1_DESC_GI,48)
           STRTRAN(mDescri,CHR(13)+CHR(10)," ")

           oPrn:Say( nLinha:=nLinha+20,360  ,TRANS(SW3->W3_QTDE,E_TrocaVP(1,_PictQtde)),aFontes:TIMES_NEW_ROMAN_12,,,,1 )
           oPrn:Say( nLinha           ,420  ,MEMOLINE(mDescri,30,1),aFontes:TIMES_NEW_ROMAN_12)
           oPrn:Say( nLinha           ,1710 ,trans(SW3->W3_PRECO*nTaxaRel /*IF(SW2->W2_PARID_U==0,1,SW2->W2_PARID_U)*/,E_TrocaVP(1,_PictPrUn)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
           oPrn:Say( nLinha           ,2190 ,trans(SW3->W3_QTDE*(SW3->W3_PRECO* nTaxaRel/*IF(SW2->W2_PARID_U==0,1,SW2->W2_PARID_U)*/),E_TrocaVP(1,_PictPrTot)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
           nNetWeight := nNetWeight + val(trans(SW3->W3_QTDE*B1Peso(SW3->W3_CC,SW3->W3_SI_NUM,SW3->W3_COD_I,SW3->W3_REG,SW3->W3_FABR,SW3->W3_FORN),"99999999999.999"))     //  LDR - OS 1203/03


           FOR W:=2 TO (LEN(mDescri)/30)+1
               SysRefresh()
               IF ! EMPTY(memoline(mDescri,30,W))
                  PARTE2:=2
                  PO557VERFIM()
                  oPrn:Say( nLinha:=nLinha+50,420  ,memoline(mDescri,30,W),aFontes:TIMES_NEW_ROMAN_12,,,1)
               ENDIF
           NEXT

           SysRefresh()
           IF ! EMPTY(ALLTRIM(SA5->A5_CODPRF))
              PARTE2:=2
              PO557VERFIM()
              oPrn:Say( nLinha:=nLinha+50,420 ,ALLTRIM(SA5->A5_CODPRF),aFontes:TIMES_NEW_ROMAN_12,,,1)
           ENDIF
           IF ! EMPTY(ALLTRIM(SA5->A5_PARTOPC))
              FOR W:=1 TO (LEN(ALLTRIM(SA5->A5_PARTOPC))/30)+1
                  IF ! EMPTY(memoline(ALLTRIM(SA5->A5_PARTOPC),30,W))
                     PARTE2:=2
                     PO557VERFIM()
                     oPrn:Say( nLinha:=nLinha+50,420  ,memoline(ALLTRIM(SA5->A5_PARTOPC),30,W),aFontes:TIMES_NEW_ROMAN_12,,,1)
                  ENDIF
              NEXT
           ENDIF
           IF ! EMPTY(ALLTRIM(SYG->YG_REG_MIN))
              PARTE2:=2
              PO557VERFIM()
              oPrn:Say( nLinha:=nLinha+50,420 ,ALLTRIM(SYG->YG_REG_MIN),aFontes:TIMES_NEW_ROMAN_12,,,1)
           ENDIF
           PARTE2:=2
           PO557VERFIM()
           oPrn:Say( nLinha:=nLinha+50,420  ,STR0045+alltrim(trans(SW3->W3_QTDE*B1Peso(SW3->W3_CC,SW3->W3_SI_NUM,SW3->W3_COD_I,SW3->W3_REG,SW3->W3_FABR,SW3->W3_FORN),"@ 99,999,999.999"))+" KGS",aFontes:TIMES_NEW_ROMAN_12) //"NET WEIGHT:"    //  LDR - OS 1203/03

           oPrn:Line( nLinha:=nLinha+50 , 110, nLinha  , 2240  )
           oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )

           oPrn:Box( nLi_Ini , 110 , nLinha , 113  )

           oPrn:Box( nLi_Ini , 370 , nLinha , 373  )
           oPrn:Box( nLi_Ini , 1400, nLinha , 1403 )

           oPrn:Box( nLi_Ini , 1750, nLinha , 1753 )
           oPrn:Box( nLi_Ini , 2240, nLinha , 2242 )


           SysRefresh()
           IF ASCAN(aVetor,SW3->W3_FABR) == 0
              AADD(aVetor,SW3->W3_FABR)
           ENDIF
           SW3->(DBSKIP())
        END

        SysRefresh()
        PARTE2:=2
        lBateBox:=.F.
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+20, 130  ,STR0046 ,aFontes:TIMES_NEW_ROMAN_12) //"SUB TOTAL "
        oPrn:Say( nLinha    ,2190 ,trans(SW2->W2_FOB_TOT* nTaxaRel/*SW2->W2_PARID_U*/,E_TrocaVP(1,_PictPrTot)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
        PARTE2:=2
        lBateBox:=.F.
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+50, 130  ,STR0047,aFontes:TIMES_NEW_ROMAN_12) //"INTERNATIONAL FREIGHT"
        oPrn:Say( nLinha    ,2190 ,trans(SW2->W2_FRETEIN* nTaxaRel/*SW2->W2_PARID_U*/,E_TrocaVP(1,_PictPrTot)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
        PARTE2:=2
        lBateBox:=.F.
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+50, 130  ,STR0048 ,aFontes:TIMES_NEW_ROMAN_12) //"INLAND"
        oPrn:Say( nLinha    ,2190 ,trans(SW2->W2_INLAND* nTaxaRel/*SW2->W2_PARID_U*/,E_TrocaVP(1,_PictPrTot)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
        PARTE2:=2
        lBateBox:=.F.
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+50, 130  ,STR0049 ,aFontes:TIMES_NEW_ROMAN_12) //"PACKING"
        oPrn:Say( nLinha    ,2190 ,trans(SW2->W2_PACKING* nTaxaRel/*SW2->W2_PARID_U*/,E_TrocaVP(1,_PictPrTot)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
        PARTE2:=2
        lBateBox:=.F.
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+50, 130  ,STR0050,aFontes:TIMES_NEW_ROMAN_12) //"DISCOUNT"
        oPrn:Say( nLinha    ,2190 ,trans(SW2->W2_DESCONT* nTaxaRel/*SW2->W2_PARID_U*/,E_TrocaVP(1,_PictPrTot)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
        PARTE2:=2
        lBateBox:=.F.
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+50, 130  ,STR0051+SW2->W2_INCOTER ,aFontes:TIMES_NEW_ROMAN_12) //"TOTAL "
        oPrn:Say( nLinha    ,2190 ,trans((SW2->W2_FOB_TOT+SW2->W2_FRETEIN+SW2->W2_INLAND+SW2->W2_PACKING-SW2->W2_DESCONT)* nTaxaRel/*SW2->W2_PARID_U*/,E_TrocaVP(1,_PictPrTot)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
        nLi_Fim2:=(nLinha+50)

        SysRefresh()
        lBateBox:=.F.
        PO557FIM()

        PARTE2:=0
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+90 ,110  ,STR0052+trans(nNetWeight,"@ 99,999,999.999")+" KGS",aFontes:TIMES_NEW_ROMAN_12) //"NET WEIGHT: "

        PARTE2:=0
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+90 ,110  ,STR0053,aFontes:TIMES_NEW_ROMAN_12) //"PRODUCER(S)"
        FOR I:=1 TO LEN(aVetor)
            SysRefresh()
            SA2->(DBSEEK(xFILIAL("SA2")+aVetor[I]))
            PARTE2:=0
            PO557VERFIM()
            oPrn:Say( nLinha:=nLinha+70 ,110  ,SA2->A2_NOME ,aFontes:TIMES_NEW_ROMAN_12)
            PARTE2:=0
            PO557VERFIM()
            oPrn:Say( nLinha:=nLinha+50 ,110  ,SA2->A2_END,aFontes:TIMES_NEW_ROMAN_12 )
            PARTE2:=0
            PO557VERFIM()
            oPrn:Say( nLinha:=nLinha+50 ,110  ,SA2->A2_BAIRRO,aFontes:TIMES_NEW_ROMAN_12 )
            PARTE2:=0
            PO557VERFIM()
            oPrn:Say( nLinha:=nLinha+50 ,110  ,ALLTRIM(SA2->A2_MUN)+" / "+SA2->A2_ESTADO ,aFontes:TIMES_NEW_ROMAN_12)
            PARTE2:=0
            PO557VERFIM()
            oPrn:Say( nLinha:=nLinha+50 ,110  ,TRANS(SA2->A2_CEP,"@R 99.999-999" ), aFontes:TIMES_NEW_ROMAN_12)
        NEXT


        SA2->(DBSEEK(xFilial("SA2")+cFORN))
        PARTE2:=0
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+90 ,110  ,STR0054,aFontes:TIMES_NEW_ROMAN_12) //"AGENT IN BRAZIL"

        IF EMPTY(SA2->A2_REPRES)
           oPrn:Say( nLinha:=nLinha+50 ,110  ,STR0055,aFontes:TIMES_NEW_ROMAN_12) //"*** NONE ***"
        ELSE
           lComissaoRetida:=.T.
                PARTE2:=0
                PO557VERFIM()
           oPrn:Say( nLinha:=nLinha+50 ,110 , SA2->A2_REPRES ,aFontes:TIMES_NEW_ROMAN_12)
           IF ! EMPTY(SA2->A2_REPR_EN)
              oPrn:Say( nLinha:=nLinha+50 ,110 , SA2->A2_REPR_EN,aFontes:TIMES_NEW_ROMAN_12)
           ENDIF
        ENDIF

        PARTE2:=0
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+90 ,110  ,STR0056,aFontes:TIMES_NEW_ROMAN_12) //"AGENT'S COMMISSION"

        IF !SW2->W2_COMIS $ cSim
           oPrn:Say( nLinha:=nLinha+50 ,110  ,STR0055,aFontes:TIMES_NEW_ROMAN_12) //"*** NONE ***"
        ELSE
           IF SW2->W2_TIP_COM == "1"
              oPrn:Say( nLinha:=nLinha+50 ,110 , trans(SW2->W2_PER_COM,"@ 9,999.99")+"%" ,aFontes:TIMES_NEW_ROMAN_12)
           ELSEIF SW2->W2_TIP_COM $ "2,3"
              If SW2->W2_MOEDA # cMoeDolar
                 nVal_Com := ( SW2->W2_VAL_COM * nTaxaRel/*SW2->W2_PARID_U*/ )
              EndIf
              oPrn:Say( nLinha:=nLinha+50 ,110 ,cMoeDolar+trans(nVal_Com,"@ 999,999,999.99"),aFontes:TIMES_NEW_ROMAN_12 )
           ELSEIF SW2->W2_TIP_COM == "4"
              oPrn:Say( nLinha:=nLinha+50 ,110 , SW2->W2_OUT_COM ,aFontes:TIMES_NEW_ROMAN_12)
           ENDIF

           SA6->( DbSetOrder( 1 ) )
           If SA6->( DbSeek( xFilial()+SA2->A2_REPR_BA+SA2->A2_REPR_AG ) )
              cNomeBanco := Alltrim(SA6->A6_NOME) + " "
           EndIf

           oPrn:Say( nLinha:=nLinha+50 ,110 , STR0057 + SA2->A2_REPR_BA + "  " + cNomeBanco + ; //"Bank: "
                                       STR0058 + SA2->A2_REPR_AG + "  " + ; //"Agency: "
                                       STR0059 + SA2->A2_REPR_CO, aFontes:TIMES_NEW_ROMAN_12) //"Account: "
        ENDIF


        PARTE2:=0
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+90 ,110 , STR0060, aFontes:TIMES_NEW_ROMAN_12) //"THE INDICATED PRICES ARE THE CURRENT PRICES FOR EXPORT."
        PARTE2:=0
        PO557VERFIM()
        oPrn:Say( nLinha:=nLinha+50 ,110 , STR0061, aFontes:TIMES_NEW_ROMAN_12) //"WE STATE ALSO THAT THERE ARE NO CATALOGS OR PRICE LISTS."

        IF ! EMPTY(aMsg[1]+aMsg[2]+aMsg[3]+aMsg[4]+aMsg[5])
           oPrn:Say( nLinha:=nLinha+70, 110 , "",aFontes:TIMES_NEW_ROMAN_12)
           FOR I:=1 TO 5
               IF ! EMPTY(aMsg[I])
                  PARTE2:=0
                  PO557VERFIM()
                  oPrn:Say( nLinha, 110, aMsg[I],aFontes:TIMES_NEW_ROMAN_12)
                  nLinha:=nLinha+50
               ENDIF
           NEXT
        ENDIF

        IF nLinha >= 2800
           AVNEWPAGE
           PO557CAB_INI()
        ENDIF
        SA2->(DBSEEK(xFilial("SA2")+cEXPORTA))
        cEndSA2 := ""
        cEndSA2 := cEndSA2+IF( !EMPTY(SA2->A2_END)    , ALLTRIM(SA2->A2_END)+", "+ALLTRIM(SA2->A2_NR_END)+" - ", " " )
        cEndSA2 := cEndSA2+IF( !EMPTY(SA2->A2_BAIRRO) , ALLTRIM(SA2->A2_BAIRRO) +" - ", "" )
        cEndSA2 := cEndSA2+IF( !EMPTY(SA2->A2_MUN)    , ALLTRIM(SA2->A2_MUN)    +" / ", "" )
        cEndSA2 := cEndSA2+IF( !EMPTY(SA2->A2_ESTADO) , ALLTRIM(SA2->A2_ESTADO) +"   ", " " )
        cEndSA2 := LEFT( cEndSA2, LEN(cEndSA2)-2 )

        oPrn:Say( nLinha:=nLinha+120,1120 , ALLTRIM(SA2->A2_NOME) ,aFontes:TIMES_NEW_ROMAN_12,,,,2)
        oPrn:Say( nLinha:=nLinha+50 ,1120 , STR0062,aFontes:TIMES_NEW_ROMAN_12,,,,2) //"Correspondence Address"
        oPrn:Say( nLinha:=nLinha+50 ,1120 , cEndSA2,aFontes:TIMES_NEW_ROMAN_12,,,,2)

        IncProc(STR0044) //"Imprimindo..."

   AVENDPAGE

AVENDPRINT

oFont1:End()
oFont2:End()

IF nTipoImp == 1
   MsAguarde({||Po557Grava()},STR0021) //"Pesquisando informa��es..."

   @ 8.8,57 SAY MTotal PICTURE _PictPrUn
ENDIF
DBSELECTAREA("Work")
RETURN NIL

*------------------------------*
Static FUNCTION PO557VERFIM()
*------------------------------*
lBateBox:=IF(lBateBox=NIL,.T.,.F.)
SysRefresh()
IF nLinha >= 2900
   IF PARTE2 > 0
      IF PARTE2 == 1
         nLi_Fim2:=nLinha
      ELSE
         nLi_Fim2:=(nLinha+50)
         nLi_Fim:=0
      ENDIF
      PO557FIM()
   ENDIF

   SysRefresh()
   AVNEWPAGE

   PO557CAB_INI()

   IF PARTE2 > 0
      nLi_Fim:=nLi_Fim2:=nLi_Ini:=nLinha
      PO557_CAB2()
   ENDIF
   RETURN .T.
ENDIF
RETURN .F.

*----------------------------*
Static FUNCTION PO557_CAB2()
*----------------------------*
SysRefresh()
oPrn:Line(nLinha            , 110, nLinha  , 2240 )
oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )
oPrn:Box( nLinha            , 110 , nLinha+60 , 111 )
oPrn:Box( nLinha            , 370 , nLinha+60 , 371  )
oPrn:Box( nLinha            , 1400, nLinha+60 , 1401 )
oPrn:Box( nLinha            , 1750, nLinha+60 , 1751 )
oPrn:Box( nLinha            , 2240, nLinha+60 , 2241 )
oPrn:Say( nLinha:=nLinha+10 , 180 ,STR0063,aFontes:TIMES_NEW_ROMAN_12 ) //"QTY."
oPrn:Say( nLinha            , 650 ,STR0005,aFontes:TIMES_NEW_ROMAN_12 ) //"DESCRIPTION"
oPrn:Say( nLinha            , 1420,STR0006+SW2->W2_MOEDA,aFontes:TIMES_NEW_ROMAN_12 ) //"UNIT US$ "//ASR 27/01/2006 - oPrn:Say( nLinha            , 1480,STR0006+SW2->W2_MOEDA,aFontes:TIMES_NEW_ROMAN_12 )
oPrn:Say( nLinha            , 1880,STR0051+SW2->W2_MOEDA,aFontes:TIMES_NEW_ROMAN_12 ) //"TOTAL US$"
oPrn:Line(nLinha:=nLinha+50 , 110, nLinha  , 2240 )
oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )
SysRefresh()
RETURN NIL

*--------------------------*
Static FUNCTION PO557FIM()
*--------------------------*
lBateBox:=IF(lBateBox==NIL,.T.,lBateBox)
oPrn:Box( nLi_Fim2, 110 , nLi_Fim2+1 , 2240)
oPrn:Box( nLi_Ini , 110 , nLi_Fim2   , 113 )

IF lBateBox
   oPrn:Box( nLi_Ini , 370 , IF(nLi_Fim==0,nLi_Fim2,nLi_Fim) , 373  )
   oPrn:Box( nLi_Ini , 1400, IF(nLi_Fim==0,nLi_Fim2,nLi_Fim) , 1403 )
ENDIF

oPrn:Box( nLi_Ini , 1750, nLi_Fim2   , 1753 )
oPrn:Box( nLi_Ini , 2240, nLi_Fim2   , 2242 )
RETURN NIL

*----------------------------*
Static FUNCTION PO557CAB_INI()
*----------------------------*
nLinha:=100
Pagina:=Pagina+1

SA2->(DBSEEK(xFilial("SA2")+cEXPORTA))
oPrn:Say( nLinha, 110,SA2->A2_NOME,aFontes:TIMES_NEW_ROMAN_12 )
oPrn:Say( nLinha, 1450,STR0043, aFontes:TIMES_NEW_ROMAN_14_BOLD ) //"PROFORMA INVOICE"

oPrn:Box( nLinha:=nLinha+90 , 110  , nLinha+400, 1030 )

oPrn:Say( nLinha            , 1120 , STR0066+SW2->W2_PO_NUM,aFontes:TIMES_NEW_ROMAN_12 ) //"REF.: "

oPrn:Say( nLinha:=nLinha+30 , 130  , memoline(SYT->YT_NOME,30,1),aFontes:TIMES_NEW_ROMAN_12 )
oPrn:Say( nLinha:=nLinha+20 , 1120 , STR0067+DATA_ATUAL ,aFontes:TIMES_NEW_ROMAN_12) //"DATE: "

oPrn:Say( nLinha:=nLinha+20 , 130  , memoline(SYT->YT_NOME,30,2),aFontes:TIMES_NEW_ROMAN_12 )
nLinha:=nLinha+10 //30

oPrn:Say( nLinha+30  , 130  , memoline(SYT->YT_ENDE,30,1),aFontes:TIMES_NEW_ROMAN_12 )
oPrn:Say( nLinha+80  , 130  , memoline(SYT->YT_ENDE,30,2),aFontes:TIMES_NEW_ROMAN_12 )
oPrn:Say( nLinha+130 , 130  , ALLTRIM(SYT->YT_CIDADE)+"-"+ALLTRIM(SYT->YT_ESTADO)+"-"+ALLTRIM(SYT->YT_PAIS),aFontes:TIMES_NEW_ROMAN_12 )
oPrn:Say( nLinha+180 , 130  , TRANS(SYT->YT_CEP,"@R 99.999-999" ),aFontes:TIMES_NEW_ROMAN_12 )
oPrn:Say( nLinha+230 , 130  , AVSX3("YT_CGC",5) +": "+ Trans(SYT->YT_CGC,AVSX3("YT_CGC",6)),aFontes:TIMES_NEW_ROMAN_12 ) //"C.G.C.: "

oPrn:Say( nLinha:=nLinha+20 , 1120 , STR0043+".: ",aFontes:TIMES_NEW_ROMAN_12 ) //"Nro. Prof."
oPrn:Say( nLinha, 1420 , TNr_Pro,aFontes:TIMES_NEW_ROMAN_12 ) //"Nro. Prof."

oPrn:Say( nLinha:=nLinha+50 , 1120 , STR0069,aFontes:TIMES_NEW_ROMAN_12 ) //"PAYMENT:"
W:=1
nLinPay := 0
WHILE nLinPay <= 6 .AND. W <= MLCOUNT(cPayment,36)
   IF !EMPTY(memoline(cPayment,40,W))
      oPrn:Say( nLinha, 1370 , memoline(cPayment,40,W),aFontes:TIMES_NEW_ROMAN_12 )
      nLinPay:=nLinPay+1
      nLinha:=nLinha+50
   ENDIF
   W:=W+1
END

nLinha:=nLinha+ (7-nLinPay) * 50

oPrn:Line( nLinha:=nLinha+120, 110, nLinha  , 2240 )
oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )

oPrn:Say( nLinha:=nLinha+60 , 1450 , STR0070+dtoc(dDataShip),aFontes:TIMES_NEW_ROMAN_12 ) //"SHIPPING DATE: "

SY9->(DBSETORDER(2))
SY9->(DBSEEK(xFilial("SY9")+ SW2->W2_DEST))
oPrn:Say( nLinha:=nLinha+50 , 110 , STR0071+ SY9->Y9_DESCR,aFontes:TIMES_NEW_ROMAN_12 ) //"DISCHARGE PORT.: "
SY9->(DBSETORDER(1))

nLinha:=nLinha+90
oSend( oPrn, "Say",  3100 ,1900, STR0072+STR(PAGINA,8),aFontes:TIMES_NEW_ROMAN_12 ) //"Page.:"

RETURN NIL
