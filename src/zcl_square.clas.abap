CLASS zcl_square DEFINITION
  PUBLIC
  INHERITING FROM zcl_square_abs
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      get_perimeter REDEFINITION.

    METHODS: display IMPORTING
                               io_vertice        TYPE REF TO zcl_vertices
                     RETURNING VALUE(rv_vertice) TYPE string.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SQUARE IMPLEMENTATION.


  METHOD display.
*    CREATE OBJECT io_vertice.
    rv_vertice = io_vertice->get_vertice( ).
  ENDMETHOD.


  METHOD get_perimeter.
    DATA(lo_square) = NEW zcl_rectangle( iv_a = 10 iv_b = 10 ).

    lo_square->mv_perimeter = 4 * lo_square->mv_a.
    rv_per = lo_square->mv_perimeter.
  ENDMETHOD.
ENDCLASS.
