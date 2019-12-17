#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SEC0023a  �Autor  �Gustavo Henrique    � Data �  23/set/02  ���
�������������������������������������������������������������������������͹��
���Descricao �Regra para emissao do documento Regularidade de Estudos.    ���
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
User Function SEC0023a()
local aArea		:= GetArea()
local aScript	:= ACScriptReq( JBH->JBH_NUM )
local aDados	:= {}
local aAss		:= {}
local cNumRA	:= Left( JBH->JBH_CODIDE, TamSX3("JA2_NUMRA")[1] )
local cDataExt	:= "S�o Paulo, "+Alltrim(Str(Day(dDatabase),2,0))+" de "+MesExtenso(Month(dDatabase))+" de "+StrZero(Year(dDatabase),4,0)+"."

Private cSEC	:= ""
Private cPRO	:= ""
                     
U_ASSREQ()

JA2->(dbSetOrder(1))
JA2->(dbSeek(xFilial("JA2")+cNumRA))

JAH->(dbSetOrder(1))
JAH->(dbSeek(xFilial("JAH")+aScript[1]))

aAdd( aDados, {"NOME"		, Alltrim(JA2->JA2_NOME) } )
aAdd( aDados, {"CURSO"		, Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC")) } )
aAdd( aDados, {"INSTITUICAO", Alltrim(aScript[10]) } )
aAdd( aDados, {"HOJE"		, cDataExt } )
aAdd( aDados, {"ASSINATURA"	, "Prof�. Luciene Fernandes de Souza" } )
aAdd( aDados, {"CARGO"		, "Secret�ria de Registros Acad�micos" } )

//�����������������������������������������������������������������������Ŀ
//� Gerando variaveis para assinaturas 	                	              �
//�������������������������������������������������������������������������
aAss := U_ACRetAss( cPRO )

aAdd( aDados, {"CASS1"   , aAss[1] })
aAdd( aDados, {"CCARGO1" , aAss[2] })
aAdd( aDados, {"CRG1"    , aAss[3] })

aAss := U_ACRetAss( cSEC )

aAdd( aDados, {"CASS2"   , aAss[1] })
aAdd( aDados, {"CCARGO2" , aAss[2] })
aAdd( aDados, {"CRG2"    , aAss[3] })

JBE->(dbSetOrder(1))
if JBE->(dbSeek(xFilial("JBE")+cNumRA+aScript[1]+aScript[3]+aScript[4]+aScript[6]))

	if JBE->JBE_ATIVO $ "256789A"	// Nao matriculado
		cSituacao	:=	"informamos que "+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+" "+;
						"n�o renovou matr�cula para o semestre em curso, estando, portanto, sem v�nculo com este "+;
						"Centro Universit�rio, o que impossibilita a expedi��o da Guia de Transfer�ncia."
		cConclusao	:=	"Havendo interesse, o aluno poder� solicitar o Hist�rico Escolar e o Conte�do Program�tico."
	elseif JBE->JBE_ATIVO == "4"	// Trancado
		cSituacao	:=	"informamos que "+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+" "+;
						"encontra-se com a matr�cula trancada no curso "+Alltrim(Posicione("JAF",1,xFilial("JAF")+JAH->JAH_CURSO+JAH->JAH_VERSAO,"JAF_DESMEC"))+" desde "+dtoc(JBE->JBE_DTSITU)+", "+;
						"de acordo com as Normas Regimentais deste Centro Universit�rio."
		cConclusao	:=	"Oportunamente, encaminharemos a Guia de Transfer�ncia."
	elseif JBE->JBE_ATIVO $ "13"	// Ativo
		cSituacao	:=	"atestamos a regularidade da condi��o d"+if(JA2->JA2_SEXO == "2", "a aluna", "o aluno")+" "+Alltrim(JA2->JA2_NOME)+", "+;
						"postulante ao ingresso neste Institui��o de Ensino Superior, pela via de Transfer�ncia."
		cConclusao	:=	"Oportunamente, encaminharemos a Guia de Transfer�ncia."
	endif
	
	aAdd( aDados, {"SITUACAO"	, cSituacao		} )
	aAdd( aDados, {"CONCLUSAO"	, cConclusao	} )
	
	ACImpDoc( JBG->JBG_DOCUM, aDados )

endif

RestArea(aArea)
Return( .T. )
