
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TOICurFun �Autor  �Joeudo Santana	     � Data �  09/04/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna se o curso foi Realizado pelo Funcionario          ���
�������������������������������������������������������������������������͹��
���Uso       � Consulta Office TRM                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function TOICurFun (cCodCurs,cCodFunc) 
Local cQueryAlias	:=	GetNextAlias()
Local aArea			:=	GetArea()                   
Local cRetorno		:=	""                  
Local nCont			:=	0

#IFDEF TOP 		
	BeginSql Alias cQueryAlias				
		SELECT COUNT(RA4_CURSO)QUANT 
		FROM %table:RA4% RA4
		WHERE RA4_CURSO = %exp:cCodCurs%
		AND RA4_MAT = %exp:cCodFunc%
		AND RA4_FILIAL = %xFilial:RA4%
		AND RA4.%notDel%
	EndSql	
			
	Dbselectarea(cQueryAlias)
	
	cRetorno:= If ((cQueryAlias)->QUANT > 0,"X","")
	
	(cQueryAlias)->(DbCloseArea())

#ELSE
      
   DbSelectArea("RA4")      
   RA4->(DbSetOrder(1))
   RA4->(DbSeek(xFilial("RA4")+cCodFunc+cCodCurs))                  
   While  RA4->(!EOF()) .AND. RA4->RA4_MAT == cCodFunc .AND. RA4->RA4_CURSO == cCodCurs    
   		nCont++
   		RA4->(DbSkip())
   End
   cRetorno:= If (nCont > 0,"X","")
   
#ENDIF  	

RestArea(aArea)  
Return cRetorno      



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TOIAvalia �Autor  �Joeudo Santana	     � Data �  09/04/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna se a avaliacao foi realizada pelo funcionario      ���
�������������������������������������������������������������������������͹��
���Uso       � Consulta Office APD                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Function TOIAvalia(cCodava,cCodAvado,cTipAval) 
Local cQueryAlias	:=	GetNextAlias()
Local aArea			:=	GetArea()                   
Local cRetorno		:=	""    
Local nCont			:=	0    
Local dData			:= cTod('//')

#IFDEF TOP   		
	BeginSql Alias cQueryAlias	  
		SELECT COUNT(*) QUANT 
		FROM %table:RDC% RDC
		WHERE  RDC_CODAVA	= %exp:cCodava%
		AND RDC_CODADO = %exp:cCodAvado%
		AND RDC_TIPOAV = %exp:cTipAval%
		AND RDC_FILIAL = %xFilial:RDC%
		AND RDC.%notDel%    
		AND RDC_DATRET <> %exp:dData%
	EndSql	
			
	Dbselectarea(cQueryAlias)
	cRetorno:= If ((cQueryAlias)->QUANT > 0,"X","")
	
	(cQueryAlias)->(DbCloseArea()) 	
	
#ELSE
      
   DbSelectArea("RDC")
   RDC->(DbSetOrder(1))
   RDC->(DbSeek(xFilial("RDC")+cCodava+cCodAvado))              
   While  RDC->(!EOF()) .AND. RDC->RDC_CODAVA == cCodava .AND. RDC->RDC_CODADO ==cCodAvado
   		If (RDC->RDC_TIPOAV == cTipAval .and. !Empty(RDC->RDC_DATRET) )        
   			nCont++
   		EndIf
   		RDC->(DbSkip())
   End
	cRetorno:= If (nCont > 0,"X","")

#ENDIF  

RestArea(aArea)                   
Return cRetorno                                                                  

