#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � M020Inc  � Autor �Marcos Wey da Mata  � Data � 28/07/2011  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada apos Inclusao de Fornecedores             ���
�������������������������������������������������������������������������͹��
���																		  ���
���																		  ���
���																		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

 
User Function M020Inc()

Local aArr		
Local aArea 	:=	GetArea()
Local oTecCtb 	:= 	TecxCtb():New()

&&if	M->A2_ZZTIPO $ "F,P,C" && A principio ser� criado Item contabil para todos os fornecedores 

	&& Atualiza Fornecedor	
	RecLock("SA2",.f.)
		SA2->A2_ZZITEM	:= 	oTecCtb:RetCliForCta( "SA2" , "A2_ZZITEM"	)
	MsUnlock("SA2")
	
	&& Criacao do Item				  
	aArr	:= 	{ oTecCtb:RetCliForCta( "SA2" , "A2_ZZITEM"		) }
	
	oTecCtb:CriaCtaCtb( aArr , "SA2" )
&&endif
RestArea(aArea)

Return