#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"
#INCLUDE 'topconn.ch'

User Function M410GET()
	SetKey(VK_F5, {|| u_Pro(GdFieldGet("C6_PRODUTO",n)) }) 
Return 
 
	
User Function Pro(cProduto)       

	Static oMainWnd
	Private nLin		:= 004
	Private _oJanela           

	
	DEFINE MSDIALOG _oJanela  TITLE "Titulo" FROM 000,000 to 170,530 PIXEL 
	
	@ nLin,012 Say cProduto SIZE 140,20 OF _oJanela PIXEL

    ACTIVATE MSDIALOG _oJanela  CENTERED               
    
       
Return 