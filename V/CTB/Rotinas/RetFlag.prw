#Include "RWMAKE.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa       �Configuradoo �Joao Marcondes      � Data �  13/03/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este programa tem a fun��o de facilitar a recontabiliza��o ���
���          � de notas fiscais de entrada/sa�da.                         ���
�������������������������������������������������������������������������͹��
���Uso       � Menu do SIGACOM, SIGAFAT, SIGACTB,SIGAEST                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RetFlag()

// Valida os m�dulos.
If !cModulo $ "COM,EST,FAT,CTB "
	Alert("Este programa pode ser chamado apenas nos seguintes m�dulos: COM,EST,FAT,CTB !")
	Return
EndIf

// Declara��o das vari�veis do programa.
Public aOpcao := {}
Public _cNF		:= Space(9)
Public _cSerie  := Space(3)
Public _cFor	:= Space(6)
Public _cLoja	:= Space(2)
Public nOpcao 	:= 1
Public lMarca	:= .t.
Public _lMostra := .t.

// Inicializa com dados do faturamento conforme padr�o do cliente.
If cModulo=="FAT"
	_cSerie := "   "
	nOpcao := 2
EndIf

// Faz o processamento, pode mostrar tela para escolher se � entradas ou sa�das, por�m
// � mais pr�tico que isso n�o ocorra.
If _lMostra
	aAdd(aOpcao,"NF Entrada")
	aAdd(aOpcao,"NF Sa�da")

	@ 001,101 To 200,305 Dialog  oMyDlg Title OemToAnsi("Retira Flag")
	@ 3,3 To 76,100
	@ 10,20 Radio aOpcao Var nOpcao
	@ 50,20 CheckBox OemToAnsi("Contab.Novamente") Var lMarca
	@ 80,30 BmpButton Type 1 Action (SUB01(),Close(oMyDlg))
	@ 80,70 BmpButton Type 2 Action Close(oMyDlg)
	Activate Dialog oMyDlg Centered
Else
	SUB01()
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SUB01    �Autor  �Marcondes           � Data �  01/12/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este programa tem a fun��o de montar o di�logo que obter�  ���
���          � os dados da NF a recontabilizar.                           ���
�������������������������������������������������������������������������͹��
���Uso       � RETFLAG.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SUB01
	// Processa se for NFE.
	If nOpcao == 1
		@ 200,1 TO 400,400 DIALOG oMyDlg1 TITLE OemToAnsi("Retira Flag NF Entrada")
		@ 02,10 TO 080,190
		@ 10,018 Say " NF : "
		@ 10,040 Get _cNF
		@ 20,018 Say " S�rie : "
		@ 20,040 Get _cSerie
		@ 30,018 Say " Forn. : "
		@ 30,040 Get _cFor  F3 "SA2"
		@ 40,018 Say " Loja : "
		@ 40,040 Get _cLoja
		@ 80,020 BMPBUTTON TYPE 01 ACTION SUB02()
		@ 80,050 BMPBUTTON TYPE 02 ACTION Close(oMyDlg1)
		@ 80,090 Button OemToAnsi("SF1") Size 15,13 Action XMATA103()
		@ 80,107 Button OemToAnsi("SF4") Size 15,13 Action MATA080()
		@ 80,124 Button OemToAnsi("SB1") Size 15,13 Action MATA010()
		@ 80,141 Button OemToAnsi("CT5") Size 15,13 Action CTBA080()
		@ 80,158 Button OemToAnsi("SM4") Size 15,13 Action CFGX019()
		@ 80,175 Button OemToAnsi("CT2") Size 15,13 Action CTBA102()
		Activate Dialog oMyDlg1 Centered

	// Processa se for NFS.
	ElseIf nOpcao == 2
		@ 200,1 TO 400,400 DIALOG oMyDlg1 TITLE OemToAnsi("Retira Flag NF Sa�da")
		@ 02,10 TO 080,190
		@ 10,018 Say " NF : "
		@ 10,040 Get _cNF
		@ 20,018 Say " S�rie : "
		@ 20,040 Get _cSerie
		@ 80,020 BMPBUTTON TYPE 01 ACTION SUB02()
		@ 80,050 BMPBUTTON TYPE 02 ACTION Close(oMyDlg1)
		@ 80,090 Button OemToAnsi("SF2") Size 15,13 Action MATC090()
		@ 80,107 Button OemToAnsi("SF4") Size 15,13 Action MATA080()
		@ 80,124 Button OemToAnsi("SB1") Size 15,13 Action MATA010()
		@ 80,141 Button OemToAnsi("CT5") Size 15,13 Action CTBA080()
		@ 80,158 Button OemToAnsi("SM4") Size 15,13 Action CFGX019()
		@ 80,175 Button OemToAnsi("CT2") Size 15,13 Action CTBA102()
		Activate Dialog oMyDlg1 Centered
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SUB02     �Autor  �Marcondes           � Data �  01/12/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este programa verifica os dados informados pelo usu�rio e  ���
���          � retira o flag da NF.                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SUB01                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SUB02

// Declara��o das vari�veis do programa.
Local _xAreaSF1 := GetArea()
Local _xAreaSF2 := GetArea()
Local _cDadosNf := ""
Local _lYesNo	:= .F.

// Processa Flag da NFE.
If nOpcao == 1

	// Ativa �rea de trabalho.
	dbSelectArea("SF1")
	dbSetOrder(1) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO

	// Procura a NF.
	dbSeek(xFilial("SF1")+_cNf+_cSerie+_cFor+_cLoja)
	If Found()

		// Solicita confirma��o para alterar.
		_cDadosNf := "Nf: " +Alltrim(_cSerie)+"-"+_cNf+" - R$ "+Alltrim(Transform(SF1->F1_VALBRUT,"@E 99,999,999,999.99"))
		_cDadosNF := _cDadosNF + " - Em: " + Transform(SF1->F1_EMISSAO,"D")
		_cDadosNF := _cDadosNF + " - Dg: " + Transform(SF1->F1_DTDIGIT,"D")
		_cDadosNF := _cDadosNF + " - Ctb: " + Transform(SF1->F1_DTLANC,"D")

		_lYesNo := MsgBox(_cDadosNf,"Confirma","YESNO")

		// Altera a NF.
		If _lYesNo	== .T.
			If RecLock("SF1",.F.)
				SF1->F1_DTLANC := CTOD(Space(8))
				msunlock()
			endIf
			
			// Carrega a rotina de contabiliza��o.
			If lMarca
				CTBANFE()
			EndIf
			
		EndIf
					
	Else
		// Aviso de NF n�o encontrada.
		Alert("Nf n�o encontrada -> " + _cSerie + "/" + _cNf)
	EndIf

	//Restaura �rea de trabalho.
	RestArea(_xAreaSF1)

// Processa Flag da NFE.
ElseIf nOpcao == 2

	// Ativa �rea de trabalho.
	dbSelectArea("SF2")
	dbSetOrder(1) // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL

	// Procura a NF.
	dbSeek(xFilial("SF2")+_cNf+_cSerie)
	If Found()

		// Solicita confirma��o para alterar.
		_cDadosNf := "Nf: " +Alltrim(_cSerie)+"-"+_cNf+" - R$ "+Alltrim(Transform(SF2->F2_VALBRUT,"@E 99,999,999,999.99"))
		_cDadosNF := _cDadosNF + " - Em: " + Transform(SF2->F2_EMISSAO,"D")
		_cDadosNF := _cDadosNF + " - Ctb: " + Transform(SF2->F2_DTLANC,"D")

		_lYesNo := MsgBox(_cDadosNf,"Confirma","YESNO")

		// Altera a NF.
		If _lYesNo	== .T.
			If RecLock("SF2",.F.)
				SF2->F2_DTLANC := CTOD(Space(8))
				msunlock()
			endIf
			
			// Carrega a rotina de contabiliza��o.
			If lMarca
				CTBANFS()
			EndIf
			
		EndIf
					
	Else
		// Aviso de NF n�o encontrada.
		Alert("Nf n�o encontrada -> " + _cSerie + "/" + _cNf)
	EndIf

	//Restaura �rea de trabalho.
	RestArea(_xAreaSF2)
EndIf

Return

Static Function XMATA103()

MATA103()

_cNF		:= SF1->F1_DOC
_cSerie  	:= SF1->F1_SERIE
_cFor		:= SF1->F1_FORNECE
_cLoja		:= SF1->F1_LOJA

oMyDlg1:Refresh()

Return