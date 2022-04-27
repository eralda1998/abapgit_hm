*&---------------------------------------------------------------------*
*& Report ZEL_SHAPE_GLOBAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zel_shape_global.

START-OF-SELECTION.

"creation of objects
  DATA(lo_circle) = NEW zcl_circle( iv_rad = 12 ).
  DATA(lo_rectangle) = NEW zcl_rectangle( iv_a = 5 iv_b = 4 ).
  DATA(lo_vertice) = NEW zcl_vertices( ).
  DATA(lo_square) = NEW zcl_square( ).


  WRITE: / lo_circle->initialize_name_circle( ) "display header of the circle
        ,/
        ,/ 'Perimeter:', lo_circle->calc_perimeter( ) "calculate parameter of the circle
        ,/ 'Area     :', lo_circle->calc_area( ) "calculate area of the circle
        ,/ lo_circle->tostring( ) "shows a string with informations about the two above
        ,/
        ,/
        ,/ '-------------------------------------------------------------------------------------------------------------------------'
        ,/ lo_rectangle->initialize_name_rectangle( ) "display header of the rectangle
        ,/
        ,/ 'Perimeter:', lo_rectangle->calc_perimeter( )"calculate parameter of the rectangle
        ,/ 'Area     :', lo_rectangle->calc_area( )"calculate area of the rectangle
        ,/ lo_rectangle->tostring( ). "shows a string with informations about the two above




  WRITE: /'--------------------------------------------------------------------------------------------------------------------------'
        ,/, 'The perimeter of the square is: ',lo_square->get_perimeter( ). "shows the perimeter of the square
  WRITE: /, lo_square->display( lo_vertice ). "display informations what we got from the composition with zcl_vertices class


  "loop to create 5 objects of class vertices
  DO 5 TIMES.
    DATA(lo_vertice2) = NEW zcl_vertices( ).
    DATA(lv_num) = zcl_vertices=>get_instances( ).
  ENDDO.

  WRITE: /,/ 'There are ',lv_num, 'created vertices (this is to demostrate class components)'.
