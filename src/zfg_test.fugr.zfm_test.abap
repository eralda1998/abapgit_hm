FUNCTION zfm_test.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_MATNR) TYPE  MATNR
*"  EXPORTING
*"     VALUE(ES_MARA) TYPE  MARA
*"----------------------------------------------------------------------
  SELECT SINGLE * FROM mara
    INTO es_mara
    WHERE matnr = iv_matnr.




ENDFUNCTION.
