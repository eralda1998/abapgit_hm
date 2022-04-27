*&---------------------------------------------------------------------*
*& Report ZEL_EV_EXEC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zel_ev_exec.

"custon exception class for redefining method get_text to display 'No data found in table VBAP' in an error message
CLASS lcx_exp DEFINITION INHERITING FROM cx_static_check.

  PUBLIC SECTION.
    DATA: txt TYPE sotr_conc VALUE 'No data found in table VBAP'.
    METHODS: get_text REDEFINITION.

ENDCLASS.

CLASS lcx_exp IMPLEMENTATION.
  METHOD get_text.
    MESSAGE txt TYPE 'E'.
  ENDMETHOD.
ENDCLASS.



"class sales_doc for accessing tables vbak(header data) and vbap(item data) to get information for sales documents
CLASS lcl_sales_doc DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: av_auart TYPE vbak-auart. "Sales Document Type
    EVENTS: no_sales_doc." event to mark when there is no Sales Document in the parameter

    METHODS:
      constructor ,
      get_header_data
        IMPORTING iv_vbeln TYPE vbeln
        EXPORTING es_vbak  TYPE vbak,

      get_item_data
        IMPORTING is_vbak TYPE vbak
        EXPORTING et_vbap TYPE zel_vbap_tt
        RAISING   lcx_exp ,

      no_sales_doc_meth FOR EVENT no_sales_doc OF lcl_sales_doc."event handler method for no_sales_doc event
ENDCLASS.

CLASS lcl_sales_doc IMPLEMENTATION.
  METHOD constructor.
    av_auart = 'TA'. "initializes the Sales Document Type with value 'TA'
  ENDMETHOD.

  METHOD get_header_data.
    "if there is no Sales Document raise event,
    "else select a row from vbak where Sales Document equals given parameter value
    "and Sales Document Type equals 'TA' initialized from constructor and store them in a local structure
    IF iv_vbeln IS INITIAL.
      RAISE EVENT no_sales_doc.
    ELSE.
      SELECT SINGLE *
      FROM vbak
      INTO es_vbak
      WHERE vbeln = iv_vbeln
        AND auart = av_auart.

    ENDIF.
  ENDMETHOD.

  METHOD get_item_data.
    "get all rows from vbap where Sales Document equals sales document from vbak, and store them into a local table
    "if no rows found, then raise an exception of displaying an error message "No data found in table VBAP"
    SELECT * FROM vbap
      INTO TABLE et_vbap
      WHERE vbeln = is_vbak-vbeln.

    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE lcx_exp.
    ENDIF.
  ENDMETHOD.

  METHOD no_sales_doc_meth.
    "EVENT HANDLER method for displaying a popup (information) message
    MESSAGE: 'No sales document!!!' TYPE 'I'.
  ENDMETHOD.
ENDCLASS.



PARAMETERS: p_vbeln TYPE vbak-vbeln.

DATA: lo_class TYPE REF TO lcl_sales_doc.

DATA: gs_vbak     TYPE vbak,
      gt_vbap     TYPE TABLE OF vbap,
      gs_vbap     LIKE LINE OF gt_vbap,
      lo_exp      TYPE REF TO lcx_exp,
      lo_exp_salv TYPE REF TO cx_salv_msg,
      lv_message  TYPE string.

DATA go_alv_table TYPE REF TO cl_salv_table.

START-OF-SELECTION.

  CREATE OBJECT lo_class.

  SET HANDLER lo_class->no_sales_doc_meth FOR lo_class.

  CALL METHOD lo_class->get_header_data
    EXPORTING
      iv_vbeln = p_vbeln
    IMPORTING
      es_vbak  = gs_vbak.

  "if we find record from table vbak with the given parameter gv_vbeln
  "we get data from table vbap that matches the record from table vbak we fetched from vbak
  IF sy-subrc = 0.

    TRY.
        CALL METHOD lo_class->get_item_data
          EXPORTING
            is_vbak = gs_vbak
          IMPORTING
            et_vbap = gt_vbap.

        "if it finds records from vbap then we show them in ALV
        IF sy-subrc IS INITIAL.
          TRY.
              cl_salv_table=>factory(
                        IMPORTING
                            r_salv_table = go_alv_table
                        CHANGING
                            t_table = gt_vbap ).

              go_alv_table->display( ).

            CATCH cx_salv_msg INTO lo_exp_salv.
              lv_message = lo_exp_salv->get_text( ).
              MESSAGE lv_message TYPE 'E'.
          ENDTRY.
        ENDIF.
        "we catch the exception we raised in get_item_data method if fetching data from vbap does not go well
      CATCH lcx_exp INTO lo_exp.
        lv_message = lo_exp->get_text( ).
        MESSAGE lv_message TYPE 'E'.
    ENDTRY.

  ENDIF.
