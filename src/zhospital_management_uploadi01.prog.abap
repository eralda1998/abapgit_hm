*----------------------------------------------------------------------*
***INCLUDE ZHOSPITAL_MANAGEMENT_UPLOADI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  UPLOAD_CSV  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE upload_csv INPUT.

*  fname = p_csv_file.
  CLEAR gt_file_tab.
  DATA: lftab    TYPE filetable,
        lrcount  TYPE i,
        luaction TYPE i.


  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = 'Select File name and directory'
*     default_extension       =
*     default_filename        =
*     file_filter             =
*     with_encoding           =
*     initial_directory       =
*     multiselection          = abap_true
    CHANGING
      file_table              = lftab
      rc                      = lrcount  "no of records selected
      user_action             = luaction "if user do not select and select cancel(9)
*     file_encoding           =
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.

  IF luaction NE 9.
    READ TABLE lftab INDEX 1 INTO p_csv_file.

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = p_csv_file
*        filetype                = 'ASC'
*       has_field_separator     = abap_true
*       header_length           = 0
*       read_by_line            = 'X'
*       dat_mode                = SPACE
*       codepage                = SPACE
*       ignore_cerr             = ABAP_TRUE
*       replacement             = '#'
*       virus_scan_profile      =
*  IMPORTING
*       filelength              =
*       header                  =
      CHANGING
        data_tab                = utab
*       isscanperformed         = SPACE
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

*    cl_demo_output=>display( utab ).
    DATA: lt_records TYPE TABLE OF char100.
    CONSTANTS: colon VALUE ':'.

    LOOP AT utab ASSIGNING FIELD-SYMBOL(<fs_utab>).
      CLEAR lt_records[].

      APPEND INITIAL LINE TO gt_file_tab ASSIGNING FIELD-SYMBOL(<fs_record>)."append initial line to target table

      SPLIT <fs_utab> AT colon INTO TABLE lt_records.

      LOOP AT lt_records ASSIGNING FIELD-SYMBOL(<fs_data>).
        CASE sy-tabix.
          WHEN 1.
            <fs_record>-mandt = <fs_data>.
          WHEN 2.
            <fs_record>-bill_id = <fs_data>.
          WHEN 3.
            <fs_record>-patient_id = <fs_data>.
          WHEN 4.
            <fs_record>-patient_name = <fs_data>.
          WHEN 5.
            <fs_record>-patient_gen = <fs_data>.
          WHEN 6.
            <fs_record>-patient_adr = <fs_data>.
          WHEN 7.
            <fs_record>-doctor_name = <fs_data>.
          WHEN 8.
            <fs_record>-bill_amount = <fs_data>.
          WHEN 9.
            <fs_record>-cuky = <fs_data>.

        ENDCASE.
      ENDLOOP.
    ENDLOOP.
    cl_demo_output=>display( gt_file_tab ).

  ELSE.
    MESSAGE 'User Cancelled Action' TYPE 'I'.
  ENDIF.




ENDMODULE.
