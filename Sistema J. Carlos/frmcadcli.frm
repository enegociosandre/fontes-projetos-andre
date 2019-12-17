VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form frmcadcli 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Cadastro de Clientes"
   ClientHeight    =   6345
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7560
   LinkTopic       =   "Form3"
   ScaleHeight     =   6345
   ScaleWidth      =   7560
   StartUpPosition =   3  'Windows Default
   WindowState     =   2  'Maximized
   Begin VB.TextBox txtconsulta2 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   2760
      TabIndex        =   34
      Top             =   4200
      Width           =   2895
   End
   Begin VB.TextBox txtie 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1680
      TabIndex        =   11
      Top             =   2640
      Width           =   2295
   End
   Begin VB.TextBox txtcpf 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   4560
      TabIndex        =   12
      Top             =   2640
      Width           =   2295
   End
   Begin VB.CommandButton cmdsair 
      Caption         =   "&Sair"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   7920
      TabIndex        =   18
      Top             =   3000
      Width           =   1215
   End
   Begin VB.CommandButton cmdconfirma 
      Caption         =   "&Confirma"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   6720
      TabIndex        =   17
      Top             =   3000
      Width           =   1215
   End
   Begin VB.TextBox txtconsulta 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   2760
      TabIndex        =   19
      Top             =   3840
      Width           =   2895
   End
   Begin VB.Data Data1 
      Caption         =   "Data1"
      Connect         =   "Access"
      DatabaseName    =   "C:\Documents and Settings\André\Desktop\Sistema Imobiliária\Imob.mdb"
      DefaultCursorType=   0  'DefaultCursor
      DefaultType     =   2  'UseODBC
      Exclusive       =   0   'False
      Height          =   345
      Left            =   10440
      Options         =   0
      ReadOnly        =   0   'False
      RecordsetType   =   1  'Dynaset
      RecordSource    =   ""
      Top             =   7200
      Visible         =   0   'False
      Width           =   1215
   End
   Begin MSFlexGridLib.MSFlexGrid MSFlexGrid1 
      Bindings        =   "frmcadcli.frx":0000
      Height          =   3135
      Left            =   120
      TabIndex        =   30
      Top             =   4560
      Width           =   11535
      _ExtentX        =   20346
      _ExtentY        =   5530
      _Version        =   393216
      FixedCols       =   0
   End
   Begin VB.CommandButton cmdexclui 
      Caption         =   "Exclui"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   5520
      TabIndex        =   16
      Top             =   3000
      Width           =   1215
   End
   Begin VB.CommandButton cmdlimpa 
      Caption         =   "Limpa"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   4320
      TabIndex        =   15
      Top             =   3000
      Width           =   1215
   End
   Begin VB.CommandButton cmdaltera 
      Caption         =   "Altera"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   3000
      TabIndex        =   14
      Top             =   3000
      Width           =   1335
   End
   Begin VB.CommandButton cmdinclui 
      Caption         =   "Inclui"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1680
      Picture         =   "frmcadcli.frx":0014
      TabIndex        =   13
      Top             =   3000
      Width           =   1335
   End
   Begin VB.TextBox txtobs 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1680
      TabIndex        =   10
      Top             =   2280
      Width           =   10095
   End
   Begin VB.TextBox txtmail 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1680
      TabIndex        =   9
      Top             =   1920
      Width           =   5175
   End
   Begin VB.TextBox txtestado 
      BeginProperty DataFormat 
         Type            =   1
         Format          =   "AA"
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   1046
         SubFormatType   =   0
      EndProperty
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1680
      TabIndex        =   6
      Top             =   1560
      Width           =   735
   End
   Begin VB.TextBox txttel2 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   5160
      TabIndex        =   8
      Top             =   1560
      Width           =   1695
   End
   Begin VB.TextBox txttel1 
      BeginProperty DataFormat 
         Type            =   0
         Format          =   "0"
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   1046
         SubFormatType   =   0
      EndProperty
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   3480
      TabIndex        =   7
      Top             =   1560
      Width           =   1455
   End
   Begin VB.TextBox txtcid 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   4680
      TabIndex        =   5
      Top             =   1200
      Width           =   2175
   End
   Begin VB.TextBox txtbairro 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1680
      TabIndex        =   4
      Top             =   1200
      Width           =   2175
   End
   Begin VB.TextBox txtend 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1680
      TabIndex        =   3
      Top             =   840
      Width           =   10095
   End
   Begin VB.TextBox txtnome 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   3480
      TabIndex        =   1
      Top             =   120
      Width           =   8295
   End
   Begin VB.TextBox txtrazao 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1680
      TabIndex        =   2
      Top             =   480
      Width           =   10095
   End
   Begin VB.TextBox txtcodigo 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1680
      TabIndex        =   0
      Top             =   120
      Width           =   975
   End
   Begin VB.Label Label14 
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      Caption         =   "Consulta o Nome:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   120
      TabIndex        =   35
      Top             =   4200
      Width           =   1890
   End
   Begin VB.Label Label13 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "RG:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   600
      TabIndex        =   33
      Top             =   2640
      Width           =   345
   End
   Begin VB.Label Label12 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "CPF:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   4080
      TabIndex        =   32
      Top             =   2640
      Width           =   435
   End
   Begin VB.Label Label11 
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      Caption         =   "Consulta o que Deseja:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   120
      TabIndex        =   31
      Top             =   3840
      Width           =   2475
   End
   Begin VB.Label Label10 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Obs:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   600
      TabIndex        =   29
      Top             =   2280
      Width           =   420
   End
   Begin VB.Label Label9 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "E-mail:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   600
      TabIndex        =   28
      Top             =   1920
      Width           =   615
   End
   Begin VB.Label Label8 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Estado:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   600
      TabIndex        =   27
      Top             =   1560
      Width           =   690
   End
   Begin VB.Label Label7 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Telefones:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   2640
      TabIndex        =   26
      Top             =   1560
      Width           =   960
   End
   Begin VB.Label Label6 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Cidade:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   3960
      TabIndex        =   25
      Top             =   1200
      Width           =   705
   End
   Begin VB.Label Label5 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Bairro:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   600
      TabIndex        =   24
      Top             =   1200
      Width           =   585
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Endereço:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   600
      TabIndex        =   23
      Top             =   840
      Width           =   930
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Nome:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   2880
      TabIndex        =   22
      Top             =   120
      Width           =   600
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "O que deseja:"
      Height          =   195
      Left            =   600
      TabIndex        =   21
      Top             =   480
      Width           =   990
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Codigo:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   600
      TabIndex        =   20
      Top             =   120
      Width           =   705
   End
End
Attribute VB_Name = "frmcadcli"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim db As Database
Dim op As Integer
Dim rs As Recordset
Private Sub cmdaltera_Click()
op = 2
trava "n"
End Sub
Private Sub Form_Load()
Set db = OpenDatabase("c:\banco\imob2.mdb")
Set rs = db.OpenRecordset("Select * from Clientes")
Set Data1.Recordset = rs
With MSFlexGrid1
.ColWidth(0) = 500
.ColWidth(1) = 2000
.ColWidth(2) = 2000
.ColWidth(3) = 3000
.ColWidth(4) = 700
.ColWidth(5) = 700
.ColWidth(6) = 200
.ColWidth(7) = 1000
.ColWidth(8) = 1000
.ColWidth(9) = 2000
.ColWidth(10) = 5000
.ColWidth(11) = 2000
.ColWidth(12) = 2000
End With
trava "s"
End Sub

Private Sub cmdconfirma_Click()
If op = 1 Then
rs.AddNew
rs!codigo = txtcodigo.Text
rs!Nome = txtnome.Text
rs!procura = txtrazao.Text
rs!Endereco = txtend.Text
rs!Cidade = txtcid.Text
rs!Bairro = txtbairro.Text
rs!Estado = txtestado.Text
rs!Telefone1 = txttel1.Text
rs!Telefone2 = txttel2.Text
rs!Email = txtmail.Text
rs!Observacoes = txtobs.Text
rs!RG = txtie.Text
rs!CPF = txtcpf.Text
rs.Update
trava "s"
Else
rs.FindFirst "codigo=" & Val(txtcodigo.Text)
rs.Edit
rs!codigo = txtcodigo.Text
rs!Nome = txtnome.Text
rs!procura = txtrazao.Text
rs!Endereco = txtend.Text
rs!Cidade = txtcid.Text
rs!Bairro = txtbairro.Text
rs!Estado = txtestado.Text
rs!Telefone1 = txttel1.Text
rs!Telefone2 = txttel2.Text
rs!Email = txtmail.Text
rs!Observacoes = txtobs.Text
rs!RG = txtie.Text
rs!CPF = txtcpf.Text
rs.Update
trava "s"
End If
Data1.Refresh
cmdlimpa_Click
End Sub
Private Sub cmdexclui_Click()
If MsgBox("Deseja excluir", vbDefaultButton2 + vbQuestion + vbYesNo, "Pergunta ?") = vbYes Then
rs.FindFirst "codigo=" & Val(txtcodigo.Text)
rs.Delete
cmdlimpa_Click
Data1.Refresh
trava "s"
End If
End Sub
Private Sub cmdinclui_Click()
cmdlimpa_Click
Form_Load

On Error GoTo vError
rs.MoveLast
txtcodigo = (rs!codigo + 1)
op = 1
trava "n"
txtnome.SetFocus
vError:
Select Case Err.Number
Case 3021
txtcodigo.Text = 1
Resume Next
Case 0
Case Else
MsgBox Err.Description, , Err.Number
End Select
End Sub
Private Sub cmdlimpa_Click()
txtcodigo.Text = ""
txtnome.Text = ""
txtrazao.Text = ""
txtend.Text = ""
txtcid.Text = ""
txtbairro.Text = ""
txtestado.Text = ""
txttel1.Text = ""
txttel2.Text = ""
txtmail.Text = ""
txtobs.Text = ""
txtie.Text = ""
txtcpf.Text = ""
txtconsulta.Text = ""
trava "s"
End Sub
Private Sub cmdsair_Click()
rs.Close
db.Close
Set rs = Nothing
Set db = Nothing
Unload Me
End Sub
Private Sub trava(ByVal tipo As String)
If tipo = "s" Then
txtcodigo.Enabled = False
txtnome.Enabled = False
txtrazao.Enabled = False
txtend.Enabled = False
txtcid.Enabled = False
txtbairro.Enabled = False
txtestado.Enabled = False
txttel1.Enabled = False
txttel2.Enabled = False
txtie.Enabled = False
txtcpf.Enabled = False
txtmail.Enabled = False
txtobs.Enabled = False
Else
txtcodigo.Enabled = True
txtnome.Enabled = True
txtrazao.Enabled = True
txtend.Enabled = True
txtcid.Enabled = True
txtbairro.Enabled = True
txtestado.Enabled = True
txttel1.Enabled = True
txttel2.Enabled = True
txtmail.Enabled = True
txtobs.Enabled = True
txtie.Enabled = True
txtcpf.Enabled = True
txtmail.Enabled = True
txtobs.Enabled = True
End If
End Sub

Private Sub MSFlexGrid1_Dblclick()
txtcodigo.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 0)
txtnome.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 1)
txtrazao.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 2)
txtend.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 3)
txtcid.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 4)
txtbairro.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 5)
txtestado.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 6)
txttel1.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 7)
txttel2.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 8)
txtmail.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 9)
txtobs.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 10)
txtie.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 11)
txtcpf.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 12)
End Sub


Private Sub txtconsulta_Change()
Set rs = db.OpenRecordset("Select * from clientes where procura like '" & txtconsulta.Text & "*' order by procura")
Set Data1.Recordset = rs
Data1.Refresh
End Sub

Private Sub txtconsulta2_Change()
Set rs = db.OpenRecordset("Select * from clientes where nome like '" & txtconsulta2.Text & "*' order by nome")
Set Data1.Recordset = rs
Data1.Refresh
End Sub

