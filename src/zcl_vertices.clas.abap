CLASS zcl_vertices DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS: constructor,
      get_vertice RETURNING VALUE(rv_vertice) TYPE string.

    CLASS-METHODS:
      get_instances RETURNING VALUE(rv_instances) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mv_vertice     TYPE string VALUE 'A square has 4 VERTICES (this is to demostrate composition)'.

    CLASS-DATA: sv_num TYPE i VALUE IS INITIAL.
ENDCLASS.



CLASS ZCL_VERTICES IMPLEMENTATION.


  METHOD constructor.
    sv_num = sv_num + 1.
  ENDMETHOD.


  METHOD get_instances.
    rv_instances = sv_num.
  ENDMETHOD.


  METHOD get_vertice.
    rv_vertice = me->mv_vertice.
  ENDMETHOD.
ENDCLASS.
