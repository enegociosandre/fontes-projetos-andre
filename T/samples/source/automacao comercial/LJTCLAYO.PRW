#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 12/07/00
#INCLUDE "FiveWin.ch"
#INCLUDE "LJENCNAB.CH"
#INCLUDE "PROTHEUS.ch"

User Function ljencnab()        // incluido pelo assistente de conversao do AP5 IDE em 12/07/00

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,NTAMARQ,NTAM,NDEC,NLIDOS,CBUFFER")
SetPrvt("LRESP,LHEADER,LFIRST,LGRAVA,ABORDERO,NHDLBCO")
SetPrvt("NHDLSAIDA,CINDD2,CCHAVD2,NINDD2,CCONTEUDO,EXPL1")
SetPrvt("CCAMPO,BBLOCK,BERRO,LRET,XCONTEUDO,CFILTRO")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/07/00 ==> #INCLUDE "FiveWin.ch"
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/07/00 ==> #INCLUDE "LJENCNAB.CH"
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/07/00 ==> #INCLUDE "PROTHEUS.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LjEnCnab � Autor � Almeida               � Data � 20/05/90 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Permite ativar a funcao de envio de arquivo LjGerCnab      ���
���          � Manualmente.                                               ���
���          � com base nos arquivos  SL2 -[SD2]- SF2 - SA1               ���
���          � onde SD2 e o arquivo no qual faremos o filtro              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � LjEnvCnab()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 12/07/00

// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> Function  LJENCNAB()
Static Function  LJENCNAB()
Local cPerg      := "LECNAB"

//������������������������������������Ŀ
//� Verifica as perguntas selecionadas �
//�������������������������������������� 
If !Pergunte(cPerg,.T.)
   Return
Endif   
//��������������������������������������Ŀ
//� Variaveis utilizadas para parametros �
//� mv_par01		 // Da Emissao         �
//� mv_par02		 // Ate o Emissao      �
//� mv_par03		 // Arq.Config 	     �
//� mv_par04       // Arq. Saida         �
//� mv_par05		 // Configuracao Cnab  �
//� mv_par06		 // De Filial          �
//� mv_par07		 // Ate Filial         �
//����������������������������������������

LjGerCnab(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07)

Return (.T.)



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LjGerCnab� Autor � Almeida               � Data � 10/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � - Gera��o do Arquivo de Envio com base nos sequintes       ���
���          �   arquivos: SL2 -[SD2]- SF2 - SL1 - SA1 - SB1              ���
���          �   onde SD2 e o centro sobre o qual faremos o filtro com    ���
���          �   base nos parametros abaixo.                              ���
���          � - Esta funcao vai poder ser disparada manualmente atraves  ���
���          �   da funcao LjEnvCnab ou disparada automaticamente exemp.  ���
���          �   Via Work Flow.                                           ���
���          �   Nesta funcao foi abolida qualquer uso de tela devido     ���
���          �   futuramente ser acionada via WORK FLOW.                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �   .T. Operacao Bem Sucedida                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�   MV_PAR01  -  Da Emissao                                  ���
���          �   MV_PAR02  -  Ate Emissao                                 ���
���          �   MV_PAR03  -  Arquivo Conf.                               ���
���          �   MV_PAR04  -  Arq. Saida                                  ���
���          �   MV_PAR05  -  Configuracao do Cnab                        ���
���          �   MV_PAR06  -  De Filial                                   ���
���          �   MV_PAR07  -  Ate Filial                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � LjGerCnab                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> Function LjGerCnab(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07)
Static Function LjGerCnab(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07)()
//������������������Ŀ
//� Define Variaveis �
//��������������������
Local nTamArq           := 0
Local nTam              := 0
Local nDec              := 0
Local nLidos            := 0
Local cBuffer           := ""
Local lResp             :=.T.
Local lHeader           :=.F.
Local lFirst            :=.F.
Local lGrava            :=.T.
Local aBordero          := {}
Private nHdlBco         := 0  // Arquivo do Banco
Private nHdlSaida       := 0  // Arquivo de Saida

//��������������������������������������������������������������Ŀ
//� Monta express�o do Filtro para sele��o	- SD2   		        �
//����������������������������������������������������������������
dbSelectArea("SD2")
dbsetorder(5)
cIndD2 := CriaTrab(nil,.f.)
cChavD2:= IndexKey()
cChavD2:= "D2_FILIAL+DTOS(D2_EMISSAO)"
IndRegua("SD2",cIndD2,cChavD2,,LJCNABIn(),OemtoAnsi(STR0001))//          STR0001  "Selecionando Registros"
nIndD2 := RetIndex("SD2")
dbSelectArea("SD2")
#IFNDEF TOP
   dbSetIndex(cIndD2+OrdBagExt())
#ENDIF
dbSetOrder(nIndD2+1)
dbGoTop()
If BOF() .and. EOF()
   Help(" ",1,"RECNO")
   RetIndex("SD2")
   dbSetOrder(1)
   Set Filter to
   FErase (cIndD2+OrdBagExt())
   Return .F.
EndIf                                                         

//��������������������������������������������������������������Ŀ
//� Executa a Abertura do Arquivos ASC II de Envio e Configuracao�
//����������������������������������������������������������������
lResp:=AbrePar(MV_PAR03,MV_PAR04,MV_PAR05)	
If !lResp
	Return .F.
Endif


/*
�������������������������Ŀ
� Arquivo de Com.Bancaria �
�    Remessa/Retorno      �
�                         �
� Memoria de Calculo      �     �������������������������Ŀ
� Registro 1 - USUARIOS   �     �Identificadores          �
� - Identif    CHR(n)   1 �     � CHR(1)   - Header       �
� - Descricao do Campo 15 �     � CHR(2)   - Detalhe      �
� - Posicao Inical      3 �     � CHR(3)   - Trailler     �
� - Posicao Final       3 �     ���������������������������
� - Decimais            1 �
� - Campo/Conteudo     60 �
���������������������������
*/


DBGOTOP() 
While !Eof() 
      
      //��������������������������������������������������������������Ŀ
      //� Movimenta todos os ponteiros de acordo com  SD2		        �
      //����������������������������������������������������������������
      SF2->(DBSETORDER(1))                                // Cabecalho NF
      SF2->(DBSEEK(SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE))

      SL1->(DBSETORDER(2))                                // Cabecalho dos Itens
      SL1->(DBSEEK(SD2->D2_FILIAL+SD2->D2_SERIE+SD2->D2_DOC))

      SL2->(DBSETORDER(1))                                // Itens do Orcamento
      SL2->(DBSEEK(SD2->D2_FILIAL+SL1->L1_NUM+SD2->D2_ITEM))

      SA1->(DBSETORDER(1))                                // Clientes
      SA1->(DBSEEK(xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA))
  
      SA3->(DBSETORDER(1))                                // Fornecedor
      SA3->(DBSEEK(xFilial("SA3")+SL1->L1_VEND))

      SB1->(DBSETORDER(1))                                // Produto
      SB1->(DBSEEK(xFilial("SB1")+SD2->D2_COD))

      //��������������������������������������������������������������Ŀ
      //� Ativar este ponto casa seja PC - Pagamento de Contas         �
      //����������������������������������������������������������������
      //IF SB1->B1_TIPO # "PC"                             // Pagamento de Conta
      //   SD2->(DBSKIP())
      //   LOOP
      //ENDIF      

      If ( MV_PAR05 == 1 )
         //��������������������������������������������������������������Ŀ
         //� Le Arquivo de Parametrizacao                                 �
         //����������������������������������������������������������������
		   nLidos:=0
		   FSEEK(nHdlBco,0,0)                                // Posiciona no Inicio do Arquivo  
		   nTamArq:=FSEEK(nHdlBco,0,2)                       // Traz o Tamanho do Arquivo TXT
		   FSEEK(nHdlBco,0,0)                                // Posicona novamemte no Inicio  
	
         While nLidos <= nTamArq

		        //��������������������������������������������������������������Ŀ
			     //� Verifica o tipo qual registro foi lido                       �
			     //����������������������������������������������������������������
			     cBuffer:=Space(85)
			     FREAD(nHdlBco,@cBuffer,85)                   // Le 85 caracteres em cada Linha

			     Do Case
			        Case SubStr(cBuffer,1,1) == CHR(1)       // Haider
				          IF lHeader                            // Finalizou leitura do Heider
					          nLidos+=85
						       Loop
					       EndIF
				     Case SubStr(cBuffer,1,1) == CHR(2)       // Detalhes
        		          IF !lFirst                           //  Se todo detalhe ja tiver sido lido 
					          lFirst := .T.                     // Finaliza o operacao arquivo Detalhe.
						       FWRITE(nHdlSaida,CHR(13)+CHR(10))
					       EndIF
			        Case SubStr(cBuffer,1,1) == CHR(3)       // Trailler
					       nLidos+=85
					       Loop
			        Otherwise
				          nLidos+=85
					       Loop
			      EndCase

			      nTam := 1+(Val(SubStr(cBuffer,20,3))-Val(SubStr(cBuffer,17,3)))
			      nDec := Val(SubStr(cBuffer,23,1))
			      cConteudo:= SubStr(cBuffer,24,60)
                                                           // Quando entra aqui esta usando modelo 1
			      lGrava := LJ150Grava(nTam,nDec,cConteudo,@aBordero,MV_PAR05)

			      If !lGrava                                  // Caso o conteudo da expressao gere  
			         Exit                                     // Erro.
			      Endif
			      nLidos+=85

         EndDO
		   If !lGrava                                        // Abandonou a Linha e agora toda
		      Exit                                           // operacao caso conteudo com erro
		   Endif
      Else                   
                                                           // Guando entra aqui esta usando modelo 2
	 	   lGrava := LJ150Grava(,,,@aBordero,MV_PAR05)

	   EndIf

	   If lGrava
	      If ( MV_PAR05 == 1 ) 
	         fWrite(nHdlSaida,CHR(13)+CHR(10))
		    	IF !lHeader
			      lHeader := .T.
			   EndIF
		   Endif
	  Endif

     RecLock("SD2")
	  SD2->D2_ENVCNAB := dDataBase
     Dbcommit()
	  MsUnlock()
  
 	  SD2->(dbSkip())
EndDO
     

If ( MV_PAR05 == 1 )
	//��������������������������������������������������������������Ŀ
	//� Monta Registro Trailler - Usando Modelo 1                    �
	//����������������������������������������������������������������
	nLidos:=0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)
	While nLidos <= nTamArq

		//��������������������������������������������������������������Ŀ
		//� Tipo qual registro foi lido                                  �
		//����������������������������������������������������������������
		cBuffer:=Space(85)
		FREAD(nHdlBco,@cBuffer,85)

		IF SubStr(cBuffer,1,1) == CHR(3)
			nTam := 1+(Val(SubStr(cBuffer,20,3))-Val(SubStr(cBuffer,17,3)))
			nDec := Val(SubStr(cBuffer,23,1))
			cConteudo:= SubStr(cBuffer,24,60)
			lGrava:=LJ150Grava( nTam,nDec,cConteudo,@aBordero,MV_PAR05)
		 End
		 nLidos+=85
	End
Else
	RodaCnab2(nHdlSaida,MV_PAR03)                // Usando Modelo 2
EndIf

If ( MV_PAR05 == 1 )
	FWRITE(nHdlSaida,CHR(13)+CHR(10))            // Usando Modelo 1
EndIf

//��������������������������������������������������������������Ŀ
//� Fecha o arquivo gerado.                                      �
//����������������������������������������������������������������
FCLOSE(nHdlBco)
FCLOSE(nHdlSaida)
//��������������������������������������������������������������Ŀ
//� Fecha o SD2 Filtro                                           �
//����������������������������������������������������������������
SD2->(DBCLOSEAREA())

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �AbrePar   � Autor � Wagner Xavier         � Data � 26/05/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Abre arquivo de Parametros                                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �AbrePar()                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �LOJA150                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> Static Function AbrePar(MV_PAR03,MV_PAR04,MV_PAR05)
Static Static Function AbrePar(MV_PAR03,MV_PAR04,MV_PAR05)()
IF !FILE(MV_PAR03)
	Help(" ",1,"NOARQPAR")
	Return .F.
Else
	If ( MV_PAR05 == 1 )
		nHdlBco:=FOPEN(MV_PAR03,0+64)
	Endif
EndIF

//����������������������������������������������������������Ŀ
//� Cria Arquivo Saida                                       �
//������������������������������������������������������������
If ( MV_PAR05 == 1 )
	nHdlSaida:=MSFCREATE(MV_PAR04,0)
Else
	nHdlSaida:=HeadCnab2(MV_PAR04,MV_PAR03)
Endif
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LJ150Grava� Autor � Wagner Xavier         � Data � 26/05/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Geracao do Arquivo de Remessa de Comunicacao      ���
���          �Bancaria                                                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �ExpL1:=LJ150Grava(ExpN1,ExpN2,ExpC1,ExpN3)                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � LOJA150                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> STATIC Function LJ150Grava( nTam,nDec,cConteudo,aBordero,MV_PAR05)
Static STATIC Function LJ150Grava( nTam,nDec,cConteudo,aBordero,MV_PAR05)()
Private xConteudo      
         
If ( MV_PAR05 == 1 )
   //����������������������������������������������������������Ŀ
   //� Analisa conteudo                                         �
   //������������������������������������������������������������
   IF Empty(cConteudo)
      cCampo:=Space(nTam)
   Else
	   IF !LJ150Orig( cConteudo )
	   	 Return .f.
	   Else
	      do case
	         case ValType(xConteudo)="D"
		           cCampo := GravaData(xConteudo,.F.)
		      case ValType(xConteudo)="N"
			        cCampo:=Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
			   otherwise
			        cCampo:=Substr(xConteudo,1,nTam)
		   endcase
	   Endif
   End
   If Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
      cCampo:=cCampo+Space(nTam-Len(cCampo))
   End
   Fwrite( nHdlSaida,cCampo,nTam )
Else
   DetCnab2(nHdlSaida,MV_PAR03)
EndIf

//����������������������������������������������������������Ŀ
//� Apenas esta sendo armazenado para uso futuro             �
//������������������������������������������������������������
Aadd(aBordero,SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_ITEM)
Return .T.


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LJ150Orig � Autor � Wagner Xavier         � Data � 10/11/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se expressao e' valida para Remessa CNAB.          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �LOJA150                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> Function LJ150Orig( cForm )
Static Function LJ150Orig( cForm )()
Local bBlock:=ErrorBlock(),bErro := ErrorBlock( { |e| ChecErr260(e,cForm) } )
Private lRet := .T.

BEGIN SEQUENCE
	xConteudo := &cForm
END SEQUENCE
ErrorBlock(bBlock)
Return lRet


/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o	 � LJCnabIn   � Autor � Almeida              � Data � 15.06.00 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Criar Indice Condicional da indRegua                        ���
���          � Filtro Consiste: Data Emissao/Nao Enviados/Filial           ���
��������������������������������������������������������������������������Ĵ��
��� Uso		 � IndRegua                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> Function LJCnabIn()
Static Function LJCnabIn()

Local cFiltro := ""
       
cFiltro := 'D2_FILIAL >= "' + mv_par06 + '" .And. '
cFiltro += 'D2_FILIAL <= "' + mv_par07 + '" .And. '
cFiltro += 'DTOS(D2_ENVCNAB) == "' + DTOS(CTOD("")) + '" .And. '
cFiltro += 'DTOS(D2_EMISSAO) >= "' + DtoS(mv_par01) + '" .And. '
cFiltro += 'DTOS(D2_EMISSAO) <= "' + DtoS(mv_par02) + '"'

Return cFiltro

