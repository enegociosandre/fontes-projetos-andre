#INCLUDE "RWMAKE.CH"

#IFDEF SPANISH
	#define STR0001 "Importacion concluida con exito."
#ELSE
	#IFDEF ENGLISH
		#define STR0001 "Import successfully completed."
	#ELSE
		#define STR0001 "Importacao concluida com sucesso."
	#ENDIF
#ENDIF

/*
  ��������������������������������������������������������������������������Ŀ
  �     Retorno Esperado apos a conversao do mailing						 �
  �                       							                         �
  �     Estrutura do array :								                 �
  �                       							                         �
  �     01- Nome															 �
  �     02- Nome Fantasia													 �
  �     03- Endereco														 �
  �		04- Municipio														 �
  �		05- Cep																 �
  �		06- Estado															 �
  �		07- Telefone														 �
  �		08- Fax																 �
  �		09- EMAIL															 �
  �		10- Url																 �
  �		11- CGC																 �
  �		12- Contato															 �
  �		13- Cargo do Cont.													 �
  �                       							                         �
  ����������������������������������������������������������������������������
*/


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKMAIL   �Autor  �Microsiga           � Data �  24/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica os diferentes tipos de mailing para estruturacao   ���
��� 		 �do array que sera importado para o browse da tela de 	  	  ���
��� 		 �cadastro de suspect                                  	  	  ���
�������������������������������������������������������������������������͹��
���Uso       �CALL CENTER                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function  TMKMAIL(cArquivo)

Local cBuffer     := ""
Local cAux        := ""
Local cString     := ""
Local cSeparador  := ""  //Verifica o tipo de separador do arquivo texto
Local aTmp        := {}
Local aEstrutura  := {}
Local nCont       := 0
Local cEof        := Chr(10)+ Chr(13)
Local nRec        := 0
Local lAspa       := .F.

//���������������������������������������������������������������������Ŀ
//� Leitura da quantidade de Registros do Arquivo                       �
//�����������������������������������������������������������������������
FT_FUSE(cArquivo)
FT_FGOTOP()
While !FT_FEOF()
	nRec++
	FT_FSKIP()
End

ProcRegua(nRec)

//��������������������������������������������������������������������������������������������������Ŀ
//� Leitura do mailing e verificacao do ultimo caracter da linha lida para  consistencia da pesquisa �
//����������������������������������������������������������������������������������������������������
FT_FGOTOP()

While !FT_FEOF()
	cBuffer:= AllTrim(FT_FREADLN())
	
	If At(";",cBuffer) > 0
		cSeparador:= ";"
	ElseIf At(",",cBuffer) > 0
		cSeparador:= ","
	Else //linha de arquivo incorreta.
		IncProc()
		FT_FSKIP()
		Loop
	Endif
	
	If (SubStr(cBuffer,Len(cBuffer),1)<>cSeparador)
		cBuffer+= cSeparador + cEof + cSeparador
	Else
		cBuffer+= cEof + cSeparador
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	IncProc()
	
	//���������������������������������������������������������������������Ŀ
	//�  Carrega o array aEstrutura com o resultado da Importacao           �
	//�����������������������������������������������������������������������
	cLinha:= cBuffer
	lAspa := .F.
	For nCont := 1 To Len(cBuffer)

		cAux   := SubStr(cLinha,1,1)
		cLinha := SubStr(cLinha,2)
		If (cAux == cEof)
			Exit
		Endif
		
		//������������������������������������������������������������������������������Ŀ
		//�  Sao verificadas as marcacoes feitas pelo Excel para concatenacao de strings �
		//��������������������������������������������������������������������������������
		Do Case
			Case cAux == '"'
				lAspa := !lAspa
			Case cAux == cSeparador .And. !lAspa
				Aadd(aTmp,cString)
				cString := ""
			OtherWise
				cString += cAux
		EndCase

	Next nCont
	
	For nCont := Len(aTmp)+1 To 11
		Aadd(aTmp,"")
	Next nCont
	
	//��������������������������������������������������Ŀ
	//�Validacao para nao salvar registros sem entidades �
	//����������������������������������������������������
	If !Empty(aTmp[1]) .OR. !Empty(aTmp[2])
		Aadd(aEstrutura,aTmp)
		aTmp := {}
	Endif
	FT_FSKIP()
End

FT_FUSE()
MsgInfo(STR0001) //Importacao concluida com sucesso

Return (aEstrutura)
