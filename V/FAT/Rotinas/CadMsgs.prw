#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} CadMsgs
Cadastro de Mensagens para utilização na NFe

@author Thiago Meschiatti
@since 21/01/16
@version P12
/*/
User Function CadMsgs()
	Local oBrowse       
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZZ2')        
	oBrowse:SetDescription('Cadastro de Autor/Interprete')  
	oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'             OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CadMsgs' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CadMsgs' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CadMsgs' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CadMsgs' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CadMsgs' OPERATION 9 ACCESS 0
Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
	Local oStruZZ2 := FWFormStruct( 1, 'ZZ2', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	                         
	oModel := MPFormModel():New('COMP011M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	oModel:AddFields( 'ZZ2MASTER', /*cOwner*/, oStruZZ2, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:SetDescription( 'Modelo de Dados de Autor/Interprete' )
	oModel:GetModel( 'ZZ2MASTER' ):SetDescription( 'Dados de Autor/Interprete' )
	oModel:setPrimaryKey({})

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
	Local oModel   := FWLoadModel( 'CadMsgs' )
	Local oStruZZ2 := FWFormStruct( 2, 'ZZ2' )
	Local oView  
	Local cCampos := {}
	
	oView := FWFormView():New()
	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZZ2', oStruZZ2, 'ZZ2MASTER' )
	oView:CreateHorizontalBox( 'TELA' , 100 )
	oView:SetOwnerView( 'VIEW_ZZ2', 'TELA' )
	
Return oView