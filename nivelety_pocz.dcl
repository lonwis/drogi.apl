// 02.01.2001 lon
// nastawy poczatkowe nivelety

// __1__ 20.01.2001 lon dodanie 
//				checkbox 'czy wstawic blok PP'
//
//
dcl_settings : default_dcl_settings { audit_level = 3; }

pocz_niveleta : dialog {
    label = "nastawy poczatkowe niwelety";
  :row {
   : boxed_column {	  
    : row {
        width = 0;
        height = 0;
        : edit_box {
            label = "wy&Sokosc punktu pocz PP:";
            key = "wys_pp";
            mnemonic = "S";
        }
	  }
    : row {
        width = 0;
        height = 0;
        : edit_box {
            label = "od&Cieta punktu pocz PP:";
            key = "x_pp";
            mnemonic = "C";
        }
	  }
		: row {
    	    : edit_box {
        	    label = "skala po&Zioma:";
          	 	 key = "skala_poziom";
           		 mnemonic = "Z";
        	}
    	}
		: row {
    	    : edit_box {
        	    label = "skala pio&Nowa:";
          	 	 key = "skala_pion";
           		 mnemonic = "N";
         	    }
    	     }
   } // koniec kolumny
        : boxed_column { 

            label = "Punkt bazowy";
           : button {
                label = "Wybierz p&Unkt <";
                key = "punkt";                 
           		 mnemonic = "U";
            }
            : edit_box {
                label = "&X:";
                key = "x";
                edit_width = 10;
            }
            : edit_box {
                label = "&Y:";
                key = "y";
                edit_width = 10;
            }
			: toggle {  // __1__
				label 	= "&wstawic Blok PP";
				key 	= "blok_PP";
				mnemonic = "B";
			}
        }
  }		
	
    ok_cancel;
	errtile;
}
