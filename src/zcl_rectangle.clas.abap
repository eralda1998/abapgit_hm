class ZCL_RECTANGLE definition
  public
  inheriting from ZCL_SHAPE
  create public

  global friends ZCL_SQUARE .

public section.

  methods CONSTRUCTOR
    importing
      !IV_A type I
      !IV_B type I .
  methods INITIALIZE_NAME_RECTANGLE
    returning
      value(RV_STRING) type STRING .

  methods ZIF_SHAPE~CALC_AREA
    redefinition .
  methods ZIF_SHAPE~CALC_PERIMETER
    redefinition .
  methods ZIF_TOSTRING_EL~TOSTRING
    redefinition .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      mv_perimeter TYPE p DECIMALS 2,
      mv_area      TYPE p DECIMALS 2,
      mv_string    TYPE string,
      mv_a         TYPE i,
      mv_b         TYPE i.

ENDCLASS.



CLASS ZCL_RECTANGLE IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).
    me->mv_a = iv_a.
    me->mv_b = iv_b.
  ENDMETHOD.


  METHOD initialize_name_rectangle.
    set_type(
      EXPORTING
         iv_type = 'RECTANGLE' ).

    set_title(
      EXPORTING
         iv_title = 'This is a rectangle!' ).

    DATA(lv_m1) = get_type( ).
    DATA(lv_m2) = get_title( ).
    CONCATENATE  lv_m1 lv_m2 INTO rv_string SEPARATED BY space.
  ENDMETHOD.


  METHOD calc_area.
    me->mv_area = me->mv_a * me->mv_b.
    rv_area = me->mv_area.
  ENDMETHOD.


  METHOD calc_perimeter.
    me->mv_perimeter = 2 * ( me->mv_a + me->mv_b ).
    rv_perimeter = me->mv_perimeter.
  ENDMETHOD.


  METHOD tostring.
    rv_string = |I am a rectangle with a: { me->mv_a } and b: { me->mv_b }. My perimeter is : { calc_perimeter( ) } and area is: { calc_area( ) }.|.
  ENDMETHOD.
ENDCLASS.
