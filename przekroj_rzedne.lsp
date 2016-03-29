


; do przekrojow 16.11.1999 lon
(defun rysuj_rzedna_p(x y / xx yy pp pk x1)
	(setq  osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	(command "_ucs" "_w"); aby uniknac klopotow

	(setq xx (/ (* x 1000) skala_poziom))	
	(setq yy (/ (* (- y wys_PP) 1000) skala_pion))
            (setq pp (list xx -17))  
	(setq pk (list xx  yy))
            (command "_line" pp pk "" ) 

        
	(setq pt (list xx -21))	; punkt wstawienia tekstu
	(command "_text" "st" "s3" pt "0" (rtos x 2 2) )

	(setq yr -9)
	(setq pt (list xx yr))	; punkt wstawienia tekstu
	(command "_text" "st" "s3" pt "90" (rtos y 2 2) )

;	(prompt "\nrzedna dopisana ")
    (setvar "OSMODE" osmode)
        
);koniec rysuj rzedna przekroju

(defun c:rz_p(/ aa xx1 yy1 )
;     (setvar "cmdecho" 0)
  (command "_ucs" "_w"); aby uniknac klopotow			   

;;(prompt "\nrz_p poczatek ");;DEBUG
    (if (equal rzedna nil) ;
        (progn (setq 	rzedna "Teren" 
			typ_rz "t"
	    )
               (command "_layer" "_m" "Projekt" "")
        )                            
    ) 



    (if  (> skala_poziom 0)(setq aa 0)(droga_pocz))
    (command "_layer" "_m" "Teren" "") 
    (while rzedna
        (initget 0 "Projekt Teren") 
	(prompt  "\nwstawienie rzednych przekroju w terenie " )
	(setq     rzedna (getpoint "\n<podaj punkt(x,y)> " ))
        (if (atom rzedna)
            (setq aa 0) ; operacja pusta
            (setq xx (car rzedna)
                  yy (cadr rzedna) 
        )   )
        (cond 
            ((eq rzedna "Projekt") 
                    (progn (setq typ_rz "p")
                          (command "_layer" "_m" "Projekt" "")
                   ))  
            ((eq rzedna "Teren")   
                    (progn (setq typ_rz "t")
                          (command "_layer" "_m" "Teren" "")                            
                    )) 
            (T rzedna) 
        )
        (if (atom rzedna)
            (setq aa 0)            
            (rysuj_rzedna_p xx yy )
        ); if atom
    ); while
     (setvar "cmdecho" 1)

); koniec rz


