
;; 14.03.lon wstawianie profilu na przekroju
;; nazwa profilu: PROFIL , 
;; wstepnie wyznaczenie skali pionowej i wys_PP
;; pytanie o punkt bazowy (0,wys_pp) (_INT) i wspolrzedna wys,
;; wstawia blok profil 
(defun c:wstaw_profil( / ) ;aa sp sps xx yy wp pp pp1)
    (setvar "cmdecho" 0)
    (command "_layer" "_m" "Profile" "")
        (if (equal skala_pion   nil) (setq skala_pion 0))
        (if  (> skala_pion 0)(setq aa " ")(progn
            (setq aa       (rtos skala_pion 2 2)
                sps        (strcat "\nPodaj wsp.skali pionowej<" aa ">: ")
                skala_pion (getreal sps)
             )
            (if (equal skala_pion   nil) (setq skala_pion 100))
        ))

        (setq punkt_bazowy (getpoint "\nWska? punkt bazowy:" )) 

        (if (equal wys_PP nil) (setq wys_PP 100))
	(setq aa         (rtos wys_PP 2 2)
              sp         wys_PP
              sps        (strcat "\nWysokosc poziomu porownawczego PP<" aa ">: ")
              wys_PP (getreal sps)
         )
        (if (equal wys_PP nil) (setq wys_PP sp))
        
        (if (equal wys_prof nil) (setq wys_prof wys_PP))
	(setq aa         (rtos wys_prof 2 2)
              sp         wys_prof
              sps        (strcat "\nWysokosc wstawienia profilu<" aa ">: ")
              wys_prof (getreal sps)
         )
        (if (equal wys_prof nil) (setq wys_prof sp))

        (setq xx (car  punkt_bazowy)
              yy (cadr punkt_bazowy) 
              wp (/ (* (- wys_prof wys_PP) 1000) skala_pion)
              pp (list xx (+ yy wp) 0)
;;              pp1 (polar pp 3 12)  ; kat w radianach !!!!!
	  pp1 (list (+ xx -10) (+ yy wp 13) 0)
        )  
        (command "_insert" "profil" pp 1 1 0 ) 
	(command "_text" "st" "s3" pp1 "0.0" 
             (strcat (rtos wys_prof 2 2)    
 	;;  " wys_PP:" (rtos wys_PP 2 2) 
        ;;      " sk_pion:" (rtos skala_pion 2 2) 
        ;;      " wp,xx,yy:" (rtos wp 2 2) " " 
	;;	(rtos xx 2 2) " "   
	;;	(rtos yy 2 2)
             )
         )
     (prompt "\n profil wstawiono ")
     (setvar "cmdecho" 1)   
);koniec wstaw_profil


