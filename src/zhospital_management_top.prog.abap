*&---------------------------------------------------------------------*
*& Include ZHOSPITAL_MANAGEMENT_TOP                 - Module Pool      ZHOSPITAL_MANAGEMENT
*&---------------------------------------------------------------------*
PROGRAM zhospital_management.

DATA: ok_code          TYPE sy-ucomm,
      gv_bill_id       TYPE zzel_bill-bill_id,
      gv_bill_amt_low  TYPE zzel_bill-bill_amount VALUE 0,
      gv_bill_amt_high TYPE zzel_bill-bill_amount VALUE 9999,
      gv_billid        TYPE zzel_bill-bill_id,
      gv_pat_id        TYPE zzel_bill-patient_id,
      gv_pat_name      TYPE zzel_bill-patient_name,
      gv_pat_gen       TYPE zzel_bill-patient_gen,
      gv_pat_adr       TYPE zzel_bill-patient_adr,
      gv_doc_name      TYPE zzel_bill-doctor_name,
      gv_amount        TYPE zzel_bill-bill_amount,
      gv_cuky          TYPE zzel_bill-cuky,
      gv_mark          TYPE char1. "to mark the selected row


TYPES: BEGIN OF ty_bill,
         mandt        TYPE mandt,
         bill_id      TYPE zzel_bill-bill_id,
         patient_id   TYPE zzel_bill-patient_id,
         patient_name TYPE zzel_bill-patient_name,
         patient_gen  TYPE zzel_bill-patient_gen,
         patient_adr  TYPE zzel_bill-patient_adr,
         doctor_name  TYPE zzel_bill-doctor_name,
         bill_amount  TYPE zzel_bill-bill_amount,
         cuky         TYPE zzel_bill-cuky,
       END OF ty_bill.

DATA: gt_data TYPE TABLE OF ty_bill,
      gs_data LIKE LINE OF  gt_data.

DATA: gs_temp     LIKE LINE OF gt_data,
      gt_file_tab TYPE TABLE OF ty_bill.


DATA: fname      TYPE string,
      utab       TYPE TABLE OF char300,
      p_csv_file TYPE string.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC' ITSELF
CONTROLS: tc TYPE TABLEVIEW USING SCREEN 0200.

*&SPWIZARD: LINES OF TABLECONTROL 'TC'
DATA:     g_tc_lines  LIKE sy-loopc.
