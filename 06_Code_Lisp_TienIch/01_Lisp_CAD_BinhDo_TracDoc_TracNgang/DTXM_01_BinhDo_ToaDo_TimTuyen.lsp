;; ============================================================================
;; FILE 01: DTXM_01_BinhDo_ToaDo_TimTuyen.lsp
;; BO LISP TRAC DIA - BINH DO - XUAT NHAP TOA DO VN2000 & LY TRINH TUYEN
;; Don vi: DTXM_GROUP - Ky su Xay dung Cau Duong
;; Cach dung: Go lenh APPLOAD trong AutoCAD -> Chon file .lsp nay
;; Danh sach lenh:
;;   1. TD1 (XuatToaDoPline) : Xuat toa do dinh Polyline (X, Y He Trac Dia) ra CSV
;;   2. TD2 (NhapToaDoCSV)   : Phun diem Mia / Coc tu file CSV (STT,X_Bac,Y_Dong,Z,Code)
;;   3. TD3 (DanhSoCoc)      : Danh so thu tu Coc va ke Bang Toa Do Coc ngay tren CAD
;;   4. TD4 (GhiLyTrinh)     : Click diem bat ky tren tim tuyen de ghi Ly trinh Km+...
;;   5. TD5 (NangCaoDoDongMuc): Gan cao do Z hang loat cho cac duong dong muc
;; ============================================================================

(vl-load-com)

;; ----------------------------------------------------------------------------
;; LENH 1: TD1 - XUAT TOA DO DINH POLYLINE RA FILE CSV (HE TRAC DIA X=BAC, Y=DONG)
;; ----------------------------------------------------------------------------
(defun c:TD1 (/ ent obj coords i n pt x_cad y_cad fn fp stt)
  (princ "\n[DTXM] Chon Polyline (Tim tuyen / Ranh GPMB) can xuat toa do: ")
  (if (and (setq ent (car (entsel "\nChon Polyline: ")))
           (wcmatch (cdr (assoc 0 (entget ent))) "*POLYLINE"))
    (progn
      (setq fn (getfiled "Luu file Toa do CSV (He Trac Dia VN2000)" "ToaDo_TimTuyen.csv" "csv" 1))
      (if fn
        (progn
          (setq fp (open fn "w"))
          (write-line "STT,TenDiem,X_HeTracDia_Bac(m),Y_HeTracDia_Dong(m),X_CAD,Y_CAD" fp)
          (setq obj (vlax-ename->vla-object ent))
          (setq coords (vlax-get obj 'Coordinates))
          (setq stt 1)
          (if (= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")
            (while coords
              (setq x_cad (car coords)
                    y_cad (cadr coords)
                    coords (cddr coords))
              ;; Luu y: Trong Trac dia VN-2000: X_TracDia = Y_CAD (Bac), Y_TracDia = X_CAD (Dong)
              (write-line (strcat (itoa stt) ",D" (itoa stt) "," (rtos y_cad 2 3) "," (rtos x_cad 2 3) "," (rtos x_cad 2 3) "," (rtos y_cad 2 3)) fp)
              (setq stt (1+ stt))
            )
            (while coords
              (setq x_cad (car coords)
                    y_cad (cadr coords)
                    coords (cdddr coords))
              (write-line (strcat (itoa stt) ",D" (itoa stt) "," (rtos y_cad 2 3) "," (rtos x_cad 2 3) "," (rtos x_cad 2 3) "," (rtos y_cad 2 3)) fp)
              (setq stt (1+ stt))
            )
          )
          (close fp)
          (princ (strcat "\n[DTXM] Da xuat thanh cong " (itoa (1- stt)) " dinh ra file: " fn))
        )
      )
    )
    (princ "\n[Loi] Doi tuong chon khong phai la Polyline!")
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; HAM TACH CHUOI CSV THEO DAU PHAY HOAC TAB
;; ----------------------------------------------------------------------------
(defun DTXM:SplitString (str delim / pos lst)
  (while (setq pos (vl-string-search delim str))
    (setq lst (cons (substr str 1 pos) lst)
          str (substr str (+ pos 1 (strlen delim))))
  )
  (reverse (cons str lst))
)

;; ----------------------------------------------------------------------------
;; LENH 2: TD2 - PHUN DIEM KHAO SAT TU FILE CSV LEN BINH DO CAD
;; Dinh dang dong CSV: STT,X_Bac,Y_Dong,Z_CaoDo,MaGhiChu
;; ----------------------------------------------------------------------------
(defun c:TD2 (/ fn fp line items stt x_td y_td z_td code pt h_txt count)
  (setq fn (getfiled "Chon file CSV so lieu Toa do (STT,X_Bac,Y_Dong,Z,GhiChu)" "" "csv;txt" 0))
  (if fn
    (progn
      (setq h_txt (getreal "\nNhap chieu cao chu cao do tren binh do <1.5>: "))
      (if (null h_txt) (setq h_txt 1.5))
      (setq fp (open fn "r")
            count 0)
      (while (setq line (read-line fp))
        (setq items (DTXM:SplitString line ","))
        (if (and (>= (length items) 4)
                 (numberp (read (nth 1 items)))
                 (numberp (read (nth 2 items))))
          (progn
            (setq stt  (nth 0 items)
                  x_td (atof (nth 1 items)) ;; X Trac dia = Y trong CAD
                  y_td (atof (nth 2 items)) ;; Y Trac dia = X trong CAD
                  z_td (atof (nth 3 items))
                  code (if (>= (length items) 5) (nth 4 items) "")
                  pt   (list y_td x_td z_td))
            ;; Tao Point 3D
            (entmakex (list (cons 0 "POINT") (cons 8 "04_DIAHINH_HIENTRANG") (cons 10 pt)))
            ;; Tao Text Cao do Z
            (entmakex (list (cons 0 "TEXT")
                            (cons 8 "04_DIAHINH_HIENTRANG")
                            (cons 10 (list (+ y_td (* 0.3 h_txt)) (- x_td (* 0.4 h_txt)) z_td))
                            (cons 40 h_txt)
                            (cons 1 (rtos z_td 2 2))
                            (cons 62 8)))
            (setq count (1+ count))
          )
        )
      )
      (close fp)
      (princ (strcat "\n[DTXM] Da phun thanh cong " (itoa count) " diem mia 3D len binh do!"))
    )
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 3: TD3 - PICK DIEM DANH SO COC VA LAP BANG TOA DO COC TRUC TIEP TREN CAD
;; ----------------------------------------------------------------------------
(defun c:TD3 (/ prefix stt h_txt pt pt_table row_h x_cad y_cad str_coc)
  (setq prefix (getstring "\nNhap tien to ten coc (VD: C, H, GPMB) <C>: "))
  (if (= prefix "") (setq prefix "C"))
  (setq stt (getint "\nNhap so thu tu coc bat dau <1>: "))
  (if (null stt) (setq stt 1))
  (setq h_txt (getreal "\nNhap chieu cao chu <2.0>: "))
  (if (null h_txt) (setq h_txt 2.0))
  (setq pt_table (getpoint "\nChon diem dat goc tren ben trai cua BANG TOA DO COC: "))
  (if pt_table
    (progn
      (setq row_h (* h_txt 2.2))
      ;; Ghi tieu de bang
      (entmakex (list (cons 0 "TEXT") (cons 8 "01_TEXT_TIEUDE") (cons 10 pt_table) (cons 40 (* h_txt 1.2))
                      (cons 1 "TEN COC          X (HE TRAC DIA)          Y (HE TRAC DIA)")))
      (while (setq pt (getpoint (strcat "\nPick vi tri coc " prefix (itoa stt) " (Enter de ket thuc): ")))
        (setq x_cad (car pt)
              y_cad (cadr pt)
              str_coc (strcat prefix (itoa stt)))
        ;; Ve vong tron ky hieu coc va ten coc
        (entmakex (list (cons 0 "CIRCLE") (cons 8 "03_TIM_TUYEN_TRUC") (cons 10 pt) (cons 40 (* h_txt 0.6)) (cons 62 1)))
        (entmakex (list (cons 0 "TEXT") (cons 8 "01_TEXT_TIEUDE")
                        (cons 10 (list (+ x_cad (* h_txt 0.8)) (+ y_cad (* h_txt 0.8)) 0.0))
                        (cons 40 h_txt) (cons 1 str_coc) (cons 62 2)))
        ;; Ghi dong vao bang toa do
        (setq pt_table (list (car pt_table) (- (cadr pt_table) row_h) 0.0))
        (entmakex (list (cons 0 "TEXT") (cons 8 "01_TEXT_GHICHU") (cons 10 pt_table) (cons 40 h_txt)
                        (cons 1 (strcat str_coc "               " (rtos y_cad 2 3) "               " (rtos x_cad 2 3)))))
        (setq stt (1+ stt))
      )
    )
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 4: TD4 - GHI LY TRINH KM+... TREN TIM TUYEN POLYLINE
;; ----------------------------------------------------------------------------
(defun c:TD4 (/ ent obj km0 pt pt_close dist total_m km m_le str_lt h_txt)
  (princ "\n[DTXM] Chon Polyline Tim tuyen de do ghi Ly trinh: ")
  (if (and (setq ent (car (entsel "\nChon Tim tuyen: ")))
           (wcmatch (cdr (assoc 0 (entget ent))) "*POLYLINE"))
    (progn
      (setq obj (vlax-ename->vla-object ent))
      (setq km0 (getreal "\nNhap ly trinh diem dau tuyen (m) <0.0>: "))
      (if (null km0) (setq km0 0.0))
      (setq h_txt (getreal "\nNhap chieu cao chu Ly trinh <2.0>: "))
      (if (null h_txt) (setq h_txt 2.0))
      (while (setq pt (getpoint "\nPick diem tren tuyen can ghi Ly trinh (Enter de thoat): "))
        (setq pt_close (vlax-curve-getClosestPointTo obj pt)
              dist     (vlax-curve-getDistAtPoint obj pt_close)
              total_m  (+ km0 dist)
              km       (fix (/ total_m 1000.0))
              m_le     (- total_m (* km 1000.0))
              str_lt   (strcat "Km" (itoa km) "+" (if (< m_le 100.0) (if (< m_le 10.0) "00" "0") "") (rtos m_le 2 2)))
        (entmakex (list (cons 0 "TEXT") (cons 8 "01_TEXT_TIEUDE") (cons 10 pt_close) (cons 40 h_txt) (cons 1 str_lt) (cons 62 4)))
        (princ (strcat "\n -> Ly trinh tai diem chon: " str_lt))
      )
    )
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 5: TD5 - NANG CAO DO DUONG DONG MUC LIEN TUC THEO BUOC CHENH CAO
;; ----------------------------------------------------------------------------
(defun c:TD5 (/ z_start dz ent obj)
  (setq z_start (getreal "\nNhap cao do Z cua duong dong muc dau tien (m) <10.0>: "))
  (if (null z_start) (setq z_start 10.0))
  (setq dz (getreal "\nNhap buoc chenh cao giua 2 duong dong muc (m) (nhap am neu giam dan) <1.0>: "))
  (if (null dz) (setq dz 1.0))
  (while (setq ent (car (entsel (strcat "\nChon duong dong muc gan Z = " (rtos z_start 2 2) "m (Enter de dung): "))))
    (setq obj (vlax-ename->vla-object ent))
    (if (vlax-property-available-p obj 'Elevation)
      (progn
        (vla-put-Elevation obj z_start)
        (vla-put-Color obj 8)
        (princ (strcat " -> Da gan Z = " (rtos z_start 2 2) "m"))
        (setq z_start (+ z_start dz))
      )
      (princ "\nDoi tuong khong ho tro thuoc tinh Elevation!")
    )
  )
  (princ)
)

(princ "\n==================================================================")
(princ "\n[DTXM_GROUP] Da tai Bo Lisp Binh Do & Toa Do: TD1, TD2, TD3, TD4, TD5")
(princ "\n==================================================================")
(princ)
