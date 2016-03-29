;; 20.04.2000. Lonia Wisniewski
;; obsluga pomiarow przekroju


;; __3__ 13.02.2001  czy dobrze liczy pole ???, poprawilem skale
;; __2__ 10.02.2001 lon dodanie attr humus naniesienie i korytowanie		  
;; __1__ 10.02.2001 lon dodanie funkcji pomiarow bez pytan
;;		  ident. obiektow przez wskazanie oknem, po nazwach kalek



;;  przekroj_bp  przekroj bez pytan
;; zaznaczenie przekroju oknem
(defun c:przekroj_bp( / kalka  e1 ss ii prz pole dlug pp
 						 NN WW   HH  PON POW WO 
						 ZU   WK  WB  HN  K
						 scmde sblip
					)
(setq sblip (getvar "blipmode"))
	(setq scmde (getvar "cmdecho"))
	(setvar "blipmode" 0)
	(setvar "cmdecho" 0)
	;;;;;;;;;;;;;  czynnosci wstepne ;;;;;;;;;;;;;;;
 (command  "_layer" "_m" "POM_nasyp"                    
                    "_m" "POM_wykop"                    
                    "_m" "POM_zdjecie_humusu"       
                    "_m" "POM_pob_nasyp"            
                    "_m" "POM_pob_wykop"            
                    "_m" "POM_warstwa_odsaczajaca"
                    "_m" "POM_podbudowa"            
                    "_m" "POM_wyrownanie_kruszywem"
                    "_m" "POM_wyrownanie_bitumiczne"
                    "_m" "POM_naniesienie_humusu"
                    "_m" "POM_korytowanie"          
    "")
;;;;;;;;;;;;;  czynnosci wstepne ;;;;;;;;;;;;;;;
   (prompt (strcat "\n Wskaz napis z nazwa przekroju :\n"))
   (setq prz (cdr (assoc 1 (entget (ssname 
                                (ssget '((0 . "TEXT")) ) 0)
                           )
              ))
   ) 
   (prompt (strcat "\n Wskaz obiekty przekroju :\n"))
   (setq  	ss (ssget  '((0 . "*POLYLINE")) )
   			ii (sslength ss)
			pp (getpoint "\nWska¿ punkt wstawienia napisow:" )
			NN 0
		 WW  0 HH  0  PON  0 POW  0 WO  0 
		 ZU  0 WK  0  WB   0  HN  0  K	0   
   )
  (while (> ii 0 )
      ;;(prompt (strcat "licznik :" (itoa ii) "\n" ) }) 			
      (setq e1 (ssname ss (1- ii))
		  kalka (cdr (assoc '8 (entget e1)))
	  )  
      (command "_area" "_o" e1)   ;;;           __3__
	  (setq pole (/ (* (getvar "AREA") skala_poziom skala_pion) 1000000)
	        dlug (/ (* (getvar "PERIMETER") skala_poziom) 1000)
	  ) 
	  (cond 
        ((equal kalka "POM_NASYP")                  (setq NN (+ NN pole)))                 
        ((equal kalka "POM_WYKOP")                  (setq WW (+ WW pole)))                
        ((equal kalka "POM_ZDJECIE_HUMUSU")         (setq HH (+ HH dlug)))       
        ((equal kalka "POM_POB_NASYP")              (setq PON (+ PON dlug)))            
        ((equal kalka "POM_POB_WYKOP")              (setq POW (+ POW dlug)))            
        ((equal kalka "POM_WARSTWA_ODSACZAJACA")    (setq WO (+ WO dlug)))
        ((equal kalka "POM_PODBUDOWA")              (setq ZU (+ ZU dlug)))            
        ((equal kalka "POM_WYROWNANIE_KRUSZYWEM")   (setq WK (+ WK pole)))
        ((equal kalka "POM_WYROWNANIE_BITUMICZNE")  (setq WB (+ WB pole)))
        ((equal kalka "POM_NANIESIENIE_HUMUSU")     (setq HN (+ HN dlug)))
        ((equal kalka "POM_KORYTOWANIE")            (setq K  (+ K  dlug)))                        
        (t nil) 
	  )  
      (setq   ii (1- ii))
  );  koniec while
 (command "_insert"  "bl_WYNIKI_POMIAROW" pp 1 1 0 prz  
		 (rtos WW   2 2)
		 (rtos NN   2 2) (rtos HH    2 2) 
		 (rtos PON  2 2) (rtos POW   2 2)
		 (rtos WO   2 2) (rtos ZU    2 2)
		 (rtos WK   2 2) (rtos WB    2 2)
  	     (rtos HN   2 2) (rtos K     2 2)  ;; __2__
 )

    (setvar "blipmode" sblip)
	(setvar "cmdecho" scmde)
	(princ))  ; koniec przekroj_bp

(defun c:przekroj( / ii ss ell sum  pp  prz NN WW HH PO)
 (setvar "cmdecho" 1)
 (if  (> skala_poziom 0)(setq ii 0)(droga_pocz))
 (prompt (strcat "\n Wskaz napis z nazwa przekroju :\n"))
 (setq    	
       	prz (cdr (assoc  1 (entget (ssname 
                                (ssget '((0 . "TEXT")) )  0)
                           )
            )    )       	
         NN (lo_pol "NASYP")
         WW  (lo_pol  "WYKOP")
         HH  (lo_dlug "HUMUS ZDJECIE")
         PON (lo_dlug "POBOCZE_NASYP")
         POW (lo_dlug "POBOCZE_WYKOP")
         WO  (lo_dlug "DLUGOSC WARSTWY ODSACZ.")
         ZU  (lo_dlug "DLUGOSC ZUZLA.")
         WK  (lo_pol  "WYROWNANIE_KRUSZYWEM")
         WB  (lo_pol  "WYROWNANIE_BITUMICZNE")
         HN  (lo_dlug "HUMUS NANIESIENIE")   ;; __2__
         K   (lo_dlug "KORYTOWANIE")         ;; __2__
	pp (getpoint "\nWska¿ punkt wstawienia napisow:" )
  )    
 (command "_insert"  "bl_WYNIKI_POMIAROW" pp 1 1 0 prz  
		 	WW NN HH PON POW WO ZU WK WB 
 			HN K   ;; __2__
 )
 (command "_qsave" )

 (setvar "cmdecho" 0)
)
;
(defun lo_pol(napis / ii ss e1 sum  pp prz) 
 (prompt (strcat "  ============ " napis "  ============  wskaz zamkniete polilinie (ctrl,shift):"))
 (setq    ss (ssget '((0 . "LWPOLYLINE"))  )       
          ii (sslength ss)
          sum 0
    )
 (while (> ii 0 )
    (setq e1 (ssname ss (1- ii)))  
    (command "_area" "o" e1)
    (setq   sum (+ sum (getvar "AREA"))    
            ii (1- ii))
 )
(rtos (/ (* sum skala_poziom skala_poziom) 1000000) 2 2)      ; 
);koniec lo_pol

(defun lo_dlug(napis / ii ss e1 sum  pp )
 (prompt (strcat "  ============ " napis "  ===============  wskaz  polilinie (ctrl,shift): "))
 (setq    ss (ssget '((0 . "LWPOLYLINE"))  )       
          ii (sslength ss)
          sum 0
    )
(while (> ii 0 )
    (setq e1 (ssname ss (1- ii)))  
    (command "_area" "o" e1)
    (setq   sum (+ sum (getvar "PERIMETER"))
	ii (1- ii))
 )
(rtos (/ (* sum skala_poziom) 1000) 2 2)  
);koniec lo_dlug


;; lo_pomiar zwrana liste (dlugosc,pole)
(defun lo_pomiar(napis / ii ss e1 sum_pole sum_dlug  pp )
 (prompt (strcat "  ============ " napis "  ===============  wskaz  polilinie (ctrl,shift): "))
 (setq    ss (ssget '((0 . "LWPOLYLINE"))  )       
          ii (sslength ss)
          sum_pole 0
		  sum_dlug 0
    )
(while (> ii 0 )
    (setq e1 (ssname ss (1- ii)))  
    (command "_area" "o" e1)
    (setq   sum_dlug (+ sum_dlug (getvar "PERIMETER"))
		    sum_pole (+ sum_pole (getvar "AREA"))    
			ii (1- ii)
 	)
)	
   (list (rtos (/ (* sum skala_poziom) 1000) 2 2)
		 (rtos (/ (* sum skala_poziom skala_poziom) 1000000) 2 2) 			   
   )		   
);koniec lo_pomiar

;==============================================
;;20.04.2000 lon obliczanie pol i dlugosci 
(defun c:lo_pole( / ii ss e1 sum  pp prz)
 (setvar "cmdecho" 1)
  
 (prompt "\n wskaz zamkniete polilinie(ctrl,shift): ")
 (setq    ss (ssget '((0 . "LWPOLYLINE"))  )       
          ii (sslength ss)
          sum 0
    )
(while (> ii 0 )
    (setq e1 (ssname ss (1- ii)))  
    (command "_area" "o" e1)
    (setq   
             sum (+ sum (getvar "AREA"))
             
    )
  (setq ii (1- ii))
 )

 (setq sum  (/ (* sum skala_poziom skala_pion) 1000000) ;; __3__
       pp (getpoint "\nWska¿ punkt tekstu:" ))    
 (command "_text" "st" "s3" pp "0.0" 
             (strcat "P="   (rtos sum 2 5)  )
 )    
);koniec lo_pole

(defun c:lo_dlugosc( / ii ss e1 sum  pp )
 (setvar "cmdecho" 1)
 (prompt "\n wskaz  polilinie(ctrl,shift): ")
 (setq    ss (ssget '((0 . "LWPOLYLINE"))  )       
          ii (sslength ss)
          sum 0
    )
(while (> ii 0 )
    (setq e1 (ssname ss (1- ii)))  
    (command "_area" "o" e1)
    (setq   
             sum (+ sum (getvar "PERIMETER"))
             
    )
  (setq ii (1- ii))
 )

 (setq pp (getpoint "\nWska¿ punkt tekstu:" ))    
 (command "_text" "st" "s3" pp "0.0" 
             (strcat "L="   (rtos sum 2 5)  )
 )    
);koniec lo_dlugosc










