*&---------------------------------------------------------------------*
*& Include          ZHOSPITAL_MANAGEMENT_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
 SET PF-STATUS 'ZSTATUS'.
 SET TITLEBAR 'HOSPITAL MANAGEMENT'.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module STATUS_0210 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0210 OUTPUT.
 SET PF-STATUS 'ZMODAL'.
 SET TITLEBAR 'MODIFY RECORD'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
 SET PF-STATUS 'ZSTATUS'.
 SET TITLEBAR 'CREATE RECORDS'.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TC'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE TC_CHANGE_TC_ATTR OUTPUT.
  DESCRIBE TABLE GT_DATA LINES TC-lines.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TC'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GET LINES OF TABLECONTROL
MODULE TC_GET_LINES OUTPUT.
  G_TC_LINES = SY-LOOPC.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0010 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'ZSTATUS'.
 SET TITLEBAR 'UPLOAD CSV FILE'.
ENDMODULE.
