;; 20.01.2001. Lonia Wisniewski
;; funkcje zaokraglenia nivelety

					;


;; bierze lastPoint  i linie (name)
;;   jesli  linia juz jest w zbiorze  Slinie  to koniec ,    a jesli nie to 
;;   doklada linie do zbioru Slinie
;;  jesli  LastPoint jest na poczatku 	kreski to nastepnym punktem jest  	koniec 	kreski
;;  jesli  LastPoint jest na koncu  		kreski to nastepnym punktem jest  	poczatek 	kreski



;;  pedit options : [Close/Join/Width/Edit vertex/Fit/Spline/Decurve/Ltype gen/Reverse/Undo]
(defun nextline(LLastpoint Nlinia rzedna  ss 
		/ Olin Lp1 Lp2 Lnextp newpoint set1)
  (if (ssmemb Nlinia Slinie)
    (progn ; then
		(prompt (strcat ss "nextline :linia juz jest \n"))
		;(kreska LLastpoint ss)
	) ; end then
    (progn  ; else
		(prompt (strcat ss "nextline : nowa linia   \n"))
		(ssadd Nlinia Slinie)
		(setq newpoint (list 
						(car LLastpoint) 
						(cadr LLastpoint) 
						rzedna
					))
		(command "_point" newpoint )
		(setq
		    Lpunkty (cons newpoint Lpunkty)
			Olin (entget Nlinia)
			Lp1  (cdr (assoc 10 Olin))
			Lp2  (cdr (assoc 11 Olin))
			Lnextp nil
		)
        (if (equal LLastpoint lp1)
			; then
			 (setq Lnextp lp2)
			;  else 
			 (if (equal LLastpoint lp2)
			   (setq Lnextp lp1)
			 )
       )
	   (if Lnextp
		   (progn 
		       (setq 
					set1      (ssget "_C" Lnextp Lnextp  '((0 . "LINE")  ))
					NNextline (ssname set1 0)
		       )
		       (while NNextline
				 (ssdel NNextline set1)
				 ; ==========================================
				 (nextline Lnextp NNextline rzedna (strcat ss "="))	 ;; rekurencyjne    wywolanie !!!!!
				 ; ==========================================
				 (setq NNextline (ssname set1 0))
		       )				; end while
			   (setq set1 nil)
		   ) ; end then
		   (progn
				(prompt (strcat ss "nextline : linia nieciagla z poziomnica\n"))
		   ) ; end else
	   ) ; end if
    )				; end else
  )					; end if
)					; end defun nextline


;  Zmienne globalne : 
; 	-  Slinie     set linii ktore juz wybrano
;	-  Lpunkty    lista punktow juz znalezionych
;	-  warstwa    linii wskazanej
;	-  Npline  	 nazwa Polyline warstwicy
(defun c:poz (/
	      Nlin1		; linia ktora wskazano jako pierwsza
	      Lpoint1	; pierwszy punkt linii
	      Lpoint2	; drugi punkt linii
		  zz
		  ss1 p1 ppp punkt
	     )
  (setq osmode (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (setq filedia (getvar "FILEDIA"))
  (setvar "FILEDIA" 0)
  (setq PEDITACCEPT (getvar "PEDITACCEPT"))
  (setvar "PEDITACCEPT" 1)
  (command "_ucs" "_w")			; aby uniknac klopotow		
  (command  "_layer" "_m" "PUNKTY_POZ" "")

  (if (not rzedna) (setq rzedna 0.0)) ; jesli jeszcze nie istnieje to zero
  (setq 
	Slinie nil
	Slinie (ssadd)
	Lpunkty (list)
	zz (getreal (strcat "\nPodaj wysokosc poziomnicy [" (rtos rzedna) "] :  "))
	Nlin1 (entsel "\nwskaz odcinek poziomnicy:")
	)
	(if (not Nlin1) (prompt "nie wskazano odcinka warstwicy \n"))
	(setq
	    Nlin1   (car Nlin1)
	)
	(if (not (eq "LINE" (cdr (assoc 0 (entget Nlin1))))) (prompt "nie wskazano odcinka warstwicy \n"))	
	(setq
	    Lpoint1 (cdr (assoc 10 (entget Nlin1)))
	    Lpoint2 (cdr (assoc 11 (entget Nlin1)))
		warstwa (cdr (assoc 8 (entget Nlin1)))
	)
  (if zz (setq rzedna zz)) ; wstawienie  wartosci pytanej jesli jest
  ;  (command  "_elev"  rzedna "" )  ; nowa domyslna wysokosc (z)  i  grubosc
  (command "_pline"   Lpoint1 Lpoint2  "")
  (setq Npline (entlast))
  ;; (prompt "\nfunkcja poz  pierwsze wywolanie nextline\n")
	
  
  (nextline Lpoint1 Nlin1 rzedna   "=")		; nextline w jedna strone
  (ssdel Nlin1 Slinie)
  (nextline Lpoint2 Nlin1 rzedna  "-")		; nextline w druga strone

  (prompt "funkcja poz  PUNKTY WSTAWIONE , WYKASOWANIE \n")
;; usuwanie podwojne punkty 
	(foreach punkt  Lpunkty
		(setq 
			ss1 nil
			ss1 (ssget "_C" punkt punkt  '((0 . "POINT") (8 . "PUNKTY_POZ") ))
			ppp (ssname ss1 0) ; pierwszy znaleziony
		)
		(ssdel ppp ss1 ) ; usuniecie pierwszego z set 
		(while (setq ppp (ssname ss1 0))  ; wykasowanie  wszystkich punktow nastepnych
			(prompt "usuniecie punktu \n")
			(ssdel ppp ss1)
			(entdel ppp)
		)
	)
  
  (prompt "funkcja poz  zakonczenie po nextline\n")

  (setvar "OSMODE" osmode)
  (setvar "FILEDIA" filedia) 
  (setvar "PEDITACCEPT" PEDITACCEPT)
)
(defun c:POZOUT ( / f ss1 pn lp p currPath currDWG fname)  
	(setq 	
		currPath (getvar "DWGPREFIX")
		currDWG (getvar "DWGNAME")
		fname (strcat currPath currDWG ".punkty_warswice_ENZ.txt" )
		f (open fname "w" ) ;c:\\drogi.ap\\0ut\\
		ss1 (ssget "X" '((0 . "POINT") (8 . "PUNKTY_POZ") )) 
	)
	(prompt (strcat " plik otwarty \n"))
	(While  (setq pn (ssname ss1 0))
		(setq 
			lp (cdr (assoc 10 (entget pn)))
			x  (car lp)
			y  (cadr lp)
			z  (caddr lp)
			
		)
		(write-line (strcat (rtos x) " , " (rtos y) " , " (rtos z) ) 
					f
		)
		(ssdel pn ss1)
	)

	(close f)
)