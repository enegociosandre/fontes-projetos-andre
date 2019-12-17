/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �TMKMala   �Autor  �Rafael M. Quadrotti � Data �  23/04/01   ���
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
User Function TmkMala(cWord,cPEEntida,cPECodEnt,cPEContat) //Arquivo do Word,Entidade,Cod.Entidade,Contato


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
OLE_SetDocumentVar(cWord, "c_Data"     , DtoC(dDatabase) )
OLE_SetDocumentVar(cWord, "c_Contato"  , cContato         )
OLE_SetDocumentVar(cWord, "c_Empresa"  , cEmpresa         )
OLE_SetDocumentVar(cWord, "c_End"      , cEnd             )
OLE_SetDocumentVar(cWord, "c_Bairro"   , cBairro          )
OLE_SetDocumentVar(cWord, "c_Cep"      , cCep             )
OLE_SetDocumentVar(cWord, "c_Mun"      , cMun             )
OLE_SetDocumentVar(cWord, "c_Est"      , cEst             )
OLE_SetDocumentVar(cWord, "c_Remetente", cRemetente       )



RestArea(aSaveArea)

Return .T.
