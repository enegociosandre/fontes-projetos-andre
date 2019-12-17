VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form frmcadfor 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Cadastro de Fornecedores"
   ClientHeight    =   6660
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7305
   LinkTopic       =   "Form3"
   ScaleHeight     =   6660
   ScaleWidth      =   7305
   StartUpPosition =   3  'Windows Default
   WindowState     =   2  'Maximized
   Begin VB.TextBox txtconsulta2 
      Height          =   285
      Left            =   6000
      TabIndex        =   32
      Top             =   4680
      Width           =   495
   End
   Begin VB.TextBox txtconsulta 
      Height          =   285
      Left            =   6000
      TabIndex        =   31
      Top             =   4320
      Width           =   495
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
      Left            =   4800
      TabIndex        =   29
      Top             =   360
      Width           =   1335
   End
   Begin VB.ComboBox cmbdisponivel 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   360
      ItemData        =   "frmcadfor.frx":0000
      Left            =   5880
      List            =   "frmcadfor.frx":0010
      TabIndex        =   9
      Text            =   "Selecione"
      Top             =   3000
      Width           =   1575
   End
   Begin VB.TextBox txtvalor 
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
      Left            =   2160
      TabIndex        =   8
      Top             =   3000
      Width           =   2175
   End
   Begin VB.TextBox txtendereco 
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
      Left            =   2160
      TabIndex        =   7
      Top             =   2640
      Width           =   9135
   End
   Begin VB.TextBox txtproprietario 
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
      Left            =   2160
      TabIndex        =   6
      Top             =   2280
      Width           =   5055
   End
   Begin VB.TextBox txtobservacoes 
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
      Left            =   2160
      TabIndex        =   5
      Top             =   1920
      Width           =   9135
   End
   Begin VB.TextBox txtgaragens 
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
      Left            =   2160
      TabIndex        =   4
      Top             =   1560
      Width           =   1575
   End
   Begin VB.TextBox txtdata 
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
      Left            =   2160
      TabIndex        =   3
      Top             =   1200
      Width           =   1575
   End
   Begin VB.TextBox txtquartos 
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
      Left            =   2160
      TabIndex        =   2
      Top             =   840
      Width           =   1575
   End
   Begin VB.TextBox txtdetalhe 
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
      Left            =   2160
      TabIndex        =   1
      Top             =   480
      Width           =   1575
   End
   Begin VB.ComboBox cmbimoveis 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   360
      ItemData        =   "frmcadfor.frx":003C
      Left            =   2160
      List            =   "frmcadfor.frx":004C
      TabIndex        =   0
      Text            =   "Selecione"
      Top             =   120
      Width           =   1575
   End
   Begin VB.Data Data1 
      Caption         =   "Data1"
      Connect         =   "Access"
      DatabaseName    =   "C:\Documents and Settings\André\Desktop\Sistema Imobiliária\Imob.mdb"
      DefaultCursorType=   0  'DefaultCursor
      DefaultType     =   2  'UseODBC
      Exclusive       =   0   'False
      Height          =   345
      Left            =   2400
      Options         =   0
      ReadOnly        =   0   'False
      RecordsetType   =   1  'Dynaset
      RecordSource    =   ""
      Top             =   5280
      Visible         =   0   'False
      Width           =   1935
   End
   Begin MSFlexGridLib.MSFlexGrid MSFlexGrid1 
      Bindings        =   "frmcadfor.frx":0073
      Height          =   2775
      Left            =   240
      TabIndex        =   17
      Top             =   5040
      Width           =   11175
      _ExtentX        =   19711
      _ExtentY        =   4895
      _Version        =   393216
      FixedCols       =   0
   End
   Begin VB.CommandButton cmdsair 
      Caption         =   "&Sair"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   6960
      TabIndex        =   15
      Top             =   3600
      Width           =   1095
   End
   Begin VB.CommandButton cmdconfirma 
      Caption         =   "&Confirma"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   5760
      TabIndex        =   14
      Top             =   3600
      Width           =   1215
   End
   Begin VB.CommandButton cmdexclui 
      Caption         =   "Exclui"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   4680
      TabIndex        =   13
      Top             =   3600
      Width           =   1095
   End
   Begin VB.CommandButton cmdlimpa 
      Caption         =   "Limpa"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   3600
      TabIndex        =   12
      Top             =   3600
      Width           =   1095
   End
   Begin VB.CommandButton cmdaltera 
      Caption         =   "Altera"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   2640
      TabIndex        =   11
      Top             =   3600
      Width           =   975
   End
   Begin VB.CommandButton cmdinclui 
      Caption         =   "Inclui"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1680
      TabIndex        =   10
      Top             =   3600
      Width           =   975
   End
   Begin VB.Label Label13 
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      Caption         =   "Consulte aqui V' para Venda 'A' para Aluguel"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   2040
      TabIndex        =   30
      Top             =   4680
      Width           =   3825
   End
   Begin VB.Label Label12 
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "Código:"
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
      Left            =   5160
      TabIndex        =   28
      Top             =   120
      Width           =   705
   End
   Begin VB.Label Label10 
      AutoSize        =   -1  'True
      BackColor       =   &H80000003&
      BackStyle       =   0  'Transparent
      Caption         =   "Disponível para:"
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
      Left            =   4440
      TabIndex        =   27
      Top             =   3000
      Width           =   1470
   End
   Begin VB.Label Label9 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Valor:"
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
      Left            =   1200
      TabIndex        =   26
      Top             =   3000
      Width           =   525
   End
   Begin VB.Label Label8 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Endereco Completo:"
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
      Left            =   120
      TabIndex        =   25
      Top             =   2640
      Width           =   1845
   End
   Begin VB.Label label7 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Proprietário:"
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
      Left            =   720
      TabIndex        =   24
      Top             =   2280
      Width           =   1095
   End
   Begin VB.Label Label6 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Observações:"
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
      Top             =   1920
      Width           =   1275
   End
   Begin VB.Label Label5 
      AutoSize        =   -1  'True
      BackColor       =   &H80000003&
      BackStyle       =   0  'Transparent
      Caption         =   "Garagens:"
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
      Left            =   840
      TabIndex        =   22
      Top             =   1560
      Width           =   945
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      BackColor       =   &H80000003&
      BackStyle       =   0  'Transparent
      Caption         =   "Data:"
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
      Left            =   1200
      TabIndex        =   21
      Top             =   1200
      Width           =   480
   End
   Begin VB.Label label3 
      AutoSize        =   -1  'True
      BackColor       =   &H80000003&
      BackStyle       =   0  'Transparent
      Caption         =   "Quartos/Banheiros:"
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
      Left            =   240
      TabIndex        =   20
      Top             =   840
      Width           =   1725
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      BackColor       =   &H80000003&
      BackStyle       =   0  'Transparent
      Caption         =   "Detalhes:"
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
      Left            =   840
      TabIndex        =   19
      Top             =   480
      Width           =   855
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackColor       =   &H80000003&
      BackStyle       =   0  'Transparent
      Caption         =   "Tipo do Imóvel:"
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
      Left            =   480
      TabIndex        =   18
      Top             =   120
      Width           =   1395
   End
   Begin VB.Label Label11 
      AutoSize        =   -1  'True
      BackColor       =   &H00FFFFFF&
      Caption         =   "Consulte aqui 'C' para Casa -  'A' para Apartamento - 'T' Terreno"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   360
      TabIndex        =   16
      Top             =   4320
      Width           =   5475
   End
End
Attribute VB_Name = "frmcadfor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim db As Database
Dim op As Integer
Dim rs As Recordset
Dim GuardaCodigo As Integer
Dim Aprovado As Boolean
Private Sub cmdaltera_Click()
op = 2
GuardaCodigo = txtcodigo.Text
trava "n"
MsgBox GuardaCodigo
End Sub
Private Sub Form_Load()
Set db = OpenDatabase("c:\banco\imob2.mdb")
Set rs = db.OpenRecordset("Select * from fornecedores")
Set Data1.Recordset = rs
With MSFlexGrid1
.ColWidth(0) = 700
.ColWidth(1) = 1200
.ColWidth(2) = 1000
.ColWidth(3) = 2000
.ColWidth(4) = 2500
.ColWidth(5) = 2000
.ColWidth(6) = 1000
.ColWidth(7) = 2000
.ColWidth(8) = 1000
.ColWidth(9) = 1000
.ColWidth(10) = 4000
End With
trava "s"
End Sub
Private Sub trava(ByVal tipo As String)
If tipo = "s" Then
txtcodigo.Enabled = False
txtdetalhe.Enabled = False
txtquartos.Enabled = False
txtdata.Enabled = False
txtgaragens.Enabled = False
txtobservacoes.Enabled = False
txtproprietario.Enabled = False
txtendereco.Enabled = False
txtvalor.Enabled = False
cmbdisponivel.Enabled = False
cmbimoveis.Enabled = False
Else
txtcodigo.Enabled = True
txtquartos.Enabled = True
txtdetalhe.Enabled = True
txtquartos.Enabled = True
txtdata.Enabled = True
txtgaragens.Enabled = True
txtobservacoes.Enabled = True
txtproprietario.Enabled = True
txtendereco.Enabled = True
txtvalor.Enabled = True
cmbdisponivel.Enabled = True
cmbimoveis.Enabled = True
End If
End Sub
Private Sub cmdconfirma_Click()
Aprovado = True
If op = 1 Then
rs.MoveFirst
    Do While Not rs.EOF
        If (txtcodigo.Text = rs!codigo) Then
            MsgBox "Você já está usando esse código"
            Aprovado = False
            Exit Do
        End If
    rs.MoveNext
    Loop
        
        If Not Aprovado = False Then
            rs.AddNew
            rs!codigo = txtcodigo.Text
            rs!detalhe = txtdetalhe.Text
            rs!Quartos = txtquartos.Text
            rs!Data = txtdata.Text
            rs!Garagens = txtgaragens.Text
            rs!Observacoes = txtobservacoes.Text
            rs!Proprietario = txtproprietario.Text
            rs!Endereco = txtendereco.Text
            rs!Valor = txtvalor.Text
            rs!Disponivel = cmbdisponivel.Text
            rs!TipoImovel = cmbimoveis.Text
            rs.Update
            trava "s"
            Data1.Refresh
            cmdlimpa_Click
        End If
Else
        rs.MoveFirst
        Do While Not rs.EOF
            If (rs!codigo = GuardaCodigo) Then
                rs.Edit
                rs!codigo = txtcodigo.Text
                rs!detalhe = txtdetalhe.Text
                rs!Quartos = txtquartos.Text
                rs!Data = txtdata.Text
                rs!Garagens = txtgaragens.Text
                rs!Observacoes = txtobservacoes.Text
                rs!Proprietario = txtproprietario.Text
                rs!Endereco = txtendereco.Text
                rs!Valor = txtvalor.Text
                rs!Disponivel = cmbdisponivel.Text
                rs!TipoImovel = cmbimoveis.Text
                rs.Update
                trava "s"
                Exit Do
            End If
            rs.MoveNext
            Loop
            Data1.Refresh
            cmdlimpa_Click
End If
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
MsgBox op
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
txtdetalhe.Text = ""
txtquartos.Text = ""
txtdata.Text = ""
txtgaragens.Text = ""
txtobservacoes.Text = ""
txtproprietario.Text = ""
txtendereco.Text = ""
txtvalor.Text = ""
cmbdisponivel.Text = ""
cmbimoveis.Text = ""
trava "s"
End Sub
Private Sub cmdsair_Click()
rs.Close
db.Close
Set rs = Nothing
Set db = Nothing
Unload Me
End Sub
Private Sub MSFlexGrid1_Dblclick()
txtcodigo.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 0)
cmbimoveis.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 1)
cmbdisponivel.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 2)
txtvalor.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 3)
txtendereco.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 4)
txtproprietario.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 5)
txtquartos.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 6)
txtdetalhe.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 7)
txtdata.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 8)
txtgaragens.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 9)
txtobservacoes.Text = MSFlexGrid1.TextMatrix(MSFlexGrid1.Row, 10)
End Sub



Private Sub txtconsulta_Change()
Set rs = db.OpenRecordset("Select * from fornecedores where TipoImovel like '" & txtconsulta.Text & "*' order by TipoImovel")
Set Data1.Recordset = rs
Data1.Refresh
End Sub

Private Sub txtconsulta2_Change()
Set rs = db.OpenRecordset("Select * from fornecedores where Disponivel like '" & txtconsulta2.Text & "*' order by Disponivel")
Set Data1.Recordset = rs
Data1.Refresh
End Sub

