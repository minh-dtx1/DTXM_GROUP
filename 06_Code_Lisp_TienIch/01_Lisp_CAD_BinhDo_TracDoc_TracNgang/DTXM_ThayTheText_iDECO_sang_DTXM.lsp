;;; ==========================================================================
;;; DTXM - LENH AUTO-LISP THAY THE TEXT "iDECO, IDECO, ideco" THANH "DTXM"
;;; Lenh: DTXM-REP hoac REP-IDECO
;;; Pham vi: ModelSpace, PaperSpace, Text, MText, Block Attribute, Dimension, Leader
;;; Tac gia: Nhom Ky thuat DTXM
;;; Ngay tao: 27/10/2026
;;; ==========================================================================

(vl-load-com)

(defun c:DTXM-REP () (c:REP-IDECO))

(defun c:REP-IDECO ( / *error* acad doc spc cnt-txt cnt-att cnt-dim cnt-blk
                       str-rep-all fn-replace-str)
  
  (defun *error* (msg)
    (vla-EndUndoMark doc)
    (if (and msg (not (wcmatch (strcase msg t) "*cancel*,*exit*,*quit*")))
      (princ (strcat "\n[Loi] " msg))
    )
    (princ)
  )

  (setq acad (vlax-get-acad-object)
        doc  (vla-get-ActiveDocument acad)
        cnt-txt 0
        cnt-att 0
        cnt-dim 0
        cnt-blk 0
  )

  ;; Ham thay the chuoi khong phan biet hoa thuong
  (defun fn-replace-str (target-str / reg matches)
    (if (and target-str (/= target-str ""))
      (progn
        (setq reg (vlax-create-object "VBScript.RegExp"))
        (vlax-put-property reg "IgnoreCase" :vlax-true)
        (vlax-put-property reg "Global" :vlax-true)
        (vlax-put-property reg "Pattern" "iDECO|IDECO|ideco")
        (setq target-str (vlax-invoke-method reg "Replace" target-str "DTXM"))
        (vlax-release-object reg)
        target-str
      )
      target-str
    )
  )

  (vla-StartUndoMark doc)
  (princ "\n>> Dang quet toan bo ban ve de thay the 'iDECO' -> 'DTXM'...")

  ;; 1. Quet Text, MText, Dimension, MultiLeader trong Model & Layouts
  (vlax-for layout (vla-get-Layouts doc)
    (vlax-for obj (vla-get-Block layout)
      (cond
        ;; Single Text
        ((= (vla-get-ObjectName obj) "AcDbText")
         (setq old-val (vla-get-TextString obj))
         (setq new-val (fn-replace-str old-val))
         (if (/= old-val new-val)
           (progn
             (vla-put-TextString obj new-val)
             (setq cnt-txt (1+ cnt-txt))
           )
         )
        )
        ;; MText
        ((= (vla-get-ObjectName obj) "AcDbMText")
         (setq old-val (vla-get-Text obj))
         (setq new-val (fn-replace-str old-val))
         (if (/= old-val new-val)
           (progn
             (vla-put-Text obj new-val)
             (setq cnt-txt (1+ cnt-txt))
           )
         )
        )
        ;; Block Reference (Attribute)
        ((= (vla-get-ObjectName obj) "AcDbBlockReference")
         (if (= (vla-get-HasAttributes obj) :vlax-true)
           (foreach att (vlax-safearray->list (vlax-variant-value (vla-GetAttributes obj)))
             (setq old-val (vla-get-TextString att))
             (setq new-val (fn-replace-str old-val))
             (if (/= old-val new-val)
               (progn
                 (vla-put-TextString att new-val)
                 (setq cnt-att (1+ cnt-att))
               )
             )
           )
         )
        )
        ;; Dimension TextOverride
        ((wcmatch (vla-get-ObjectName obj) "*Dimension*")
         (setq old-val (vla-get-TextOverride obj))
         (if (and old-val (/= old-val ""))
           (progn
             (setq new-val (fn-replace-str old-val))
             (if (/= old-val new-val)
               (progn
                 (vla-put-TextOverride obj new-val)
                 (setq cnt-dim (1+ cnt-dim))
               )
             )
           )
         )
        )
        ;; MultiLeader
        ((= (vla-get-ObjectName obj) "AcDbMLeader")
         (setq old-val (vla-get-TextString obj))
         (if (and old-val (/= old-val ""))
           (progn
             (setq new-val (fn-replace-str old-val))
             (if (/= old-val new-val)
               (progn
                 (vla-put-TextString obj new-val)
                 (setq cnt-txt (1+ cnt-txt))
               )
             )
           )
         )
        )
      )
    )
  )

  ;; 2. Quet cac Attribute Definition va Text trong Block Definitions
  (vlax-for blk (vla-get-Blocks doc)
    (if (and (= (vla-get-IsLayout blk) :vlax-false)
             (= (vla-get-IsXRef blk) :vlax-false))
      (vlax-for obj blk
        (cond
          ((= (vla-get-ObjectName obj) "AcDbAttributeDefinition")
           (setq old-val (vla-get-TextString obj))
           (setq new-val (fn-replace-str old-val))
           (if (/= old-val new-val)
             (progn
               (vla-put-TextString obj new-val)
               (setq cnt-blk (1+ cnt-blk))
             )
           )
          )
          ((or (= (vla-get-ObjectName obj) "AcDbText")
               (= (vla-get-ObjectName obj) "AcDbMText"))
           (setq old-val (if (= (vla-get-ObjectName obj) "AcDbText")
                           (vla-get-TextString obj)
                           (vla-get-Text obj)))
           (setq new-val (fn-replace-str old-val))
           (if (/= old-val new-val)
             (progn
               (if (= (vla-get-ObjectName obj) "AcDbText")
                 (vla-put-TextString obj new-val)
                 (vla-put-Text obj new-val)
               )
               (setq cnt-blk (1+ cnt-blk))
             )
           )
          )
        )
      )
    )
  )

  (vla-EndUndoMark doc)
  (vla-Regen doc acAllViewports)

  (princ "\n=======================================================")
  (princ "\n [DTXM] KET QUA THAY THE 'iDECO' -> 'DTXM':")
  (princ (strcat "\n - Text / MText / MLeader : " (itoa cnt-txt) " doi tuong."))
  (princ (strcat "\n - Thuoc tinh Block (Att) : " (itoa cnt-att) " doi tuong."))
  (princ (strcat "\n - Ghi de Kich thuoc (Dim): " (itoa cnt-dim) " doi tuong."))
  (princ (strcat "\n - Dinh nghia trong Block : " (itoa cnt-blk) " doi tuong."))
  (princ (strcat "\n >> TONG CONG DA THAY THE : " (itoa (+ cnt-txt cnt-att cnt-dim cnt-blk)) " vi tri."))
  (princ "\n=======================================================\n")
  (princ)
)

(princ "\n[DTXM] Da nap lenh: DTXM-REP hoac REP-IDECO de thay the text.")
(princ)