#include "RWMake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SEC0031A � Autor � Gustavo Henrique   � Data �  05/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera o titulo a pagar para o solcitante                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/       
User Function SEC0031A()

Processa( { || U_SEC0031B(), "Aguarde", "Gerando NCC..." } )

MsgInfo( "NCC Gerada com sucesso." )

Return( .T. )              

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SEC0031B � Autor � Gustavo Henrique   � Data �  05/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera o titulo a pagar para o solcitante                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/       
User Function SEC0031B()

Local aRet		:= ACScriptReq( JBH->JBH_NUM )
Local cTitulo
Local cRA		:= Left( JBH->JBH_CODIDE, TamSX3( "JA2_NUMRA" )[1] )
Local cParcela	:= GetMV( "MV_1DUP" )
Local cCodBco	:= aRet[12]
Local cAgencia	:= aRet[13]
Local cConta	:= aRet[14]
Local nValor	:= Val(aRet[11])
Local nBolPrz	:= GetMv("MV_ACRVENC")
Local aPrefixo  := ACPrefixo()
  
ProcRegua( 3 )       

IncProc()              
                       
JA2->(dbSetOrder(1))
JA2->(dbSeek(xFilial("JA2") + cRA ) )

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1") + JA2->JA2_CLIENT + JA2->JA2_LOJA))

cTitulo  := GetSxeNum("SE1", "E1_NUM") // Obtem o numero do Titulo.

dbSelectArea("SE1")
dbSetOrder(1)
While dbSeek(xFilial("SE1")+aPrefixo[6]+cTitulo+cParcela)	// aPrefixo[6] = "REQ" - Requerimento
	cTitulo := GetSxeNum("SE1", "E1_NUM") // Obtem o numero do Titulo.
EndDo    

IncProc()

ConfirmSX8()

Reclock("SE1",.T.)

SE1->E1_FILIAL		:= xFilial("SE1")
SE1->E1_PREFIXO		:= aPrefixo[6]
SE1->E1_NUM			:= cTitulo
SE1->E1_PARCELA		:= cParcela
SE1->E1_TIPO		:= MV_CRNEG
SE1->E1_CLIENTE		:= SA1->A1_COD
SE1->E1_NOMCLI		:= SA1->A1_NREDUZ
SE1->E1_LOJA		:= SA1->A1_LOJA
SE1->E1_EMISSAO		:= dDatabase
SE1->E1_VENCTO		:= dDatabase + nBolPrz
SE1->E1_VENCREA		:= DataValida(dDatabase+nBolPrz, .T.)
SE1->E1_VALOR		:= nValor
SE1->E1_NATUREZ		:= SA1->A1_NATUREZ
SE1->E1_HIST		:= Posicione("JBF",1,xFilial("JBF")+JBH->(JBH_TIPO+JBH_VERSAO),"JBF_DESC")
SE1->E1_EMIS1		:= dDatabase
SE1->E1_SALDO		:= nValor
SE1->E1_VENCORI		:= dDatabase + nBolPrz
SE1->E1_MOEDA		:= 1
SE1->E1_VLCRUZ		:= xMoeda(nValor,1,1,dDatabase)
SE1->E1_STATUS		:= "A"
SE1->E1_SITUACA 	:= "0"
SE1->E1_ORIGEM		:= "REQNCC"
SE1->E1_FLUXO		:= "S"
SE1->E1_FILORIG		:= xFilial("SE1")
SE1->E1_NRDOC		:= JBH->JBH_NUM
SE1->E1_PORTADO		:= cCodBco
SE1->E1_AGEDEP		:= cAgencia
SE1->E1_CONTA		:= cConta
SE1->E1_NUMRA		:= cRA

SE1->( MsUnlock() )
         
IncProc()

Return( .T. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SEC0031C � Autor � Gustavo Henrique   � Data �  05/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Emite o recibo para o aluno                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SEC0031C()

Processa( { || U_SEC0031E() }, "Aguarde", "Gerando Recibo..." )

Return( .T. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SEC0031D � Autor � Gustavo Henrique   � Data �  06/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica se o titulo foi baixado (pago) para o aluno       ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/       
User Function SEC0031D()

Local lRet := .T.

SE1->( dbSetOrder(9) ) 	// NumDoc + Prefixo + Cliente + Loja
SE1->( dbSeek( xFilial( "SE1" ) + JBH->JBH_NUM ) )

While SE1->( ! EoF() .and. E1_FILIAL == xFilial( "SE1" ) .and. E1_NRDOC == JBH->JBH_NUM .and. SE1->E1_TIPO # MV_CRNEG )
	SE1->( dbSkip() )
EndDo

If SE1->E1_SALDO # 0
	MsgInfo( "O t�tulo de NCC para esta solicita��o ainda n�o foi baixado.", "Aten��po" )
	lRet := .F.
EndIf

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SEC0031E � Autor � Gustavo Henrique   � Data �  07/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Emite o documento										  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/       
User Function SEC0031E()

Local cRA		:= Left( JBH->JBH_CODIDE, TamSX3( "JA2_NUMRA" )[1] )
Local aDados 	:= {}
Local aRet		:= {}

ProcRegua( 3 )

IncProc()

aRet := ACScriptReq( JBH->JBH_NUM )

AAdd( aDados, { "cValor"	, "R$ " + AllTrim( Transform( Val(aRet[11]), "@E 9,999,999.99" ) ) + " (" + Extenso( Val( aRet[11] ) ) + ") " } )
AAdd( aDados, { "cMotivo"	, aRet[10] } )
AAdd( aDados, { "cNome"		, Posicione( "JA2", 1, xFilial( "JA2" ) + cRA, "JA2_NOME" ) } )
AAdd( aDados, { "cRA"		, "RA : " + cRA } )
            
IncProc()

ACImpDoc( JBG->JBG_DOCUM, aDados )
         
IncProc()

Return( .T. )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SEC0031F � Autor � Gustavo Henrique   � Data �  07/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida banco, agencia e conta                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/       
User Function SEC0031F()

Local lRet := .T.

SA6->( dbSetOrder( 1 ) )

lRet := SA6->( dbSeek( xFilial( "SA6" ) + M->JBH_SCP12 + M->JBH_SCP13 + M->JBH_SCP14 ) )

If ! lRet
	MsgInfo( "Banco, ag�ncia e conta n�o encontrados.", "Aten��o" )
EndIf

Return( lRet )
