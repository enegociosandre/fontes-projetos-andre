#include "Protheus.ch"


User Function PE01NFESEFAZ()    

Local aProd    := Paramixb[1]
Local cMensCli := Paramixb[2]      
Local cMensFis := Paramixb[3]      
Local aDest    := Paramixb[4]      
Local aNota    := Paramixb[5]      
Local aInfoItem:= Paramixb[6]      
Local aRet     := {}     
Local nI       := 0 
  
for  nI:= 1 to len(aProd)
	aProd[nI,4] :=  posicione("SB5",1,xFilial("SB5")+aProd[nI,2],"B5_CEME")
next nI


if cOperac =="1"
		
	/*Mensagem template*/
	oTMsg := FswTemplMsg():TemplMsg("S",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
	oTMsg:carMsg()
	For nI := 1 to Len(oTMsg:aMsg)
		If !Empty(oTMsg:aMsg[nI,2]) .AND. !( Upper(AllTrim(oTMsg:aMsg[nI,2])) $ cMensCli )
			cMensCli +=IIF(!Empty(cMensCli)," ","")
			cMensCli +=AllTrim(oTMsg:aMsg[nI,2])
		EndIf
	Next nI
else
	
	
	oTMsg := FswTemplMsg():TemplMsg("E",SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
	oTMsg:carMsg()
	For nI := 1 to Len(oTMsg:aMsg)
		If !Empty(oTMsg:aMsg[nI,2]) .AND. !( Upper(AllTrim(oTMsg:aMsg[nI,2])) $ cMensCli )
			cMensCli += IIF(!Empty(cMensCli)," "," ")
			cMensCli +=AllTrim(oTMsg:aMsg[nI,2])
		EndIf
	Next nI


endIf	
	


aAdd(aRet,aProd)
aAdd(aRet,cMensCli)
aAdd(aRet,cMensFis) 
aAdd(aRet,aDest)
aAdd(aRet,aNota)
aAdd(aRet,aInfoItem) 
return aRet 