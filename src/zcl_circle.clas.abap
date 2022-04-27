CLASS zcl_circle DEFINITION
  PUBLIC
  INHERITING FROM zcl_shape
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: co_pi TYPE p DECIMALS 2 VALUE '3.14'.

    METHODS:
      constructor IMPORTING iv_rad TYPE i,
      initialize_name_circle RETURNING VALUE(rv_string) TYPE string,
      calc_area REDEFINITION,
      calc_perimeter REDEFINITION,
      tostring REDEFINITION.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      mv_rad       TYPE i,
      mv_perimeter TYPE p DECIMALS 2,
      mv_area      TYPE p DECIMALS 2,
      mv_string    TYPE string.
ENDCLASS.



CLASS ZCL_CIRCLE IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).
    me->mv_rad = iv_rad.
  ENDMETHOD.


  METHOD initialize_name_circle.

    set_type(
        EXPORTING
          iv_type = 'CIRCLE' ).

    set_title(
        EXPORTING
          iv_title = 'This is a circle!' ).

    DATA(lv_m1) = get_type( ).
    DATA(lv_m2) = get_title( ).

    CONCATENATE  lv_m1 lv_m2 INTO rv_string SEPARATED BY space.

  ENDMETHOD.


  METHOD calc_area.
    me->mv_area = co_pi * me->mv_rad * me->mv_rad.
    rv_area = me->mv_area.
  ENDMETHOD.


  METHOD calc_perimeter.
    me->mv_perimeter = 2 * co_pi * me->mv_rad.
    rv_perimeter = me->mv_perimeter.
  ENDMETHOD.


  METHOD tostring.
    rv_string = |I am a circle with radius: { me->mv_rad }. My perimeter is: { calc_perimeter( ) } and area is: { calc_area( ) }.|.
  ENDMETHOD.
ENDCLASS.
