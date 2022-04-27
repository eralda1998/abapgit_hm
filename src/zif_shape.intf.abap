INTERFACE zif_shape
  PUBLIC .
  INTERFACES: zif_tostring_el.
  ALIASES: tostring FOR zif_tostring_el~tostring.
  METHODS:
    calc_area RETURNING VALUE(rv_area) TYPE i,
    calc_perimeter RETURNING VALUE(rv_perimeter) TYPE i.

ENDINTERFACE.
