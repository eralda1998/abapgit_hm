*&---------------------------------------------------------------------*
*& Include          ZHOSPITAL_MANAGEMENT_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE ok_code.
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'BTN_DISPLAY'.
      CLEAR ok_code.
      PERFORM show_records.

    WHEN 'BTN_CREATE'.
      CLEAR ok_code.
      CALL SCREEN '0300'.


  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.

  CASE ok_code.
    WHEN  'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'BACK'.
      LEAVE TO SCREEN '0200'.
    WHEN 'BTN_CREATE300'.
      CLEAR ok_code.
      PERFORM create_records300.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  FIELD_SELECTION  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE field_selection INPUT.

  CASE ok_code.
    WHEN 'BTN_DELETE'.
      CLEAR ok_code.
      PERFORM delete_record.
    WHEN 'BTN_MODIFY'.
      CLEAR ok_code.
      gs_temp = gs_data.
      CALL SCREEN '0210' STARTING AT 10 03 ENDING AT 70 15.

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'TC'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: PROCESS USER COMMAND
MODULE tc_user_command INPUT.
  ok_code = sy-ucomm.
  PERFORM user_ok_tc USING    'TC'
                              'GT_DATA'
                              ' '
                     CHANGING ok_code.
  sy-ucomm = ok_code.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0210  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0210 INPUT.
  CASE ok_code.
    WHEN 'ENTER'.
      CLEAR ok_code.
      PERFORM modify_record210.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      CLEAR ok_code.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BTN_CSV_DISP'.
      CLEAR ok_code.
      CALL SCREEN '0200'.
*  	WHEN ''.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
