/*
Programa : QbgAtuEmpresa_rdm.
Autor    : Jo�o Pedro Macimiano Trabbold
Data     : 17/08/04 8:40.
Uso      : Fazer a amarra��o entre as empresas cadastradas (SY5) com os fornecedores (SA2).
           Ajuste para a rotina de c�mbio para frete, seguro e comiss�o.
Revisao  : 
*/

#include "EECRDM.CH"

/*
Funcao     : AtuEmpresa().
Parametros : Nenhum.
Retorno    : .t. -> Atualiza��o realizada com sucesso.
             .f. -> Atualiza��o n�o pode ser realizada.
Objetivos  : Fazer a amarra��o entre as empresas cadastradas (SY5) com os fornecedores (SA2).
             Ajuste para os tratamentos para frete, seguro e comiss�o.
Autor      : Jo�o Pedro Macimiano Trabbold
Data       : 17/08/04 8:41.
Revisao    :
Obs.       :
*/
*------------------------*
User Function AtuEmpresa()
*------------------------*
Local lRet:=.t.

Begin sequence

   /* Verifica se o ambiente possue todas as configura��es necess�rias para a ativa��o 
      dos tratamentos de frete, seguro e comiss�o. */

   If EECFlags("FRESEGCOM")

      If !MsgYesNo("Confirma a atualiza��o?","Aten��o")
         lRet:= .f.
         Break
      EndIf

      // Valida��es espec�ficas para atualiza��o do cadastro de empresas.
      If !VldAtu()
         lRet:= .f.
         Break
      EndIf

      // ** Grava o campo chave para os pedidos.
      Processa({|| AmarraForn() })

      MsgInfo("Atualiza��o realizada com sucesso!","Aviso")
   Else
      MsgStop("Problema:"+Replic(ENTER,2)+;
              "      A atualiza��o n�o poder� ser realizada."+Replic(ENTER,2)+;
              "Detalhes:"+Replic(ENTER,2)+;
              "      O ambiente n�o possue todas as configura��es necess�rias para a"+ENTER+;
              "ativa��o dos tratamentos de frete, seguro e comiss�o.","Aten��o")
      lRet := .f.
   EndIf

End Sequence

Return lRet

/*
Funcao      : VldAtu().
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Valida��o que verifica se o SA2 e o SY5 est�o no mesmo modo (exclusivo ou compartilhado).
Autor       : Jo�o Pedro Macimiano Trabbold
Data        : 17/08/04 14:46.
Revisao     :
Obs.        :
*/
*----------------------*
Static Function VldAtu()
*----------------------*
Local lRet:=.t. 


Begin Sequence

   If xFilial("SA2") # xFilial("SY5")
      MsgStop("Para haver o relacionamento entre Empresa e Fornecedor as duas "+ENTER+;
              "tabelas devem estar no mesmo modo (compartilhado ou exclusivo).","Atualiza��o n�o pode ser efetuada!") 
      lRet:=.f.
   endif

End Sequence

Return lRet

/*
Funcao      : AmarraForn().
Parametros  : Nenhum.
Retorno     : .t./.f. 
Objetivos   : Amarrar as Empresas (SY5) com os fornecedores (SA2).
Autor       : Jo�o Pedro Macimiano Trabbold
Data        : 17/08/04 14:46.
Revisao     :
Obs.        :
*/
*--------------------------*
Static Function AmarraForn()
*--------------------------*
Local lRet:=.t., aOrd:=SaveOrd({"SY5","SA2"}) 
Local lFound := .t.  
Local lFirst := .t.
Local nCod:= 1

Begin Sequence 
   
   SY5->(DbSetOrder(1)) 
   SY5->(DbSeek(xFilial("SY5")))
   While !SY5->(EOF()) .AND. xFilial("SY5") == SY5->Y5_FILIAL 
    
      if !empty(SY5->Y5_CODSA2) .AND. !empty(SY5->Y5_LOJASA2)
         SA2->(DBSetOrder(1))
         
         If !SA2->(DBSEEK(xFilial("SA2")+SY5->Y5_CODSA2))
            BEGIN TRANSACTION
               If SY5->(RECLOCK("SY5",.f.))
                  SY5->Y5_CODSA2 :=""
               EndIf
            END TRANSACTION            
            loop
         endif
         
         SY5->(DBSKIP())
         loop    
      EndIf 

      SA2->(DBSetOrder(3))
      if !empty(SY5->Y5_NRCPFCG) .AND. val(SY5->Y5_NRCPFCG) <> 0 .AND. ;
         SA2->(DBSEEK(xFilial("SA2")+SY5->Y5_NRCPFCG))
         BEGIN TRANSACTION
            if SY5->(RECLOCK("SY5",.f.))
               SY5->Y5_CODSA2  := SA2->A2_COD
               SY5->Y5_LOJASA2 := SA2->A2_LOJA 
            endif
         END TRANSACTION
         SY5->(DBSKIP())
         loop
      
      else  
       
         SA2->(DBSetOrder(2)) 
         if SA2->(DBSEEK(xFilial("SA2")+SY5->Y5_NOME))
            BEGIN TRANSACTION  
               If SY5->(RECLOCK("SY5",.f.))
                  SY5->Y5_CODSA2 := SA2->A2_COD
                  SY5->Y5_LOJASA2 := SA2->A2_LOJA   
               endif
            END TRANSACTION
            SY5->(DBSKIP())
            loop 
         else
            SA2->(DBSetOrder(1))
            If SA2->(DBSEEK(xFilial("SA2")+StrZero(1,AvSx3("A2_COD",AV_TAMANHO))))
               if lFirst
                  Do while lFound
                     If !SA2->(DBSEEK(xFilial("SA2")+StrZero(nCod,AvSx3("A2_COD",AV_TAMANHO))))                     
                        lFound := .f.
                        Loop
                     EndIf
                     nCod += 50
                  EndDo  
         
                  Do while !lFound
                     If SA2->(DBSEEK(xFilial("SA2")+StrZero(nCod,AvSx3("A2_COD",AV_TAMANHO))))                    
                        lFound := .t.
                        Loop
                     EndIf
                     nCod := nCod - 1
                  EndDo 
                  nCod += 1 
                  lfirst := .f.
               else
                  lFound := .t.
                  Do while lFound  
                     nCod += 1 
                     If !SA2->(DBSEEK(xFilial("SA2")+StrZero(nCod,AvSx3("A2_COD",AV_TAMANHO))))                     
                        lFound := .f.
                        Loop
                     EndIf
                  EndDo  
               endif
             
            endif   
               
            BEGIN TRANSACTION
               If SA2->(RECLOCK("SA2",.t.)) 
                  SA2->A2_FILIAL := xFilial("SA2")
                  SA2->A2_COD    := StrZero(nCod,AvSx3("A2_COD",AV_TAMANHO))
                  SA2->A2_LOJA   := "."
                  SA2->A2_NOME   := SY5->Y5_NOME
                  SA2->A2_NREDUZ := SUBSTR(SUBSTR(SY5->Y5_NOME,1,at(" ",SY5->Y5_NOME)-1),1,20)  
                  SA2->A2_END    := if(!empty(SY5->Y5_END),SY5->Y5_END,".")
                  SA2->A2_MUN    := if(!empty(SY5->Y5_CIDADE),SubStr(SY5->Y5_CIDADE,1,AvSx3("A2_MUN",AV_TAMANHO)),".")
            
                  SX5->(DBSeek(xFilial("SX5")+"12"))
                  SA2->A2_EST := "."
              
                  While !SX5->(EOF()) .AND. SX5->X5_TABELA == "12"
                     if SY5->Y5_EST $ SX5->X5_DESCRI
                        SA2->A2_EST := SX5->X5_CHAVE
                        Exit
                     EndIf
                     SX5->(DBSkip())
                  enddo
               
                  SA2->A2_TIPO    := "J"
                  SA2->A2_ID_FBFN := "2-FORN"  
                  SA2->A2_CGC := if(!empty(SY5->Y5_NRCPFCG),SY5->Y5_NRCPFCG,)  

                  If SY5->(RECLOCK("SY5",.f.))
                     SY5->Y5_CODSA2 := SA2->A2_COD 
                     SY5->Y5_LOJASA2 := SA2->A2_LOJA  
                  EndIf
               endif
            END TRANSACTION
         endif
      endif
      
      SY5->(DBSKIP())
   EndDo

End Sequence

RestOrd(aOrd)

Return lRet
*--------------------------------------------------------------------------------------------------------------*
*  FIM DO RDMAKE QBGATUEMPRESA_RDM.PRW
*--------------------------------------------------------------------------------------------------------------*