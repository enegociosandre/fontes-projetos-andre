#INCLUDE "TMKR021.ch"
#INCLUDE "RWMAKE.CH"  
#INCLUDE "TMKR021.CH"

#DEFINE DESLOC_ETQ  57

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TMKR021  � Autor � Armando M. Tessaroli  � Data � 01/04/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Etiquetas para mala direta de clientes                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Clientes (SA1)                                             ���
�������������������������������������������������������������������������Ĵ��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �        �      �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TMKR021()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local wnrel   	:= "TMKR021"  	 	// Nome do Arquivo utilizado no Spool
Local Titulo 	:= STR0001			// "Etiqueta para Mala Direta"
Local cDesc1 	:= STR0002 			// "Este programa ira emitir etiquetas para"
Local cDesc2 	:= STR0003 			// "mala direta."
Local cDesc3 	:= STR0004 			// "Informe os parametros de selecao dos clientes"
Local nReg   	:= 0
Local nomeprog	:= "TMKR021.PRX"		// nome do programa
Local cString 	:= "SA1"				// Alias utilizado na Filtragem
Local lDic    	:= .F. 					// Habilita/Desabilita Dicionario
Local lComp   	:= .F. 					// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro 	:= .T. 					// Habilita/Desabilita o Filtro

Private Tamanho := "G" 					// P/M/G
Private Limite  := 220 					// 80/132/220
Private aReturn := { STR0005,;			// [1] Reservado para Formulario	//"Zebrado"
					 1,;				// [2] Reservado para N� de Vias
					 STR0006,;			// [3] Destinatario					//"Administracao"
					 2,;				// [4] Formato => 1-Comprimido 2-Normal	
					 2,;	    		// [5] Midia   => 1-Disco 2-Impressora
					 1,;				// [6] Porta ou Arquivo 1-LPT1... 4-COM1...
					 "",;				// [7] Expressao do Filtro
					 1 } 				// [8] Ordem a ser selecionada
					 					// [9]..[10]..[n] Campos a Processar (se houver)
Private m_pag   := 1  				 	// Contador de Paginas
Private nLastKey:= 0  				 	// Controla o cancelamento da SetPrint e SetDefault
Private cPerg   := "TMK021"  		 	// Pergunta do Relatorio
Private aOrdem  := {}  				 	// Ordem do Relatorio

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte(cPerg,.F.)

//���������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                          �
//� Mv_Par01           // Do CLiente                              �
//� Mv_Par02           // Ate o Cliente                           �
//� Mv_Par03           // Do CEP                                  �
//� Mv_Par04           // Ate o CEP                               �
//�����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	Set Filter to
	Return
Endif

RptStatus({|lEnd| TK021Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TK021Imp � Autor � Armando M. Tessaroli  � Data � 01/04/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das etiquetas para mala direta.                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Call Center                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function TK021Imp(lEnd,wnrel,cString,nomeprog,Titulo)


//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao Do Cabecalho e Rodape    �
//����������������������������������������������������������������
Local aStruSA1	:= {}
Local nLi		:= 0			// Linha a ser impressa
Local nMax		:= 58			// Maximo de linhas suportada pelo relatorio
Local cbCont	:= 0			// Numero de Registros Processados
Local cbText	:= SPACE(10)	// Mensagem do Rodape
Local cCabec1	:= "" 			// Label dos itens
Local cCabec2	:= "" 			// Label dos itens
Local cQryAd	:= ""
Local cName		:= ""

//�������������������������������������������������������Ŀ
//�Declaracao de variaveis especificas para este relatorio�
//���������������������������������������������������������
Local cQuery		:= ""		// Guarda a query pata top
Local aEtiq[8,4]				// Array que gerencia a impress�o das etiquetas
Local nEtiqueta		:= 1		// Coluna da etiqueta
Local nI			:= 0		// Controle
Local nJ			:= 0		// Controle
Local nX			:= 0
Local nCol			:= 0		// Coluna de impressao


DbSelectArea("SA1")
DbSetOrder(1)
SetRegua(RecCount())

#IFDEF TOP

	aStruSA1  := SA1->(dbStruct())

	cQuery :=	" SELECT	A1_COD, A1_CEP, A1_NOME, A1_END, A1_ENDENT, A1_MUN, A1_EST "

	//���������������������������������������������Ŀ
	//�Busca campos especificos no filtro de usu�rio�
	//�����������������������������������������������
	If !Empty(aReturn[7])
		For nX := 1 To SA1->(FCount())
			cName := SA1->(FieldName(nX))
			If AllTrim( cName ) $ aReturn[7]
				If aStruSA1[nX,2] <> "M"
					If !cName $ cQuery .And. !cName $ cQryAd
		        	cQryAd += ","+cName
					EndIf
				EndIf
			EndIf
		Next nX
	EndIf

    cQuery += cQryAd		
	
	cQuery +=	" FROM " +	RetSqlName("SA1") + " SA1 "
	
	cQuery +=	" WHERE	SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND " +;
				" 		SA1.A1_COD BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND" +;
				" 		SA1.A1_CEP BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND" +;
				"		SA1.D_E_L_E_T_ = ' '" +;
				" ORDER BY " + SqlOrder(IndexKey())
	
	DbSelectArea("SA1")
	DbCloseArea()
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TMKR021.SQL", cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SA1', .F., .T.)
	
#ELSE
	DbSeek(xFilial("SA1") + Mv_Par01, .T.)
#ENDIF

While	(!Eof())					.AND.;
		SA1->A1_COD >= Mv_Par01		.AND.;
		SA1->A1_COD <= Mv_Par02
	
	IncRegua()
	
	If lEnd
		@Prow()+1,001 PSay STR0007 //"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Considera filtro do usuario                                  �
	//����������������������������������������������������������������
	If (!Empty(aReturn[7])) .AND. (!&(aReturn[7]))
		DbSkip()
		Loop
	Endif
	
	//�����������������������������Ŀ
	//�Avalia os parametros para DBF�
	//�������������������������������
	#IFNDEF TOP
		If SA1->A1_CEP <= Mv_Par03 .or. SA1->A1_CEP >= Mv_Par04
			DbSkip()
			Loop
		Endif
	#ENDIF
	
	For nI:=1 TO 4
			
			_n_Lin := pRow()
			_n_Col := pCol()
			@ _n_Lin,_n_Col PSay chr( getMV( "MV_COMP" ) )
			setPrc( _n_Lin,_n_Col )
			
			Do Case
				Case nEtiqueta == 1
					
					aEtiq[1,nEtiqueta] := STR0008 + SA1->A1_COD //"Cliente: "
					aEtiq[2,nEtiqueta] := SA1->A1_NOME
					aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_END),Subs(SA1->A1_END,1,49),Subs(SA1->A1_ENDENT,1,49))
					aEtiq[4,nEtiqueta] := AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST
					aEtiq[5,nEtiqueta] := STR0009 + Transform(SA1->A1_CEP,"@R 99999-999") //"Cep: "
					aEtiq[6,nEtiqueta] := ""
					aEtiq[7,nEtiqueta] := ""
					aEtiq[8,nEtiqueta] := ""
					
					nEtiqueta++
					
				Case nEtiqueta == 2
					
					aEtiq[1,nEtiqueta] := STR0008 + SA1->A1_COD //"Cliente: "
					aEtiq[2,nEtiqueta] := SA1->A1_NOME
					aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_END),Subs(SA1->A1_END,1,49),Subs(SA1->A1_ENDENT,1,49))
					aEtiq[4,nEtiqueta] := AllTrim(SA1->A1_MUN)+" -  "+SA1->A1_EST
					aEtiq[5,nEtiqueta] := STR0009 + Trans(SA1->A1_CEP,"@R 99999-999") //"CEP: "
					aEtiq[6,nEtiqueta] := ""
					aEtiq[7,nEtiqueta] := ""
					aEtiq[8,nEtiqueta] := ""
					
					nEtiqueta++
					
				Case nEtiqueta == 3
					
					aEtiq[1,nEtiqueta] := STR0008 + SA1->A1_COD //"Cliente: "
					aEtiq[2,nEtiqueta] := SA1->A1_NOME
					aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_END),Subs(SA1->A1_END,1,49),Subs(SA1->A1_ENDENT,1,49))
					aEtiq[4,nEtiqueta] := AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST
					aEtiq[5,nEtiqueta] := STR0009 + Trans(SA1->A1_CEP,"@R 99999-999") //"CEP: "
					aEtiq[6,nEtiqueta] := ""
					aEtiq[7,nEtiqueta] := ""
					aEtiq[8,nEtiqueta] := ""
					
					nEtiqueta++
					
				Case nEtiqueta == 4
					
					
					aEtiq[1,nEtiqueta] := STR0008 + SA1->A1_COD //"Cliente: "
					aEtiq[2,nEtiqueta] := SA1->A1_NOME
					aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_END),Subs(SA1->A1_END,1,49),Subs(SA1->A1_ENDENT,1,49))
					aEtiq[4,nEtiqueta] := AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST
					aEtiq[5,nEtiqueta] := STR0009 + Trans(SA1->A1_CEP,"@R 99999-999") //"CEP: "
					aEtiq[6,nEtiqueta] := ""
					aEtiq[7,nEtiqueta] := ""
					aEtiq[8,nEtiqueta] := ""
					
					nEtiqueta := 1
					For nI:= 1 TO 8
						For nJ := 1 TO 4
							@ nLi,nCol  PSay aEtiq[nI,nJ]
							nCol += DESLOC_ETQ
						Next nJ
						nLi++
						nCol := 0
					Next nI
					
					For nI:= 1 TO 8
						For nJ:=1 TO 4
							aEtiq[nI,nJ] := ""
						Next nJ
					Next nI
					nLi++
			EndCase

		DbSelectArea("SA1")
		Dbskip()
	Next nI
	
End

For nI:= 1 TO 8
	For nJ:=1 TO 4
		If !EMPTY(aEtiq[nI,nJ])
			@ nLi,nCol  PSay aEtiq[nI,nJ]
			nCol += DESLOC_ETQ
		Endif
	Next nJ
	nLi++
	nCol := 0
Next nI


//�������������������������������������������������������������������Ŀ
//�Caso nada tenha sido impresso, entao imprime uma menssagem de aviso�
//���������������������������������������������������������������������
If nLi == 0
	nLi := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,nChrComp)
	nLi++
	@ nLi,000 PSay STR0010 //"Nao existem dados a serem impressos para este relatorio com os parametros informados"
Endif

#IFDEF TOP
	DbSelectArea("SA1")
	DbCloseArea()
	ChkFile("SA1")
#ENDIF

Set Device To Screen
If ( aReturn[5] = 1 )
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return(.T.)
