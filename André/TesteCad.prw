#include 'protheus.ch'
#include 'totvs.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

User Function TesteCad()   

Local cTitulo		:= "Informe a descrição do produto a ser alterada"
Private cCod		:= SPACE(15)
Private cDesc	:= SPACE(20)
Private nLin		:= 004
Private _oJanela
Private lRet		:= .T.

	DEFINE MSDIALOG _oJanela  TITLE cTitulo FROM 000,000 to 170,530 PIXEL 
	 
	nLin+=5
	
	@ nLin,012 Say "Codigo:" SIZE 140,20 OF _oJanela PIXEL
	@ nLin,060 MSGET cCod F3 "SB1" WHEN .T. SIZE 60,07 OF _oJanela PIXEL

	nLin+=15

	@ nLin,012 Say "Descrição:" SIZE 140,20 OF _oJanela PIXEL
	@ nLin,060 MSGET cDesc WHEN .T. SIZE 60,07 OF _oJanela PIXEL

	@ 60,130 BUTTON "Gravar" SIZE 50,12 ACTION(GravaSB1()) OF _oJanela PIXEL
	@ 60,200 BUTTON "Cancelar" SIZE 50,12 ACTION(_oJanela:End()) OF _oJanela PIXEL
	
	Activate Dialog _oJanela Centered
                          
Return(lRet)


Static Function GravaSB1()

		
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1") + cCod ))
		While !SB1->(EOF()) .AND. (SB1->B1_FILIAL + SB1->B1_COD) == (xFilial("SB1") + cCod)
			
			SB1->(RecLock("SB1",.F.))
					SB1->B1_DESC := cDesc
			SB1->(MsUnLock())
			
			SB1->(dbSkip())
	    EndDo
	    SB1->(dbCloseArea())
	EndIf

	MsgInfo("Descrição Gravada!","Informação!")
	_oJanela:End()
	
Return(lRet)