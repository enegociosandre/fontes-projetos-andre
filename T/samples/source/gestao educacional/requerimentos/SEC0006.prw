#include "rwmake.ch"
#include "acadef.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC0006a  �Autor  �Rafael Rodrigues    � Data �  18/jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Regra Final do Requerimento de Cancelamento de Matricula.   ���
���          �Rotina para cancelar o curso especificado no script.        ���
�������������������������������������������������������������������������͹��
���Param.    �Nenhum.                                                     ���
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
User Function SEC0006a()
local cNumRA	:= Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aRet   	:= ACScriptReq( JBH->JBH_NUM )
local nRecord	:= 0
local aPrefixo	:= ACPrefixo()

JBE->(dbSetOrder(1))	// JBE_FILIAL+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA
JBE->(dbSeek(xFilial("JBE")+cNumRA+aRet[1]+aRet[3]+aRet[4]+aRet[6]))
while JBE->( !eof() .and. JBE_FILIAL+JBE_NUMRA+JBE_CODCUR+JBE_PERLET+JBE_HABILI+JBE_TURMA == xFilial("JBE")+cNumRA+aRet[1]+aRet[3]+aRet[4]+aRet[6] )
	if JBE->JBE_ATIVO == "2" .and. JBE->JBE_SITUAC == "1"	// Pre-matricula
		nRecord := JBE->( Recno() )
		exit
	elseif JBE->JBE_ATIVO == "1"
		nRecord := JBE->( Recno() )
		exit
	endif
	JBE->( dbSkip() )
end

if nRecord > 0
	//�����������������������������������������������������������������������������������������������������������������������Ŀ
	//� Apaga reservas do aluno e libera vaga no curso, periodo, turma e em todas as disciplinas em que ele est� matriculado. �
	//� Atualiza o status no curso e nas disciplinas para trancado e apaga todos os titulos em aberto.                        �
	//�������������������������������������������������������������������������������������������������������������������������
	U_ACLibVaga( cNumRA, aRet[1], aRet[3], aRet[6], aPrefixo, "009", "9", "6", aRet[4] )	// Cancelamento
endif
	
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC0006b  �Autor  �Rafael Rodrigues    � Data �  19/jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicializador Padrao da Justificativa do Script.            ���
���          �Verifica a situacao financeira do aluno e alerta caso esteja���
���          �irregular. O aluno deve reguralizar a situacao financeira do���
���          �curso antes de requerer trancamento/cancelamento/desistencia���
�������������������������������������������������������������������������͹��
���Param.    �Nenhum.                                                     ���
�������������������������������������������������������������������������͹��
���Retorno   �ExpC1 : Brancos.                                            ���
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
User Function SEC0006b()

// Utiliza a funcao de validacao para exibir as mensagens
U_SEC0006c()

Return ""

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC0006c  �Autor  �Rafael Rodrigues    � Data �  19/jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao da Justificativa do Script.                       ���
���          �Verifica a situacao financeira do aluno e alerta caso esteja���
���          �irregular. O aluno deve reguralizar a situacao financeira do���
���          �curso antes de requerer trancamento/cancelamento/desistencia���
�������������������������������������������������������������������������͹��
���Param.    �Nenhum.                                                     ���
�������������������������������������������������������������������������͹��
���Retorno   �ExpL1 : Indicador de validacao.                             ���
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
User Function SEC0006c(lweb)
local aArea		:= GetArea()
Local aRet      := {}
local lRet		:= .T.
local cNumRA	:= Padr(M->JBH_CODIDE ,TamSx3("JA2_NUMRA")[1])
local cCurso	:= Padr(M->JBH_SCP01  ,TamSx3("JBE_CODCUR")[1])
local cPerLet	:= Padr(M->JBH_SCP03  ,TamSx3("JBE_PERLET")[1])
local cHabili   := Padr(M->JBH_SCP04  ,TamSx3("JBE_HABILI")[1])
local cTurma	:= Padr(M->JBH_SCP06  ,TamSx3("JBE_TURMA")[1])
local cCliente	:= Posicione("JA2", 1, xFilial("JA2")+cNumRA, "JA2_CLIENT")
local cLoja		:= Posicione("JA2", 1, xFilial("JA2")+cNumRA, "JA2_LOJA"  )
local aAtraso	:= {}
local cTexto	:= ""
local i

lWeb := IIf(lWeb == NIL, .F., lWeb)

JBE->( dbSetOrder(1) )
JBE->( dbSeek(xFilial("JBE") + cNumRA + cCurso + cPerLet + cHabili + cTurma) )
if JBE->JBE_ATIVO <> "1"	// Se nao for ativo
    If lWeb
        aadd(aRet,{.F.,'<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">O aluno n�o est� ativo no curso e per�odo letivo solicitados.</font></b><br>'})
    Else    
		MsgStop("O aluno n�o est� ativo no curso e per�odo letivo solicitados.")
		lRet := .F.
	EndIf	
endif

if lRet

	//�����������������������������������������������������������������Ŀ
	//�Para requerimento de cancelamento de matricula, verifica se as   �
	//�aulas ainda nao iniciaram e se e'aluno novo.                     �
	//�������������������������������������������������������������������
	JAR->( dbSetOrder(1) )
	JAR->( dbSeek(xFilial() + cCurso + cPerLet + cHabili) )
	if JAR->JAR_DATA1 <= dDatabase
	    If lWeb
	        aadd(aRet,{.F.,	"O cancelamento s� pode ser efetuado at� o dia anterior ao in�cio das aulas e ap�s o pagamento da matricula."})
		Else	        	
			MsgStop("O cancelamento s� pode ser efetuado at� o dia anterior ao in�cio das aulas e ap�s o pagamento da matr�cula." )
			lRet := .F.
		EndIf	
	endif

	If lRet
	
		//�����������������������������������������������������������������Ŀ
		//�Percorre todos os titulos do aluno verificando t�tulos em atraso �
		//�para o curso solicitado no script.                               �
		//�������������������������������������������������������������������
		SE1->( dbSetOrder(2) )	// (F) E1_FILIAL+E1_CLIENTE+E1_LOJA
		SE1->( dbSeek(xFilial("SE1")+cCliente+cLoja) )
		while !SE1->( eof() ) .and. SE1->E1_CLIENTE+SE1->E1_LOJA == cCliente+cLoja
			
			// Se o curso for outro, ignora
			if Left( SE1->E1_NRDOC, 6 ) <> cCurso
				SE1->( dbSkip() )
			    loop
			// Se estiver em atraso, acumula no array 
			elseif SE1->E1_VENCREA < dDatabase .and. SE1->E1_STATUS <> "B"
				aAdd( aAtraso, {SE1->E1_PARCELA+" / "+SE1->E1_PREFIXO, SE1->E1_VENCREA, SE1->E1_VALOR} )
			endif
			
			SE1->( dbSkip() )
		end
		
		if len( aAtraso ) > 0
			    If lWeb
					aadd(aRet,{.F.,'<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Existem t�tulos pendentes para este aluno.</font></b><br>'})
					aadd(aRet,{.F.,'<table width="60%" border="0" cellspacing="0" cellpadding="0" align="center">'})
					aadd(aRet,{.F.,'<tr align="center">'})
					aadd(aRet,{.F.,'<td height="11"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">T&iacute;tulo</font></b></td>'})
					aadd(aRet,{.F.,'<td height="11"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Vencimento</font></b></td>'})
					aadd(aRet,{.F.,'<td height="11"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Valor</font></b></td>'})
					aadd(aRet,{.F.,'</tr>'})
			    Else
					lRet	:= .F.
					cTexto	+= "Existem t�tulos pendentes para este aluno."+CRLF
					cTexto	+= "� necess�ria a negocia��o destes t�tulos antes de prosseguir com a inclus�o deste requerimento."+CRLF+CRLF
					cTexto	+= "Titulo         Vencimento               Valor"+CRLF
				EndIf	
		endif
		
		for i := 1 to len( aAtraso )
			    If lWeb
					aadd(aRet,{.F.,'<tr align="center">'})
					aadd(aRet,{.F.,'<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">'+Alltrim(aAtraso[i][1])+'</font></td>'})
					aadd(aRet,{.F.,'<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">'+dtoc(aAtraso[i][2])+'</font></td>'})
					aadd(aRet,{.F.,'<td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">'+Alltrim(Transform(aAtraso[i][3], "@E 9,999.99"))+'</font></td>'})
					aadd(aRet,{.F.,'</tr>'})
			    Else
					cTexto += aAtraso[i][1] + Space(6) + dtoc(aAtraso[i][2]) + Space(6) + Transform(aAtraso[i][3], "@E 999,999,999.99") + CRLF
				Endif	
		next i
		
		if len( aAtraso ) > 0
			
			if lWeb
				aadd(aRet,{.F.,'</table>'})
			else
				MsgStop( cTexto )
			endif
			
		else
		
			//��������������������������������������������������������������������������������Ŀ
			//� Verifica se existe titulo de matricula em aberto para o aluno, caso exista nao �
			//� permite que o aluno efetue o cancelamento ate que ele pague a matricula        �
			//����������������������������������������������������������������������������������
			lRet := U_ACMatPaga( cCurso, cPerLet, cNumRA )
					
			if ! lRet
					
				if ! lWeb     
					MsgStop( "O t�tulo referente a matr�cula deste aluno deve ser baixado antes da solicita��o de cancelamento." )
				else
					aadd(aRet,{.F.,	'<b><font face="Verdana, Arial, Helvetica, sans-serif" size="1">' +;
									'O t�tulo referente a matr�cula deste aluno deve ser baixado antes da solicita��o de cancelamento.</font></b><br>'})
				endif
						
			endIf		
			
		endif

	endif

endif
	
RestArea(aArea)

Return( iif( lWeb, aRet, lRet ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC0006d  �Autor  �Rafael Rodrigues    � Data �  02/jul/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacoes do script.                                       ���
�������������������������������������������������������������������������͹��
���Param.    �Nenhum.                                                     ���
�������������������������������������������������������������������������͹��
���Retorno   �ExpL1 : Indicador de validacao.                             ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional - Requerimentos                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC0006d( lScript, cKey, lWeb )
local lRet	:= .T.                         
Local aRet  := {}

lScript	:= if( lScript == nil, .F., lScript )
cKey	:= if( cKey == nil, "", cKey )    
lWeb	:= if( lWeb == nil, .F., lWeb )    

if lScript
	lRet	:= ExistCpo("JBE",Padr(M->JBH_CODIDE,TAMSX3("JA2_NUMRA")[1])+cKey, 1)

	if lRet

		JBE->( dbSetOrder(3) )
		lRet := JBE->( dbSeek( xFilial("JBE")+"1"+Padr(M->JBH_CODIDE,TAMSX3("JA2_NUMRA")[1])+cKey ) )
	
		if !lRet 
		    If !lWeb
				MsgStop("Curso inv�lido para este aluno.")
			Else
		        aadd(aRet,{.F.,"Curso inv�lido para este aluno."})	
		        Return aRet
		    EndIf   
		else
			M->JBH_SCP02	:= Posicione("JAF",1,xFilial("JAF")+Posicione("JAH",1,xFilial("JAH")+JBE->JBE_CODCUR,"JAH_CURSO")+JAH->JAH_VERSAO,"JAF_DESMEC")
			M->JBH_SCP03	:= JBE->JBE_PERLET
			M->JBH_SCP04    := JBE->JBE_HABILI
			M->JBH_SCP06	:= JBE->JBE_TURMA
			M->JBH_SCP07	:= Posicione("JAR",1,xFilial("JAR")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI,"JAR_ANOLET")
			M->JBH_SCP08	:= Posicione("JAR",1,xFilial("JAR")+JBE->JBE_CODCUR+JBE->JBE_PERLET+JBE->JBE_HABILI,"JAR_PERIOD")
			M->JBH_SCP09	:= Posicione("JA2",1,xFilial("JA2")+JBE->JBE_NUMRA,"JA2_FRESID")	
		endif
	endif
endif

Return lRet
