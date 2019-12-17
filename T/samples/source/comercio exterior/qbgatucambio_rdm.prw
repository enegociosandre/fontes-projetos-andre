/*
Programa : Qbgatucambio_rdm.
Autor    : Jo�o Pedro Macimiano Trabbold
Data     : 19/08/04 8:45.
Uso      : Fazer a atualiza��o dos novos campos do EEQ, a partir de dados da capa do embarque
Revisao  : 
*/

#include "EECRDM.CH"

/*
Funcao     : AtuCambio().
Parametros : Nenhum.
Retorno    : .t. -> Atualiza��o realizada com sucesso.
             .f. -> Atualiza��o n�o pode ser realizada.
Objetivos  : Fazer a atualiza��o dos novos campos do EEQ, a partir de dados da capa do embarque e do EC6
Autor      : Jo�o Pedro Macimiano Trabbold
Data       : 19/08/04 8:45.
Revisao    :
Obs.       :
*/
*------------------------*
User Function AtuCambio()
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

      // Valida��es espec�ficas para atualiza��o dos campos do EEQ
      If !VldAtu()
         lRet:= .f.
         Break
      EndIf

      // ** Grava os campos 
      Processa({|| GravaCpos() })

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
Objetivos   : Valida��o que verifica se as tabelas EEQ e EEC est�o no mesmo modo (exclusivo ou compartilhado).
Autor       : Jo�o Pedro Macimiano Trabbold
Data        : 19/08/04 10:33.
Revisao     :
Obs.        :
*/
*----------------------*
Static Function VldAtu()
*----------------------*
Local lRet:=.t. 


Begin Sequence

   If xFilial("EEQ") # xFilial("EEC")
      MsgStop("Para haver a Atualiza��o, as tabelas de Embarques(EEC) e do Valor das Parcelas"+ENTER+;
              " de Embarque(EEQ) devem estar no mesmo modo (compartilhado ou exclusivo).","Atualiza��o n�o pode ser efetuada!") 
      lRet:=.f.
   endif

End Sequence

Return lRet

/*
Funcao      : GravaCpos().
Parametros  : Nenhum.
Retorno     : .t./.f. 
Objetivos   : Gravar os conte�dos dos novos campos do EEQ
Autor       : Jo�o Pedro Macimiano Trabbold
Data        : 17/08/04 14:46.
Revisao     :
Obs.        :
*/
*--------------------------*
Static Function GravaCpos()
*--------------------------*
Local lRet:=.t., aOrd:=SaveOrd({"EEQ","EC6","EEC"}) 

Begin Sequence 
   EEQ->(DbSetOrder(1))
   EEQ->(DbSeek(xFilial("EEQ")))
   While !EEQ->(EOF()) .And. xFilial("EEQ") == EEQ->EEQ_FILIAL
      EC6->(DbSetOrder(1))
      if EC6->(DbSeek(xFilial("EC6")+"EXPORT"+EEQ->EEQ_EVENT))  
      
         EEC->(DBSetOrder(1))
         if EEC->(DBSeek(xFilial("EEC")+EEQ->EEQ_PREEMB))
            
            BEGIN TRANSACTION  
               If EEQ->(RecLock("EEQ",.f.))
                  
                  if EC6->EC6_RECDES == "1"
                     EEQ->EEQ_FORN   := EEC->EEC_FORN
                     EEQ->EEQ_FOLOJA := EEC->EEC_FOLOJA
                     EEQ->EEQ_IMPORT := EEC->EEC_IMPORT
                     EEQ->EEQ_IMLOJA := EEC->EEC_IMLOJA
                     EEQ->EEQ_TIPO   := "R"
                  Else
                     EEQ->EEQ_TIPO   := "P"
                  endif 
                  EEQ->EEQ_MOEDA  := EEC->EEC_MOEDA
                  
               endif
            END TRANSACTION
         
         endif     
      endif  
      EEQ->(DbSkip())    
   enddo
End Sequence

RestOrd(aOrd)

Return lRet
*--------------------------------------------------------------------------------------------------------------*
*  FIM DO RDMAKE QBGATUCAMBIO_RDM.PRW
*--------------------------------------------------------------------------------------------------------------*