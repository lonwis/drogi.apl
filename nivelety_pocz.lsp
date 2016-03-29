;; 12.01.2001. Lonia Wisniewski
;; zbior funkcji do projektowania drog


;; __1__ 20.01.2001 lon dodanie 
;;				checkbox 'czy wstawic blok PP'

;; zbior funkcji do projektowania drog
;; plik z funkcja poczatkowa
;; zmienne globalne :
;;	wys_PP	
;;  x_PP  - nowa 12.01.2001
;;	punkt_bazowy
;;	skala_poziom
;;	skala_pion
;;  blok_PP   wartosci 1 0   __1__
;;	typ_rz -  wartosci p i t

;(defun *error* (msg)
 ;  (printc "Blad:  ")
;   (printc msg)
;   (printc)   
;)

(defun droga_pocz ( / status res lx_pp lwys_pp lskala_poziom lskala_pion 
		ltyp_rz lx ly lpunkt
		lblok_PP  ; __1__
		osnap
		)
		(setq  osmode (getvar "OSMODE"))
		(setvar "OSMODE" 0)
		(command "_ucs" "_w"); aby uniknac klopotow
  (command "_layer" "_m" "TAB_RZEDNE" "")         
  (command "_layer" "_m" "Projekt" "")
  (command "_layer" "_m" "Teren" "")
  (command "_layer" "_m" "POMOCNICZA" "")
  
  (setq status 5
		punkt1 nil
		lblok_PP 0      ;__1__
  		dcl_id (load_dialog "nivelety_pocz.dcl")
  )
  (setvar "cmdecho" 0)
  (if (equal  blok_PP nil)      (setq blok_PP 0)) ; __1__
  (if (equal  wys_PP nil)       (setq wys_PP 100))
  (if (equal  x_PP nil)         (setq x_PP 0))
  (if (equal  skala_poziom nil) (setq skala_poziom 100))
  (if (equal  skala_pion nil)   (setq skala_pion 100))
  (if (equal  typ_rz nil)       (setq typ_rz "p"))
  (if (equal  punkt_bazowy nil) 
    (setq lx 0 ly 0)
  	(setq lx (car punkt_bazowy) 
  		  ly (cadr punkt_bazowy) 
  	)
  )
  (setq lwys_PP wys_pp
		lx_PP x_PP
		lskala_poziom skala_poziom
		lskala_pion skala_pion
		lblok_PP blok_PP
  )	
(while (>  status 2)  ;; petla formatki 
  (if(not(new_dialog "pocz_niveleta" dcl_id))
    (progn
      (alert "Nie znaleziono pliku pocz_niveleta.DCL")
      (exit)
    );progn
  );if
   (if (= 5 status) (mode_tile "wys_pp" 2))

   (set_tile    "x" 			(rtos lx 2 2) )
   (set_tile    "y" 			(rtos ly 2 2) )
   (set_tile    "wys_pp" 		(rtos lwys_pp 2 2) )
   (set_tile    "x_pp"  		(rtos lx_pp 2 2) )
   (set_tile    "skala_poziom"  (rtos lskala_poziom) )
   (set_tile    "skala_pion"    (rtos lskala_pion) )
   (set_tile    "blok_PP"		(itoa lblok_PP))
   (action_tile "x" 			"(setq lx (atof $value))")
   (action_tile "y" 			"(setq ly (atof $value))")
   (action_tile "wys_pp" 		"(setq lwys_pp (atof $value))")
   (action_tile "x_pp"  		"(setq lx_pp (atof $value))")
   (action_tile "skala_poziom" 	"(setq lskala_poziom (atof $value))")
   (action_tile "skala_pion"  	"(setq lskala_pion (atof $value))")
   (action_tile "blok_PP"  		"(setq lblok_PP (atoi $value))") ; __1__
;   (action_tile "typ_rz_p"    	"(setq ltyp_rz \"p\")")
;   (action_tile "typ_rz_t"    	"(setq ltyp_rz \"t\")")

   (action_tile "punkt"       	"(done_dialog 4)") ; "      lx (car lpunkt) ly (cadr lpunkt) )"
   (action_tile "accept"      	"(done_dialog 2)(setq res 1)")
   (action_tile "cancel"      	"(done_dialog 0)(setq res 0)")
 
   (setq status (start_dialog))

      (cond                      ; Decide what to do .
        ((= status 4)         ; guzik punkt 
          (initget 1)
          (setq lpunkt (getpoint "\nWska? punkt bazowy:")  )
          (if lpunkt
            (setq lx (car   lpunkt)    
                  ly (cadr  lpunkt)
            )
          )
        );  koniec guzik punkt
	  )	
) ;  koniec while   

    (if (= status 2)    ;; If OK was picked...
    (progn
       (if (> lwys_pp 0) (setq wys_pp lwys_pp) )
       (if (> lx_pp 0)   (setq x_pp lx_pp) )
       (if (> lskala_poziom 0) (setq skala_poziom lskala_poziom) )
       (if (> lskala_pion 0) (setq skala_pion lskala_pion) )
       (setq ;typ_rz ltyp_rz
	   	     punkt_bazowy (list lx ly)	
			 blok_PP  lblok_PP  ;; __1__
		)
; 	   (command "_text" "st" "s4" "5,1" "0" 
;	   		(strcat "PP " (rtos wys_PP 2 2))
;		)
		(if (= blok_PP 1)  ;;__1__
        (command "_insert" "BL_PP" punkt_bazowy 1 1 0 
           (strcat "PP " (rtos wys_PP 2 2)) ; PP_etykieta
		   (rtos skala_poziom 2 2)
		   (rtos skala_pion   2 2)
		   (rtos wys_PP       2 2)
		   (rtos x_PP         2 2)
	    )
		)  ;;  __1__
    );progn
   ); koniec     ;; If OK was picked...
 
  
  (unload_dialog dcl_id)

;;;   (command "_ucs" "c" punkt_bazowy )
   (setvar "OSMODE" osmode)

;   (prompt (strcat 	"PP:  "  
;   					"wys_PP: "  (rtos wys_pp)
;   					"; x_PP: "	(rtos x_pp)
;					"\n skala_poz: " (rtos skala_poziom)
;					"; skala_pion: " (rtos skala_pion)
;					"\n"
;   			)
;   )
);defun pocz



