*&---------------------------------------------------------------------*
*& Report ZEL_SHAPE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zel_shape.

"Local interface for returning a string
INTERFACE lif_tostring.
  METHODS: tostring RETURNING VALUE(rv_string) TYPE string.
ENDINTERFACE.

"Nested Local interface for calculating and returning shape's Area and Perimeter
INTERFACE lif_shape.
  INTERFACES: lif_tostring.
  ALIASES: tostring FOR lif_tostring~tostring.
  METHODS:
    calc_area RETURNING VALUE(rv_area) TYPE i,
    calc_perimeter RETURNING VALUE(rv_perimeter) TYPE i.
ENDINTERFACE.

"(SuperClass) Class for the Shape with get and set methods, also methods from the interface
CLASS lcl_shape DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_shape.
    "Aliases for shortage of method name's access
    ALIASES: calc_area FOR lif_shape~calc_area,
             calc_perimeter FOR lif_shape~calc_perimeter,
             tostring FOR lif_shape~tostring.
    METHODS:
      constructor,
      get_type RETURNING VALUE(rv_type) TYPE string ,
      set_type IMPORTING iv_type TYPE string,
      get_title RETURNING VALUE(rv_title) TYPE string,
      set_title IMPORTING iv_title TYPE string.

  PROTECTED SECTION.
    DATA: mv_type  TYPE string,
          mv_title TYPE string.
ENDCLASS.

CLASS lcl_shape IMPLEMENTATION.
  METHOD constructor.
  ENDMETHOD.
  METHOD set_type.
    me->mv_type = iv_type.
  ENDMETHOD.
  METHOD get_type.
    rv_type = me->mv_type.
  ENDMETHOD.
  METHOD set_title.
    me->mv_title = iv_title.
  ENDMETHOD.
  METHOD get_title.
    rv_title = me->mv_title.
  ENDMETHOD.
  METHOD calc_area.
  ENDMETHOD.
  METHOD calc_perimeter.
  ENDMETHOD.
  METHOD tostring.
  ENDMETHOD.

ENDCLASS.


"class circle inherits from superclass shape.
CLASS lcl_circle DEFINITION INHERITING FROM lcl_shape.

  PUBLIC SECTION.

    CONSTANTS: co_pi TYPE p DECIMALS 2 VALUE '3.14'.

    METHODS:
      constructor IMPORTING iv_rad TYPE i,
      initialize_name_circle RETURNING VALUE(rv_string) TYPE string, "access get and set methods of superclass
      "redefines superclass' methods
      calc_area REDEFINITION,
      calc_perimeter REDEFINITION,
      tostring REDEFINITION.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      mv_rad       TYPE i, "radius
      mv_perimeter TYPE p DECIMALS 2,
      mv_area      TYPE p DECIMALS 2,
      mv_string    TYPE string.


ENDCLASS.

CLASS lcl_circle IMPLEMENTATION.
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

  METHOD calc_perimeter.
    me->mv_perimeter = 2 * co_pi * me->mv_rad.
    rv_perimeter = me->mv_perimeter.
  ENDMETHOD.

  METHOD calc_area.
    me->mv_area = co_pi * me->mv_rad * me->mv_rad.
    rv_area = me->mv_area.
  ENDMETHOD.

  METHOD tostring.
    rv_string = |I am a circle with radius: { me->mv_rad }. My perimeter is: { calc_perimeter( ) } and area is: { calc_area( ) }.|.
  ENDMETHOD.
ENDCLASS.





"DEMOSTRATING FRIEND CONCEPT
CLASS lcl_square DEFINITION DEFERRED.

"class rectangle
CLASS lcl_rectangle DEFINITION INHERITING FROM lcl_shape FRIENDS lcl_square .

  PUBLIC SECTION.

    METHODS:
      constructor IMPORTING iv_a TYPE i iv_b TYPE i,
      initialize_name_rectangle RETURNING VALUE(rv_string) TYPE string,
      calc_area REDEFINITION,
      calc_perimeter REDEFINITION,
      tostring REDEFINITION.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      mv_perimeter TYPE p DECIMALS 2,
      mv_area      TYPE p DECIMALS 2,
      mv_string    TYPE string,
      mv_a         TYPE i,
      mv_b         TYPE i.


ENDCLASS.



CLASS lcl_rectangle IMPLEMENTATION.
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

  METHOD calc_perimeter.
    me->mv_perimeter = 2 * ( me->mv_a + me->mv_b ).
    rv_perimeter = me->mv_perimeter.
  ENDMETHOD.

  METHOD calc_area.
    me->mv_area = me->mv_a * me->mv_b.
    rv_area = me->mv_area.
  ENDMETHOD.

  METHOD tostring.
    rv_string = |I am a rectangle with a: { me->mv_a } and b: { me->mv_b }. My perimeter is : { calc_perimeter( ) } and area is: { calc_area( ) }.|.
  ENDMETHOD.
ENDCLASS.


"demostrating abstract class for square that has an abstract method with no implementation
CLASS lcl_square_abs DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      get_perimeter ABSTRACT RETURNING VALUE(rv_per) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_square_abs IMPLEMENTATION.
ENDCLASS.



"demostrating composition of vertices and square (a square has 4 vertices)
CLASS lcl_vertices DEFINITION.
  PUBLIC SECTION.

    METHODS: constructor,
      get_vertice RETURNING VALUE(rv_vertice) TYPE string.

    CLASS-METHODS:
      get_instances RETURNING VALUE(rv_instances) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mv_vertice     TYPE string VALUE 'A square has 4 VERTICES(this is to demostrate composition)'.

    CLASS-DATA: sv_num TYPE i VALUE IS INITIAL. "static data

ENDCLASS.

CLASS lcl_vertices IMPLEMENTATION.
  METHOD constructor.
    "is used for counting instances of this class created
    sv_num = sv_num + 1.
  ENDMETHOD.
  METHOD get_instances.
    "returns the number of counted instances created
    rv_instances = sv_num.
  ENDMETHOD.
  METHOD get_vertice.
    "returns the string 'A square has 4 VERTICES(this is to demostrate composition)'
    rv_vertice = me->mv_vertice.
  ENDMETHOD.
ENDCLASS.



"class square that inherits from abstract class lcl_square_abs, its abstract method
CLASS lcl_square DEFINITION INHERITING FROM lcl_square_abs.
  PUBLIC SECTION.
    METHODS:
      get_perimeter REDEFINITION,

      "importing an object of class lcl_vertices // composition
      display IMPORTING
                        io_vertice        TYPE REF TO lcl_vertices
              RETURNING VALUE(rv_vertice) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_square IMPLEMENTATION.
  METHOD get_perimeter.
    "calculate perimeter of a square by accessing the private member value mv_a of class lcl_rectangle,
    "because lcl_rectangle has granted friendship with lcl_square
    DATA(lo_square) = NEW lcl_rectangle( iv_a = 10 iv_b = 10 ).

    lo_square->mv_perimeter = 4 * lo_square->mv_a.
    rv_per = lo_square->mv_perimeter.
  ENDMETHOD.

  METHOD display.
*   method to display 'A square has 4 VERTICES(this is to demostrate composition)'
    rv_vertice = io_vertice->get_vertice( ).
  ENDMETHOD.
ENDCLASS.



"------------------------------------------------------------------------------------------------------------------------------------------------------------

START-OF-SELECTION.
  "creation of local objects
  DATA(lo_circle) = NEW lcl_circle( iv_rad = 12 ).
  DATA(lo_rectangle) = NEW lcl_rectangle( iv_a = 5 iv_b = 4 ).
  DATA(lo_vertice) = NEW lcl_vertices( ).
  DATA(lo_square) = NEW lcl_square( ).


  WRITE: / lo_circle->initialize_name_circle( )"display header of the circle
        ,/
        ,/ 'Perimeter:', lo_circle->calc_perimeter( )"calculate parameter of the circle
        ,/ 'Area     :', lo_circle->calc_area( )"calculate area of the circle
        ,/ lo_circle->tostring( )"shows a string with informations about the two above
        ,/
        ,/
        ,/ '-------------------------------------------------------------------------------------------------------------------------'
        ,/ lo_rectangle->initialize_name_rectangle( )"display header of the rectangle
        ,/
        ,/ 'Perimeter:', lo_rectangle->calc_perimeter( )"calculate parameter of the rectangle
        ,/ 'Area     :', lo_rectangle->calc_area( )"calculate area of the rectangle
        ,/ lo_rectangle->tostring( )."shows a string with informations about the two above




  WRITE: /'--------------------------------------------------------------------------------------------------------------------------'
        ,/, 'The perimeter of the square is: ',lo_square->get_perimeter( )."shows the perimeter of the square
  WRITE: /, lo_square->display( lo_vertice )."display informations what we got from the composition with zcl_vertices class


  "loop to create 5 objects of class vertices
  DO 5 TIMES.
    DATA(lo_vertice2) = NEW lcl_vertices( ).
    DATA(lv_num) = lcl_vertices=>get_instances( ).
  ENDDO.

  WRITE: /,/ 'There are ',lv_num, 'created vertices(this is to demostrate class components)'.
