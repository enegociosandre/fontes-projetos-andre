#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460FIM  ºAutor  ³Deivid A. C. de Limaº Data ³  19/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no final da geracao da NF Saida, utilizadoº±±
±±º          ³ para gravacao de dados adicionais.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function M460FIM()

Local oTMsg  	:= FswTemplMsg():TemplMsg("S",SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
Local nPBruto	:= 0
Local nPLiqui	:= 0
Local nVolume 	:= 0

&& inicio calculo do peso liquido
SD2->(dbSetOrder(3))
SD2->(dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))

Do While !SD2->(EOF()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
	
	nPLiqui += SD2->D2_QUANT * Posicione("SB1", 1, xFilial("SB1")+SD2->D2_COD, "B1_PESO")
	//nPBruto += SD2->D2_QUANT * Posicione("SB1", 1, xFilial("SB1")+SD2->D2_COD, "B1_PESBRU")
	//nVolume += SD2->D2_QUANT
	
	SD2->(dbSkip())
Enddo

/*
If nVolume > 999999	
	msgAlert("Volume maior que "+alltrim(Transform(999999.99, "@E 999,999.99"))+" favor digitar na mão!")
	nVolume := 0
EndIf

If nPBruto > 999999
	msgAlert("Peso bruto maior que "+alltrim(Transform(999999.99, "@E 999,999.99"))+" favor digitar na mão!")
	nPBruto := 0
EndIf

If nPLiqui > 999999
	msgAlert("Peso liquido maior que "+alltrim(Transform(999999.99, "@E 999,999.99"))+" favor digitar na mão!")
	nPLiqui := 0
EndIf
*/
&& fim

&& inicio template mensagens da NF
SD2->(dbSetOrder(3))
SD2->(dbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))

SC5->(dbSetOrder(1))
SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

aAdd(oTMsg:aCampos,{"F2_TRANSP",  SC5->C5_TRANSP})
aAdd(oTMsg:aCampos,{"F2_REDESP",  SC5->C5_REDESP})
aAdd(oTMsg:aCampos,{"F2_PLIQUI",  IIF(!Empty(SC5->C5_PESOL),SC5->C5_PESOL,nPLiqui)})
aAdd(oTMsg:aCampos,{"F2_PBRUTO",  SC5->C5_PBRUTO})
aAdd(oTMsg:aCampos,{"F2_VOLUME1", SC5->C5_VOLUME1})
aAdd(oTMsg:aCampos,{"F2_ESPECI1", SC5->C5_ESPECI1})
aAdd(oTMsg:aCampos,{"F2_ZZPLACA", SC5->C5_VEICULO})
aAdd(oTMsg:aCampos,{"F2_ZZUFPLA", CriaVar("F2_ZZUFPLA")})
aAdd(oTMsg:aCampos,{"F2_ZZDTSAI", dDatabase})
aAdd(oTMsg:aCampos,{"F2_ZZHRSAI", Time()})
//aAdd(oTMsg:aCampos,{"F2_ZZMARCA", CriaVar("F2_ZZMARCA")})

//Inicio dos dados da exportacao
If Alltrim(SF2->F2_EST) == "EX" 
	aAdd(oTMsg:aCampos,{"F2_ZZUFEMB" 	,CriaVar("F2_ZZUFEMB")})
	aAdd(oTMsg:aCampos,{"F2_ZZLCEMB" 	,CriaVar("F2_ZZLCEMB")}) 
EndIf
//Fim dos dados da exportacao

oTMsg:Processa()

RecLock("SC5",.F.)
	SC5->C5_TRANSP := SF2->F2_TRANSP
	SC5->C5_REDESP := SF2->F2_REDESP
	SC5->C5_PBRUTO := nPBruto
	SC5->C5_PESOL  := nPLiqui
MsUnlock()

SD2->(dbSetOrder(3))
&& fim template mensagens da NF

&& Atualiza tabela CDL - Complemento de exportacao
If Alltrim(SF2->F2_EST) == "EX" 
	updCDL()
EndIf

Return


***************************************************************************************************************
/**
 * Rotina		:	updCDL
 * Autor		:	André Oquendo - TOTVS IP
 * Data			:	06/11/2014
 * Descrição	:	Salva os dados de exportação no CDL
 * Uso			: 
 * Modulo		:  	
 * Alterações 	:
 */
 

Static Function updCDL()
	Local aArea    	:= GetArea()  
	Local aAreaSD2  := SD2->(GetArea())
	Local aAreaCDL  := CDL->(GetArea())
	
	dbSelectArea("CDL")
	dbsetorder(1)  
	dbseek( xFilial("CDL") + SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))

	While CDL->(!Eof()) .AND. CDL->(CDL_DOC+CDL_SERIE+CDL_FORNEC+CDL_LOJA) == SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)

		RecLock("CDL",.F.)  
        	CDL->(dbDelete())  
  		CDL->(MsUnlock("CDL"))

		CDL->(dbSkip())  

	EndDo               

	dbSelectArea("SD2")
	dbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbSeek(xFilial("SD2")+ SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)) 
	While SD2->(!Eof()) .AND. SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)	
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
		//cria os CDL		
		RecLock("CDL", .T.)      	
			CDL->CDL_FILIAL  :=  xFilial("CDL")  
			CDL->CDL_DOC     :=  SF2->F2_DOC 
			CDL->CDL_SERIE   :=  SF2->F2_SERIE
			CDL->CDL_ESPEC   :=  SF2->F2_ESPECIE
			CDL->CDL_LOJA    :=  SF2->F2_LOJA 
			CDL->CDL_UFEMB   :=  SF2->F2_ZZUFEMB
			CDL->CDL_LOCEMB  :=  AllTrim(SF2->F2_ZZLCEMB)						
			CDL->CDL_ITEMNF  :=  SD2->D2_ITEM			
			CDL->CDL_PRODNF  :=  SD2->D2_COD
			CDL->CDL_CLIENT  :=  SF2->F2_CLIENTE								
			CDL->(MsUnlock("CDL"))   
		SD2->(DbSkip())
	EndDo 
	
  	CDL->(RestArea(aAreaCDL))
  	SD2->(RestArea(aAreaSD2))
  	RestArea(aArea)
Return

