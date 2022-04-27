class ZCL_SHAPE definition
  public
  create public .

public section.

  interfaces ZIF_TOSTRING_EL .
  interfaces ZIF_SHAPE .

  aliases CALC_AREA
    for ZIF_SHAPE~CALC_AREA .
  aliases CALC_PERIMETER
    for ZIF_SHAPE~CALC_PERIMETER .
  aliases TOSTRING
    for ZIF_SHAPE~TOSTRING .

  methods CONSTRUCTOR .
  methods GET_TYPE
    returning
      value(RV_TYPE) type STRING .
  methods SET_TYPE
    importing
      !IV_TYPE type STRING .
  methods GET_TITLE
    returning
      value(RV_TITLE) type STRING .
  methods SET_TITLE
    importing
      !IV_TITLE type STRING .
  PROTECTED SECTION.
    DATA: mv_type  TYPE string,
          mv_title TYPE string.
ENDCLASS.



CLASS ZCL_SHAPE IMPLEMENTATION.


  METHOD calc_area.
  ENDMETHOD.


  METHOD calc_perimeter.
  ENDMETHOD.


  METHOD constructor.
  ENDMETHOD.


  METHOD get_title.
    rv_title = me->mv_title.
  ENDMETHOD.


  METHOD get_type.
    rv_type = me->mv_type.
  ENDMETHOD.


  METHOD set_title.
    me->mv_title = iv_title.
  ENDMETHOD.


  METHOD set_type.
    me->mv_type = iv_type.
  ENDMETHOD.


  METHOD tostring.
  ENDMETHOD.
ENDCLASS.
