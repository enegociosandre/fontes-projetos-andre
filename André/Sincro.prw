#include "rwmake.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � SINCRO   � Autor � Milton Nishimoto      � Data �30/04/08  ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Cria os campos _SINCDT e _SINCRH na tabela SX3 para cada   ���
���          � registro existente da tabela SX2.                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Portal VETI                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SINCRO()

Private oEXPORT
Private lDrop      := .f.
Private lTudo      := .T.
Private cTimeStart := Time()
Private cTimeEnd	 := Time()

@ 200,001 TO 380,400 DIALOG oEXPORT TITLE OemToAnsi("Exporta para DTC")
@ 002,010 TO 080,190
@ 010,018 Say " Este programa ira gerar os campos de sincronizacao de dados   "
@ 018,018 Say " do ambiente selecionado para web.                             "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkEXPORT()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oEXPORT)

Activate Dialog oEXPORT Centered

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXPORTDTC �Autor  �Microsiga           � Data �  10/26/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function OkEXPORT()

Processa({|| RunCont() },"Processando...")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SINCRO    �Autor  �Microsiga           � Data �  05/23/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RunCont()

Local cAreaX2		:= ""
Local cSincD		:= ""
Local cSincH		:= ""
Local cAlias		:= ""
Local nOrdem		


DbSelectArea("SX2")
DbSetOrder(1)
DbGoTop()

ProcRegua( SX2->( LastRec() ) )

While !EOF()
	
	IncProc(OemToAnsi("Tabela ")+SX2->X2_CHAVE  )
	ProcessMessages()
	
	cAlias		:= X2_CHAVE
	
	dbSelectArea("SIX")
	dbSetOrder(1)
	If !dbSeek(cAlias)
		DbSelectArea("SX2")
		dbSkip()
		Loop
	EndIf
	
	DbSelectArea("SX2")
	
	If SubStr(X2_CHAVE,1,1) == "S"
		cSincD		:= SubStr(X2_CHAVE,2,2) + "_SINCDT"
		cSincH		:= SubStr(X2_CHAVE,2,2) + "_SINCHR"
	Else
		cSincD		:= X2_CHAVE + "_SINCDT"
		cSincH		:= X2_CHAVE + "_SINCHR"
	EndIf
	
	cAreaX2		:= GetArea()
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbGoTop()
	If !DbSeek(cSincD)
		
		DbSelectArea("SX3")
		DbSetOrder(1)
		DbGoTop()
		DbSeek(cAlias+"ZZ",.T.)
		//Alert(X3_ARQUIVO+X3_ORDEM)
		DbSkip(-1)
		If X3_ARQUIVO == cAlias .And. X3_ARQUIVO <> "SX5"
			nOrdem		:= Soma1(X3_ORDEM)
			//Alert(X3_ARQUIVO+X3_ORDEM)
			//inclui registro
			DbAppend()
			X3_ARQUIVO 	:= cAlias
			X3_ORDEM 	:= nOrdem
			X3_CAMPO	:= cSincD
			X3_TIPO		:= "D"
			X3_TAMANHO	:= 8
			X3_DECIMAL	:= 0
			X3_TITULO	:= "Dt. Sincroniz"

				If SX3->X3_TIPO <> "C"				
					If SX3->X3_TIPO == "N"							
						cTipo := "P"							
					Else		
						cTipo := SX3->X3_TIPO							
					EndIf
					cQuery := "Insert Into TOP_FIELD ( FIELD_TABLE, FIELD_NAME, FIELD_TYPE, FIELD_PREC, FIELD_DEC) Values ('dbo."+RetSqlName(cAlias)+"','" + Alltrim(SX3->X3_CAMPO) + "','" + cTipo + "','" + Alltrim(Str(SX3->X3_TAMANHO)) + "','" + Alltrim(Str(SX3->X3_DECIMAL)) + "')"
						
					TcSqlExec(cQuery)
				EndIf			
			
			DbAppend()
			X3_ARQUIVO 	:= cAlias
			X3_ORDEM 	:= Soma1(nOrdem)
			X3_CAMPO	:= cSincH
			X3_TIPO		:= "C"
			X3_TAMANHO	:= 5
			X3_DECIMAL	:= 0
			X3_TITULO	:= "Hr. Sincroniz"
			X3_PICTURE	:= "99:99"

			cNome := RetSqlName(SX2->X2_CHAVE)
			If TCCanOpen(cNome)
				
				//inclui o campo no SQL
				cQueryA		:= "ALTER TABLE "+ RetSqlName(cAlias) +"  ADD " + cSincD + " varchar(8) NOT NULL  DEFAULT  '"+Space(8)+"' "
				memowrite("sincroa.sql",cquerya)
				TcSqlExec(cQueryA)
	
				
				cQueryA		:= "ALTER TABLE "+ RetSqlName(cAlias) +"  ADD " + cSincH + " varchar(5) NOT NULL DEFAULT '"+Space(5)+"'"
				memowrite("sincrob.sql",cquerya)
				TcSqlExec(cQueryA)
			EndIf
			
		EndIf
	EndIf
	RestArea(cAreaX2)
	DbSkip()
EndDo
Alert("Finalizado..")
//U_CriaSX()
Return
