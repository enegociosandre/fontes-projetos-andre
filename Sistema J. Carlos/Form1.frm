VERSION 5.00
Object = "{0D452EE1-E08F-101A-852E-02608C4D0BB4}#2.0#0"; "FM20.DLL"
Begin VB.Form Form1 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Sistema Imobiliárias"
   ClientHeight    =   5790
   ClientLeft      =   165
   ClientTop       =   270
   ClientWidth     =   7155
   LinkTopic       =   "Form1"
   ScaleHeight     =   5790
   ScaleWidth      =   7155
   StartUpPosition =   1  'CenterOwner
   WindowState     =   2  'Maximized
   Begin VB.Timer Timer1 
      Interval        =   500
      Left            =   6720
      Top             =   2520
   End
   Begin VB.Image Image1 
      Height          =   2940
      Left            =   3120
      Picture         =   "Form1.frx":0000
      Top             =   3960
      Width           =   6000
   End
   Begin MSForms.CommandButton CommandButton2 
      Height          =   1455
      Left            =   6120
      TabIndex        =   3
      Top             =   240
      Width           =   2055
      Caption         =   "Imóveis"
      Size            =   "3625;2566"
      Picture         =   "Form1.frx":39702
      FontHeight      =   165
      FontCharSet     =   0
      FontPitchAndFamily=   2
      ParagraphAlign  =   3
   End
   Begin MSForms.CommandButton CommandButton1 
      DragIcon        =   "Form1.frx":39C94
      Height          =   1455
      Left            =   3960
      TabIndex        =   2
      Top             =   240
      Width           =   2055
      Caption         =   "Clientes"
      Size            =   "3625;2566"
      Picture         =   "Form1.frx":3A0D6
      FontHeight      =   165
      FontCharSet     =   0
      FontPitchAndFamily=   2
      ParagraphAlign  =   3
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Imóveis e Clientes"
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
      Left            =   5040
      TabIndex        =   1
      Top             =   3240
      Width           =   1920
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Sistema Imobiliário"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   20.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      Height          =   480
      Left            =   4200
      TabIndex        =   0
      Top             =   2280
      Width           =   3900
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False



Private Sub CommandButton1_Click()
frmcadcli.Show
End Sub
Private Sub CommandButton2_Click()
frmcadfor.Show
End Sub

Private Sub Form_Load()
    hora = Time
    data = Date
 
End Sub




Private Sub mnuCli_Click()
frmcadcli.Show
End Sub


Private Sub mnufor_Click()
frmcadfor.Show
End Sub

