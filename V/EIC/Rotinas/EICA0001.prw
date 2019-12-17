#Include "protheus.ch"
#Include "fwmvcdef.ch"

#Define CAMPOSCAB "ZZ1_PRODUT|"
#Define CAMPOSDET "ZZ1_NIVEL|ZZ1_ATRIB|ZZ1_DES_AT|ZZ1_ESPECI|ZZ1_DES_ES|"

/**
 * Função:			EICA0001
 * Autor:			Ademar Pereira Junior
 * Data:			25/01/2016
 * Descrição:		Atributos N.V.E. do Produto
**/

User Function EICA0001()
Local oAuxBrow
	
	oAuxBrow := FWMBrowse():New()
	oAuxBrow:SetDescription("Atributos N.V.E. do Produto")
	oAuxBrow:SetAlias("ZZ1")
	oAuxBrow:SetLocate()
	oAuxBrow:Activate()
Return


/****************************************************************************************************/


// Função: MenuDef		
Static Function MenuDef()
Local aAuxRot := {}
	
	ADD OPTION aAuxRot TITLE "Visualizar" ACTION "VIEWDEF.EICA0001" OPERATION 2 ACCESS 0
	ADD OPTION aAuxRot TITLE "Incluir"    ACTION "VIEWDEF.EICA0001" OPERATION 3 ACCESS 0
	ADD OPTION aAuxRot TITLE "Alterar"    ACTION "VIEWDEF.EICA0001" OPERATION 4 ACCESS 0
	ADD OPTION aAuxRot TITLE "Excluir"    ACTION "VIEWDEF.EICA0001" OPERATION 5 ACCESS 0
Return aAuxRot


/****************************************************************************************************/


// Função: ViewDef
Static Function ViewDef()
Local oAuxView			:= FWFormView():New()
Local oAuxModel     := FWLoadModel("EICA0001")
Local oAuxStCab 	:= FWFormStruct(2,"ZZ1",{| cCampo | AllTrim(cCampo) + '|' $ CAMPOSCAB})
Local oAuxStGri 	:= FWFormStruct(2,"ZZ1",{| cCampo | AllTrim(cCampo) + '|' $ CAMPOSDET})

	oAuxView:SetModel(oAuxModel)
	oAuxView:AddField("FLE001_CAB",oAuxStCab,"ZZ1MASTER")
	oAuxView:AddGrid("FLE001_ITEM",oAuxStGri,"ZZ1DETAIL")
	
	oAuxStGri:RemoveField("ZZ1_PRODUT")

	oAuxView:CreateHorizontalBox("MASTER",20)
	oAuxView:CreateHorizontalBox("DETAIL",80)
	
	oAuxView:SetOwnerView("FLE001_CAB","MASTER")
	oAuxView:SetOwnerView("FLE001_ITEM","DETAIL")
	
	oAuxView:SetDescription("Atributos N.V.E. do Produto")
Return oAuxView


/****************************************************************************************************/


// Função: Modeldef
Static Function Modeldef()
Local oAuxModel     := MPFormModel():New("ZZ1FORM")
Local oAuxStCab 	:= FWFormStruct(1,"ZZ1",{| cCampo | AllTrim(cCampo) + '|' $ CAMPOSCAB})
Local oAuxStGri 	:= FWFormStruct(1,"ZZ1",{| cCampo | AllTrim(cCampo) + '|' $ CAMPOSDET})
	
	oAuxModel:SetDescription("Atributos N.V.E. do Produto")
	
	oAuxModel:AddFields("ZZ1MASTER",Nil,oAuxStCab)
	oAuxModel:AddGrid("ZZ1DETAIL","ZZ1MASTER",oAuxStGri)
	
	oAuxModel:GetModel("ZZ1MASTER"):SetDescription("Cabecalho")
	oAuxModel:GetModel("ZZ1DETAIL"):SetDescription("Itens")
	
	oAuxModel:SetRelation("ZZ1DETAIL",{	{"ZZ1_FILIAL","xFilial('ZZ1')"},;
	           							{"ZZ1_PRODUT","ZZ1_PRODUT"}},; 
	           							ZZ1->(IndexKey(1)))	

	oAuxModel:SetPrimaryKey({"ZZ1_NIVEL"})
Return oAuxModel