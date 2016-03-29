;; 17.01.2001. Lonia Wisniewski
;; funkcje pomiarow spadkow na nivelecie 


(defun spadki( p1 p2 / r i dx dy xs naz)
	    (setq  dx (- (car p2) (car p1))
			   dy (- (cadr p2) (cadr p1))
			   i  (/  dy dx )
			   xs (+ (car p1) (/ dx 2))
			   dx (/ (* dx skala_poziom) 1000)
			   dy (/ (* dy skala_pion)   1000)
			   i (* (/ (* i skala_pion) skala_poziom) 100)
		)
		(if (> dy 0)
		    (setq naz "bl_spadek_prawo")
		    (setq naz "bl_spadek_lewo")
		)
        (prompt (strcat "\n i,dx,dy:  " 
						(rtos i 2 4) "%, "
						(rtos dx 2 4) ", "
						(rtos dy 2 4) " \n"	
				;		(rtos xs 2 2) ", "
				;		naz ", "
				)
		)		
		(command "_insert" naz (list xs (cadr punkt_bazowy) 0) 1 1 0 
			(strcat (rtos (abs i) 2 2) "%") 
			(rtos dx 2 2)  
		)
)
(defun c:spadek_linii(/ p1 p2 )
  (command "_ucs" "_w"); aby uniknac klopotow		
  (setq lin1 (car (entsel "\nwskaz odcinek nivelety:"))
		p1 (cdr (assoc 10 (entget lin1)))
		p2 (cdr (assoc 11 (entget lin1)))
  )
  (spadki p1 p2)
;;;  (command "_ucs" "c" punkt_bazowy )	
)
(defun c:spadek_punkty(/ p1 p2  osmode)
	(setq  osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	(command "_ucs" "_w"); aby uniknac klopotow
	(setq 
	   p1 (getpoint "\nwskaz punkt poczatkowy(z lewej): ")
	   p2 (getpoint "\nwskaz punkt koncowy: " )
    )
;;;   (command "_ucs" "c" punkt_bazowy )	
   (spadki p1 p2)	
   (setvar "OSMODE" osmode)
)

