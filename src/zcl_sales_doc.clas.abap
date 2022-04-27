class ZCL_SALES_DOC definition
  public
  final
  create public .

public section.

  data AV_DATE type DATUM .
  data AV_AUART type VBAK-AUART .

  events NO_SALES_DOC .

  methods GET_HEADER_DATA
    importing
      !IV_VBELN type VBELN
    exporting
      !ES_VBAK type VBAK .
  methods GET_ITEM_DATA
    importing
      !IS_VBAK type VBAK
    exporting
      !ET_VBAP type ZEL_VBAP_TT
    raising
      ZCX_EXP_EL .
  methods NO_SALES_DOC_METH
    for event NO_SALES_DOC of ZCL_SALES_DOC .
  methods CONSTRUCTOR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SALES_DOC IMPLEMENTATION.


  method CONSTRUCTOR.
        av_auart = 'TA'.
  endmethod.


  METHOD get_header_data.

    IF iv_vbeln IS INITIAL.
      RAISE EVENT no_sales_doc.
    ELSE.
      SELECT SINGLE *
      FROM vbak
      INTO es_vbak
      WHERE vbeln = iv_vbeln
        AND auart = av_auart.

      av_date = es_vbak-erdat.
    ENDIF.

  ENDMETHOD.


  method GET_ITEM_DATA.

        SELECT * FROM vbap
      INTO TABLE et_vbap
      WHERE vbeln = is_vbak-vbeln.

    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_exp_el.
    ENDIF.

  endmethod.


  METHOD no_sales_doc_meth.
    MESSAGE: 'No sales document!!!' TYPE 'I'.
  ENDMETHOD.
ENDCLASS.
