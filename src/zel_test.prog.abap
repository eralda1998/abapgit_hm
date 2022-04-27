*&---------------------------------------------------------------------*
*& Report ZEL_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEL_TEST.


    DATA popup_return TYPE c.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = text-t03
        text_question         = text-t04
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

    IF popup_return NE '1'.
      LEAVE.
    ENDIF.
