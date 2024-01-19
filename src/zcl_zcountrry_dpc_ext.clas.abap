class ZCL_ZCOUNTRRY_DPC_EXT definition
  public
  inheriting from ZCL_ZCOUNTRRY_DPC
  create public .

public section.
protected section.

  methods COUNTRYSET_GET_ENTITY
    redefinition .
  methods COUNTRYSET_GET_ENTITYSET
    redefinition .
  methods DETAILSET_GET_ENTITY
    redefinition .
  methods COUNTRYSET_CREATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZCOUNTRRY_DPC_EXT IMPLEMENTATION.


  METHOD countryset_create_entity.
    DATA: ls_data TYPE zcl_zcountrry_mpc=>ts_country.

    CALL METHOD io_data_provider->read_entry_data
      IMPORTING
        es_data = ls_data.

    DATA ls_country TYPE zcountry_db.
    MOVE-CORRESPONDING ls_data TO ls_country.
    ls_country-mandt           = '100'.
    ls_country-dimension       = 'COUNTRY'.
    ls_country-parentdimension = 'REGION'.

    INSERT zcountry_db FROM ls_country.
  ENDMETHOD.


  METHOD countryset_get_entity.

    DATA(trackcode) = CONV numc10( it_key_tab[ name = 'Code' ]-value ).

    SELECT SINGLE * FROM zonlab2_view INTO CORRESPONDING FIELDS OF er_entity
      WHERE code = trackcode.

  ENDMETHOD.


  METHOD countryset_get_entityset.
    DATA:
     country_selopt TYPE rsdsselopt_t.

    LOOP AT it_filter_select_options ASSIGNING FIELD-SYMBOL(<filter>).
      CASE <filter>-property.
        WHEN 'Title'.
          country_selopt = VALUE #( FOR selopt IN <filter>-select_options
            ( sign = selopt-sign option = selopt-option low = selopt-low high = selopt-high )
          ).
      ENDCASE.
    ENDLOOP.

    SELECT * FROM zcountry_db INTO CORRESPONDING FIELDS OF TABLE et_entityset
      WHERE title IN country_selopt.

    SORT et_entityset BY cntryflag DESCENDING.

  ENDMETHOD.


  METHOD detailset_get_entity.
    DATA(trackcode) = it_key_tab[ name = 'Code' ]-value .

    SELECT SINGLE * FROM ZONLAB2_VIEW INTO CORRESPONDING FIELDS OF er_entity
      WHERE code = trackcode.
**ENDTRY.
  ENDMETHOD.
ENDCLASS.
