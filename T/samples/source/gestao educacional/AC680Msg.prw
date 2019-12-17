#include "rwmake.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AC680Msg  �Autor  �Rafael Rodrigues    � Data �  12/Jun/02  ���
�������������������������������������������������������������������������͹��
���Desc.     �Alimenta as instrucoes personalizadas nos boletos emitidos  ���
���          �via hypersite.                                              ���
���          �                                                            ���
���          �A tabela SE1 ja esta posicionada neste momento              ���
�������������������������������������������������������������������������͹��
���Param.    �Nenhum                                                      ���
�������������������������������������������������������������������������͹��
���Retorno   � Array unidimensional com as mensagens a serem impresas.    ���
�������������������������������������������������������������������������͹��
���Uso       �Gestao Educacional - Hypersite                              ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��� wilker     �19/11   �      � customizacao boleto - instrucoes         ���
���            �        �      � processo seletivo eh diferenciado        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AC680Msg()
local aReturn	:= {}
local aArea     := GetArea()
local i
local cInscricao := "" // processo seletivo
local aCursos    := {} // processo seletivo
local cDescProc  := "" // processo seletivo
local cDescFase  := "" // processo seletivo   
local aProva     := {}
// variaveis para a descricao do local da prova
local cDescLocal := ""
local cEndereco  := ""
local cNumero    := ""
local cComplem   := ""
local cCidade    := ""
local cUF        := "" 
Local lOracle := "ORACLE" $ TCGetDB()

SET DATE FORMAT "dd/mm/yyyy"

// VERIFICA SE A CHAMADA DO BOLETO EH FEITO POR UM CANDIDATO
IF (SE1->E1_CLIENTE+SE1->E1_LOJA == GetMv("MV_CLICAND")) // ENTAO EH PROCESSO SELETIVO
	JA1->(dbsetorder(8))
	if JA1->( dbseek(xFilial("JA1")+SE1->E1_PREFIXO+SE1->E1_NUM ) )
		cInscricao := Alltrim(JA1->JA1_CODINS)
		// verifica a data da prova
		aProva := PSDtProva(JA1->JA1_PROSEL,"001",JA1->JA1_TPCAND,JA1->JA1_CODINS)
		

		// posicionar na tabela de locais
		dbselectarea("JA3")
		dbsetorder(1)
		
		if JA3->(dbseek(xFilial("JA3")+JA1->JA1_LOCAL))
			cDescLocal := ALLTRIM(JA3->JA3_DESLOC)
			cEndereco  := ALLTRIM(JA3->JA3_END)
			cNumero    := ALLTRIM(JA3->JA3_NUMEND)
			cComplem   := ALLTRIM(JA3->JA3_COMPLE)
			cCidade    := ALLTRIM(JA3->JA3_CIDADE)
			cUF        := ALLTRIM(JA3->JA3_EST)
		endif

		
		// verifica as opcoes selecionada pelo candidato
		aCursos    := CANDOPC(cInscricao)
		cDescProc  := Alltrim(Posicione("JA6",1,xFilial("JA6")+JA1->JA1_PROSEL,"JA6_DESC"))
		cDescFase  := ALLTRIM(Tabela("F6",JA1->JA1_FASATU,.F.))
		aAdd(aReturn, "Senhor caixa, favor n�o receber ap�s o vencimento")
		aAdd(aReturn, cDescProc+" - "+cDescFase)
		aAdd(aReturn, "INSCRI��O N� "+cInscricao)
		              
		for i := 1 to len(aCursos)
			if len(aCursos) == 1
				aAdd(aReturn, " Opcao : "+aCursos[i][2]+" - "+aCursos[i][3])
			else
				aAdd(aReturn, alltrim(str(i))+"� opcao : "+aCursos[i][2]+" - "+aCursos[i][3])
			endif
		next i
		
        if !Empty(cDescLocal)
    		AADD(aReturn, 'LOCAL PROVA : '+cDescLocal)
    	endif	
		                

		// fazer o print do endereco do local
        AADD(aReturn, cEndereco+" "+cNumero+" "+cComplem)		
        AADD(aReturn, cCidade+" "+cUF)		

		
		if len(aProva) > 0
			AADD(aReturn, 'DATA PROVA : '+DTOC(aProva[1][1]))
		endif
		
		AADD(aReturn, ' ')
		AADD(aReturn, '*** O n�o pagamento deste boleto implicar� no cancelamento autom�tico de sua inscri��o ***')
	endif
Else // outros
	cquery := "SELECT JAF_COD A1_CURSO, MAX(JC5_DTVAL1) A1_DTINIBL, MAX(JC5_DTVAL2) A1_DTFIMBL"
	cQuery += " FROM "+RETSQLNAME ('JA2')+" JA2, "+RETSQLNAME ('JBE')+" JBE, "+RETSQLNAME('JAH')+" JAH, "+RETSQLNAME('JAF')+" JAF, "+RETSQLNAME('JC5')+" JC5"
	cQuery += " WHERE JA2.JA2_FILIAL  = '" + xFilial("JA2") + "' AND JA2.D_E_L_E_T_ <> '*' "
	cQuery += " AND JBE.JBE_FILIAL  = '" + xFilial("JBE") + "' AND JBE.D_E_L_E_T_ <> '*' "
	cQuery += " AND JAH.JAH_FILIAL  = '" + xFilial("JAH") + "' AND JAH.D_E_L_E_T_ <> '*' "
	cQuery += " AND JAF.JAF_FILIAL  = '" + xFilial("JAF") + "' AND JAF.D_E_L_E_T_ <> '*' "
	cQuery += " AND LTRIM(RTRIM(JA2_NUMRA)) = '"+ALLTRIM(SE1->E1_NUMRA)+"'"
	cQuery += " AND JA2.JA2_NUMRA = JBE.JBE_NUMRA "
	cQuery += " AND JBE.JBE_ATIVO = '1' "
	cQuery += " AND JBE.JBE_CODCUR = JAH.JAH_CODIGO "
	If lOracle
	   	cQuery += " AND JC5.JC5_FILIAL(+) = '" + xFilial("JC5") + "' AND JC5.D_E_L_E_T_(+) <> '*' "
		cQuery += " AND JBE.JBE_NUMRA = JC5.JC5_NUMRA(+) "
	Else
	   	cQuery += " AND JC5.JC5_FILIAL = '" + xFilial("JC5") + "' AND JC5.D_E_L_E_T_ <> '*' "
		cQuery += " AND JBE.JBE_NUMRA *= JC5.JC5_NUMRA "
	EndIf
	cQuery += " AND JAH.JAH_CURSO = JAF.JAF_COD "
	cQuery += " AND JAH.JAH_VERSAO = JAF.JAF_VERSAO "
	cQuery += " GROUP BY JAF.JAF_COD "

	TCQUERY cQuery NEW ALIAS "SEL"
	
	Valor := ''
	Desconto := ''
	
	Sano := Left(GRAVADATA(SE1->E1_VENCTO,.F.,8),4)
	Smes := SUBSTR(GRAVADATA(SE1->E1_VENCTO,.F.,8),5,2)
	Nmes := VAL(SUBSTR(GRAVADATA(SE1->E1_VENCTO,.F.,8),5,2))
	Sdata := ''
	diautil2 := {'07','06','06','05','07','06','05','07','06','07','07','06'}
	diautil3 := {'07','06','07','05','07','07','06','05','06','07','05','06'}
    Sdata := diautil3[Nmes]+'/'+Smes+'/'+Sano
	
	if ((ALLTRIM(SEL->A1_CURSO) == '01127' .or. ALLTRIM(SEL->A1_CURSO) == '11127' .or. ALLTRIM(SEL->A1_CURSO) == '01128' .or. ALLTRIM(SEL->A1_CURSO) == '11128') .and. GRAVADATA(SE1->E1_VENCTO,.F.,8) = '20020605')
		Sdata := '01/'+Smes+'/'+Sano
	endif
	if ((ALLTRIM(SEL->A1_CURSO) == '01127' .or. ALLTRIM(SEL->A1_CURSO) == '11127' .or. ALLTRIM(SEL->A1_CURSO) == '01128' .or. ALLTRIM(SEL->A1_CURSO) == '11128') .and. Right(GRAVADATA(SE1->E1_VENCTO,.F.,8),2) == '25')
		Sdata := '20/'+Smes+'/'+Sano
	endif
	if ((ALLTRIM(SEL->A1_CURSO) == '01127' .or. ALLTRIM(SEL->A1_CURSO) == '11127' .or. ALLTRIM(SEL->A1_CURSO) == '01128' .or. ALLTRIM(SEL->A1_CURSO) == '11128') .and. Right(GRAVADATA(SE1->E1_VENCTO,.F.,8),2) = '15')
		Sdata := '10/'+Smes+'/'+Sano
	endif
	if Sano == '2002' .and. ALLTRIM(SEL->A1_CURSO) <> '00011' .and. ALLTRIM(SEL->A1_CURSO) <> '00018' .and. ALLTRIM(SEL->A1_CURSO) <> '01127' .and. ALLTRIM(SEL->A1_CURSO) <> '11127' .and. ALLTRIM(SEL->A1_CURSO) <> '01128' .and. ALLTRIM(SEL->A1_CURSO) <> '11128'
		Sdata := diautil2[Nmes]+'/'+Smes+'/'+Sano
	else
		if Sano == '2002' .and. ALLTRIM(SEL->A1_CURSO) <> '01127' .and. ALLTRIM(SEL->A1_CURSO) <> '11127' .and. ALLTRIM(SEL->A1_CURSO) <> '01128' .and. ALLTRIM(SEL->A1_CURSO) <> '11128'
			Sdata := '10/'+Smes+'/'+Sano
		else
     		Sdata := diautil3[Nmes]+'/'+Smes+'/'+Sano
		endif
	endif
	
	if SE1->E1_VLBOLSA > SE1->E1_DESCON1 .and. !EMPTY(SEL->A1_DTINIBL) .and. GRAVADATA(SE1->E1_VENCTO,.F.,8) >= SEL->A1_DTINIBL .and. GRAVADATA(SE1->E1_VENCTO,.F.,8) <= SEL->A1_DTFIMBL
		Valor := AllTrim(STR(SE1->E1_VLBOLSA,12,2))
	else
		Valor := AllTrim(STR(SE1->E1_DESCON1,12,2))
	endif
	
	Desconto := '1 - Ate o dia '+Sdata+' conceder desconto de R$ '+Valor
	
	AADD(aReturn, Desconto)
	
	Desconto2 := ''
	Sdata1 := ''
	Sdata2 := ''
	Sano := Left(GRAVADATA(SE1->E1_VENCTO,.F.,8),4)
	Smes := SUBSTR(GRAVADATA(SE1->E1_VENCTO,.F.,8),5,2)
	Nmes := VAL(SUBSTR(GRAVADATA(SE1->E1_VENCTO,.F.,8),5,2))
	
	Sdata1 := sData
	Sdata2 := '10/'+Smes+'/'+Sano
	
	If SE1->E1_DESCON2 > 0
	   if SE1->E1_VLBOLSA > SE1->E1_DESCON2 .and. !EMPTY(SEL->A1_DTINIBL) .and. GRAVADATA(SE1->E1_VENCTO,.F.,8) >= SEL->A1_DTINIBL .and. GRAVADATA(SE1->E1_VENCTO,.F.,8) <= SEL->A1_DTFIMBL
          Desconto2 := ''
	   else
		  Desconto2 := '2 - Do dia '+Sdata1+' at� o dia '+Sdata2+' conceder desconto de R$ '+ALLTRIM(STR(SE1->E1_DESCON2,12,2))+'.'
	   endif
	   AADD(aReturn, Desconto2)
	EndIf
	
	cMens3 := 'O Banco n�o est� autorizado a receber este t�tulo ap�s o vencimento, somente a tesouraria do cedente.'
	
	AADD(aReturn, cMens3)
	
	cMulta:= ALLTRIM(STR(SE1->E1_VALOR*0.1,12,2))
	cJuros:= ALLTRIM(STR(SE1->E1_VALOR*0.0003,12,2))
	
	cMens4 := 'Ap�s o vencimento ser� cobrado o valor integral, mais multa de R$ '+cMulta+', acrescido de R$ '+cJuros+' ao dia de atraso, e mais o IGPM do m�s, pr�-rata, do dia do efetivo pagamento.'
	
	AADD(aReturn, cMens4)
	
        SEL->( dbCloseArea() )
endif
RestArea(aArea)
Return(aReturn)
