#include "totvs.ch"

/**
 * Rotina		:   XCadSB1
 * Autor		:	Andre
 * Data			:	
 * Descricao	:	
 *
 * Observacoes	:	Exemplo utilizado no Curso de ADVPL Avançado */   


User Function XCadSB1
	Private aRotina:={}                  
	AADD(aRotina,{"Pesquisar" ,"AxPesqui"  	,0,1})
	AADD(aRotina,{"Visualizar","U_pMod2Edit",0,2})
	AADD(aRotina,{"Incluir"   ,"U_pMod2Inc" ,0,3})
	AADD(aRotina,{"Alterar"   ,"U_pMod2Edit",0,4})
	AADD(aRotina,{"Excluir"   ,"U_pMod2Edit",0,5})
	Private cCadastro:="Pedido de Venda"
	mBrowse(,,,,"ZA2")
Return 
      
User Function pMod2Inc(cAlias,nReg,nOpc)
	Local oDlg  									
	Local oGet  									
	Local bOk		:= {|| GravaInc()	,oDlg:End()}   		
	Local bCancel	:= {|| RollBackSX8(),oDlg:End()}    
	Private cNumero	:= CriaVar("ZA2_NUM"	,.T.)  		
	Private cCodigo	:= CriaVar("ZA2_CODIGO"	,.T.)		
	Private cNome	:= CriaVar("ZA2_NOME"	,.T.)
	Private dData	:= CriaVar("ZA2_DATA"	,.T.)
	Private aHeader	:= {} 
	Private aCols	:= {}  	
	CriaCab()            		
	CriaItens(nOpc)									
	Define MsDialog oDlg From 0,0 to 350,500 Title "Incluir" Pixel          
		@ 35,05 	Say 	"Numero" 	of oDlg Pixel
		@ 34,35 	MsGet 	cNumero 	of oDlg Pixel Size 40,7 // When .F.
		@ 35,90 	Say 	"Data" 		of oDlg Pixel
		@ 34,105 	MsGet 	dData 		of oDlg Pixel Size 40,7 // When .F.
		@ 48,05 	Say 	"Cod Vend." of oDlg Pixel 
		@ 47,35 	MsGet 	cCodigo 	of oDlg Pixel Size 40,7 F3 "SA3" Valid VldVend()
		@ 48,90 	Say 	"Nome" 		of oDlg Pixel
		@ 47,105 	MsGet 	cNome 		of oDlg Pixel Size 100,7 When .F.		
		oGet:=MsGetDados():New(62,1,176,249,nOpc,"AlwaysTrue()","Alwaystrue()","+ZA3_ITEM",.T.)	
	Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg,bOK,bCancel)   
Return																	



Static Function GravaInc  
	Local i,j
	DbSelectArea("ZA2") 
	DbSetorder(1)
	i:=1
	If !aCols[i,Len(aHeader)+1]        			
		RecLock("ZA2",.T.)                   	
			ZA2->ZA2_FILIAL	:= xFilial("ZA2")
			ZA2->ZA2_NUM 	:= cNumero
			
			
			ZA2->ZA2_CODIGO	:= cCodigo
			ZA2->ZA2_DATA	:= dData 
			ZA2->ZA2_NOME	:= cNome
		ZA2->(MsUnLock())		
	Endif	
	For i:=1 to Len(aCols)
		DbSelectArea("ZA3")
		DbSetorder(1)
		RecLock("ZA3", .T.) 
			ZA3->ZA3_FILIAL := xFilial("ZA3")
			ZA3->ZA3_NUM 	:= cNumero
			For j:=1 to Len(aHeader)     
				ZA3->&(aHeader[j,2]):=aCols[i,j] 
			Next
		ZA3->(MsUnlock())              
	Next                         
	ConfirmSX8()	
Return

          

User Function pMod2Edit(cAlias,nReg,nOpc)   	
	Local oDlg 
	Local oGet
	Local bOk		:= {|| GravaAlt(nOpc),oDlg:End()}      
	Local bCancel	:= {|| oDlg:End()}                 
	Private cNumero	:= ZA2->ZA2_NUM		       
	Private cCodigo	:= ZA2->ZA2_CODIGO              
	Private cNome	:= ZA2->ZA2_NOME         
	Private dData	:= ZA2->ZA2_DATA                   
	Private aHeader	:= {}
	Private aRegs	:= {}
	Private aCols	:= {}


	CriaCab()                  
	CriaItens(nOpc) 
	
	Define MsDialog oDlg From 0,0 to 350,500 Title "Alterar" Pixel		
		@ 35,05 Say "Numero" 	of oDlg Pixel
		@ 34,35 MsGet cNumero 	of oDlg Pixel Size 40,7 When .F.
		@ 35,90 Say "Data" 		of oDlg Pixel
		@ 34,105 MsGet dData 	of oDlg Pixel Size 40,7 When .F.
		@ 48,05 Say "Cod Vend." of oDlg Pixel 
		@ 47,35 MsGet cCodigo 	of oDlg Pixel Size 40,7 When .F.
		@ 48,90 Say "Nome" 		of oDlg Pixel
		@ 47,105 MsGet cNome 	of oDlg Pixel Size 100,7 When .F.
		oGet:=MsGetDados():New(62,1,176,249,nOpc,"AlwaysTrue()","Alwaystrue()","+ZA3_ITEM",.T.)	
	Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg,bOK,bCancel)    

Return


															

Static Function CriaCab     
	Local aArea:= GetArea()  	
	DbSelectArea("SX3")	
	DbSetorder(1)		
	DbSeek("ZA3")				
	While !Eof() .and. X3_ARQUIVO=="ZA3"	
		If X3USO(X3_USADO).and. !Alltrim(Right(X3_CAMPO,6))$"NUM|CODIGO|NOME|DATA" .and. cNivel>=X3_NIVEL 	
			aadd(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VLDUSER,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT}) 
		Endif
		DbSkip()
	End    
	RestArea(aArea)
Return
             





Static Function CriaItens(nOpc)   
	Local i     
	DbSelectArea("ZA3")
	DbSetOrder(1)
	If nOpc==3  	
		AADD(aCols,Array(Len(aHeader)+1)) 			
		For i:=1 to Len(aHeader)          			
			aCols[1,i]:=CriaVar(aHeader[i,2],.T.) 	
		Next           
		aCols[1,GdFieldPos("ZA3_ITEM")]:=StrZero(1,TamSX3("ZA3_ITEM")[1]) 	
		aCols[1,Len(aHeader)+1]:=.F.   
	Else 
        DbSelectArea("ZA3")        
		DbSetOrder(1)       						
		DbSeek(xFilial("ZA3")+cNumero)
		While ZA3->(!EOF()).AND.ZA3->ZA3_NUM==cNumero   
			aadd(aCols,Array(Len(aHeader)+1))			
			aadd(aRegs,ZA3->(Recno())) 
			For i:=1 to Len(aHeader)                    
				aCols[Len(aCols),i]:=ZA3->&(aHeader[i,2])
			Next                          
			aCols[Len(aCols),Len(aHeader)+1]:=.f.      
			ZA3->(DbSkip())
		End
	Endif
Return
             

Static Function GravaAlt(nOpc)  
	Local i   
	Local j
	If nOpc==5   
		DbSelectArea("ZA3")
		DbSetOrder(1)
		DbSeek(xFilial("ZA3") + cNumero)
		While !Eof() .And. ZA3->(ZA3_FILIAL + ZA3_NUM) == xFilial("ZA3") + cNumero
			RecLock("ZA3")
			DbDelete()
			MsUnLock()
			DbSkip()
		End
		DbSelectArea("ZA2")
		RecLock("ZA2", .F.)
		DbDelete()
		MsUnLock()
	ElseIf nOpc==4   
		DbSelectArea("ZA3")
		DbSetOrder(1)
		For i:=1 to Len(aCols)					
			If i<=Len(aRegs)       			 
			    ZA3->(DbGoto(aRegs[i]))			
				RecLock("ZA3",.F.) 				
				If aCols[i,Len(aHeader)+1]==.T. 
					ZA3->(DbDelete()) 
					ZA3->(MsUnLock())
				Else                           
					RecLock("ZA3", .F.)
						For j:=1 to Len(aHeader)
							ZA3->(FieldPut(FieldPos(aHeader[j,2]),aCols[i,j])) 	
						Next         
					ZA3->(MsUnlock())
				Endif
			Else
				If !aCols[i,Len(aHeader)+1] 	
					DbSelectArea("ZA3")
					DbSetorder(1)
					RecLock("ZA3", .T.) 
					ZA3->ZA3_FILIAL :=xFilial("ZA3")
					ZA3->ZA3_NUM 	:= cNumero
					For j:=1 to Len(aHeader)     
						ZA3->&(aHeader[j,2]):=aCols[i,j] 
					Next
					ZA3->(MsUnlock())              
				Endif
			Endif
		Next	
	Endif		
Return 


Static Function VldVend    
	Local lResp:=.T.
	cNome:=RetField("SA3",1,xFilial("SA3")+cCodigo,"A3_NOME")   
	If Empty(cNome)
		MsgStop("Vendedor não localizado!","Aviso")
		lResp:=.F.
	Endif
Return lResp

