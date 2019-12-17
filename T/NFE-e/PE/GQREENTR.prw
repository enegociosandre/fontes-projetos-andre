#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GQREENTR ºAutor  ³Deivid A. C. de Limaº Data ³  07/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no final da geracao da NF Entrada,        º±±
±±º          ³ utilizado para gravacao de dados adicionais.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GQREENTR()

Local oTMsg  := FswTemplMsg():TemplMsg("E",SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)

&& inicio template mensagens da NF
If SF1->F1_FORMUL == "S"
	aAdd(oTMsg:aCampos,{"F1_ZZVOLUM",CriaVar("F1_ZZVOLUM")})
	aAdd(oTMsg:aCampos,{"F1_ZZESPEC",CriaVar("F1_ZZESPEC")})
	aAdd(oTMsg:aCampos,{"F1_PESOL"  ,CriaVar("F1_PESOL"  )})
	aAdd(oTMsg:aCampos,{"F1_ZZPBRUT",CriaVar("F1_ZZPBRUT")})
	aAdd(oTMsg:aCampos,{"F1_ZZTRANS",CriaVar("F1_ZZTRANS")})
	aAdd(oTMsg:aCampos,{"F1_ZZPLACA",CriaVar("F1_ZZPLACA")})
	aAdd(oTMsg:aCampos,{"F1_ZZMARCA",CriaVar("F1_ZZMARCA")})

	oTMsg:Processa()
Endif
&& fim template mensagens da NF

Return