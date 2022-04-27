*&---------------------------------------------------------------------*
*& Include          ZHOSPITAL_MANAGEMENT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SHOW_RECORDS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM show_records .

*  IF gv_bill_id IS NOT INITIAL.
*    SELECT *
*      FROM zzel_bill
*      INTO TABLE gt_data
*      WHERE bill_id = gv_bill_id
*      AND bill_amount BETWEEN gv_bill_amt_low AND gv_bill_amt_high.
*
*    IF gv_bill_amt_high IS INITIAL OR gv_bill_amt_low IS INITIAL.
*      SELECT *
*        FROM zzel_bill
*        INTO TABLE gt_data
*        WHERE bill_id = gv_bill_id.
*    ENDIF.
*
*  ELSE.
*
*    SELECT *
*       FROM zzel_bill
*       INTO TABLE gt_data
*       WHERE  bill_amount BETWEEN gv_bill_amt_low AND gv_bill_amt_high.
*
*    IF gv_bill_amt_high IS INITIAL OR gv_bill_amt_low IS INITIAL.
*      SELECT *
*        FROM zzel_bill
*        INTO TABLE gt_data.
*    ENDIF.
*
*  ENDIF.

*  DATA: lt_filter TYPE STANDARD TABLE OF ty_bill WITH KEY bill_id.
*
*
*  IF gv_bill_id IS NOT INITIAL AND ( gv_bill_amt_high IS INITIAL OR gv_bill_amt_low IS INITIAL ).
*    lt_filter = FILTER #( gt_data USING KEY bill_id WHERE bill_id = gv_bill_id ).
*
*  ELSEIF gv_bill_id IS NOT INITIAL AND ( gv_bill_amt_high IS NOT INITIAL OR gv_bill_amt_low IS NOT INITIAL ).
*    lt_filter = FILTER #( gt_data USING KEY bill_id WHERE bill_id = gv_bill_id AND bill_amount GE gv_bill_amt_low AND bill_amount LE gv_bill_amt_high ).
*
*  ELSE.
*    lt_filter = FILTER #( gt_data USING KEY bill_id WHERE bill_amount GE gv_bill_amt_low AND bill_amount LE gv_bill_amt_high ).
*    "
*  ENDIF.


  DATA: ls_filter LIKE LINE OF gt_file_tab.
  CLEAR gt_data.

  IF gv_bill_id IS NOT INITIAL.

    IF gv_bill_amt_high IS INITIAL OR gv_bill_amt_low IS INITIAL.
      LOOP AT gt_file_tab INTO ls_filter WHERE bill_id = gv_bill_id.

        APPEND ls_filter TO gt_data.
        CLEAR: ls_filter.

      ENDLOOP.
    ELSE.
      LOOP AT gt_file_tab INTO ls_filter WHERE bill_id = gv_bill_id AND ( bill_amount GE gv_bill_amt_low AND bill_amount LE gv_bill_amt_high ).

        APPEND ls_filter TO gt_data.
        CLEAR: ls_filter.

      ENDLOOP.
    ENDIF.
  ELSE.

    IF gv_bill_amt_high IS INITIAL OR gv_bill_amt_low IS INITIAL.
      LOOP AT gt_file_tab INTO ls_filter.

        APPEND ls_filter TO gt_data.
        CLEAR: ls_filter.

      ENDLOOP.
    ELSE.
      LOOP AT gt_file_tab INTO ls_filter WHERE bill_amount GE gv_bill_amt_low AND bill_amount LE gv_bill_amt_high.

        APPEND ls_filter TO gt_data.
        CLEAR: ls_filter.

      ENDLOOP.
    ENDIF.
  ENDIF.

  cl_demo_output=>display( gt_data ).


ENDFORM.

*&---------------------------------------------------------------------*
*& Form DELETE_RECORD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_record .
  DATA popup_return TYPE c.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = TEXT-t01 "confirm deletion
      text_question         = TEXT-t02 "do you really want to delete this record?
      text_button_1         = 'Yes'
      text_button_2         = 'No'
      default_button        = '1'
      display_cancel_button = 'X'
    IMPORTING
      answer                = popup_return " to hold the FM's return value
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*      IF popup_return EQ '1'.
*        LEAVE.
*      ENDIF.

  IF popup_return EQ '1'.
    LEAVE.
*    DELETE zzel_bill FROM gs_data.
    DELETE gt_data where bill_id = gs_data-bill_id.
    IF sy-subrc IS INITIAL.
      COMMIT WORK AND WAIT.
      cl_demo_output=>display( gt_data ).
      MESSAGE 'Record deleted successfully.' TYPE 'S'.
      PERFORM update_sts_record_del.
    ELSE.
      MESSAGE 'There was a problem while trying to delete the record. ' TYPE 'I'.
    ENDIF.

  ELSE.
    LEAVE.
  ENDIF.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form create_records200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_records300 .
  CLEAR gs_data.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = 'Z1'
      object                  = 'ZEL_RANGE'
*     QUANTITY                = '1'
*     SUBOBJECT               = ' '
*     TOYEAR                  = '0000'
*     IGNORE_BUFFER           = ' '
    IMPORTING
      number                  = gv_billid
*     QUANTITY                =
*     RETURNCODE              =
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


*  SELECT SINGLE *
*      FROM zzel_bill
*      INTO CORRESPONDING FIELDS OF gs_data.

  IF sy-subrc = 0.

    CLEAR gs_data.

    SELECT SINGLE *
    FROM zzel_bill
    INTO CORRESPONDING FIELDS OF gs_data
    WHERE patient_id = gv_pat_id
    AND patient_name = gv_pat_name
    AND patient_gen = gv_pat_gen
    AND patient_adr = gv_pat_adr
    AND doctor_name = gv_doc_name
    AND bill_amount = gv_amount
    AND cuky = gv_cuky.

    gs_data-bill_id = gv_billid.
    gs_data-patient_id = gv_pat_id.
    gs_data-patient_name = gv_pat_name.
    gs_data-patient_gen = gv_pat_gen.
    gs_data-patient_adr = gv_pat_adr.
    gs_data-doctor_name = gv_doc_name.
    gs_data-bill_amount =  gv_amount.
    gs_data-cuky = gv_cuky.

    INSERT INTO zzel_bill
    VALUES gs_data.

    MESSAGE 'Record insterted successfully!' TYPE 'I'.
    PERFORM update_sts_record_cre.
    CLEAR gs_data.
  ENDIF.


ENDFORM.

*----------------------------------------------------------------------*
*   INCLUDE TABLECONTROL_FORMS                                         *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  USER_OK_TC                                               *
*&---------------------------------------------------------------------*
FORM user_ok_tc USING    p_tc_name TYPE dynfnam
                         p_table_name
                         p_mark_name
                CHANGING p_ok      LIKE sy-ucomm.

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA: l_ok     TYPE sy-ucomm,
        l_offset TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

*&SPWIZARD: Table control specific operations                          *
*&SPWIZARD: evaluate TC name and operations                            *
  SEARCH p_ok FOR p_tc_name.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
  l_offset = strlen( p_tc_name ) + 1.
  l_ok = p_ok+l_offset.
*&SPWIZARD: execute general and TC specific operations                 *
  CASE l_ok.
    WHEN 'INSR'.                      "insert row
      PERFORM fcode_insert_row USING    p_tc_name
                                        p_table_name.
      CLEAR p_ok.

    WHEN 'DELE'.                      "delete row
      PERFORM fcode_delete_row USING    p_tc_name
                                        p_table_name
                                        p_mark_name.
      CLEAR p_ok.

    WHEN 'P--' OR                     "top of list
         'P-'  OR                     "previous page
         'P+'  OR                     "next page
         'P++'.                       "bottom of list
      PERFORM compute_scrolling_in_tc USING p_tc_name
                                            l_ok.
      CLEAR p_ok.
*     WHEN 'L--'.                       "total left
*       PERFORM FCODE_TOTAL_LEFT USING P_TC_NAME.
*
*     WHEN 'L-'.                        "column left
*       PERFORM FCODE_COLUMN_LEFT USING P_TC_NAME.
*
*     WHEN 'R+'.                        "column right
*       PERFORM FCODE_COLUMN_RIGHT USING P_TC_NAME.
*
*     WHEN 'R++'.                       "total right
*       PERFORM FCODE_TOTAL_RIGHT USING P_TC_NAME.
*
    WHEN 'MARK'.                      "mark all filled lines
      PERFORM fcode_tc_mark_lines USING p_tc_name
                                        p_table_name
                                        p_mark_name   .
      CLEAR p_ok.

    WHEN 'DMRK'.                      "demark all filled lines
      PERFORM fcode_tc_demark_lines USING p_tc_name
                                          p_table_name
                                          p_mark_name .
      CLEAR p_ok.

*     WHEN 'SASCEND'   OR
*          'SDESCEND'.                  "sort column
*       PERFORM FCODE_SORT_TC USING P_TC_NAME
*                                   l_ok.

  ENDCASE.

ENDFORM.                              " USER_OK_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_INSERT_ROW                                         *
*&---------------------------------------------------------------------*
FORM fcode_insert_row
              USING    p_tc_name           TYPE dynfnam
                       p_table_name             .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_lines_name       LIKE feld-name.
  DATA l_selline          LIKE sy-stepl.
  DATA l_lastline         TYPE i.
  DATA l_line             TYPE i.
  DATA l_table_name       LIKE feld-name.
  FIELD-SYMBOLS <tc>                 TYPE cxtab_control.
  FIELD-SYMBOLS <table>              TYPE STANDARD TABLE.
  FIELD-SYMBOLS <lines>              TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: get looplines of TableControl                              *
  CONCATENATE 'G_' p_tc_name '_LINES' INTO l_lines_name.
  ASSIGN (l_lines_name) TO <lines>.

*&SPWIZARD: get current line                                           *
  GET CURSOR LINE l_selline.
  IF sy-subrc <> 0.                   " append line to table
    l_selline = <tc>-lines + 1.
*&SPWIZARD: set top line                                               *
    IF l_selline > <lines>.
      <tc>-top_line = l_selline - <lines> + 1 .
    ELSE.
      <tc>-top_line = 1.
    ENDIF.
  ELSE.                               " insert line into table
    l_selline = <tc>-top_line + l_selline - 1.
    l_lastline = <tc>-top_line + <lines> - 1.
  ENDIF.
*&SPWIZARD: set new cursor line                                        *
  l_line = l_selline - <tc>-top_line + 1.

*&SPWIZARD: insert initial line                                        *
  INSERT INITIAL LINE INTO <table> INDEX l_selline.
  <tc>-lines = <tc>-lines + 1.
*&SPWIZARD: set cursor                                                 *
  SET CURSOR 1 l_line.

ENDFORM.                              " FCODE_INSERT_ROW

*&---------------------------------------------------------------------*
*&      Form  FCODE_DELETE_ROW                                         *
*&---------------------------------------------------------------------*
FORM fcode_delete_row
              USING    p_tc_name           TYPE dynfnam
                       p_table_name
                       p_mark_name   .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: delete marked lines                                        *
  DESCRIBE TABLE <table> LINES <tc>-lines.

  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    IF <mark_field> = 'X'.
      DELETE <table> INDEX syst-tabix.
      IF sy-subrc = 0.
        <tc>-lines = <tc>-lines - 1.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.                              " FCODE_DELETE_ROW

*&---------------------------------------------------------------------*
*&      Form  COMPUTE_SCROLLING_IN_TC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*      -->P_OK       ok code
*----------------------------------------------------------------------*
FORM compute_scrolling_in_tc USING    p_tc_name
                                      p_ok.
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_tc_new_top_line     TYPE i.
  DATA l_tc_name             LIKE feld-name.
  DATA l_tc_lines_name       LIKE feld-name.
  DATA l_tc_field_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <lines>      TYPE i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.
*&SPWIZARD: get looplines of TableControl                              *
  CONCATENATE 'G_' p_tc_name '_LINES' INTO l_tc_lines_name.
  ASSIGN (l_tc_lines_name) TO <lines>.


*&SPWIZARD: is no line filled?                                         *
  IF <tc>-lines = 0.
*&SPWIZARD: yes, ...                                                   *
    l_tc_new_top_line = 1.
  ELSE.
*&SPWIZARD: no, ...                                                    *
    CALL FUNCTION 'SCROLLING_IN_TABLE'
      EXPORTING
        entry_act      = <tc>-top_line
        entry_from     = 1
        entry_to       = <tc>-lines
        last_page_full = 'X'
        loops          = <lines>
        ok_code        = p_ok
        overlapping    = 'X'
      IMPORTING
        entry_new      = l_tc_new_top_line
      EXCEPTIONS
*       NO_ENTRY_OR_PAGE_ACT  = 01
*       NO_ENTRY_TO    = 02
*       NO_OK_CODE_OR_PAGE_GO = 03
        OTHERS         = 0.
  ENDIF.

*&SPWIZARD: get actual tc and column                                   *
  GET CURSOR FIELD l_tc_field_name
             AREA  l_tc_name.

  IF syst-subrc = 0.
    IF l_tc_name = p_tc_name.
*&SPWIZARD: et actual column                                           *
      SET CURSOR FIELD l_tc_field_name LINE 1.
    ENDIF.
  ENDIF.

*&SPWIZARD: set the new top line                                       *
  <tc>-top_line = l_tc_new_top_line.


ENDFORM.                              " COMPUTE_SCROLLING_IN_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_MARK_LINES
*&---------------------------------------------------------------------*
*       marks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM fcode_tc_mark_lines USING p_tc_name
                               p_table_name
                               p_mark_name.
*&SPWIZARD: EGIN OF LOCAL DATA-----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: mark all filled lines                                      *
  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    <mark_field> = 'X'.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_DEMARK_LINES
*&---------------------------------------------------------------------*
*       demarks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM fcode_tc_demark_lines USING p_tc_name
                                 p_table_name
                                 p_mark_name .
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA l_table_name       LIKE feld-name.

  FIELD-SYMBOLS <tc>         TYPE cxtab_control.
  FIELD-SYMBOLS <table>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <wa>.
  FIELD-SYMBOLS <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (p_tc_name) TO <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE p_table_name '[]' INTO l_table_name. "table body
  ASSIGN (l_table_name) TO <table>.                "not headerline

*&SPWIZARD: demark all filled lines                                    *
  LOOP AT <table> ASSIGNING <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT p_mark_name OF STRUCTURE <wa> TO <mark_field>.

    <mark_field> = space.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines
*&---------------------------------------------------------------------*
*& Form modify_record110
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_record210.

  IF gs_data NE gs_temp.
*    MODIFY zzel_bill
*    FROM gs_data.
    MODIFY gt_data
    FROM gs_data.
    IF sy-subrc = 0.
      cl_demo_output=>display( gt_data ).
      MESSAGE 'Record modified successfully!' TYPE 'S'.
      PERFORM update_sts_record_mod.
    ENDIF.

  ELSE.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_sts_record_mod
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_sts_record_mod .
  DATA: gs_sts TYPE zzel_status.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = 'Z2'
      object                  = 'ZEL_RANGE'
*     QUANTITY                = '1'
*     SUBOBJECT               = ' '
*     TOYEAR                  = '0000'
*     IGNORE_BUFFER           = ' '
    IMPORTING
      number                  = gs_sts-status_id
*     QUANTITY                =
*     RETURNCODE              =
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  gs_sts-changed_bill_id = gs_data-bill_id.
  gs_sts-sts_date = sy-datum.
  gs_sts-sts_time = sy-uzeit.

  INSERT INTO zzel_status VALUES gs_sts.
  COMMIT WORK AND WAIT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_sts_record_del
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_sts_record_del .
  DATA: gs_sts TYPE zzel_status.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = 'Z2'
      object                  = 'ZEL_RANGE'
*     QUANTITY                = '1'
*     SUBOBJECT               = ' '
*     TOYEAR                  = '0000'
*     IGNORE_BUFFER           = ' '
    IMPORTING
      number                  = gs_sts-status_id
*     QUANTITY                =
*     RETURNCODE              =
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  gs_sts-deleted_bill_id = gs_data-bill_id.
  gs_sts-sts_date = sy-datum.
  gs_sts-sts_time = sy-uzeit.

  INSERT INTO zzel_status VALUES gs_sts.
  COMMIT WORK AND WAIT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_sts_record_cre
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_sts_record_cre .
  DATA: gs_sts TYPE zzel_status.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = 'Z2'
      object                  = 'ZEL_RANGE'
*     QUANTITY                = '1'
*     SUBOBJECT               = ' '
*     TOYEAR                  = '0000'
*     IGNORE_BUFFER           = ' '
    IMPORTING
      number                  = gs_sts-status_id
*     QUANTITY                =
*     RETURNCODE              =
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  gs_sts-created_bill_id = gs_data-bill_id.
  gs_sts-sts_date = sy-datum.
  gs_sts-sts_time = sy-uzeit.

  INSERT INTO zzel_status VALUES gs_sts.
  COMMIT WORK AND WAIT.

ENDFORM.
