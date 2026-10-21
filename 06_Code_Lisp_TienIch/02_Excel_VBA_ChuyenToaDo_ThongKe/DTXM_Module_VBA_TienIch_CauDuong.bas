Attribute VB_Name = "DTXM_VBA_CauDuong"
' =============================================================================
' MODULE VBA TIEN ICH KY SU CAU DUONG - DTXM_GROUP
' Cach nhap vao Excel:
'   1. Nhan Alt + F11 trong Excel de mo cua so Visual Basic Editor (VBE)
'   2. Chon File -> Import File... -> Chon file DTXM_Module_VBA_TienIch_CauDuong.bas
'   3. Su dung cac ham tren bang tinh Excel hoac chay Macro (Alt + F8)
' Danh sach Tinh nang:
'   - Ham =VND(SoTien)        : Doc so tien bang chu Tieng Viet (phuc vu Du toan/Hop dong)
'   - Ham =RadToDMS(GocDo)    : Doi goc thap phan sang Do - Phut - Giay (VD: 32° 15' 40")
'   - Macro XuatScriptCAD()   : Xuat vung lenh AutoCAD da chon ra file .scr de chay trong CAD
' =============================================================================

Option Explicit

' -----------------------------------------------------------------------------
' 1. HAM DOC SO TIEN BANG CHU TIENG VIET: =VND(SoTien)
' -----------------------------------------------------------------------------
Public Function VND(ByVal SoTien As Double) As String
    Dim ChuSo As Variant
    Dim DonVi As Variant
    Dim StrSo As String, KetQua As String
    Dim i As Integer, Nhom As Integer, SoNhom As Integer
    Dim Tram As Integer, Chuc As Integer, Dvi As Integer
    
    If SoTien = 0 Then
        VND = "Không đồng."
        Exit Function
    End If
    
    ChuSo = Array("không", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín")
    DonVi = Array("", "nghìn", "triệu", "tỷ", "nghìn tỷ", "triệu tỷ")
    
    SoTien = Round(Abs(SoTien), 0)
    StrSo = Format(SoTien, "0")
    
    Do While Len(StrSo) Mod 3 <> 0
        StrSo = "0" & StrSo
    Loop
    
    SoNhom = Len(StrSo) \ 3
    KetQua = ""
    
    For i = 1 To SoNhom
        Tram = Val(Mid(StrSo, (i - 1) * 3 + 1, 1))
        Chuc = Val(Mid(StrSo, (i - 1) * 3 + 2, 1))
        Dvi = Val(Mid(StrSo, (i - 1) * 3 + 3, 1))
        
        If Tram > 0 Or Chuc > 0 Or Dvi > 0 Then
            If i > 1 Or Tram > 0 Then
                KetQua = KetQua & " " & ChuSo(Tram) & " trăm"
            End If
            
            If Chuc > 1 Then
                KetQua = KetQua & " " & ChuSo(Chuc) & " mươi"
                If Dvi = 1 Then
                    KetQua = KetQua & " mốt"
                ElseIf Dvi = 5 Then
                    KetQua = KetQua & " lăm"
                ElseIf Dvi > 0 Then
                    KetQua = KetQua & " " & ChuSo(Dvi)
                End If
            ElseIf Chuc = 1 Then
                KetQua = KetQua & " mười"
                If Dvi = 5 Then
                    KetQua = KetQua & " lăm"
                ElseIf Dvi > 0 Then
                    KetQua = KetQua & " " & ChuSo(Dvi)
                End If
            ElseIf Chuc = 0 And Dvi > 0 Then
                If i > 1 Or Tram > 0 Then
                    KetQua = KetQua & " linh " & ChuSo(Dvi)
                Else
                    KetQua = KetQua & " " & ChuSo(Dvi)
                End If
            End If
            
            Nhom = SoNhom - i
            If Nhom > 0 Then
                KetQua = KetQua & " " & DonVi(Nhom)
            End If
        End If
    Next i
    
    KetQua = Trim(KetQua)
    KetQua = UCase(Left(KetQua, 1)) & Mid(KetQua, 2) & " đồng chẵn."
    VND = KetQua
End Function

' -----------------------------------------------------------------------------
' 2. HAM DOI GOC THAP PHAN SANG DO - PHUT - GIAY: =DegToDMS(32.5125)
' -----------------------------------------------------------------------------
Public Function DegToDMS(ByVal DegVal As Double) As String
    Dim d As Long, m As Long, s As Double
    Dim signStr As String
    If DegVal < 0 Then signStr = "-" Else signStr = ""
    DegVal = Abs(DegVal)
    d = Int(DegVal)
    m = Int((DegVal - d) * 60)
    s = Round(((DegVal - d) * 60 - m) * 60, 1)
    If s >= 60 Then
        s = 0
        m = m + 1
    End If
    If m >= 60 Then
        m = 0
        d = d + 1
    End If
    DegToDMS = signStr & d & "° " & Format(m, "00") & "' " & Format(s, "00.0") & """"
End Function

' -----------------------------------------------------------------------------
' 3. MACRO XUAT VUNG O DANG CHON RA FILE SCRIPT AUTOCAD (.SCR)
' -----------------------------------------------------------------------------
Public Sub XuatScriptCAD()
    Dim rng As Range, cell As Range
    Dim filePath As Variant
    Dim fileNum As Integer
    
    If TypeName(Selection) <> "Range" Then
        MsgBox "Vui long quet chon cot chua lenh AutoCAD truoc khi chay Macro!", vbExclamation, "DTXM_GROUP"
        Exit Sub
    End If
    
    filePath = Application.GetSaveAsFilename(InitialFileName:="VeTuyen_ToaDo.scr", _
               FileFilter:="AutoCAD Script (*.scr), *.scr", Title:="Luu file Script AutoCAD")
    If filePath = False Then Exit Sub
    
    fileNum = FreeFile
    Open filePath For Output As #fileNum
    For Each cell In Selection.Cells
        If Trim(cell.Text) <> "" Then
            Print #fileNum, cell.Text
        End If
    Next cell
    Close #fileNum
    
    MsgBox "Da xuat thanh cong file Script AutoCAD tai:" & vbCrLf & filePath, vbInformation, "DTXM_GROUP"
End Sub
