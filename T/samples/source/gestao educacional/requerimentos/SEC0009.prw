#include "rwmake.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC0009a  �Autor  �Rafael Rodrigues    � Data �  21/jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Regra para emissao do documento Guia de Transferencia.      ���
�������������������������������������������������������������������������͹��
���Param.    �Nenhum.                                                     ���
�������������������������������������������������������������������������͹��
���Retorno   �ExpL1 : Informando se obteve sucesso                        ���
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
User Function SEC0009a()

local aArea		:= GetArea()
local lRet		:= .F.
local lOk		:= .T.
local cNumRA	:= Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aRet		:= ACScriptReq( JBH->JBH_NUM )
local aDados	:= {}
local aAss		:= {}
local cDataExt	:= "S�o Paulo, "+Alltrim(Str(Day(dDatabase),2,0))+" de "+MesExtenso(Month(dDatabase))+" de "+StrZero(Year(dDatabase),4,0)+"."

private cPRO	:= Space(6)
private cSEC	:= Space(6)

//����������������������������������������������������������Ŀ
//� Seleciona as assinaturas da pro-reitoria e da secretaria �
//������������������������������������������������������������
U_AssReq()

JA2->(dbSetOrder(1))
JA2->(dbSeek(xFilial("JA2")+cNumRA))

JAH->(dbSetOrder(1))
JAH->(dbSeek(xFilial("JAH")+aRet[1]))

aAdd( aDados, {"NOME"		, Alltrim(JA2->JA2_NOME) } )
aAdd( aDados, {"CURSO"		, Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC")) } )
aAdd( aDados, {"HABILI"     , Posicione("JDK",1,xFilial("JDK")+aRet[4],"JDK_DESC")} )
aAdd( aDados, {"INSTITUICAO", Alltrim(aRet[10]) } )
aAdd( aDados, {"HOJE"		, cDataExt } )
aAdd( aDados, {"ASSINATURA"	, "Prof�. Luciene Fernandes de Souza" } )
aAdd( aDados, {"CARGO"		, "Secret�ria de Registros Acad�micos" } )

// Caso encontrar o campo 11 e 12 preenchidos no script da solicitacao do requerimento
if Len( aRet ) > 10
	aAdd( aDados, {"cNomSecr" , alltrim( aRet[11]  ) } )
	aAdd( aDados, {"cFuncSecr", alltrim( aRet[12] ) } )
endif

//������������������������������������Ŀ
//� Gerando variaveis para assinaturas �
//��������������������������������������
aAss := U_ACRetAss( cPRO )

aAdd( aDados, {"cAss1"  , aAss[1] } )
aAdd( aDados, {"cCargo1", aAss[2] } )
aAdd( aDados, {"cRg1"   , aAss[3] } )

aAss := U_ACRetAss( cSEC )

aAdd( aDados, {"cAss2"  , aAss[1] } )
aAdd( aDados, {"cCargo2", aAss[2] } )
aAdd( aDados, {"cRg2"   , aAss[3] } )

JBE->(dbSetOrder(1))

if JBE->(dbSeek(xFilial("JBE")+cNumRA+aRet[1]+aRet[3]+aRet[4]+aRet[6]))
                              
	if JBE->JBE_ATIVO $ "256789AB"	// Nao matriculado
		cSituacao	:=	"Atendendo ao que disp�e a Portaria do MEC n� 975/92, informamos que "+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+" "+;
						"n�o renovou matr�cula para o semestre em curso, estando, portanto, sem v�nculo com este "+;
						"Centro Universit�rio, o que impossibilita a expedi��o da Guia de Transfer�ncia."
		cConcl	:=	"  " 
		cConclus	:=	"Colocamo-nos � disposi��o para quaisquer esclarecimentos."
		lOk := .F.
	elseif JBE->JBE_ATIVO == "4"	// Trancado
		cSituacao	:=	"Atendendo ao que disp�e a Portaria do MEC n� 975/92, informamos que de acordo com as normas regimentais deste Centro Universit�rio "+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+" "+;
						"encontra-se com a matr�cula trancada no curso "+Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC"))+" desde "+dtoc(JBE->JBE_DTSITU)+", "
		cConcl	:=	"Oportunamente, encaminharemos a Guia de Transfer�ncia."   
		cConclus	:=	"Colocamo-nos � disposi��o para quaisquer esclarecimentos."
	elseif JBE->JBE_ATIVO $ "13"	// Ativo;Transferido
		cSituacao	:=	"DECLARAMOS, para os devidos fins de direito, que "+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+", "+;
						"requeriu, nesta secretaria, a TRANSFER�NCIA para "+alltrim(aRet[10])+", de conformidade com a declara��o de vaga apresentada."
		cConcl	:=	"DECLARAMOS tamb�m que encaminharemos a Guia de Transf�rencia, via correio, atendendo ao que determina a Portaria n� 975, de 25/06/92, D.O.U p�g. 8.161."
		cConclus	:=	" "
		If ExistBlock("ACAtAlu1")
			U_ACAtAlu1("JBE")
		EndIf
				
		RecLock( "JBE", .F. )
		JBE->JBE_NUMREQ := JBH->JBH_NUM
		JBE->JBE_ATIVO  := "B"		//	Transferido
		JBE->JBE_TPTRAN := "002"	// Transferencia(vindos de outras IES) 
		MsUnlock()    
		
		//���������������������������������������������������������������������������������������������������Ŀ
		//� Atualiza situa��o do aluno e das disciplinas do curso de origem em que o aluno estava matriculado �
		//�����������������������������������������������������������������������������������������������������
		JC7->( dbSetOrder( 1 ) )
		JC7->( dbSeek( xFilial( "JC7" ) + JBE->( JBE_NUMRA + JBE_CODCUR + JBE_PERLET + JBE_HABILI + JBE_TURMA ) ) )
		
		While JC7->( ! EoF() .And. xFilial( "JC7" ) + JC7_NUMRA + JC7_CODCUR + JC7_PERLET + JC7_HABILI + JC7_TURMA == xFilial( "JC7" ) + JBE->( JBE_NUMRA + JBE_CODCUR + JBE_PERLET + JBE_HABILI + JBE_TURMA ) )
			
			RecLock( "JC7", .F. )
			JC7->JC7_SITDIS := "008"	// Transferido
			JC7->JC7_SITUAC := "9"		// Cancelado
			JC7->( MsUnlock() )
			
			JC7->( dbSkip() )
			
		End

		If ExistBlock("ACAtAlu2")
			U_ACAtAlu2("JBE")
		EndIf

	endif
	
	aAdd( aDados, {"SITUACAO"	, cSituacao		} )
	aAdd( aDados, {"CONCL"	, cConcl	} )
	aAdd( aDados, {"cCONCLUSAO1"	, cConclus	} )
	ACImpDoc( JBG->JBG_DOCUM, aDados )

	if lOk
		
		lRet := U_Sec0009b()	// Emite a guia de transferencia
		
	else
		
		lRet := .T.
		
	endif
	
endif

RestArea(aArea)

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC0009b  �Autor  �Rafael Rodrigues    � Data �  20/jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Regra para emissao do documento Guia de Transferencia.      ���
�������������������������������������������������������������������������͹��
���Param.    �Nenhum.                                                     ���
�������������������������������������������������������������������������͹��
���Retorno   �ExpL1 : Informando se obteve sucesso                        ���
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
User Function SEC0009b()
local aASS 		:= {}
local aArea		:= GetArea()
local lRet		:= .T.
local cNumRA	:= Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aScript	:= ACScriptReq( JBH->JBH_NUM )
local aDados	:= {}
local cDataExt	:= "S�o Paulo, "+Alltrim(Str(Day(dDatabase),2,0))+" de "+MesExtenso(Month(dDatabase))+" de "+StrZero(Year(dDatabase),4,0)+"."

JA2->(dbSetOrder(1))
JA2->(dbSeek(xFilial("JA2")+cNumRA))

JAH->(dbSetOrder(1))
JAH->(dbSeek(xFilial("JAH")+aScript[1]))

aAdd( aDados, {"SEXO"		, if(JA2->JA2_SEXO == "2", "a aluna", "o aluno") } )
aAdd( aDados, {"NOME"		, Alltrim(JA2->JA2_NOME) } )
aAdd( aDados, {"CURSO"		, Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC")) } )
aAdd( aDados, {"HABILI"     , Posicione("JDK",1,xFilial("JDK")+aScript[4],"JDK_DESC")})
aAdd( aDados, {"INSTITUICAO", Alltrim(aScript[10]) } )
aAdd( aDados, {"HOJE"		, cDataExt } )
aAdd( aDados, {"ASSINATURA"	, "Prof. Eduardo Stor�poli" } )
aAdd( aDados, {"CARGO"		, "Reitor" } )
aAdd( aDados, {"RG"			, "RG n� 10.633.686" } )
aAss := U_ACRetAss( cPRO )

aAdd( aDados, {"cAss1"  , aAss[1] } )
aAdd( aDados, {"cCargo1", aAss[2] } )
aAdd( aDados, {"cRg1"   , aAss[3] } )

aAss := U_ACRetAss( cSEC )

aAdd( aDados, {"cAss2"  , aAss[1] } )
aAdd( aDados, {"cCargo2", aAss[2] } )
aAdd( aDados, {"cRg2"   , aAss[3] } )

ACImpDoc( "\SEC0009b.dot", aDados )

RestArea(aArea)

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SEC0009c � Autor � Gustavo Henrique   � Data � 28/03/03    ���
�������������������������������������������������������������������������͹��
���Descricao � Libera vaga do aluno ao deferir o requerimento, e se a     ���
���          � guia de transferencia foi emitida.                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC0009c()

local cNumRA	:= Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local aRet		:= ACScriptReq( JBH->JBH_NUM )
local aPrefixo	:= ACPrefixo()

JBE->(dbSetOrder(1))

if JBE->(dbSeek(xFilial("JBE")+cNumRA+aRet[1]+aRet[3]+aRet[4]+aRet[6]))

	if ! (JBE->JBE_ATIVO $ "2356789AB")	// Nao matriculado

		//�����������������������������������������������������������������������������������������������������������������������Ŀ
		//� Apaga reservas do aluno e libera vaga no curso, periodo, turma e em todas as disciplinas em que ele est� matriculado. �
		//� Atualiza o status no curso e nas disciplinas para transferido e apaga todos os titulos em aberto.                     �
		//�������������������������������������������������������������������������������������������������������������������������
		U_ACLibVaga( cNumRA, aRet[1], aRet[3], aRet[6], aPrefixo, "008", "9", "3", aRet[4] )
     
	endif

endif

Return( .T. )
