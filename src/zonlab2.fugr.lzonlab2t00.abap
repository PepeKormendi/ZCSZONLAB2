*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCOUNTRY_DB.....................................*
DATA:  BEGIN OF STATUS_ZCOUNTRY_DB                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCOUNTRY_DB                   .
CONTROLS: TCTRL_ZCOUNTRY_DB
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCOUNTRY_DB                   .
TABLES: ZCOUNTRY_DB                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
