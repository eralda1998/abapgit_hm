*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZZEL_BILL.......................................*
DATA:  BEGIN OF STATUS_ZZEL_BILL                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZEL_BILL                     .
CONTROLS: TCTRL_ZZEL_BILL
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZZEL_DOCTOR.....................................*
DATA:  BEGIN OF STATUS_ZZEL_DOCTOR                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZEL_DOCTOR                   .
CONTROLS: TCTRL_ZZEL_DOCTOR
            TYPE TABLEVIEW USING SCREEN '0003'.
*...processing: ZZEL_PATIENT....................................*
DATA:  BEGIN OF STATUS_ZZEL_PATIENT                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZZEL_PATIENT                  .
CONTROLS: TCTRL_ZZEL_PATIENT
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZZEL_BILL                     .
TABLES: *ZZEL_DOCTOR                   .
TABLES: *ZZEL_PATIENT                  .
TABLES: ZZEL_BILL                      .
TABLES: ZZEL_DOCTOR                    .
TABLES: ZZEL_PATIENT                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
