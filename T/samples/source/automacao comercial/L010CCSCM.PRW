#include "Rwmake.ch"
#include "Font.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ConsCCSM �Autor  �Marcos Alves        � Data �  30/01/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Consulta da ficha do cliente                               ���
�������������������������������������������������������������������������͹��
���Uso       � LOJA010T                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function L010CCSCM()
Local _cDados
Local _aDados:={}
Local _lRet  :=.F.
Local _oDlg 

Private nTotal     := 0
Private aParcTef   := {}

ctTrilha_2 := ''
cTrans	   := '60'	// Codigo da transacao
//����������������������������������Ŀ
//�aRet[1] ->Retorna o tipo do cartao�
//�1 - Magnetico                     �
//�2 - N�o Magn�tico                 �
//�3- CPF                            �
//�4- Abandona                       �
//�aRet[2] -> O dado sendo:          �
//�1,2 -> Numero do cart�o           �
//�3 -> numero do cpf                �
//������������������������������������
aRet:=L010TCart()

AAdd(_aDados,"36")  			 // Codigo da Rede 36 CCS
AAdd(_aDados,"04")  			 // Tipo da Consulta   - '04' - Consulta Generica
cDados  := "001"   				// Codigo da consulta - '001'- Situacao do cliente
If aRet[1] == 1 .Or. aRet[1] == 2
	cDados += "01"      			// Tipo de entrada    - '01' - Numero do Cart�o 
	cDados += PadL(AllTrim(aRet[2]),16,"0")
ElseIf aRet[1] == 3
	cDados += "02"      			// Tipo de entrada    - '02' - Numero do CPF e Data inicio 
	cDados += PadL(AllTrim(aRet[2]),11,"0")
Else
	Return Nil
EndIf
AAdd(_aDados,cDados)
cSaida:='S'
// O Parametro "CS", retona o array _aDados, com as informacoes do cliente
_lRet  :=loja010t("P","CS",@_aDados,.F.,.F.)
If _lRet
	@ 0,0 TO 420,550 DIALOG _oDlg TITLE "Situa��o do Cliente"
    L1:=05
    L2:=25
	@ L1   , 06 Say _aDados[1][1] //Nome do Cliente no Cart�o
	@ L1+10, 07 Get _aDados[1][2] SIZE 120,14 When .F.
	@ L1   , 135 Say _aDados[2][1] //"Numero do Cart�o"   
	@ L1+10, 137 Get _aDados[2][2] SIZE 120,14 When .F.

	L1+=L2
	@ L1   , 06 Say _aDados[3][1] //"CPF do cliente"             
	@ L1+10, 07 Get _aDados[3][2] SIZE 120,14 When .F.
	@ L1   , 135 Say _aDados[4][1] //"Situa��o do Cliente"          
	@ L1+10, 137 Get _aDados[4][2] SIZE 120,14 When .F.

	L1+=L2
	@ L1   , 06 Say _aDados[5][1] //"Enviado para a grafica" 
	@ L1+10, 07 Get _aDados[5][2] SIZE 120,14 When .F.
	@ L1   , 135 Say _aDados[6][1] //"Lista negra interna"       
	@ L1+10, 137 Get _aDados[6][2] SIZE 120,14 When .F.

	L1+=L2
	@ L1   , 06  Say _aDados[7][1] //"Lista negra manual"      
	@ L1+10, 07  Get _aDados[7][2] SIZE 120,14 When .F.
	@ L1   , 135 Say _aDados[8][1] //"Primeira compra do cliente"
	@ L1+10, 137 Get _aDados[8][2] SIZE 120,14 When .F.

	L1+=L2
	@ L1   , 06  Say _aDados[9][1]//"Data do Cadastramento"        
	@ L1+10, 07  Get _aDados[9][2] SIZE 120,14 When .F.
	@ L1   , 135 Say _aDados[10][1]//"Saldo atual de milhas"         
	@ L1+10, 137 Get _aDados[10][2] SIZE 120,14 picture Transform(Val(_aDados[10][2]),"@E 9,999,999")   When .F.

	L1+=L2
	@ L1   , 06 Say _aDados[11][1] //"Saldo atual em valor de milhas"
	@ L1+10, 07 Get _aDados[11][2] SIZE 120,14 picture Transform(Val(_aDados[11][2])/100,"@E 9,999,999.99") When .F.
	@ L1   , 135 Say _aDados[12][1] //"Limite de cr�dito dispon�vel"   
	@ L1+10, 137 Get _aDados[12][2] SIZE 120,14 picture Transform(Val(_aDados[12][2])/100,"@E 9,999,999.99") When .F.

	L1+=L2
	@ L1   , 06 Say _aDados[13][1]//"Dia do vencimento"            
	@ L1+10, 07 Get _aDados[13][2] SIZE 120,14 When .F.

	L1+=(L2+5)
	@ L1,200 Button "_Confirma" 	Size 52,16 Action (Close(_oDlg))
	Activate Dialog _oDlg Centered
EndIf
	
Return( _lRet )
