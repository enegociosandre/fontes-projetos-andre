#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC004a   �Autor  �Gustavo Henrique    � Data �  18/jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Regra Final do Requerimento de Regime Domiciliar            ���
���          �Rotina para gravar os dados de regime domiciliar do aluno.  ���
�������������������������������������������������������������������������͹��
���Param.    �ExpC1 : RA do aluno.                                        ���
�������������������������������������������������������������������������͹��
���Retorno   �ExpL1 : Informando se a gravacao obteve sucesso             ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional - Requerimentos                          ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC0004a( cNumRA )

Local lAchou := .F.
Local aRet   := ACScriptReq( JBH->JBH_NUM )

Begin Transaction

	JCM->( dbSetOrder( 1 ) )
	lAchou := JCM->( dbSeek( xFilial( "JCM" ) + SubStr( cNumRA, 1, 15 ) + DtoS( CtoD( aRet[3] ) ) ) )

	RecLock( "JCM", !lAchou )
		                      
	JCM->JCM_FILIAL := xFilial( "JCM" )
	JCM->JCM_NUMRA  := cNumRA		                     
	JCM->JCM_DATA1  := CtoD( aRet[3] )
	JCM->JCM_DATA2  := CtoD( aRet[4] )
	JCM->JCM_CODCID := aRet[1]
	     
	// Gravacao do campo memo "Observacoes"
	JCM->( MSMM(If(lAchou,JCM_MEMO1,NIL),TamSX3("JCM_OBSERV")[1],,aRet[5],1,,,"JCM","JCM_MEMO1") )
	
	JCM->( MsUnLock() )

End Transaction
	
Return( .T. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC004b   �Autor  �Gustavo Henrique    � Data �  26/jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao do campo Data Inicial do requerimento de Regime   ���
���          �Domiciliar.                                                 ���
�������������������������������������������������������������������������͹��
���Param.    �ExpD1 : Data Inicial.                                       ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional - Requerimentos                          ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC004b( dDataIni, dDataFim, lWeb )

Local lRet		:= .T.
Local cACCodGe	:= AllTrim( GetMV( "MV_ACCODGE" ) )
Local nACGesta	:= GetMV( "MV_ACGESTA" )
Local nACDoenc	:= GetMV( "MV_ACDOENC" )
Local dDataCalc	:= dDataIni
Local dPerIni	:= Ctod("  /  /  ")
Local aRet 		:= {}

lWeb		:= iif(lWeb == nil,.F.,lWeb)


// Verifica se a data inicial nao eh menor que a data de matricula do aluno
If dDataIni # NIL
               
	JBE->( dbSetOrder( 3 ) )
    If !lWeb
		JBE->( dbSeek( xFilial( "JBE" ) + "1" + Left( M->JBH_CODIDE, TamSX3("JA2_NUMRA" )[1] ) ) )
 	else 
		JBE->( dbSeek( xFilial( "JBE" ) + "1" + Left( ALLTRIM(HttpSession->ra), TamSX3("JA2_NUMRA" )[1] ) ) ) 	
 	EndIf
 	
	dPerIni := Posicione( "JAR", 1, xFilial("JAR") + JBE->( JBE_CODCUR + JBE_PERLET + JBE_HABILI ), "JAR_DATA1" )
	                                                                                                                 
	If dDataIni < dPerIni
		if !lWeb
			MsgInfo( "A data inicial n�o pode ser inferior que a data de inicio do periodo letivo: " + DtoC( dPerIni ) )
		else
			aadd(aRet,{.F.,"A data inicial n�o pode ser inferior que a data de inicio do periodo letivo: " + DtoC( dPerIni )})			        
    	EndIf

		lRet := .F.
	EndIf

EndIf

If lRet

	// Caso o codigo CID seja o mesmo do parametro referente ao codigo de gestante 
	If RTrim( M->JBH_SCP01 ) $ RTrim( cACCodGe )
		dDataCalc += nACGesta
	Else
		dDataCalc += nACDoenc
	EndIf
	    
	// Se for a validacao do campo de Data Final
	If dDataFim # NIL      
	
		lRet := dDataFim >= dDataIni
		
		If ! lRet 
			If !lWeb
				MsgStop( "A data final n�o pode ser menor que a data inicial." )
			else
				aadd(aRet,{.F.,"A data final n�o pode ser menor que a data inicial."})			        
	    	EndIf
		EndIf
		
		If lRet
		
			lRet := dDataFim <= dDataCalc
		
			If ! lRet
				If !lWeb
					MsgStop( "A data final n�o pode ser maior que o dia " + DtoC( dDataCalc ) )
				else
					aadd(aRet,{.F.,"A data final n�o pode ser maior que o dia " + DtoC( dDataCalc )})			        
		    	EndIf
			EndIf 	
		
			// Verifica se a soma dos regimes domiciliares ultrapassa o limite de tempo
			// dos parametros
			If lRet
				If !lWeb
					lRet := U_SEC004d( M->JBH_SCP01, dDataIni, dDataFim, Padr( M->JBH_CODIDE, TamSx3("JA2_NUMRA")[1] ) )
				else
					lRet := U_SEC004d( M->JBH_SCP01, dDataIni, dDataFim, Padr( ALLTRIM(HttpSession->ra), TamSx3("JA2_NUMRA")[1] ) )
				EndIf
			EndIf
			
		EndIf
				
	EndIf	

EndIf
	
Return( iif(!lWeb,lRet,aRet) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC004c   �Autor  �L.E.Fael            � Data �  26/jul/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao do codigo CID para Web                            ���
�������������������������������������������������������������������������͹��
���Param.    �lweb                                                        ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional - Requerimentos                          ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC004C(lweb)

Local aRet := {}
local aArea		:= GetArea()

lWeb := IIf(lWeb == NIL, .F., lWeb)
TMR->(dbSetOrder(1))
If !(TMR->(dbSeek(xFilial("TMR")+PadR(M->JBH_SCP01, TamSX3("TMR_CID")[1]))))
		If lWeb       
				aadd(aRet,{.F.,"Codigo CID n�o Cadastrado."})
				RestArea(aArea)
				Return aRet
		Else   
				RestArea(aArea)		
		        Return .F.
		EndIf
EndIf
RestArea(aArea)
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC004d   �Autor  �Gustavo Henrique    � Data �  29/jul/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao do periodo de regime domiciliar                   ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional - Requerimentos                          ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC004d( cCodCid, dData1, dData2, cNumRA )

Local cAno         := ""
Local cCodGestante := RTrim( GetMv("MV_ACCODGE") )
Local dPeriodo1    := Ctod("  /  /  ")
Local dPeriodo2    := Ctod("  /  /  ")
Local lRet         := .T.
Local lGestante    := .F.
Local nQtdDias     := 0
Local nTempoMax    := 0

JCM->( dbSetOrder( 1 ) )

If ! Empty( dData1 )

	JCM->( dbSeek( xFilial( "JCM" ) + cNumRA ) )
	                                            
	Do While JCM->( ! EoF() .and. JCM_FILIAL == xFilial( "JCM" ) .and. JCM_NUMRA == cNumRA )

		If dData1 >= JCM->JCM_DATA1 .and. dData1 <= JCM->JCM_DATA2
			MsgInfo( "J� existe regime domiciliar nesta data." )
			lRet := .F.
			Exit
		EndIf
         
		JCM->( dbSkip() )

	EndDo

EndIf
                
If lRet .and. !Empty(dData1) .And. !Empty(dData2) .And. !Empty(cCodCid)

	cAno      := Right(Str(Year(dData1), 4), 2)
	dPeriodo1 := Iif(Month(dData1) >= 1 .And. Month(dData1) <= 6, Ctod("01/01/" + cAno), Ctod("01/07/" + cAno))
	dPeriodo2 := Iif(Month(dData1) >= 1 .And. Month(dData1) <= 6, Ctod("30/06/" + cAno), Ctod("31/12/" + cAno))
	lGestante := Iif(RTrim(cCodCid) $ cCodGestante, .T., .F.)
	nTempoMax := Iif(lGestante, GetMv("MV_ACGESTA"), GetMv("MV_ACDOENC"))
 	nQtdDias  := dData2 - dData1
                            
	JCM->( dbSeek( xFilial( "JCM" ) + cNumRA ) )

	Do While JCM->( ! EoF() .and. JCM_FILIAL == xFilial( "JCM" ) .and. JCM_NUMRA == cNumRA )

		If JCM->JCM_DATA1 < dPeriodo1 .Or. JCM->JCM_DATA2 > dPeriodo2
			JCM->( dbSkip() )
			Loop
		EndIf

		nQtdDias := nQtdDias + ( JCM->JCM_DATA2 - JCM->JCM_DATA1 )
         
		JCM->( dbSkip() )

	EndDo

	If nQtdDias > nTempoMax
		// A soma de todos os regimes domiciliares nesse semestre, supera o tempo maximo
		// definido nos parametros MV_ACDOENC ou MV_ACGESTA, de acordo com o tipo do 
		// regime.
		Help(" ",1,"ACAA240A_A")
		lRet := .F.
	EndIf

EndIf

Return( lRet )
