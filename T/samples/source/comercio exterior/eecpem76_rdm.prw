
#include "EECRDM.CH"
#include "EECPEM76.CH"

/*
Funcao      : EECPEM76
Parametros  : Nenhum
Retorno     : lRet (.T.) - Se for Confirmado
                   (.F.) - Se for Cancelado
Objetivos   : Impressao do Packing List
Autor       : Eduardo C. Romanini
Data/Hora   : 12/02/2008 15:30
Obs.        : Utiliza o arquivo Pem76.rpt
*/
*----------------------*
User Function EECPEM76()
*----------------------*
Local lRet    := .T.
Local nAlias  := Select()
Local aOrd    := SaveOrd({"EX9","EYH"})

Private cArqRpt := "PEM76.RPT"
Private cTitRpt := STR0001//"Impress�o do Packing List"

Private cUnidad   := "KG"
Private cUnidDe   := "KG"
Private cAssNome  := Space(60)
Private cAssEmp   := Space(60)
Private cAssCargo := Space(60)

Begin Sequence
   
   //Unidade de Medida considerada na Estufagem
   If !Empty(EEC->EEC_UNIDAD)
      cUnidDe := EEC->EEC_UNIDAD
   EndIf
   
   //Tela de Par�metros Iniciais
   If !TelaGets()
      lRet := .F.
      Break
   EndIf
    
   cSeqRel :=GetSXENum("SY0","Y0_SEQREL")
   ConfirmSX8()
 
   //Grava��o dos Dados
   If !GravaDados()
      lRet := .F.
      Break
   EndIf
   
   //Grava��o do Hist�rico
   HEADER_P->(DbGoTop())
   Do While !HEADER_P->(Eof())
      HEADER_H->(dbAppend())
      AvReplace("HEADER_P","HEADER_H") 
      HEADER_P->(DbSkip())
   EndDo   

   DETAIL_P->(DbGoTop())
   Do While !DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo   

End Sequence

RestOrd(aOrd)
Select(nAlias)

Return lRet 

/*
Funcao      : TelaGets()
Parametros  : Nenhum
Retorno     : lRet (.T.) - Se for Confirmado
                   (.F.) - Se for Cancelado
Objetivos   : Exibi��o da tela de parametros
Autor       : Eduardo C. Romanini
Data/Hora   : 12/02/2008 15:30
Obs.        : 
*/
*------------------------*
Static Function TelaGets()
*------------------------*
Local lRet := .F.

Local bOk     := {|| lRet := .T., oDlg:End()}
Local bCancel := {|| oDlg:End()}

Local oFld, oDlg, oFldDoc

Begin Sequence
                         	
   //Assinatura
   If !Empty(EEC->EEC_RESPON)
      cAssNome  := IncSpace(AllTrim(Upper(EEC->EEC_RESPON)),60,.F.) //Nome
   EndIf
    
   cAssEmp   := IncSpace(AllTrim(Upper(SM0->M0_NOMECOM)),60,.F.) //Empresa
   
   EE3->(DbSetOrder(2))
   If EE3->(DbSeek(xFilial("EE3")+EEC->EEC_RESPON))
      cAssCargo := IncSpace(Alltrim(Upper(EE3->EE3_CARGO)),60,.F.) //Cargo
   EndIf 
  
   DEFINE MSDIALOG oDlg TITLE STR0002 FROM 9,0 TO 20,50 OF oMainWnd //"Packing List"
   
     oFld := TFolder():New(15,1,{STR0003,STR0004},{"PAR","ASS"},oDlg,,,,.T.,.F.,200,90) //"Parametros","Assinatura"

     aEval(oFld:aControls,{|x| x:SetFont(oDlg:oFont)})

     //Folder Par�metros
     oFldDoc := oFld:aDialogs[1] 

     @ 06,05 TO 55,190 LABEL STR0005 OF oFldDoc PIXEL //"Detalhes"
     @ 15,10 SAY STR0006 OF oFldDoc PIXEL //"Unidade de Medida"
     @ 15,65 MSGET cUnidad  SIZE 20,07 F3 "SAH"  VALID (NaoVazio() .and. ExistCpo("SAH")) OF oFldDoc PIXEL 
     
     //Folder Assinatura
     oFldDoc := oFld:aDialogs[2]     

     @ 06,05 TO 55,190 LABEL STR0005 OF oFldDoc PIXEL //"Detalhes"

     @ 15,10 SAY STR0007 OF oFldDoc PIXEL //"Respons�vel"
     @ 15,65 MSGET cAssNome SIZE 120,07 OF oFldDoc PIXEL 

     @ 25,10 SAY STR0008 OF oFldDoc PIXEL //"Empresa"
     @ 25,65 MSGET cAssEmp SIZE 120,07 OF oFldDoc PIXEL 

     @ 35,10 SAY STR0009 OF oFldDoc PIXEL //"Cargo"
     @ 35,65 MSGET cAssCargo SIZE 120,07 OF oFldDoc PIXEL 
     
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,bOk,bCancel))

End Sequence

Return lRet

/*
Funcao      : GravaDados()
Parametros  : Nenhum
Retorno     : lRet (.T.) - Se for gravado corretamente
                   (.F.) - Se n�o for gravado corretamente.
Objetivos   : Grava��o dos Dados de Capa e Detalhe.
Autor       : Eduardo C. Romanini
Data/Hora   : 12/02/2008 15:30
Obs.        : 
*/
*--------------------------*
Static Function GravaDados()
*--------------------------*
Local lRet        := .T.

Local n           := 0
Local nInc        := 0
Local nInc2       := 0
Local nIncCont    := 0
Local nPesoLqTo   := 0
Local nPesoBrTo   := 0
Local nPesLiq     := 0
Local nPesBru     := 0
Local nPallet     := 0
Local nTotCont    := 0
Local nContPallet := 0
Local nTotEmb     := 0
Local nTotPallet  := 0
Local nRecEYH     := 0
Local nLinha      := 0

Local cPalletID   := ""

Local aItens      := {}
Local aPallet     := {}
Local aEmbExt     := {}

Begin Sequence
 
   EX9->(DbSetOrder(1))
   
   //Looping nos Containers para retornar a quantidade total do Embarque.
   EX9->(DbSeek(xFilial("EX9")+EEC->EEC_PREEMB))
   While EX9->(!EOF()) .and. EX9->(EX9_FILIAL+EX9_PREEMB) == xFilial("EX9")+EEC->EEC_PREEMB
      
      nTotCont ++ //Total de Container

      EYH->(DbSetOrder(3))
      EYH->(DbSeek(xFilial("EYH")+"S"+EEC->EEC_PREEMB+EX9->EX9_ID))
      While EYH->(!Eof() .And. EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC == xFilial("EYH")+"S"+EEC->EEC_PREEMB+EX9->EX9_ID)

         If EYH->EYH_PLT == "S" //Verifica se � Pallet
            
            nTotPallet += EYH->EYH_QTDEMB //Total de Pallets
            
            nRecEYH := EYH->(RecNo())
            
            cPalletID := EYH->EYH_ID 
         
            //Posiciona o registro na Embalagem externa dentro do Pallet.
            EYH->(DbSetOrder(3))
            EYH->(DbSeek(xFilial("EYH")+"S"+EEC->EEC_PREEMB+cPalletID))
            While EYH->(!Eof() .And. EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC == xFilial("EYH")+"S"+EEC->EEC_PREEMB+cPalletID)           
               nTotEmb += EYH->EYH_QTDEMB //Total de Embalagens Externas dentro do Pallet              
               EYH->(DbSkip())
            EndDo

            EYH->(DbGoTo(nRecEYH))
         Else
            nTotEmb += EYH->EYH_QTDEMB //Total de Embalagens Externas fora do Pallet
         EndIf
       
         EYH->(DBSkip())
      EndDo

      EX9->(DbSkip())
   EndDo
   
   //Verifica se existe embalagem estufada
   If nTotEmb == 0
      MsgInfo(STR0010,STR0011)//"N�o foram encontrados dados para impress�o."###"Aten��o"
      lRet := .F.
      Break
   EndIf
   
   //Refaz o Looping nos containers para grava��o dos dados
   EX9->(DbSeek(xFilial("EX9")+EEC->EEC_PREEMB))
   While EX9->(!EOF()) .and. EX9->(EX9_FILIAL+EX9_PREEMB) == xFilial("EX9")+EEC->EEC_PREEMB
 
      nIncCont    := 1
      nPesoLqTo   := 0
      nPesoBrTo   := 0
      nContPallet := 0
      nLinha      := 0
      
      aPallet := {}
      aEmbExt := {}
      aItens  := {}
 
      HEADER_P->(DbAppend())
      
      HEADER_P->AVG_FILIAL := xFilial("SY0")
      HEADER_P->AVG_CHAVE  := EX9->EX9_CONTNR
      HEADER_P->AVG_SEQREL := cSeqRel
      
      //C�digo do Embarque (Commercial Invoice)
      HEADER_P->AVG_C02_20 := Alltrim(EX9->EX9_PREEMB)
      
      //Fornecedor
      SA2->(DbSetOrder(1))
      If SA2->(DbSeek(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
         
         HEADER_P->AVG_C01_60 := Alltrim(SA2->A2_NOME) //Nome
         
         HEADER_P->AVG_C02_60 := AllTrim(SA2->A2_END)  //Endere�o
         
         If !Empty(SA2->A2_NR_END)
            HEADER_P->AVG_C02_60 += ", " + AllTrim(SA2->A2_NR_END) //N�mero
         EndIf
         
         HEADER_P->AVG_C03_60 := Alltrim(SA2->A2_MUN) + " - " + AllTrim(SA2->A2_EST) //Cidade - Estado

         //Pais
         If !Empty(SA2->A2_PAIS)
            SYA->(DbSetOrder(1))
            If SYA->(DbSeek(xFilial("SYA")+SA2->A2_PAIS))
               HEADER_P->AVG_C03_60 += " - " + AllTrim(SYA->YA_DESCR) //Descri��o
            EndIf
         EndIf
      
      EndIf
      
      //Importador
      SA1->(DbSetOrder(1))
      If SA1->(DbSeek(xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
         
         HEADER_P->AVG_C04_60 := Alltrim(SA1->A1_NOME) //Nome
         
         HEADER_P->AVG_C05_60 := AllTrim(SA1->A1_END)  //Endere�o
         
         HEADER_P->AVG_C06_60 := Alltrim(SA1->A1_MUN) + " - " + AllTrim(SA1->A1_EST) //Cidade - Estado

         //Pais
         If !Empty(SA1->A1_PAIS)
            SYA->(DbSetOrder(1))
            If SYA->(DbSeek(xFilial("SYA")+SA1->A1_PAIS))
               HEADER_P->AVG_C06_60 += " - " + AllTrim(SYA->YA_DESCR) //Descri��o
            EndIf
         EndIf
      
      EndIf      
      
      //Pa�s de Destino
      SYA->(DbSetOrder(1))      
      If SYA->(DbSeek(xFilial("SYA")+EEC->EEC_PAISDT))
         HEADER_P->AVG_C07_60 := Alltrim(SYA->YA_DESCR) //Descri��o
      EndIf
      
      //Local de Embarque
      SY9->(DbSetOrder(2))
      If SY9->(DbSeek(xFilial("SY9")+EEC->EEC_ORIGEM))
         HEADER_P->AVG_C08_60 := AllTrim(SY9->Y9_DESCR) //Descri��o
         
         //Pais de Origem
         If !Empty(SY9->Y9_PAIS)
            SYA->(DbSetOrder(1))      
            If SYA->(DbSeek(xFilial("SYA")+SY9->Y9_PAIS))
               HEADER_P->AVG_C12_60 := Alltrim(SYA->YA_DESCR) //Descri��o
            EndIf
         EndIf
         
      EndIf
      
      //Local de Desembarque
      SY9->(DbSetOrder(2))
      If SY9->(DbSeek(xFilial("SY9")+EEC->EEC_DEST))
         HEADER_P->AVG_C09_60 := AllTrim(SY9->Y9_DESCR) //Descri��o
      EndIf
      
      //Via de Transporte
      SYQ->(DbSetOrder(1))
      If SYQ->(DbSeek(xFilial("SYQ")+EEC->EEC_VIA))
         HEADER_P->AVG_C10_60 := AllTrim(SYQ->YQ_DESCR) //Descri��o
      EndIf
       
      //C�digo do Container
      HEADER_P->AVG_C01_20 := Alltrim(EX9->EX9_CONTNR)
      
      //Lacre
      HEADER_P->AVG_C11_60 := Alltrim(EX9->EX9_LACRE)      
      
      //Assinatura
      If !Empty(cAssNome)
         HEADER_P->AVG_C13_60 := AllTrim(cAssNome) //Nome
      EndIf
 
      If !Empty(cAssEmp)
         HEADER_P->AVG_C14_60 := AllTrim(cAssEmp) //Empresa
      EndIf
      
      If !Empty(cAssCargo)
         HEADER_P->AVG_C15_60 := AllTrim(cAssCargo) //Cargo
      EndIf
      
      //Unidade de Medida
      HEADER_P->AVG_C01_10 := Alltrim(cUnidad)

      //////////////////////////////////
      //Embalagens Externas ou Pallets//
      //////////////////////////////////
      EYH->(DbSetOrder(3))
      EYH->(DbSeek(xFilial("EYH")+"S"+EEC->EEC_PREEMB+EX9->EX9_ID))
      While EYH->(!Eof() .And. EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC == xFilial("EYH")+"S"+EEC->EEC_PREEMB+EX9->EX9_ID)

         If EYH->EYH_PLT == "S"
            aAdd(aPallet,EYH->(RecNo()))
         Else
            aAdd(aEmbExt,EYH->(RecNo()))
         EndIf
       
         EYH->(DBSkip())
      EndDo

      ///////////////////////
      //Looping nos Pallets//
      ///////////////////////
      For n := 1 to Len(aPallet)

         EYH->(DbGoTo(aPallet[n]))
         
         cPalletID   := EYH->EYH_ID 
         
         nPallet     := EYH->EYH_QTDEMB
         nContPallet += nPallet

         //Posiciona o registro na Embalagem externa dentro do Pallet.
         EYH->(DbSetOrder(3))
         EYH->(DbSeek(xFilial("EYH")+"S"+EEC->EEC_PREEMB+cPalletID))
         While EYH->(!Eof() .And. EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC == xFilial("EYH")+"S"+EEC->EEC_PREEMB+cPalletID)

            DETAIL_P->(DbAppend())
      
            DETAIL_P->AVG_FILIAL := xFilial("SY0")
            DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
            DETAIL_P->AVG_SEQREL := cSeqRel
            
            nLinha++
            DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            
            
            //Pallet 
            DETAIL_P->AVG_C01_10 := Alltrim(Str(nPallet))

            //Embalagem Extena
            DETAIL_P->AVG_C02_20 := Transform(EYH->EYH_QTDEMB,"@E 99,999,999") //Quantidade
         
            EE5->(DbSetOrder(1))
            If EE5->(DbSeek(xFilial("EE5")+EYH->EYH_CODEMB))

               //Descri��o
               DETAIL_P->AVG_C01_60 := AllTrim(EYH->EYH_DESEMB)
            
               //Dimens�o
               DETAIL_P->AVG_C06_20 := Alltrim(EE5->EE5_DIMENS)
            
               //Volume
               DETAIL_P->AVG_C07_20 := "m3"

            EndIf
         
            //Peso Bruto
            nPesBru := AvTransUnid(cUnidDe,cUnidad,,EYH->EYH_PSBRTO)
            DETAIL_P->AVG_C09_20 := Transform(nPesBru,"@E 999,999,999.999")
            nPesoBrTo += nPesBru
         
            //Produto
            aItens := BuscaItens()
            For nInc := 1 To Len(aItens)
            
               If nInc > 1 
                  DETAIL_P->(DbAppend())
      
                  DETAIL_P->AVG_FILIAL := xFilial("SY0")
                  DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
                  DETAIL_P->AVG_SEQREL := cSeqRel
        
                  nLinha++
                  DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            

                  nIncCont++
               
               EndIf
            
               //Identificador da Linha(Utilizado para o Sub-Relat�rio)
               DETAIL_P->AVG_N01_04 := nIncCont

               //Quantidade
               DETAIL_P->AVG_C03_20 := Transform(aItens[nInc][2],AVSX3("EE9_SLDINI",AV_PICTURE))
            
               //Unidade de Medida
               DETAIL_P->AVG_C04_20 := Transform(aItens[nInc][4],AVSX3("EE9_UNIDAD",AV_PICTURE))
            
               //C�digo de Item
               DETAIL_P->AVG_C05_20 := AllTrim(Upper(aItens[nInc][3]))
            
               //Peso Liquido Unit�rio
               nPesLiq := aItens[nInc][5]
               DETAIL_P->AVG_C08_20 := Transform(nPesLiq,AVSX3("EE9_PSLQTO",AV_PICTURE))
               nPesoLqTo += nPesLiq
               
               //Pedido no Cliente (Referencia do Cliente)
               DETAIL_P->AVG_C02_60 := AllTrim(Upper(aItens[nInc][6]))

               //Descri��o do Item
               For nInc2 := 1 To MlCount(aItens[nInc][1])
               
                  DETAIL_P->(DbAppend())
            
                  DETAIL_P->AVG_SEQREL := cSeqRel
                  DETAIL_P->AVG_FILIAL := xFilial("SY0")
                  DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
                
                  nLinha++
                  DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            
        
                  DETAIL_P->AVG_CONT   := "SUB"
                           
                  //Identificador da Linha(Utilizado para o Sub-Relat�rio)
                  DETAIL_P->AVG_N01_04 := nIncCont
               
                  DETAIL_P->AVG_C01150 := MemoLine(aItens[nInc][1],,nInc2)
                  
                  //Pedido no Cliente (Referencia do Cliente)
                  DETAIL_P->AVG_C02_60 := AllTrim(Upper(aItens[nInc][6]))
               
               Next

            Next
         
            nIncCont++
       
            EYH->(DbSkip())                                
         EndDo
      Next
      
      //////////////////////////////////////////////////
      //Looping nas Embalagens Externas fora de Pallet//
      //////////////////////////////////////////////////
      For n := 1 to Len(aEmbExt)

         EYH->(DbGoTo(aEmbExt[n]))

         DETAIL_P->(DbAppend())
      
         DETAIL_P->AVG_FILIAL := xFilial("SY0")
         DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
         DETAIL_P->AVG_SEQREL := cSeqRel
         
         nLinha++
         DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            
            
         //Pallet 
         DETAIL_P->AVG_C01_10 := "-"

         //Embalagem Extena
         DETAIL_P->AVG_C02_20 := Transform(EYH->EYH_QTDEMB,"@E 99,999,999") //Quantidade
         
         EE5->(DbSetOrder(1))
         If EE5->(DbSeek(xFilial("EE5")+EYH->EYH_CODEMB))

            //Descri��o
            DETAIL_P->AVG_C01_60 := AllTrim(EYH->EYH_DESEMB)
            
            //Dimens�o
            DETAIL_P->AVG_C06_20 := Alltrim(EE5->EE5_DIMENS)
           
            //Volume
            DETAIL_P->AVG_C07_20 := "m3"

         EndIf
       
         //Peso Bruto
         nPesBru := AvTransUnid(cUnidDe,cUnidad,,EYH->EYH_PSBRTO)
         DETAIL_P->AVG_C09_20 := Transform(nPesBru,"@E 999,999,999.999")
         nPesoBrTo += nPesBru
         
         //Produto
         aItens := BuscaItens()
         For nInc := 1 To Len(aItens)
            
            If nInc > 1 
               DETAIL_P->(DbAppend())
     
               DETAIL_P->AVG_FILIAL := xFilial("SY0")
               DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
               DETAIL_P->AVG_SEQREL := cSeqRel
                
               nLinha++
               DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            
               
               nIncCont++
               
            EndIf
            
            //Identificador da Linha(Utilizado para o Sub-Relat�rio)
            DETAIL_P->AVG_N01_04 := nIncCont

            //Quantidade
            DETAIL_P->AVG_C03_20 := Transform(aItens[nInc][2],AVSX3("EE9_SLDINI",AV_PICTURE))
            
            //Unidade de Medida
            DETAIL_P->AVG_C04_20 := Transform(aItens[nInc][4],AVSX3("EE9_UNIDAD",AV_PICTURE))
            
            //C�digo de Item
            DETAIL_P->AVG_C05_20 := AllTrim(Upper(aItens[nInc][3]))
            
            //Peso Liquido Unit�rio
            nPesLiq := aItens[nInc][5]
            DETAIL_P->AVG_C08_20 := Transform(nPesLiq,AVSX3("EE9_PSLQTO",AV_PICTURE))
            nPesoLqTo += nPesLiq
            
            //Pedido no Cliente (Referencia do Cliente)
            DETAIL_P->AVG_C02_60 := AllTrim(Upper(aItens[nInc][6]))
            
            //Descri��o do Item
            For nInc2 := 1 To MlCount(aItens[nInc][1])
               
               DETAIL_P->(DbAppend())
            
               DETAIL_P->AVG_SEQREL := cSeqRel
               DETAIL_P->AVG_FILIAL := xFilial("SY0")
               DETAIL_P->AVG_CHAVE  := EX9->EX9_CONTNR
               
               nLinha++
               DETAIL_P->AVG_LINHA  := StrZero(nLinha,6)            
            
               DETAIL_P->AVG_CONT   := "SUB"
                           
               //Identificador da Linha(Utilizado para o Sub-Relat�rio)
               DETAIL_P->AVG_N01_04 := nIncCont
               
               DETAIL_P->AVG_C01150 := MemoLine(aItens[nInc][1],,nInc2)
              
               //Pedido no Cliente (Referencia do Cliente)
               DETAIL_P->AVG_C02_60 := AllTrim(Upper(aItens[nInc][6]))
            Next

         Next
         
         nIncCont++
      
      Next

      //Totalizador de Embalagens Externas
      HEADER_P->AVG_C02_30 := AllTrim(Str(nTotEmb))
      
      //Totalizador de Pallets
      HEADER_P->AVG_C02_10 := AllTrim(Str(nContPallet)) //Pallets do Container
      HEADER_P->AVG_C03_30 := AllTrim(Str(nTotPallet))  //Pallets do Embarque

      //Totalizador de Containers
      HEADER_P->AVG_C01_30 := AllTrim(Str(nTotCont))
      
      //Totalizador do Peso Liquido
      HEADER_P->AVG_C03_20 := Transform(nPesoLqTo,AVSX3("EE9_PSLQTO",AV_PICTURE))
      
      //Totalizador do Peso Bruto
      HEADER_P->AVG_C04_20 := Transform(nPesoBrTo,AVSX3("EE9_PSLQTO",AV_PICTURE))
 
      EX9->(DbSkip())
   
   EndDo
   
   HEADER_P->(DBCOMMIT())
   DETAIL_P->(DBCOMMIT())

End Sequence

Return lRet

/*
Funcao      : BuscaItens()
Parametros  : Nenhum
Retorno     : aRet - Array com os dados dos itens.
Objetivos   : Busca os itens dentro das embalagens externas.
Autor       : Eduardo C. Romanini
Data/Hora   : 12/02/2008 15:30
Obs.        : 
*/
*--------------------------*
Static Function BuscaItens()
*--------------------------*
Local aRet    := {}
Local aOrd    := SaveOrd({"EE9"})

Local nRecno  := EYH->(Recno())
Local nPsLqUn := 0

Local cDesc   := "" 
Local cChave  := EYH->(EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_ID)
Local cPedido := ""

Begin Sequence
   
   /*
     Detalhes do Array de Retorno
     [1] - Descri��o
     [2] - Quantidade
     [3] - Codigo do Item
     [4] - Unidade de Quantidade
     [5] - Peso Liquido Total
   */

   //Busca as embalagens internas da atual, at� chegar no item
   If EYH->(DbSeek(cChave))
      While EYH->(!Eof() .And. EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC == cChave)
         If !Empty(EYH->EYH_COD_I)
            EE9->(DbSetOrder(3))
            If EE9->(DbSeek(xFilial("EE9")+EYH->(EYH_PREEMB+EYH_SEQEMB)))
               cDesc := MSMM(EE9->EE9_DESC, TAMSX3("EE9_VM_DES")[1],,, LERMEMO)
               
               cPedido := EE9->EE9_PEDIDO

               If !Empty(EE9->EE9_UNPES) 
                  nPsLqUn := AvTransUnid(EE9->EE9_UNPES,cUnidad,EE9->EE9_COD_I,EE9->EE9_PSLQUN) * EYH->EYH_QTDEMB
               Else
                  nPsLqUn := AvTransUnid(EE9->EE9_UNIDAD,cUnidad,EE9->EE9_COD_I,EE9->EE9_PSLQUN) * EYH->EYH_QTDEMB            
               EndIf
         
               aAdd(aRet,{cDesc,EYH->EYH_QTDEMB,EE9->EE9_COD_I,EE9->EE9_UNIDAD,nPsLqUn,EE9->EE9_REFCLI})

            EndIf
         Else
            aRet := BuscaItens()
         EndIf

         EYH->(DbSkip())
      EndDo
   EndIf

End Sequence

EYH->(DbGoTo(nRecno))
RestOrd(aOrd, .T.)
   
Return aRet
