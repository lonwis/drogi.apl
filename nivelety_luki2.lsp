;; 2009.10.01 lwi   zamiana zmiennej T na TTT dla nowego acad
;; 20.01.2001. Lonia Wisniewski utworzenie
;; funkcje zaokraglenia nivelety

;
(defun c:nluki(  /  
		        lin1 lin2  
				promien okrag
				lp1 lp2 ; punkty lewego odcinka 
				pp1 pp2 ; punkty prawego odcinka
				pk pr     ; punkt pomocniczy
				dx1 dy1 dx2 dy2 ; odleglocsi po x i y
				pkx pky
				nazwa  	nazwa2
				blok 
				osmode
				xb yb 	
				srodek pocz koniec  kat1 kat2 ; param okregu
				xs1 xs2 xs3 ys1 ys2 ys3 ;od srodka do p 1 i 2 i 3
				rp1 rp3  ; nowe wspolrzedne lp1 i pp2 w skali 1:1
				ps1 ps3 ; punkty styczne na rys
				B TTT ; parametry luku
              )
	(setq  osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
			  
  (command "_ucs" "_w"); aby uniknac klopotow			   
  (setq   xb (car punkt_bazowy)
		  yb (cadr punkt_bazowy)
		  promien (getdist "podaj promien luku [1000]: ")
		  ; entsel zwraca nazwe obiektu i punkt
		  lin1 (car (entsel "\nwskaz lewe ramie wierzcholka nivelety:")) 
		  lp1 (cdr (assoc 10 (entget lin1)))
		  lp2 (cdr (assoc 11 (entget lin1)))

		  lin2 (car (entsel "\nwskaz prawe ramie wierzcholka nivelety:")) 
		  pp1 (cdr (assoc 10 (entget lin2)))
		  pp2 (cdr (assoc 11 (entget lin2)))
	;	  promien (getdist "\npodaj promien okregu [100]:")
   )
   (if (equal promien nil)(setq promien 1000))
   
;; zamienia miejscami punkty tak zeby
;; 		p1 byl z lewej a p2 z prawej 
	(if (> (car lp1)  (car lp2) )
		(setq pk lp1 
			  lp1 lp2
			  lp2 pk
		)
	); if
	(if (> (car pp1)  (car pp2) )
		(setq pk pp1 
			  pp1 pp2
			  pp2 pk
		)
	); if
    (if (= (car lp2) (car pp1))  ; jezeli lp2 == pp1
	(if (= (cadr lp2) (cadr pp1))
		(progn ; jezeli lp2 = pp1 
		   (setq 
				 ; oblicz odl po x i y   z przeliczenie skal
				 dx1 (/ (* (- (car lp2)  (car lp1))  skala_poziom) 1000)
				 dx2 (/ (* (- (car pp2)  (car lp2))  skala_poziom) 1000)
				 dy1 (/ (* (- (cadr lp2) (cadr lp1)) skala_pion) 1000)
				 dy2 (/ (* (- (cadr lp2) (cadr pp2)) skala_pion) 1000)
				 ; nowe wspolrzedne lp1 i pp2 w skali 1:1
				 rp1 (list (- (car lp2) dx1) (- (cadr lp2) dy1))
				 rp3 (list (+ (car lp2) dx2) (- (cadr lp2) dy2))
				 nazwa (strcat "W_" (itoa  (fix (car lp2)) ))
		   )
		   (command  "_layer" "_m" "POMOCNICZA" "")
(prompt "\nlinie pomocnicze ")(princ)
		   (command  "_LINE" rp1 lp2 "")
			(setq  lin1 (entlast))
		   (command "_LINE" lp2 rp3 "")
		    (setq  lin2 (entlast))
		   (command "_layer" "_m" "Projekt" "")
(prompt "\nzaokraglenie ")(princ)
			(command "_fillet" "_t" "_t" "_r" promien)
			(command "_fillet"  lin1 lin2 )
			(setq  okrag (entlast)
				;;srodek pocz koniec prom kat1 kat2				   
				  srodek (cdr (assoc 10 (entget okrag)))
				  kat1 (cdr (assoc 50 (entget okrag))) ; w radianach
				  kat2 (cdr (assoc 51 (entget okrag)))
				  pocz (polar srodek kat2 promien)
				  koniec (polar srodek kat1 promien)
				  
				  xs1 (- (car srodek) (car pocz))
				  xs2 (- (car srodek) (car lp2))
				  xs3 (- (car koniec) (car srodek))
				  
				  ys1 (- (cadr pocz) (cadr srodek))
		          ys2 (- (cadr lp2) (cadr srodek))
				  ys3 (- (cadr koniec) (cadr srodek))
				  
				  ps1 (list 
				  		(- (car lp2) (/ (* (- xs1 xs2)   1000) skala_poziom))
						(- (cadr lp2) (/ (* (- ys2 ys1)   1000) skala_pion))
				       )
				  ps3 (list
						(+ (car lp2) (/ (* (+ xs2 xs3)   1000) skala_poziom))
						(- (cadr lp2) (/ (* (- ys2 ys3)   1000) skala_pion))
				  )
	                ;; punkt szczytu luku na rys 
	 	              pkx  (+ (car  lp2) (/ (* xs2 1000) skala_poziom))
		   )
		   (command	"_line" ps1 ps2 "" )
(prompt "\n  skasowanie linii pomocniczych ")(princ)
			;;(command	"_erase" lin1 lin2 "" )
		   (if (equal (tblsearch  "block" nazwa) nil)
(prompt "\n tworzenie bloku ")(princ)
				(command "_BLOCK" nazwa lp2  okrag "")
				(command "_BLOCK" nazwa "T" lp2  okrag "")
			)
		   (princ (STRCAT "\n " "wstawiam blok " nazwa "\n"))
		   (command "_layer" "_m" "Projekt" "")
		   (command "_INSERT" nazwa lp2
				         (/ 1000 skala_poziom )
						 (/ 1000 skala_pion )
						 0.0
		   )
		   (command "_explode" "_last" )
		   (setq okrag (entlast)) ; wlasciwie elipsa 
			(if (> (cadr lp1) (cadr lp2))
			    (setq nazwa2 "bl_luk_wklesly" 
				      TTT (/ (+ xs1 xs3) -2 )
					  B (- (cadr srodek) (cadr lp2) promien); rozn po y
	;(list lp2 pkx pky promien xs2 ys2)
					  pky  (- (cadr lp2) (/ (* (+ promien ys2) 1000) skala_pion))
				)
				(setq nazwa2 "bl_luk_wypukly" 
				      TTT (/ (+ xs1 xs3) 2 )
					  B (- (cadr lp2) (cadr srodek) promien); rozn po y
					  pky  (- (cadr lp2) (/ (* (- ys2 promien) 1000) skala_pion))
				)
			)		
(princ (STRCAT "\n " "wstawiam blok " nazwa2 "\n"))
				(command "_INSERT" nazwa2 (list (car lp2) yb)
				         1 1 0.0
						 (rtos promien 2 0 )
						 (rtos TTT 2 2 ) 
						 (rtos B 2 2 ) 
						 nazwa
		)
		;    (rz_proj ps1)
		;    (rz_proj ps3)
		;   (rz_proj  (list pkx pky))
		;	(command "_LINE" (list (car ps1) (+ yb 30)) 
		;					 (list (car ps3) (+ yb 30))
		;					 ""
		;	)
			
		); jezeli lp2 = pp1
	)
	) 
	
;;;	(command "_ucs" "_o" punkt_bazowy )
    (setvar "OSMODE" osmode)
	;(list  lp2 pkx pky promien xs2 ys2)
);; koniec 
