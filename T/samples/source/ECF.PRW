#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ECF       �Autor  �Andre Alves Veiga   � Data �  16/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa de exemplo das fun��es da dll para comunica��o     ���
���          �com as impressoras fiscais.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ECF()
Local nRetorno
Local cRetorno , cPorta, cImp, cComando, cStatus
Local aImp, aComando, aPorta, aComando1,aRet
Local oDlg, oPorta, oImp, oComando, oStatus


//������������������������������������������������������������������������Ŀ
//�Inicializa vari�veis                                                    �
//��������������������������������������������������������������������������
cRetorno := Space(200)
aPorta := { LjGetStation('PORTIF') }
aImp := {}
aComando := {}
aComando1 := {}
aRet := {}
//������������������������������������������������������������������������Ŀ
//�Alimenta a array de Impressoras Homologadas                             �
//��������������������������������������������������������������������������
nRetorno := IFListar( @cRetorno )
IF nRetorno == 0
	aImp := { LjGetStation('IMPFISC') }
	aComando := VerComandos()
	aComando1 := aComando[1]
	aComando  := aComando[2]
	
	//������������������������������������������������������������������������Ŀ
	//�Define Janela de Dialogo com Usu�rio                                    �
	//��������������������������������������������������������������������������
	DEFINE MSDIALOG oDlg TITLE "Teste de Impressoras Fiscais" FROM 0,0 TO 300,400 PIXEL
	@  10, 10 SAY "Porta " PIXEL
	@  17, 10 MSCOMBOBOX oPorta VAR cPorta ITEMS aPorta SIZE 40,50 OF oDlg PIXEL
	@  32, 10 SAY "Impressora " PIXEL
	@  39, 10 MSCOMBOBOX oImp VAR cImp ITEMS aImp SIZE 100,50 OF oDlg PIXEL When .F.
	@  54, 10 SAY "Comando" PIXEL
	@  61, 10 MSCOMBOBOX oComando VAR cComando ITEMS aComando SIZE 100,50 OF oDlg PIXEL
	@  61,130 BUTTON "Executa Comando" SIZE 60,10 ACTION ( aRet := fExecuta(nHdlECF,aComando1,cComando),;
	oStatus:Add('Comando = '+cComando),;
	oStatus:Add('Retorno da fun��o = '+Str(aRet[1],2,0)),;
	oStatus:Add('Retorno = '+iif(Empty(aRet[2]),'',aRet[2])),;
	oStatus:Add(Repl('-',70)) ) PIXEL
	@  76, 10 LISTBOX oStatus VAR cStatus SIZE 181,60 ITEMS {} OF oDlg PIXEL
	@ 140,160 BUTTON "SAIR" SIZE 40,10 ACTION (oDlg:End()) PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	MsgAlert("Erro na comunica��o com a DLL.")
Endif

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DoArray   �Autor  �Andre Alves Veiga   � Data �  16/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Recebe uma string com um separador e retorna um array       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� cString                                                    ���
���          � cSeparador                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function DoArray( cString,cSeparador )
Local aRetorno := {}
Local nPos := 0

If PCount() = 1
	cSeparador := '|'
Endif
Do While .T.
	nPos := AT( cSeparador,cString )
	if nPos > 0
		aAdd( aRetorno,Subst(cString,1,nPos-1) )
		cString := Subst(cString,nPos+1,Len(cString) )
	Else
		aAdd( aRetorno,cString )
		Exit
	Endif
Enddo

Return aRetorno

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �VerComandos�Autor  �Microsiga           � Data �  16/06/00   ���
��������������������������������������������������������������������������͹��
���Desc.     � Alimenta a array de Comandos                                ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Function VerComandos()
Local i, aRetorno := {}
Local aRetorno2 := {}
Local aRet := {}

aAdd( aRetorno, {'Leitura X', 			  					'IFLeituraX(nHdlECF)'} )
aAdd( aRetorno, {'Impress�o de Cheques', 				'fCheque(nHdlECF)'} )
aAdd( aRetorno, {'Redu��o Z', 			  					'IFReducaoZ(nHdlECF)'} )
aAdd( aRetorno, {'Abre Cupom', 			  					'IFAbreCup(nHdlECF)'} )
aAdd( aRetorno, {'Pega N�mero Cupom', 	  				'IFPegCupom(nHdlECF,cRet)'} )
aAdd( aRetorno, {'Pega N�mero do PDV',   				'IFPegPDV(nHdlECF,cRet)'} )
aAdd( aRetorno, {'Registra Item', 		  					'fRegItem(nHdlECF)'} )
aAdd( aRetorno, {'Pagamentos',			 					'fPagto(nHdlECF)'} )
aAdd( aRetorno, {'Fechamento do Cupom', 					'fFechaCup(nHdlECF)'} )
aAdd( aRetorno, {'Adicionar Al�quotas',  				'fAdicAliq(nHdlECF)'} )
aAdd( aRetorno, {'Leitura das Al�quotas de ICMS',  	'IFLeAliq(nHdlECF,cRet)'} )
aAdd( aRetorno, {'Leitura das Al�quotas de ISS',   	'IFLeAliIss(nHdlECF,cRet)'} )
aAdd( aRetorno, {'Leitura das Cond.Pagamento',     	'IFLeConPag(nHdlECF,cRet)'} )
aAdd( aRetorno, {'Cancelamento do item', 			   'IFCancItem(Str(nHdlECF),1,0)'} )
aAdd( aRetorno, {'Cancelamento do cupom',			   'IFCancCup(nHdlECF)'} )
aAdd( aRetorno, {'Abre Cupom n�o fiscal',			   'fAbrCNFis(nHdlECF)'} )
aAdd( aRetorno, {'Impress�o de texto n�o Fiscal',  	'fTxtNFis(nHdlECF)'} )
aAdd( aRetorno, {'Fechamento do Cupom n�o Fiscal', 	'IFFchCNFis(nHdlECF)' } )
aAdd( aRetorno, {'Autentica��o',							'fAutentic(nHdlECF)' } )
aAdd( aRetorno, {'Nomea��o de totalizador n�o fiscal','fTotNFis(nHdlECF)' } )
aAdd( aRetorno, {'Status da Impressora',			      'f_Status(nHdlECF,@cRet)' } )
aAdd( aRetorno, {'Desconto no Total', 					'fDescTot(nHdlECF)' } )
aAdd( aRetorno, {'Acr�scimo no Total',					'fAcresTot(nHdlECF)' } )
aAdd( aRetorno, {'Leitura da mem�ria fiscal',			'fMemFisc(nHdlECF)' } )
aAdd( aRetorno, {'Acionamento da Gaveta',				'IFGaveta(nHdlECF)' } )
aAdd( aRetorno, {'Abrir ECF', 								'IFAbrECF(nHdlECF)' } )
aAdd( aRetorno, {'Fechar ECF', 								'IFFchECF(nHdlECF)' } )
aAdd( aRetorno, {'Grava Condi��o de Pagamento',		'fGrvCondP(nHdlECF)' } )

aSort( aRetorno ,,, {|a,b| a[1] < b[1]} )

For i:=1 to Len(aRetorno)
	aAdd( aRetorno2, aRetorno[i][1] )
next i
aRet := {aRetorno, aRetorno2}
Return aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fExecuta  �Autor  �Andre Alves Veiga   � Data �  20/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica qual o comando foi pedido para executar e         ���
���          � chama a fun��o da DLL.                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fExecuta( nHdlECF,aComandos,cComando )
Local nRet
Local cRet := Space(200)
Local aRet := {}
Local cCmd
Local bCmd
cCmd := aComandos[aScan(aComandos, {|x| x[1]=cComando})][2]
bCmd := &('{ |nHdlECF,cRet| ' + cCmd + ' }')
nRet := Eval( bCmd, nHdlECF, @cRet )
aRet := {nRet, Alltrim(cRet)}
Return aRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCheque   �Autor  �Andre Alves Veiga   � Data �  20/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Faz a impressao do cheque                                   ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fCheque(nHdlECF)
Local nRet := nValor := 0
Local cCidade, cBanco, cFavor, cMensagem
Local dEmissao := dDataBase

//����������������������������������������������������������
//�Inicializa vari�veis                                    �
//����������������������������������������������������������
cCidade := Space(20)
cBanco := Space(3)
cFavor := Space(20)
cMensagem := Space(50)

//����������������������������������������������������������
//�Define janela para interface com usu�rio                �
//����������������������������������������������������������
DEFINE MSDIALOG oDlg1 TITLE "Impress�o de Cheques" FROM 0,0 TO 300,500 PIXEL
@  10, 10 SAY "Banco" PIXEL
@  17, 10 MSGET cBanco PICTURE "999" PIXEL
@  10, 60 SAY "Valor" PIXEL
@  17, 60 GET nValor PICTURE "@E 999,999,999.99" PIXEL
@  32, 10 SAY "Favorecido" PIXEL
@  39, 10 GET cFavor PIXEL
�@  54, 10 SAY "Cidade" PIXEL
@  61, 10 GET cCidade PIXEL
@  76, 10 SAY "Data" PIXEL
@  83, 10 GET dEmissao PIXEL
@  97, 10 SAY "Mensagem" PIXEL
@ 104, 10 GET cMensagem  PICTURE "@S40" PIXEL
@ 119,150 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet:=IFCheque(nHdlECF,cBanco,StrZero(nValor,14,2),cFavor,cCidade,DTOC(dEmissao),cMensagem,'') )
@ 119,210 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fRegItem  �Autor  �Andre Alves Veiga   � Data �  20/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua a registro de venda do item.                         ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fRegItem(nHdlECF)
Local nRet := 0
Local cCodigo,cDesc
Local nQtde := nvlrUnit := nvlrDesconto := nAliquota := nvlrTotal := nVlrLiquido := 0

//����������������������������������������������������������
//�Inicializa vari�veis                                    �
//����������������������������������������������������������
cCodigo := Space(15)
cDesc   := Space(60)

//����������������������������������������������������������
//�Janela para interface com usuario                       �
//����������������������������������������������������������
DEFINE MSDIALOG oDlg1 TITLE "Registro de Itens" FROM 0,0 TO 300,350 PIXEL
@  12, 10 SAY "Codigo" PIXEL
@  19, 10 MSGET cCodigo SIZE 60,8 OF oDlg1 PIXEL
@  30, 10 SAY "Descricao" PIXEL
@  37, 10 MSGET cDesc SIZE 150,8 OF oDlg1  PIXEL
@  48, 10 SAY "Quantidade" PIXEL
@  55, 10 MSGET oQtde VAR nQtde SIZE 30,8 OF oDlg1 PIXEL PICTURE "@E 99,999.99"
oQtde:BLostFocus := { || nVlrTotal := nQtde * nVlrUnit, oDlg1:Refresh() }
@  48, 70 SAY "Aliquota" PIXEL
@  55, 70 MSGET nAliquota SIZE 30,8 OF oDlg1 PIXEL PICTURE "@E 99.99"
@  66, 10 SAY "Valor Unitario" PIXEL
@  73, 10 MSGET oVlrUnit VAR nVlrUnit SIZE 50,8 OF oDlg1 PIXEL PICTURE "@E 999,999,999.99"
oVlrUnit:BLostFocus := { || nVlrTotal := nQtde * nVlrUnit, oDlg1:Refresh() }
@  84, 10 SAY "Valor Total" PIXEL
@  91, 10 MSGET nVlrTotal SIZE 50,8 OF oDlg1 WHEN .F. PIXEL PICTURE "@E 999,999,999.99"
@ 102, 10 SAY "Valor Desconto" PIXEL
@ 109, 10 MSGET oVlrDesconto VAR nVlrDesconto SIZE 50,8 OF oDlg1 PIXEL PICTURE "@E 999,999,999.99"
oVlrDesconto:BLostFocus := { || nVlrLiquido := nVlrTotal - nVlrDesconto, oDlg1:Refresh() }
@ 120, 10 SAY "Valor Liquido" PIXEL
@ 127, 10 MSGET nVlrLiquido SIZE 50,8 OF oDlg1 WHEN .F. PIXEL PICTURE "@E 999,999,999.99"
@ 138, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFRegItem(nHdlECF,cCodigo,cDesc,Str(nQtde,7,2),Str(nvlrUnit,14,2),Str(nvlrDesconto,14,2),'T'+Str(nAliquota,5,2)), oDlg1:End() )
@ 138,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fPagto    �Autor  �Andre Alves Veiga   � Data �  20/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua as condicoes de pagamento                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fPagto(nHdlECF)
Local nRet := 0
Local cforma  := ''
Local cforma1 := 'DINHEIRO       '
Local cforma2 := 'CHEQUE         '
Local cforma3 := cforma4 := cforma5 := cforma6 := Space(15)
Local nvalor1 := nvalor2 := nvalor3 := nvalor4 := nvalor5 := nvalor6 := ntotal := 0

//����������������������������������������������������������
//�Janela para interface com usuario                       �
//����������������������������������������������������������
DEFINE MSDIALOG oDlg1 TITLE "Pagamento" FROM 0,0 TO 300,254 PIXEL
@ 7,15 SAY "Formas de Pagto" PIXEL
@ 7,78 SAY "Valores" PIXEL
@ 21,14 MSGET oforma1 VAR cforma1 SIZE 50,8 OF oDlg1 Picture "@!" PIXEL
@ 21,64 MSGET ovalor1 VAR nvalor1 SIZE 50,8 OF oDlg1 Picture "@E 999,999,999.99" PIXEL
ovalor1:BLostFocus := { || ntotal := nvalor1+nvalor2+nvalor3+nvalor4+nvalor5+nvalor6, oDlg1:Refresh() }
@ 34,14 MSGET oforma2 VAR cforma2 SIZE 50,8 OF oDlg1 Picture "@!" PIXEL
@ 34,64 MSGET ovalor2 VAR nvalor2 SIZE 50,8 OF oDlg1 Picture "@E 999,999,999.99" PIXEL
ovalor2:BLostFocus := { || ntotal := nvalor1+nvalor2+nvalor3+nvalor4+nvalor5+nvalor6, oDlg1:Refresh() }
@ 46,14 MSGET oforma3 VAR cforma3 SIZE 50,8 OF oDlg1 Picture "@!" PIXEL
@ 46,64 MSGET ovalor3 VAR nvalor3 SIZE 50,8 OF oDlg1 Picture "@E 999,999,999.99" PIXEL
ovalor3:BLostFocus := { || ntotal := nvalor1+nvalor2+nvalor3+nvalor4+nvalor5+nvalor6, oDlg1:Refresh() }
@ 59,14 MSGET oforma4 VAR cforma4 SIZE 50,8 OF oDlg1 Picture "@!" PIXEL
@ 59,64 MSGET ovalor4 VAR nvalor4 SIZE 50,8 OF oDlg1 Picture "@E 999,999,999.99" PIXEL
ovalor4:BLostFocus := { || ntotal := nvalor1+nvalor2+nvalor3+nvalor4+nvalor5+nvalor6, oDlg1:Refresh() }
@ 71,14 MSGET oforma5 VAR cforma5 SIZE 50,8 OF oDlg1 Picture "@!" PIXEL
@ 71,64 MSGET ovalor5 VAR nvalor5 SIZE 50,8 OF oDlg1 Picture "@E 999,999,999.99" PIXEL
ovalor5:BLostFocus := { || ntotal := nvalor1+nvalor2+nvalor3+nvalor4+nvalor5+nvalor6, oDlg1:Refresh() }
@ 83,14 MSGET oforma6 VAR cforma6 SIZE 50,8 OF oDlg1 Picture "@!" PIXEL
@ 84,64 MSGET ovalor6 VAR nvalor6 SIZE 50,8 OF oDlg1 Picture "@E 999,999,999.99" PIXEL
ovalor6:BLostFocus := { || ntotal := nvalor1+nvalor2+nvalor3+nvalor4+nvalor5+nvalor6, oDlg1:Refresh() }
              
@ 106,64 MSGET ototal VAR ntotal SIZE 50,8 OF oDlg1 WHEN .F. Picture "@E 999,999,999.99" PIXEL
@ 130,82 BUTTON 'Ok' SIZE 40,10 PIXEL ACTION ( iif(nvalor1>0,cForma+=Alltrim(cforma1)+'|'+StrZero(nvalor1,14,2),),;
																iif(nvalor2>0,cForma+=Alltrim(cforma2)+'|'+StrZero(nvalor2,14,2),),;
																iif(nvalor3>0,cForma+=Alltrim(cforma3)+'|'+StrZero(nvalor3,14,2),),;
																iif(nvalor4>0,cForma+=Alltrim(cforma4)+'|'+StrZero(nvalor4,14,2),),;
																iif(nvalor5>0,cForma+=Alltrim(cforma5)+'|'+StrZero(nvalor5,14,2),),;
																iif(nvalor6>0,cForma+=Alltrim(cforma6)+'|'+StrZero(nvalor6,14,2),),;
																nRet := IFPagto(nHdlECF,cForma),;
																oDlg1:End()	 )
																		  
@ 130,29 BUTTON 'Cancel' SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fFechaCup �Autor  �Andre Alves Veiga   � Data �  20/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua o fechamento do cupom fiscal                         ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fFechaCup(nHdlECF)
Local nRet := 0
Local cMensagem := Space(50)

DEFINE MSDIALOG oDlg1 TITLE "Fechamento do Cupom Fiscal" FROM 0,0 TO 100,300 PIXEL
@ 10, 10 SAY "Mensagem" PIXEL
@ 10, 50 MSGET cMensagem SIZE 100,8 OF oDlg1 PIXEL
@ 30, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFFechaCup( nHdlECF,cMensagem ), oDlg1:End() )
@ 30,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fAdicAliq �Autor  �Andre Alves Veiga   � Data �  20/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua a adicao de aliquotas na Impressora Fiscal           ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fAdicAliq(nHdlECF)
Local nRet := 0
Local nAliquota := 0
Local nTipo := 1

DEFINE MSDIALOG oDlg1 TITLE "Grava Aliquotas" FROM 0,0 TO 150,300 PIXEL
@ 10, 10 SAY "Aliquota de" PIXEL
@ 10, 70 RADIO oTipo VAR nTipo 3D SIZE 40,10 PROMPT 'ICMS','ISS' OF oDlg1 PIXEL
@ 32, 10 SAY "Aliquota" PIXEL
@ 32, 70 MSGET oAliquota VAR nAliquota SIZE 40,8 PICTURE "@E 99.99" PIXEL OF oDlg1
@ 45, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFAdicAliq( nHdlECF,Alltrim(Str(nAliquota,5,2)),Str(nTipo,1,0)), oDlg1:End() )
@ 45,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fAbrCNFis �Autor  �Andre Alves Veiga   � Data �  20/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Abre cupom n�o Fiscal                                       ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fAbrCNFis(nHdlECF)
Local nRet := 0
Local cCondicao := Space(20)
Local nValor := 0
Local cTotalizador := Space(5)

DEFINE MSDIALOG oDlg1 TITLE "Abre cupom n�o fiscal" FROM 0,0 TO 150,400 PIXEL
@ 05, 10 SAY "Condicao de Pagto" PIXEL
@ 05, 70 MSGET cCondicao SIZE 100,8 OF oDlg1 PIXEL
@ 16, 10 SAY "Valor" PIXEL
@ 16, 70 MSGET nValor SIZE 40,8 PICTURE "@E 999,999,999.99" OF oDlg1 PIXEL
@ 27, 10 SAY "Totalizador" PIXEL
@ 27, 70 MSGET cTotalizador SIZE 40,8 OF oDlg1 PIXEL
@ 38, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFAbrCNFis( nHdlECF,cCondicao,Alltrim(Str(nValor,14,2)),Alltrim(cTotalizador) )  )
@ 38,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fTxtNFis  �Autor  �Andre Alves Veiga   � Data �  21/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Faz a impress�o de texto n�o fiscal                         ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fTxtNFis(nHdlECF)
Local nRet := 0
Local cTexto := Space(80)

DEFINE MSDIALOG oDlg1 TITLE "Impressao de texto n�o fiscal" FROM 0,0 TO 300,400 PIXEL
@  05, 10 SAY "Texto" PIXEL
@  12, 10 GET oTexto VAR cTexto OF oDlg1 MEMO SIZE 114,200 PIXEL
@ 140, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION (MsgInfo(MSMM(cTexto,80)), nRet := IFTxtNFis( nHdlECF, MSMM(cTexto,80) ) )
@ 140,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fAutentic �Autor  �Andre Alves Veiga   � Data �  21/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Faz a autentica��o do                                       ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fAutentic(nHdlECF)
Local nRet := 0
Local nVezes := nValor := 0
Local cTexto := Space(20)

DEFINE MSDIALOG oDlg1 TITLE "Autentica��o de Documentos" FROM 0,0 TO 300,300 PIXEL
@ 05, 10 SAY "Vezes" PIXEL
@ 05, 70 MSGET nVezes SIZE 40,8 OF oDlg1 PIXEL PICTURE "@E 99"
@ 16, 10 SAY "Valor" PIXEL
@ 16, 70 MSGET nValor SIZE 40,8 OF oDlg1 PIXEL PICTURE "@E 999,999,999.99"
@ 27, 10 SAY "Texto" PIXEL
@ 27, 70 MSGET cTexto SIZE 100,8 OF oDlg1 PIXEL
@ 38, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFAutentic( nHdlECF,nVezes,nValor,cTexto)  )
@ 38,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fTotNFis  �Autor  �Andre Alves Veiga	  � Data �  21/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Nomea��o de Totalizador N�o Fiscal                          ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fTotNFis(nHdlECF)
Local nRet := 0
Local nNumero := 0
Local cDescricao := Space(20)

DEFINE MSDIALOG oDlg1 TITLE "Nomea��o de totalizador n�o fiscal" FROM 0,0 TO 300,300 PIXEL
@ 05, 10 SAY "N�mero do Totalizador" PIXEL
@ 05, 70 MSGET nNumero SIZE 40,8 OF oDlg1 PIXEL PICTURE "@E 99"
@ 16, 10 SAY "Descri��o" PIXEL
@ 16, 70 MSGET cDescricao SIZE 100,8 OF oDlg1 PIXEL
@ 38, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFTotNFis( nHdlECF,nNumero,cDescricao)  )
@ 38,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �f_Status   �Autor  �Andre Alves Veiga   � Data �  21/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o Status da Impressora	                             ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function f_Status(nHdlECF,cRet)
Local nRet := 0
Local aEscolha := {}
Local cEscolha

//����������������������������������������������������������
//�Inicializa variaveis                                    �
//����������������������������������������������������������
aAdd(aEscolha  ,'1 - Hora')
aAdd(aEscolha  ,'2 - Data')
aAdd(aEscolha  ,'3 - Checa Papel')
aAdd(aEscolha  ,'4 - Cancelamento de Item')
aAdd(aEscolha  ,'5 - Cupom Fechado ?')
aAdd(aEscolha  ,'6 - Retorno de Suprimento')
aAdd(aEscolha  ,'7 - ECF permite desconto por item ?')
aAdd(aEscolha  ,'8 - Verifica se foi feita a redu��o Z')

//����������������������������������������������������������
//�Monta tela para interface com usu�rio                   �
//����������������������������������������������������������
DEFINE MSDIALOG oDlg1 TITLE "Status da Impressora" FROM 0,0 TO 150,300 PIXEL
@ 15, 10 SAY "Opera��o" PIXEL
@ 15, 70 MSCOMBOBOX oEscolha VAR cEscolha ITEMS aEscolha SIZE 70,8 OF oDlg1 PIXEL
@ 38, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFStatus(nHdlECF, Alltrim(Str(aScan(aEscolha,cEscolha),5,0)), @cRet),oDlg1:End()  )
@ 38,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fDescTot  �Autor  �Andre Alves Veiga   � Data �  21/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acrescenta desconto no total do cupom fiscal                ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fDescTot(nHdlECF)
Local nRet := 0
Local nDesconto := 0

DEFINE MSDIALOG oDlg1 TITLE "Desconto Total" FROM 0,0 TO 150,300 PIXEL
@ 15, 10 SAY "Valor Desconto" PIXEL
@ 15, 70 MSGET nDesconto SIZE 40,8 OF oDlg1 PIXEL PICTURE "@E 999,999,999.99"
@ 38, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFDescTot(nHdlECF,Alltrim(Str(nDesconto,14,2))), oDlg1:End() )
@ 38,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED


Return nRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fAcresTot �Autor  �Andre Alves Veiga   � Data �  21/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Acrescenta um acrescimo no total do cupom fiscal            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fAcresTot(nHdlECF)
Local nRet := 0
Local nAcrescimo := 0

DEFINE MSDIALOG oDlg1 TITLE "Desconto Total" FROM 0,0 TO 150,300 PIXEL
@ 15, 10 SAY "Valor Acrescimo" PIXEL
@ 15, 70 MSGET nAcrescimo SIZE 40,8 OF oDlg1 PIXEL PICTURE "@E 999,999,999.99"
@ 38, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFAcresTot(nHdlECF,Alltrim(Str(nAcrescimo,14,2))), oDlg1:End() )
@ 38,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMemFisc  �Autor  �Andre Alves Veiga   � Data �  21/06/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Faz a leitura da Mem�ria Fiscal                             ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fMemFisc(nHdlECF)
Local nRet := 0
Local dDataIni := dDataFim := Ctod(Space(8))

DEFINE MSDIALOG oDlg1 TITLE "Desconto Total" FROM 0,0 TO 150,300 PIXEL
@ 10, 10 SAY "Data Inicial" PIXEL
@ 10, 70 MSGET dDataIni OF oDlg1 PIXEL
@ 25, 10 SAY "Data Final" PIXEL
@ 25, 70 MSGET dDataFim OF oDlg1 PIXEL
@ 42, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFMemFisc( nHdlECF, DTOC(dDataIni), DTOC(dDataFim)), oDlg1:End()   )
@ 42,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGrvCondP �Autor  �Andre Alves Veiga   � Data �  06/21/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Faz a grava��o das condicoes de pagamento                   ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Function fGrvCondP(nHdlECF)
Local nRet := 0
Local cCondicao := Space(30)

DEFINE MSDIALOG oDlg1 TITLE "Grava Condi��o de Pagamento" FROM 0,0 TO 150,350 PIXEL
@ 10, 10 SAY "Condi��o de Pagamento" PIXEL
@ 10, 70 MSGET cCondicao SIZE 100,8 OF oDlg1 PIXEL
@ 38, 50 BUTTON "Ok" SIZE 40,10 PIXEL ACTION ( nRet := IFGrvCondP( nHdlECF, Alltrim(cCondicao)) )
@ 38,100 BUTTON "Cancel" SIZE 40,10 PIXEL ACTION (oDlg1:End())
ACTIVATE DIALOG oDlg1 CENTERED

Return nRet

