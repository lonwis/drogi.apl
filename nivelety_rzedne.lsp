
;  funkcje rzednych nivelety 12.01.2000

; __2__ 25.01.2001 lon dodalem lacz linie parametr 0 1 
;			czy laczyc kolejne czubki
; __1__ 23.01.2001 lon wyrzucenie ucs lokalnego 

; zwraca st1ring z dziesiatkami iksa 
(defun dzies( x /  a100 a1000 ) 
  (setq a1000 (fix  (/ x 1000)); ilosc km
  		x (- x (* a1000 1000)); reszta z km
		a100  (fix  (/ x 100)); ilosc setek
		x (- x (* a100 100)); reszta z setek
  )
  (list x a100 a1000)
); koniec dzies


; rz  rodzaj rzednych 	"p" projektowe "t" terenu
; niveleta - wzdluz drogi
(defun rysuj_rzedna(x y rz lacz_linie / xx yy pp  naz xb yb)
  (command "_ucs" "_w"); aby uniknac klopotow			   
		
    (if (equal rz "p") 
			(setq naz "BL_RZ_PROJEKTOWA") 
			(setq  naz "BL_RZ_TERENU")
	)
    (if (equal rz "p") 
			(command "_layer" "_m" "Projekt" "") 
			(command "_layer" "_m" "Teren" "")
	)

	(setq xb (car punkt_bazowy)
		  yb (cadr punkt_bazowy)
		  xx (+ xb (/ (* (- x x_PP)   1000) skala_poziom))	
		  yy (+ yb (/ (* (- y wys_PP) 1000) skala_pion))
		  pp (dzies x) ;  podzial na dzies i setki tys
	)
    (command "_line" (list xx yb) (list xx yy) "" )
	(if  (equal punkt1 nil)
		 (setq punkt1 (list xx yy))
		 (progn
		    (if (equal 1 lacz_linie) 
		      (command "_line" punkt1 (list xx yy) "")
			)
			(setq punkt1 (list xx yy))
		 )
	) 
    (if (equal rz "p") (setq naz "BL_RZ_PROJEKTOWA") 
					   (setq  naz "BL_RZ_TERENU")
	)
    (command "_insert" naz (list xx yb) 1 1 0
		(rtos y 2 2)
		(rtos (car pp) 2 2)
		(rtos x 2 2)
	)        
);koniec rysuj rzedna
; niweeleta

(defun c:rz( );/ aa xx1 yy1  )
;     (setvar "cmdecho" 0)
  (command "_ucs" "_w"); aby uniknac klopotow			   
    (setq punkt nil)
    (if  (equal typ_rz nil)(setq typ_rz "p"))
    (if  (equal rzedna nil) 
         (setq rzedna "Projekt" 
					 typ_rz "p"
		 )
    ) 
    
    (while rzedna
        (initget 0 "Projekt Teren") 
	    (prompt (strcat "\nwstawienie rzednych niwelety " typ_rz))
	    (setq     rzedna (getpoint "\nProjekt/Teren/<wpisz wsp. punktu (x,y)> " ))
        (if (atom rzedna)
            (setq aa 0) ; operacja pusta
            (setq xx (car rzedna)
                  yy (cadr rzedna) 
            )			
		)
        (cond 
            ((eq rzedna "Projekt") 
                    (setq typ_rz "p")
			)            
                     
            ((eq rzedna "Teren")   
                    (setq typ_rz "t")
			) 
            (T rzedna) 
        )
        (if (atom rzedna)
            (setq aa 0)            
		    (progn 
				(rysuj_rzedna xx yy Typ_rz 1)
		    ) ; else atom
        ); if atom
    ); while
     (setvar "cmdecho" 1)

); koniec rz

(defun rz_proj( p1 / xb yb x y )
	(setq xb (car punkt_bazowy)
		  yb (cadr punkt_bazowy)
  		   x (+ (/ (* (- (car p1) xb) skala_poziom) 1000) x_pp)
		   y (+ (/ (* (- (cadr p1) yb) skala_pion)   1000) wys_pp)
    )
    (rysuj_rzedna x y "p" 0)
)		
(defun c:rz_punkt(/ p1    osmode )
	(setq  osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	(command "_ucs" "_w"); aby uniknac klopotow
	(setq p1 (getpoint "\nwskaz punkt projektowy: "))
     (rz_proj p1)
     (setvar "OSMODE" osmode)
)
