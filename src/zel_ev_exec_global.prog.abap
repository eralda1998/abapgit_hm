*&---------------------------------------------------------------------*
*& Report ZEL_EV_EXEC_GLOBAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zel_ev_exec_global.


PARAMETERS: p_vbeln TYPE vbak-vbeln.

DATA: lo_class TYPE REF TO zcl_sales_doc.

DATA: gs_vbak     TYPE vbak,
      gt_vbap     TYPE TABLE OF vbap,
      gs_vbap     LIKE LINE OF gt_vbap,
      lo_exp      TYPE REF TO zcx_exp_el,
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
      CATCH zcx_exp_el INTO lo_exp.
        lv_message = lo_exp->get_text( ).
        MESSAGE lv_message TYPE 'E'.

    ENDTRY.

  ENDIF.
