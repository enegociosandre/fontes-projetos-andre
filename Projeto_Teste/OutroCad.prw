#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.ch'

User Function OutroCad()   
 Local aRotAdic :={} 
 Local bPre := {||MsgAlert('Chamada antes da fun��o')}
 Local bOK  := {||MsgAlert('Chamada ao clicar em OK'), .T.}
 Local bTTS  := {||MsgAlert('Chamada durante transacao')}
 Local bNoTTS  := {||MsgAlert('Chamada ap�s transacao')}    
 Local aButtons := {}//adiciona bot�es na tela de inclus�o, altera��o, visualiza��o e exclusao
 aadd(aButtons,{ "PRODUTO", {|| MsgAlert("Teste")}, "Teste", "Bot�o Teste" }  ) //adiciona chamada no aRotina
 aadd(aRotAdic,{ "Adicional","U_oAdic", 0 , 6 })
 AxCadastro("ZZJ", "Relacao Pella", "U_oDelOk()", "U_oCOK()", aRotAdic, bPre, bOK, bTTS, bNoTTS, , , aButtons, , )  
Return(.T.)                        
User Function oDelOk()  
 //MsgAlert("Chamada antes do delete") 
Return 
User Function oCOK()    
//MsgAlert("Clicou botao OK") 
Return .t.      
User Function oAdic()   
//MsgAlert("Rotina adicional") 
Return