;; ============================================================================
;; FILE 02: DTXM_02_TracDoc_TracNgang_Taluy.lsp
;; BO LISP TRAC DOC - TRAC NGANG - DO DOC - CAO TRINH - RAI TALUY DAO DAP
;; Don vi: DTXM_GROUP - Ky su Xay dung Cau Duong
;; Danh sach lenh:
;;   1. TN1 (NoiSuyCaoDo) : Noi suy cao do Z tren Trac doc / Trac ngang tu 1 diem goc
;;   2. TN2 (GhiDoDoc)    : Tinh va ghi % do doc (i%) hoac do doc 1:m giua 2 diem
;;   3. TN3 (RaiTaluy)    : Rai ky hieu chan taluy (vach ngan - dai xen ke) doc 2 Polyline
;;   4. TN4 (CongDienTich): Cong tong dien tich cac vung Hatch / Polyline (Dao, Dap, KCAD)
;;   5. TN5 (CongChieuDai): Cong tong chieu dai cac Line/Pline/Arc/Spline (Cong, Ranh, Cap)
;; ============================================================================

(vl-load-com)

;; ----------------------------------------------------------------------------
;; LENH 1: TN1 - NOI SUY VA GHI CAO TRINH TREN TRAC DOC / TRAC NGANG
;; ----------------------------------------------------------------------------
(defun c:TN1 (/ pt0 z0 ky pt z_calc h_txt str_z)
  (setq pt0 (getpoint "\nPick diem goc da biet cao do tren Trac doc / Trac ngang: "))
  (if pt0
    (progn
      (setq z0 (getreal "\nNhap cao do thuc te tai diem goc (m) <0.00>: "))
      (if (null z0) (setq z0 0.0))
      (setq ky (getreal "\nNhap he so phong ty le dung (VD: Trac ngang 1:1 nhap 1; Trac doc 1/1000-1/100 nhap 10) <1.0>: "))
      (if (null ky) (setq ky 1.0))
      (setq h_txt (getreal "\nNhap chieu cao chu cao trinh <1.8>: "))
      (if (null h_txt) (setq h_txt 1.8))
      (while (setq pt (getpoint "\nPick diem can ghi cao trinh (Enter de ket thuc): "))
        (setq z_calc (+ z0 (/ (- (cadr pt) (cadr pt0)) ky))
              str_z  (strcat (if (>= z_calc 0.0) "+" "") (rtos z_calc 2 2)))
        ;; Ve tam giac ky hieu cao trinh
        (entmakex (list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity") (cons 8 "02_DIM_KICHTHUOC")
                        (cons 100 "AcDbPolyline") (cons 90 3) (cons 70 1)
                        (cons 10 pt)
                        (cons 10 (list (- (car pt) (* h_txt 0.5)) (+ (cadr pt) (* h_txt 0.8))))
                        (cons 10 (list (+ (car pt) (* h_txt 0.5)) (+ (cadr pt) (* h_txt 0.8))))))
        (entmakex (list (cons 0 "TEXT") (cons 8 "01_TEXT_TIEUDE")
                        (cons 10 (list (- (car pt) (* h_txt 0.8)) (+ (cadr pt) (* h_txt 1.1)) 0.0))
                        (cons 40 h_txt) (cons 1 str_z) (cons 62 4)))
        (princ (strcat "\n -> Cao trinh = " str_z))
      )
    )
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 2: TN2 - GHI DO DOC % (VD: i = 2.0%) HOAC DO DOC MAI TALUY (1 : 1.50)
;; ----------------------------------------------------------------------------
(defun c:TN2 (/ p1 p2 dx dy mode h_txt mid_pt ang str_slope)
  (setq p1 (getpoint "\nChon diem dau doan doc: "))
  (setq p2 (getpoint p1 "\nChon diem cuoi doan doc: "))
  (if (and p1 p2)
    (progn
      (setq dx (abs (- (car p2) (car p1)))
            dy (abs (- (cadr p2) (cadr p1))))
      (initget "PhanTram Taluy")
      (setq mode (getkword "\nChon kieu ghi do doc [PhanTram/Taluy] <PhanTram>: "))
      (if (null mode) (setq mode "PhanTram"))
      (setq h_txt (getreal "\nNhap chieu cao chu <1.8>: "))
      (if (null h_txt) (setq h_txt 1.8))
      (if (> dx 0.0001)
        (progn
          (if (= mode "PhanTram")
            (setq str_slope (strcat "i=" (rtos (* (/ dy dx) 100.0) 2 2) "%"))
            (setq str_slope (strcat "1:" (rtos (/ dx dy) 2 2)))
          )
          (setq mid_pt (list (/ (+ (car p1) (car p2)) 2.0) (+ (/ (+ (cadr p1) (cadr p2)) 2.0) (* h_txt 0.5)) 0.0)
                ang    (angle p1 p2))
          (if (and (> ang (* 0.5 pi)) (<= ang (* 1.5 pi)))
            (setq ang (+ ang pi))
          )
          (entmakex (list (cons 0 "TEXT") (cons 8 "01_TEXT_GHICHU")
                          (cons 10 mid_pt) (cons 40 h_txt) (cons 50 ang) (cons 1 str_slope) (cons 62 2)))
          (princ (strcat "\n -> Da ghi do doc: " str_slope))
        )
        (princ "\nHai diem trung phuong dung (dx = 0)!")
      )
    )
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 3: TN3 - RAI KY HIEU TALUY DAO / DAP GIUA 2 DUONG POLYLINE (DINH & CHAN)
;; ----------------------------------------------------------------------------
(defun c:TN3 (/ ent_top ent_bot obj_top obj_bot step len cur_d pt_top pt_bot pt_mid is_long)
  (princ "\n[DTXM] Rai vach Taluy giua duong DINH taluy va duong CHAN taluy:")
  (setq ent_top (car (entsel "\nChon Polyline DINH taluy (Mep vai duong): ")))
  (setq ent_bot (car (entsel "\nChon Polyline CHAN taluy: ")))
  (if (and ent_top ent_bot)
    (progn
      (setq step (getreal "\nNhap buoc rai vach taluy (m) <2.0>: "))
      (if (null step) (setq step 2.0))
      (setq obj_top (vlax-ename->vla-object ent_top)
            obj_bot (vlax-ename->vla-object ent_bot)
            len     (vlax-curve-getDistAtParam obj_top (vlax-curve-getEndParam obj_top))
            cur_d   0.0
            is_long T)
      (while (<= cur_d len)
        (setq pt_top (vlax-curve-getPointAtDist obj_top cur_d)
              pt_bot (vlax-curve-getClosestPointTo obj_bot pt_top))
        (if is_long
          ;; Vach dai noi tu dinh xuong chan taluy
          (entmakex (list (cons 0 "LINE") (cons 8 "04_DIAHINH_HIENTRANG") (cons 10 pt_top) (cons 11 pt_bot) (cons 62 8)))
          ;; Vach ngan = 50% chieu dai tu dinh xuong chan
          (progn
            (setq pt_mid (list (/ (+ (car pt_top) (car pt_bot)) 2.0)
                               (/ (+ (cadr pt_top) (cadr pt_bot)) 2.0)
                               0.0))
            (entmakex (list (cons 0 "LINE") (cons 8 "04_DIAHINH_HIENTRANG") (cons 10 pt_top) (cons 11 pt_mid) (cons 62 8)))
          )
        )
        (setq cur_d   (+ cur_d step)
              is_long (not is_long))
      )
      (princ "\n[DTXM] Da rai xong ky hieu mai Taluy!")
    )
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 4: TN4 - CONG TONG DIEN TICH CAC HATCH / POLYLINE KHEP KIN VA GHI RA TEXT
;; ----------------------------------------------------------------------------
(defun c:TN4 (/ ss i ent obj total_area hs ent_txt elst)
  (princ "\n[DTXM] Quet chon cac vung Hatch hoac Polyline khep kin can cong Dien tich: ")
  (if (setq ss (ssget '((0 . "HATCH,LWPOLYLINE,POLYLINE,CIRCLE,REGION"))))
    (progn
      (setq hs (getreal "\nNhap he so nhan ty le dien tich (neu ve 1:1 nhap 1.0) <1.0>: "))
      (if (null hs) (setq hs 1.0))
      (setq total_area 0.0
            i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i)
              obj (vlax-ename->vla-object ent))
        (if (vlax-property-available-p obj 'Area)
          (setq total_area (+ total_area (* (vla-get-Area obj) hs)))
        )
        (setq i (1+ i))
      )
      (princ (strcat "\n=============================================="))
      (princ (strcat "\n -> TONG DIEN TICH (" (itoa (sslength ss)) " doi tuong) = " (rtos total_area 2 2) " m2"))
      (princ (strcat "\n=============================================="))
      (if (setq ent_txt (car (entsel "\nChon Text co san tren ban ve de ghi de ket qua (Enter de bo qua): ")))
        (progn
          (setq elst (entget ent_txt))
          (setq elst (subst (cons 1 (rtos total_area 2 2)) (assoc 1 elst) elst))
          (entmod elst)
          (princ "\n -> Da cap nhat gia tri dien tich vao Text!")
        )
      )
    )
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 5: TN5 - CONG TONG CHIEU DAI CAC DOAN TUYEN / CONG / RANH / CAP DUL
;; ----------------------------------------------------------------------------
(defun c:TN5 (/ ss i ent obj total_len hs ent_txt elst)
  (princ "\n[DTXM] Quet chon cac Line, Polyline, Arc, Spline can tinh Tong chieu dai: ")
  (if (setq ss (ssget '((0 . "LINE,LWPOLYLINE,POLYLINE,ARC,SPLINE"))))
    (progn
      (setq hs (getreal "\nNhap he so nhan ty le chieu dai (neu don vi m nhap 1.0; neu mm doi ra m nhap 0.001) <1.0>: "))
      (if (null hs) (setq hs 1.0))
      (setq total_len 0.0
            i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i)
              obj (vlax-ename->vla-object ent))
        (setq total_len (+ total_len (* (vlax-curve-getDistAtParam obj (vlax-curve-getEndParam obj)) hs)))
        (setq i (1+ i))
      )
      (princ (strcat "\n=============================================="))
      (princ (strcat "\n -> TONG CHIEU DAI (" (itoa (sslength ss)) " doi tuong) = " (rtos total_len 2 2) " m"))
      (princ (strcat "\n=============================================="))
      (if (setq ent_txt (car (entsel "\nChon Text co san tren ban ve de ghi de ket qua (Enter de bo qua): ")))
        (progn
          (setq elst (entget ent_txt))
          (setq elst (subst (cons 1 (rtos total_len 2 2)) (assoc 1 elst) elst))
          (entmod elst)
          (princ "\n -> Da cap nhat gia tri chieu dai vao Text!")
        )
      )
    )
  )
  (princ)
)

(princ "\n=====================================================================")
(princ "\n[DTXM_GROUP] Da tai Bo Lisp Trac Doc & Trac Ngang: TN1, TN2, TN3, TN4, TN5")
(princ "\n=====================================================================")
(princ)
