#Include 'Protheus.ch'

//+------------+--------------+--------+------------------------+-------+------------+
//| Função:    | A010TOK()    | Autor: | David Alves dos Santos | Data: | 10/07/2017 |
//+------------+--------------+--------+------------------------+-------+------------+
//| Descrição: | Ponto de entrada busca campos customizados na tabela SB1.           |
//+------------+---------------------------------------------------------------------+
//|   SigaMDI.net - A rede social para Analistas Protheus / Desenvolvedores AdvPL.   |
//+----------------------------------------------------------------------------------+
User Function A010TOK()
	
	Local cCampo := ""
	Local lRet   := .T.

	//-- Seleciona o dicionario de dados SX3.
	dbSelectArea('SX3')
	dbSetOrder(1)
	dbGoTop()
	//-- Verifica se existe o arquivo SB1.
	If MsSeek('SB1')
		//-- Varre o SX3 buscando os campos customizados.
		While !Eof() .And. SX3->X3_ARQUIVO == 'SB1'
			If SX3->X3_PROPRI == 'U'
				cCampo := "M->" + AllTrim(SX3->X3_CAMPO)
				//-- Valida se o campo customizado foi preenchido.
				If Empty(&cCampo)
					Alert("Favor informar o conteudo para o campo: " + SX3->X3_CAMPO)
					lRet := .F.
				Else
					MsgInfo("Produto gravado com sucesso!")
				EndIf
			EndIf
			DbSkip()
		EndDo
	EndIf

Return( lRet )