;; ============================================================================
;; FILE 03: DTXM_03_KetCau_CotThep_TienIchInAn.lsp
;; BO LISP THONG KE COT THEP - TIEN ICH TEXT/NUMBER - DONG BO LAYER CAU DUONG
;; Don vi: DTXM_GROUP - Ky su Xay dung Cau Duong
;; Danh sach lenh:
;;   1. KC1 (ThemDongThep) : Nhap nhanh 1 thanh cot thep va tu dong tinh Khoi luong (kg)
;;   2. KC2 (CongTextSo)   : Quet chon hang loat Text chua con so de tinh Tong / Trung binh
;;   3. KC3 (TangSoThuTu)  : Copy Text va tu dong tang so thu tu (1, 2, 3... hoac T1, T2...)
;;   4. KC4 (TaoLayerDTXM) : Tu dong khoi tao 17 Layer chuan nganh Cau Duong ngay trong CAD
;;   5. KC5 (DonRacBanVe)  : Don sach ban ve (Purge All + Audit + Xoa doi tuong trung)
;; ============================================================================

(vl-load-com)

;; ----------------------------------------------------------------------------
;; LENH 1: KC1 - NHAP VA TINH DONG THONG KE COT THEP TRUC TIEP TREN CAD
;; Cong thuc: g_1m (kg/m) = d^2 / 162.16 (theo TCVN 1651:2018)
;; ----------------------------------------------------------------------------
(defun c:KC1 (/ pt h_txt sh_thep d_mm l_1thanh so_thanhso_ck tong_sl tong_dai tl_rieng tong_kl row_str)
  (setq pt (getpoint "\nChon diem dat dong Thong ke cot thep tren ban ve: "))
  (if pt
    (progn
      (setq h_txt (getreal "\nNhap chieu cao chu bang thep <2.2>: "))
      (if (null h_txt) (setq h_txt 2.2))
      (while (/= (setq sh_thep (getstring "\nNhap So hieu thanh thep (VD: 1, 2a, D1... Enter de dung): ")) "")
        (setq d_mm      (getreal "\n  + Duong kinh cot thep d (mm) (VD: 10, 12, 16, 20, 25, 32): ")
              l_1thanh  (getreal "\n  + Chieu dai 1 thanh L (m) (VD: 11.70): ")
              so_thanh  (getint  "\n  + So thanh trong 1 cau kien: ")
              so_ck     (getint  "\n  + So luong cau kien <1>: "))
        (if (null so_ck) (setq so_ck 1))
        (setq tong_sl  (* so_thanh so_ck)
              tong_dai (* tong_sl l_1thanh)
              tl_rieng (/ (* d_mm d_mm) 162.162)
              tong_kl  (* tong_dai tl_rieng))
        (setq row_str (strcat "Thanh [" sh_thep "]   |   Phi " (rtos d_mm 2 0) "mm   |   L = "
                              (rtos l_1thanh 2 2) "m   |   SL = " (itoa tong_sl) " thanh   |   Tong dai = "
                              (rtos tong_dai 2 2) "m   |   g = " (rtos tl_rieng 2 3) " kg/m   |   KL = "
                              (rtos tong_kl 2 2) " kg"))
        (entmakex (list (cons 0 "TEXT") (cons 8 "01_TEXT_GHICHU") (cons 10 pt) (cons 40 h_txt) (cons 1 row_str) (cons 62 2)))
        (setq pt (list (car pt) (- (cadr pt) (* h_txt 2.0)) 0.0))
        (princ (strcat "\n -> " row_str))
      )
    )
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 2: KC2 - QUET CHON CAC TEXT SO DE CONG TONG VA GHI KET QUA
;; ----------------------------------------------------------------------------
(defun c:KC2 (/ ss i ent str val sum_val cnt ent_out elst)
  (princ "\n[DTXM] Quet chon cac Text / MText chua gia tri so can cong tong: ")
  (if (setq ss (ssget '((0 . "TEXT,MTEXT"))))
    (progn
      (setq sum_val 0.0
            cnt     0
            i       0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i)
              str (cdr (assoc 1 (entget ent)))
              ;; Thay dau phay bang dau cham neu co
              str (vl-string-translate "," "." str)
              val (distof str))
        (if val
          (setq sum_val (+ sum_val val)
                cnt     (1+ cnt))
        )
        (setq i (1+ i))
      )
      (princ (strcat "\n=============================================="))
      (princ (strcat "\n -> So luong Text hop le : " (itoa cnt)))
      (princ (strcat "\n -> TONG CONG            : " (rtos sum_val 2 2)))
      (if (> cnt 0)
        (princ (strcat "\n -> TRUNG BINH CONG      : " (rtos (/ sum_val cnt) 2 2)))
      )
      (princ (strcat "\n=============================================="))
      (if (setq ent_out (car (entsel "\nChon Text dich de ghi Tong cong (Enter de bo qua): ")))
        (progn
          (setq elst (entget ent_out)
                elst (subst (cons 1 (rtos sum_val 2 2)) (assoc 1 elst) elst))
          (entmod elst)
          (princ "\n -> Da ghi ket qua Tong cong vao Text dich!")
        )
      )
    )
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 3: KC3 - COPY TEXT VA TU DONG TANG SO THU TU (DANH SO THANH THEP / COC / TRU)
;; ----------------------------------------------------------------------------
(defun c:KC3 (/ prefix num step pt h_txt str_out)
  (setq prefix (getstring "\nNhap tien to (VD: Nhip N, Tru T, Coc C, hoac de trong neu chi danh so 1,2,3): "))
  (setq num (getint "\nNhap so bat dau <1>: "))
  (if (null num) (setq num 1))
  (setq step (getint "\nNhap buoc tang <1>: "))
  (if (null step) (setq step 1))
  (setq h_txt (getreal "\nNhap chieu cao chu <2.5>: "))
  (if (null h_txt) (setq h_txt 2.5))
  (while (setq pt (getpoint (strcat "\nPick diem dat [" prefix (itoa num) "] (Enter de dung): ")))
    (setq str_out (strcat prefix (itoa num)))
    (entmakex (list (cons 0 "TEXT") (cons 8 "01_TEXT_TIEUDE") (cons 10 pt) (cons 40 h_txt) (cons 1 str_out) (cons 62 4)))
    (setq num (+ num step))
  )
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 4: KC4 - TU DONG KHOI TAO 17 LAYER CHUAN CAU DUONG DTXM_GROUP
;; ----------------------------------------------------------------------------
(defun DTXM:MakeLayer (name color lweight)
  (if (null (tblsearch "LAYER" name))
    (entmakex (list (cons 0 "LAYER")
                    (cons 100 "AcDbSymbolTableRecord")
                    (cons 100 "AcDbLayerTableRecord")
                    (cons 2 name)
                    (cons 70 0)
                    (cons 62 color)
                    (cons 6 "Continuous")
                    (cons 370 lweight)))
  )
)

(defun c:KC4 ()
  (DTXM:MakeLayer "00_KHUNGTEN_VIEN"      7   50)
  (DTXM:MakeLayer "00_KHUNGTEN_MANH"      8   18)
  (DTXM:MakeLayer "01_TEXT_TIEUDE"        4   35)
  (DTXM:MakeLayer "01_TEXT_GHICHU"        2   20)
  (DTXM:MakeLayer "02_DIM_KICHTHUOC"      3   15)
  (DTXM:MakeLayer "03_TIM_TUYEN_TRUC"     1   15)
  (DTXM:MakeLayer "04_DIAHINH_HIENTRANG"  8   13)
  (DTXM:MakeLayer "04_DIAHINH_RANHGIOI"   252 15)
  (DTXM:MakeLayer "05_DUONG_TK_MATCAT"    1   35)
  (DTXM:MakeLayer "05_DUONG_TK_KCAD"      3   20)
  (DTXM:MakeLayer "06_KC_BETONG_CAT"      4   40)
  (DTXM:MakeLayer "06_KC_BETONG_THAY"     2   22)
  (DTXM:MakeLayer "06_KC_NETKHUAT"        6   15)
  (DTXM:MakeLayer "07_COTTHEP_CHU"        5   45)
  (DTXM:MakeLayer "07_COTTHEP_DAI"        1   30)
  (DTXM:MakeLayer "08_HATCH_VATLIEU"      253 9)
  (DTXM:MakeLayer "09_ATGT_BIENBAO_SON"   30  25)
  (princ "\n[DTXM] Da tao xong 17 Layer chuan nganh Cau Duong!")
  (princ)
)

;; ----------------------------------------------------------------------------
;; LENH 5: KC5 - DON RAC BAN VE NHANH (PURGE ALL + AUDIT)
;; ----------------------------------------------------------------------------
(defun c:KC5 ()
  (setvar "CMDECHO" 0)
  (command "._-PURGE" "All" "*" "No")
  (command "._-PURGE" "Regapps" "*" "No")
  (command "._AUDIT" "Yes")
  (setvar "CMDECHO" 1)
  (princ "\n[DTXM] Da don sach rac ban ve (Purge All + Regapps + Audit)!")
  (princ)
)

(princ "\n=========================================================================")
(princ "\n[DTXM_GROUP] Da tai Bo Lisp Ket Cau & Tien Ich: KC1, KC2, KC3, KC4, KC5")
(princ "\n=========================================================================")
(princ)
