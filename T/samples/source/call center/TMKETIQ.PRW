/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �TMKEtiq   �Autor  �Rafael M. Quadrotti � Data �  23/04/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Integracao com o Microsoft Word para criacao dos arquivos  ���
���          � de Mala Direta                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������͹��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������͹��
���Andrea F. �12/05/04�811   �Impl. Continua- Identificar o campo CIDADE  ���
���          �        �      �da tabela ACH com o ALIAS na frente.        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TMKETIQ(cWord,cPEEntida,cPECodEnt,cPEContat,cLista) //Entidade,Cod.Entidade,Contato,Codigo da Lista


//�����������������������Ŀ
//�Declaracao de variaveis�
//�������������������������

Local cContato     := ""
Local cEnd     	   := ""
Local cBairro      := ""
Local cCep         := ""
Local cMun         := ""
Local cEst         := ""
Local cEmpresa     := ""
Local cRemetente   := SM0->M0_NOMECOM

Local cAlias       := ""
Local aSaveArea    := GetArea()

Local cCampo       := ""

Local cCPOEnd      := ""
Local cCPOBairro   := ""
Local cCPOMun      := ""
Local cCPOEst 	   := ""
Local cCPOCep      := ""

//Variaveis para envio dos dados ao word
Local c_Data      := ""
Local c_Contato   := ""
Local c_Empresa   := ""
Local c_End       := ""
Local c_Bairro    := ""
Local c_Cep       := ""
Local c_Mun       := ""
Local c_Est       := ""
Local c_Remetente := ""

//Controle de impressao de etiquetas.
Local nEtiqueta := 0  // Contador do Contato


DbSelectArea("SU6")
DbSetOrder(1)   
DbSeek(xFilial("SU6") + cLista)
While !Eof() .AND. (SU6->U6_FILIAL == xFilial("SU6")) .AND. (SU6->U6_LISTA == cLista)
	//�����������������������������������Ŀ
	//�Incrementa o contador de etiquetas.�
	//�������������������������������������
	nEtiqueta++
			
	
	
	cAlias  := Alltrim(cPEEntida)
	
	//��������������������������������Ŀ
	//�Carrega a descricao da empresa .�
	//����������������������������������
	DbSelectArea(cAlias)
	DbSetOrder(1)
	
	If  cAlias == "SU2"
		cCampo := SubStr(cAlias,2,2) + "_DPRO"
	ElseIf cAlias == "ACH"
		cCampo := cAlias + "_RAZAO"
	Else
		If UPPER(Substr(cAlias,1,1)) == "S"
			cCampo := SubStr(cAlias,2,2) + "_NOME"
		Else
			cCampo := cAlias + "_NOME"		
		EndIf
	EndIf
	
	If DbSeek (xFilial(cAlias) + Alltrim(cPECodEnt))
		cEmpresa := &(cAlias +"->"+cCampo)
	EndIf
	
	
	//��������������������������������������������
	//�Carrega o nome do contato se este existir.�
	//��������������������������������������������
	If !Empty(cPEContat)
		dbSelectArea("SU5")
		dbSetOrder(1)
		dbSeek(xFilial("SU5") + cPEContat)
		cContato:= SU5->U5_CONTAT
		
		//���������������������������������������������Ŀ
		//�Verifica qual o tipo de endereco selecionado.�
		//�1= Residencial, 2= Comercial                 �
		//�����������������������������������������������
		If (SU4->U4_TIPOEND == "1") //Endereco Residencial
			cEnd    := SU5->U5_END
			cBairro := SU5->U5_BAIRRO
			cMun    := SU5->U5_MUN
			cEst    := SU5->U5_EST
			cCep    := SU5->U5_CEP
		EndIf
	EndIf
	
	//���������������������������������������������Ŀ
	//� Se o Endereco for comercial ou o contato nao�
	//�existir os dados para envio serao os dados da�
	//�entidade.                                    �
	//�����������������������������������������������
	If	(SU4->U4_TIPOEND == "2") .Or. Empty(cPEContat)
		
		cCPOEnd    := Iif(UPPER(SubStr(cAlias,1,1))=="S", SubStr(cAlias,2,2) + "_END",cAlias+"_END"   )
		cCPOBairro := Iif(UPPER(SubStr(cAlias,1,1))=="S", SubStr(cAlias,2,2) + "_END",cAlias+"_BAIRRO")
		cCPOMun    := Iif(UPPER(SubStr(cAlias,1,1))=="S", SubStr(cAlias,2,2) + "_END",cAlias+"_MUN"   )
		cCPOEst    := Iif(UPPER(SubStr(cAlias,1,1))=="S", SubStr(cAlias,2,2) + "_END",cAlias+"_EST"   )
		cCPOCep    := Iif(UPPER(SubStr(cAlias,1,1))=="S", SubStr(cAlias,2,2) + "_END",cAlias+"_CEP"   )
		
		If DbSeek (xFilial(cAlias) + Alltrim(cPECodEnt))
			cEnd    := &(cAlias + "->" + cCPOEnd)
			cBairro := Iif(cAlias == "SUS"," ",&(cAlias + "->" + cCPOBairro))
			If cAlias == "ACH"
				cMun := ACH->ACH_CIDADE
			ElseIf  cAlias == "JA2"
				cMun := " "
			else 
				cMun :=	&(cAlias + "->" + cCPOMun )
			EndIf
			cEst    := &(cAlias +"->"+ cCPOEst)
			cCep    := &(cAlias +"->"+ cCPOCep)
		EndIf
	EndIf
	
	//������������������������������������������������������������������������������
	//� -Funcao que atualiza as variaveis do Word.                                 �
	//������������������������������������������������������������������������������
	
	If nEtiqueta = 1
		OLE_SetDocumentVar(cWord, "c_Data"     , DtoC(dDatabase) )
		OLE_SetDocumentVar(cWord, "c_Contato"  , cContato         )
		OLE_SetDocumentVar(cWord, "c_Empresa"  , cEmpresa         )
		OLE_SetDocumentVar(cWord, "c_End"      , cEnd             )
		OLE_SetDocumentVar(cWord, "c_Bairro"   , cBairro          )
		OLE_SetDocumentVar(cWord, "c_Cep"      , cCep             )
		OLE_SetDocumentVar(cWord, "c_Mun"      , cMun             )
		OLE_SetDocumentVar(cWord, "c_Est"      , cEst             )
		OLE_SetDocumentVar(cWord, "c_Remetente", cRemetente       )
	
	ElseIf  nEtiqueta > 1
	
		c_Data      := "c_Data"      + Alltrim(Str(nEtiqueta))
		c_Contato   := "c_Contato"   + Alltrim(Str(nEtiqueta))
		c_Empresa   := "c_Empresa"   + Alltrim(Str(nEtiqueta))
		c_End       := "c_End"       + Alltrim(Str(nEtiqueta))
		c_Bairro    := "c_Bairro"    + Alltrim(Str(nEtiqueta))
		c_Cep       := "c_Cep"       + Alltrim(Str(nEtiqueta))
		c_Mun       := "c_Mun"       + Alltrim(Str(nEtiqueta))
		c_Est       := "c_Est"       + Alltrim(Str(nEtiqueta))
		c_Remetente := "c_Remetente" + Alltrim(Str(nEtiqueta))
		
	
		OLE_SetDocumentVar(cWord, c_Data     , DtoC(dDatabase) )
		OLE_SetDocumentVar(cWord, c_Contato  , cContato         )
		OLE_SetDocumentVar(cWord, c_Empresa  , cEmpresa         )
		OLE_SetDocumentVar(cWord, c_End      , cEnd             )
		OLE_SetDocumentVar(cWord, c_Bairro   , cBairro          )
		OLE_SetDocumentVar(cWord, c_Cep      , cCep             )
		OLE_SetDocumentVar(cWord, c_Mun      , cMun             )
		OLE_SetDocumentVar(cWord, c_Est      , cEst             )
		OLE_SetDocumentVar(cWord, c_Remetente, cRemetente       )
		
	EndIf
     
    DbSelectArea("SU6")
	//�����������������������������������������������������������������������Ŀ
	//�A funcao DbSkip esta posicionada aqui para que a valida��o de quebra   �
	//�de pagina das etiquetas para que possa funcionar normalmente e nao seja|
	//�apresentada a mensagem de erro do word.                                �
	//�A posicao do Skip nao influenciara diretamente na logica normal de laco�
	//�while                                                                  �
	//�  dbskip()                                                             �
	//�End                                                                    �
	//�������������������������������������������������������������������������
		
	DbSkip()
		
	//������������������������������������������������Ŀ
	//�Se preencheu as 10 etiquetas imprime uma pagina.�
	//��������������������������������������������������
	If (nEtiqueta == 10) .OR. (EOF())
		nEtiqueta:= 0
			
		//�������������������������������������������������������������������������������������
		//�-Funcao que atualiza os campos da memoria para o Documento, utilizada logo apos a  �
		//�funcao OLE_SetDocumentVar().														  �
		//�������������������������������������������������������������������������������������
		OLE_UpdateFields(cWord)
			
		//�����������������������������������������������������������������������������������������
		//�-Funcao que imprime o Documento corrente podendo ser especificado o numero de copias,  �
		//�podedo tambem imprimir com um intervalo especificado nos parametros "nPagInicial" ate  �
		//�"nPagFinal" retirando o parametro "ALL".												  �
		//�����������������������������������������������������������������������������������������
		OLE_PrintFile(cWord,"ALL",,,)
		
	Endif
End

RestArea(aSaveArea)
	
Return .T.
