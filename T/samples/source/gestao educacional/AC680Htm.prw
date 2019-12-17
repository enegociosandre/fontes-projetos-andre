#include "rwmake.ch"
                 
#define __ADA	1
#define __DEP	2
#define __TUT	3
#define __MES	4
#define __MAT	5
#define __REQ	6
#define __NEG	7
#define __DIS	8

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AC680Htm  �Autor  �Rafael Rodrigues    � Data �  10/Jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada na emissao da segunda via do boleto, para  ���
���          �imprimir um cabecalho personalizado antes do boleto.        ���
�������������������������������������������������������������������������͹��
���Param.    �Nenhum                                                      ���
�������������������������������������������������������������������������͹��
���Retorno   �Texto ou HTML a ser impresso no inicio da pagina do boleto  ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional - Hypersite                              ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��� WILKER     �21/06/02�      � INCLUSAO DOS TIPOS DE BOLETO             ���
��� WILKER     �28/10/02�      � INCLUSAO DE CONTROLE DE SESSAO PARA O    ���
���            �        �      � PRINT DO LOGO DA INSTITUICAO NO BOLETO   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AC680Htm()
// ::: ARMAZENAR POSICIONAMENTO DO SE1
Local SE1Filial   := SE1->E1_FILIAL
Local SE1Prefixo  := SE1->E1_PREFIXO
Local SE1Num      := SE1->E1_NUM
Local SE1Parcela  := SE1->E1_PARCELA
Local SE1Tipo     := SE1->E1_TIPO
local cReturn	 := ""
Local aTipos	 := U_AC680Prf() // chamada dos tipos de boleto
Local cDescr	 := ""
Local nPos		 := 0
Local cLogo	     := ""
Local nTamSX1    := 0 
Local nTamSX2    := 0 
Local nTamSX3    := 0 
Local nTamControle := 0
Local cControle    := ""

Private aPrefixo := ACPrefixo()

if !Empty( HttpSession->cPastaImg )
	cLogo := HttpSession->cPastaImg + "/logo_boleto.gif"
endif

nPos   := Ascan(aTipos,{|aVal| aVal[1] == SE1->E1_PREFIXO})
if nPos > 0
	cDescr := Capital(Alltrim(aTipos[nPos,2]))
endif

//��������������������������������������������������������������������������Ŀ
//� Se estiver sendo chamada da solicitacao de requerimentos, posiciona no   �
//� requerimento que originou o titulo.                                      �
//����������������������������������������������������������������������������
if SE1->E1_PREFIXO == aPrefixo[__REQ]
	
	JBH->( dbSetOrder( 1 ) )
	JBH->( dbSeek( xFilial( "JBH" ) + SE1->E1_NRDOC ) )
	
endif

/*
"ADA", "Adapta��o"
"DEP", "Depend�ncia"
"MAT", "Matr�cula"
"MES", "Mensalidade"
"NEG", "Negocia��o"
"REQ", "Requerimento"
"TUT", "Tutoria"
*/


//posicionar SE1
SE1->(dbsetorder(1))
if SE1->(dbseek(SE1Filial+SE1Prefixo+SE1Num+SE1Parcela+SE1Tipo))
	if SE1->E1_PREFIXO $ aPrefixo[__ADA] + "/" + aPrefixo[__DEP] + "/" + aPrefixo[__TUT] // "ADA/DEP/TUT"
		
		cReturn := '<table border="0" width="100%" cellspacing="0" cellpadding="0">'
		cReturn += '  <tr>'
		if !Empty(cLogo)
			cReturn += '    <td width="200"><img border="0" src="'+cLogo+'"></td>'
		else
			cReturn += '    <td width="200">&nbsp;</td>'
		endif
		cReturn += '    <td width="*" valign="center" align="center">'
		cReturn += '       <font face="Verdana" size="1">Prezado Aluno <b>'+Alltrim( Posicione("SA1", 1, xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA, "A1_NOME") )+'</b></font><br>'
		cReturn += '&nbsp;'
		cReturn += '    </td>'
		cReturn += '    <td width="200" valign="top" align="right">'
		cReturn += '       <font face="Verdana" size="1">'+cDescr+'</font><br></td>'
		cReturn += '  </tr>'
		cReturn += '</table>'
		cReturn += ' <font face="Verdana" size="1">Este pagamento dever� ser efetuado UNICAMENTE NA REDE BANC�RIA e a liquida��o '
		cReturn += 'dever� ser efetuada at� a data do vencimento no banco que melhor lhe convier. Ap�s '
		cReturn += 'o vencimento, o pagamento somente poder� ser efetuado no banco portador da cobran�a.</font><br><br>'
		cReturn += '<table border="0" width="100%" cellspacing="0">'
		cReturn += '<tr><td width="80%"> <font face="Verdana" size="1"><b>Disciplina</b></font><br></td>'
		cReturn += '<td width="*"> <font face="Verdana" size="1"><b>Carga Hor�ria</b></font><br></td></tr>'
		
		nTamSX1 := TamSx3("JBE_CODCUR")[1]
		nTamSX2 := TamSx3("JBE_PERLET")[1]
		nTamSX3 := TamSx3("JAE_CODIGO")[1]
		nTamControle := TamSx3("JBA_COD")[1]
		cControle    := Substr(SE1->E1_NRDOC, (nTamSX1 + nTamSX2) + 1, nTamControle)

		JBA->(dbSetOrder(1))
		JBA->(dbSeek(xFilial("JBA") + cControle))

		While JBA->JBA_FILIAL == xFilial("JBA") .And.;
				JBA->JBA_COD    == cControle      .And. !Eof()
			cReturn += '<tr><td width="80%"> <font face="Verdana" size="1">'
			cReturn += Alltrim( Posicione("JAE",1,xFilial("JAE") + JBA->JBA_CODDIS,"JAE_DESC") )
			cReturn += '</font>&nbsp;</td><td width="*"> <font face="Verdana" size="1">'
			cReturn += Alltrim( Str( Posicione("JAE",1,xFilial("JAE") + JBA->JBA_CODDIS,"JAE_CARGA"), 4, 0 ) )
			cReturn += '</font>&nbsp;</td></tr>'

			dbSelectArea("JBA")
			dbSkip()
		EndDo

		cReturn += '</table>'
		cReturn += '<br>'
		
	elseif SE1->E1_PREFIXO $ aPrefixo[__MAT]
		
		cReturn := '<table border="0" width="100%" cellspacing="0" cellpadding="0">'
		cReturn += '  <tr>'
		if !Empty(cLogo)
			cReturn += '    <td width="200"><img border="0" src="'+cLogo+'"></td>'
		else
			cReturn += '    <td width="200">&nbsp;</td>'
		endif
		cReturn += '    <td width="*">'
		cReturn += '      <p align="center"><b><u>ATEN��O</u></b></td>'
		cReturn += '    <td width="200"></td>'
		cReturn += '  </tr>'
		cReturn += '</table>'
		cReturn += ' <font face="Verdana" size="1">- A emiss�o deste boleto considera o desconto habitual aplicado ao seu curso e dever� ser pago na rede banc�ria;<br>'
		cReturn += '- O pagamento em '+dtoc(SE1->E1_VENCREA)+' dever� ser efetuado sem desconto;<br>'
		cReturn += '- Desconsiderar o boleto enviado anteriormente;</font><br>'
		cReturn += '<p align="center"><font face="Verdana" size="1"><b>A SUA REMATR�CULA SOMENTE SER� EFETIVADA MEDIANTE:</b></font><br>'
		cReturn += ' <font face="Verdana" size="1">- Pagamento deste boleto;<br><br>'
		
		// Nao existe calculo para se chegar a esta data.
		cReturn += '<font face="Verdana" size="1">- N�o constar qualquer tipo de d�bitos anteriores a '+"30/06/02"+' junto ao departamento financeiro;<br>'
                cReturn += '- Entrega dos documentos contidos no envelope de rematr�cula, em local indicado pela instituicao;</font><br>'
		cReturn += '<p align="center"><font face="Verdana" size="1"><b>O n�o pagamento deste boleto at� a data de seu vencimento implicar� na perda de sua vaga.</b></font><br>'
		
	elseif SE1->E1_PREFIXO $ aPrefixo[__MES]
		
		cReturn := '<table border="0" width="100%" cellspacing="0" cellpadding="0">'
		cReturn += '  <tr>'
		if !Empty(cLogo)
			cReturn += '    <td width="190"><img border="0" src="'+cLogo+'"></td>'
		else
			cReturn += '    <td width="190">&nbsp;</td>'
		endif
		cReturn += '    <td width="*">'
		cReturn += '      <p align="center"><font face="Verdana" size="1">Prezado Aluno <b>'+Alltrim( Posicione("SA1", 1, xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA, "A1_NOME") )+'</b></font>'
		cReturn += '&nbsp;'
		cReturn += '    </td>'
		cReturn += '    <td width="300"></td>'
		cReturn += '  </tr>'
		cReturn += '</table>'
		cReturn += ' <font face="Verdana" size="1">Este pagamento dever� ser efetuado UNICAMENTE NA REDE BANC�RIA e, para que voc� '
		cReturn += 'seja beneficiado com os valores dos descontos, ler atentamente as informa��es existentes '
		cReturn += 'no campo "INSTRU��ES" do boleto."</font><br>'
		
	elseif SE1->E1_PREFIXO $ aPrefixo[__REQ] .and. JBH->JBH_TIPSOL $ "134"	// 1=Funcionario, 3=Candidato, 4=Externo
		
		cReturn := '<table border="0" width="100%" cellspacing="0" cellpadding="0">'
		cReturn += '  <tr>'
		if !Empty(cLogo)
			cReturn += '    <td width="200"><img border="0" src="'+cLogo+'"></td>'
		else
			cReturn += '    <td width="200">&nbsp;</td>'
		endif
		cReturn += '    <td width="*" valign="center" align="center">'
		If JBH->JBH_TIPSOL == "1"
			cReturn += '       <font face="Verdana" size="1">Prezado Funcion�rio <b>'+Alltrim( Posicione("SRA", 1, xFilial("SRA")+Left(JBH->JBH_CODIDE,TamSX3("RA_MAT")[1] ), "RA_NOME") )+'</b></font>'
			cReturn += '&nbsp;'
		ElseIf JBH->JBH_TIPSOL == "3"
	        cReturn += '       <font face="Verdana" size="1">Candidato <b>'+Alltrim( Posicione("JA1", 1, xFilial("JA1")+Left(JBH->JBH_CODIDE,TamSX3("JA1_CODINS")[1] ), "JA1_NOME") )+'</b></font>'
		Else
			cReturn += '       <font face="Verdana" size="1">Prezado(a) <b>'+Alltrim( Posicione( "JCR", 1, xFilial("JCR") + Left(JBH->JBH_CODIDE,TamSX3("JCR_RG")[1]), "JCR_NOME") )+'</b></font>'
			cReturn += '&nbsp;'
		EndIf
		cReturn += '    </td>'
		cReturn += '    <td width="200" valign="top" align="right">'
		cReturn += '       '+cDescr+'</td>'
		cReturn += '  </tr>'
		cReturn += '</table>'
		cReturn += ' Este pagamento dever� ser efetuado UNICAMENTE NA REDE BANC�RIA e a liquida��o '
		cReturn += 'dever� ser efetuada at� a data do vencimento no banco que melhor lhe convier. Ap�s '
		cReturn += 'o vencimento, o pagamento somente poder� ser efetuado no banco portador da cobran�a.<br>'
		cReturn += ' <table border="0" width="100%" cellspacing="0">'
		cReturn += '</table>'
		
	else
		
		cReturn := '<table border="0" width="100%" cellspacing="0" cellpadding="0">'
		cReturn += '  <tr>'
		if !Empty(cLogo)
			cReturn += '    <td width="200"><img border="0" src="'+cLogo+'"></td>'
		else
			cReturn += '    <td width="200">&nbsp;</td>'
		endif
		cReturn += '    <td width="*" valign="center" align="center">'
		
		JA1->(dbSetOrder(8))	// JA1_FILIAL+JA1_PRFTIT+JA1_NUMTIT
		If JA1->(dbSeek(xFilial("JA1")+SE1Prefixo+SE1Num))
			cReturn += '       <font face="Verdana" size="1">Prezado Candidato <b>'+Alltrim( JA1->JA1_NOME )+'</b></font>'
			cReturn += '&nbsp;'
		else
			cReturn += '       <font face="Verdana" size="1">Prezado Aluno <b>'+Alltrim( Posicione("SA1", 1, xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA, "A1_NOME") )+'</b></font>'
			cReturn += '&nbsp;'
		endif
		
		cReturn += '    </td>'
		cReturn += '    <td width="200" valign="top" align="right">'
		cReturn += '       '+cDescr+'</td>'
		cReturn += '  </tr>'
		cReturn += '</table>'
		cReturn += 'O n�o pagamento deste boleto implicar� no cancelamento autom�tico de sua inscri��o'
//		cReturn += ' Este pagamento dever� ser efetuado UNICAMENTE NA REDE BANC�RIA e a liquida��o '
//		cReturn += 'dever� ser efetuada at� a data do vencimento no banco que melhor lhe convier. Ap�s '
//		cReturn += 'o vencimento, o pagamento somente poder� ser efetuado no banco portador da cobran�a.<br>'
//		cReturn += ' <table border="0" width="100%" cellspacing="0">'
//		cReturn += '</table>'
		
	endif
endif
Return cReturn
