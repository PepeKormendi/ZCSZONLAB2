*&---------------------------------------------------------------------*
*& Report ZCSZ_ONLAB2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCSZ_ONLAB2.



TYPES: BEGIN OF ty_struct,
         id             TYPE char8,
         indicator_code TYPE zindicatorcode,
         spatialdimtype TYPE zdimensiontype,
         spatialdim     TYPE zdimension,
         timedimtype    TYPE zdimensiontype,
         timedim        TYPE zdimension,
         dim1type       TYPE zdimensiontype,
         dim1           TYPE zdimension,
         dim2type       TYPE zdimensiontype,
         dim2           TYPE zdimension,
         value          TYPE zvalue,
         numericvalue   TYPE znumeric,
         low            TYPE zvalue,
         high           TYPE zvalue,
         datee          TYPE zdate,
       END OF ty_struct.


DATA lo_client               TYPE REF TO if_http_client.
DATA lo_part                 TYPE REF TO if_http_entity.
DATA lv_xstring              TYPE xstring.
DATA lv_service_host_country TYPE string.
DATA lv_service_host_whosis  TYPE string.
DATA lv_service_host_bp_03   TYPE string.
DATA lv_service_host_dev20   TYPE string.
DATA lv_service_host_nutover TYPE string.
DATA lv_json_resp_country    TYPE string.
DATA lv_json_resp_whosis     TYPE string.
DATA lv_json_resp_bp_03      TYPE string.
DATA lv_json_resp_dev20      TYPE string.
DATA lv_json_resp_nutover    TYPE string.


DATA: lr_country       TYPE REF TO data,
      lr_nutover       TYPE REF TO data,
      lr_whosis        TYPE REF TO data,
      lr_bp_03         TYPE REF TO data,
      lr_dev20         TYPE REF TO data,
      ls_country       TYPE zcountry_db,
      ls_nutoverweight TYPE znutoverwghtnum,
      ls_whosis        TYPE zwhosis_000001,
      ls_bp_03         TYPE zbp_03,
      ls_devices20     TYPE zdevice20,
      lt_country       TYPE TABLE OF zcountry_db,
      lt_nutoverweight TYPE TABLE OF znutoverwghtnum,
      lt_whosis        TYPE TABLE OF zwhosis_000001,
      lt_bp_03         TYPE TABLE OF zbp_03,
      lt_devices20     TYPE TABLE OF zdevice20.

FIELD-SYMBOLS:
  <data>        TYPE data,
  <results>     TYPE any,
  <structure>   TYPE any,
  <table>       TYPE ANY TABLE,
  <field>       TYPE any,
  <field_value> TYPE data.

"Host kialakítása filterekkel.

lv_service_host_country = 'https://ghoapi.azureedge.net/api/Dimension/Country/DimensionValues'.
*lv_service_host_whosis  = 'https://ghoapi.azureedge.net/api/WHOSIS_000001'.
*lv_service_host_bp_03   = 'https://ghoapi.azureedge.net/api/bp_03'.
*lv_service_host_dev20   = 'https://ghoapi.azureedge.net/api/devices20'.
*lv_service_host_nutover = 'https://ghoapi.azureedge.net/api/NUTOVERWEIGHTNUM'.

PERFORM datamine USING    lv_service_host_country
                 CHANGING lv_json_resp_country.

*PERFORM datamine USING    lv_service_host_bp_03
*                 CHANGING lv_json_resp_bp_03.
*
*PERFORM datamine USING    lv_service_host_dev20
*                 CHANGING lv_json_resp_dev20.
*
*PERFORM datamine USING    lv_service_host_nutover
*                 CHANGING lv_json_resp_nutover.
*
*PERFORM datamine USING    lv_service_host_whosis
*                 CHANGING lv_json_resp_whosis.

PERFORM deserialize USING lv_json_resp_country
                 CHANGING lr_country.

*PERFORM deserialize USING lv_json_resp_bp_03
*                 CHANGING lr_bp_03.
*
*PERFORM deserialize USING lv_json_resp_dev20
*                 CHANGING lr_dev20.
*
*PERFORM deserialize USING lv_json_resp_nutover
*                 CHANGING lr_nutover.
*
*PERFORM deserialize USING lv_json_resp_whosis
*                 CHANGING lr_whosis.


*&---------------------------------------------------------------------*
*& Country structure filled here
*&---------------------------------------------------------------------*
CHECK lr_country IS BOUND.
IF lr_country IS BOUND.
  ASSIGN lr_country->* TO <data>.
  ASSIGN COMPONENT 'VALUE' OF STRUCTURE <data> TO <results>.
  ASSIGN <results>->* TO <table>.

  LOOP AT <table> ASSIGNING <structure>.
    ASSIGN <structure>->* TO <data>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `CODE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_country = <field>.
      ASSIGN lr_country->* TO <field_value>.
      CHECK <field_value> IS ASSIGNED.
      ls_country-code = <field_value>.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `TITLE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_country = <field>.
      ASSIGN lr_country->* TO <field_value>.
      CHECK <field_value> IS ASSIGNED.
      ls_country-title = <field_value>.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `PARENTDIMENSION` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_country = <field>.
      ASSIGN lr_country->* TO <field_value>.
      CHECK <field_value> IS ASSIGNED.
      ls_country-parentdimension = <field_value>.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `DIMENSION` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_country = <field>.
      ASSIGN lr_country->* TO <field_value>.
      CHECK <field_value> IS ASSIGNED.
      ls_country-dimension = <field_value>.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `PARENTCODE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_country = <field>.
      ASSIGN lr_country->* TO <field_value>.
      CHECK <field_value> IS ASSIGNED.
      ls_country-parentcode = <field_value>.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `PARENTTITLE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_country = <field>.
      ASSIGN lr_country->* TO <field_value>.
      CHECK <field_value> IS ASSIGNED.
      ls_country-parenttitle = <field_value>.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    APPEND ls_country TO lt_country.
    CLEAR ls_country.
  ENDLOOP.
ENDIF.

*&---------------------------------------------------------------------*
*& WHOSIS_000001 structure
*&---------------------------------------------------------------------*
IF lr_whosis IS BOUND.
  ASSIGN lr_whosis->* TO <data>.
  ASSIGN COMPONENT 'VALUE' OF STRUCTURE <data> TO <results>.
  ASSIGN <results>->* TO <table>.

  LOOP AT <table> ASSIGNING <structure>.
    ASSIGN <structure>->* TO <data>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `ID` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_whosis = <field>.
      ASSIGN lr_whosis->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_whosis-id = <field_value>.
      ELSE.
        ls_whosis-id = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `INDICATORCODE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_whosis = <field>.
      ASSIGN lr_whosis->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_whosis-indicator_code = <field_value>.
      ELSE.
        ls_whosis-indicator_code = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `SPATIALDIMTYPE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_whosis = <field>.
      ASSIGN lr_whosis->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_whosis-spatialdimtype = <field_value>.
      ELSE.
        ls_whosis-spatialdimtype = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `SPATIALDIM` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_whosis = <field>.
      ASSIGN lr_whosis->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_whosis-spatialdim = <field_value>.
      ELSE.
        ls_whosis-spatialdim = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `TIMEDIMTYPE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_whosis = <field>.
      ASSIGN lr_whosis->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_whosis-timedimtype = <field_value>.
      ELSE.
        ls_whosis-timedimtype = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `TIMEDIM` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_whosis = <field>.
      ASSIGN lr_whosis->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_whosis-timedim = <field_value>.
      ELSE.
        ls_whosis-timedim = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `VALUE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_whosis = <field>.
      ASSIGN lr_whosis->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_whosis-value = <field_value>.
      ELSE.
        ls_whosis-value = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `NUMERICVALUE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_whosis = <field>.
      ASSIGN lr_whosis->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_whosis-numericvalue = <field_value>.
      ELSE.
        ls_whosis-numericvalue = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `LOW` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_whosis = <field>.
      ASSIGN lr_whosis->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_whosis-low = <field_value>.
      ELSE.
        ls_whosis-low = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `HIGH` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_whosis = <field>.
      ASSIGN lr_whosis->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_whosis-high = <field_value>.
      ELSE.
        ls_whosis-high = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    APPEND ls_whosis TO lt_whosis.
    CLEAR ls_whosis.
  ENDLOOP.
ENDIF.



*&---------------------------------------------------------------------*
*& NUTOVERWEIGHTNUM structure
*&---------------------------------------------------------------------*
IF lr_nutover IS BOUND.
  ASSIGN lr_nutover->* TO <data>.
  ASSIGN COMPONENT 'VALUE' OF STRUCTURE <data> TO <results>.
  ASSIGN <results>->* TO <table>.

  LOOP AT <table> ASSIGNING <structure>.
    ASSIGN <structure>->* TO <data>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `ID` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_nutover = <field>.
      ASSIGN lr_nutover->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_nutoverweight-id = <field_value>.
      ELSE.
        ls_nutoverweight-id = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `INDICATORCODE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_nutover = <field>.
      ASSIGN lr_nutover->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_nutoverweight-indicator_code = <field_value>.
      ELSE.
        ls_nutoverweight-indicator_code = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `SPATIALDIMTYPE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_nutover = <field>.
      ASSIGN lr_nutover->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_nutoverweight-spatialdimtype = <field_value>.
      ELSE.
        ls_nutoverweight-spatialdimtype = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `SPATIALDIM` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_nutover = <field>.
      ASSIGN lr_nutover->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_nutoverweight-spatialdim = <field_value>.
      ELSE.
        ls_nutoverweight-spatialdim = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `TIMEDIMTYPE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_nutover = <field>.
      ASSIGN lr_nutover->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_nutoverweight-timedimtype = <field_value>.
      ELSE.
        ls_nutoverweight-timedimtype = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `TIMEDIM` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_nutover = <field>.
      ASSIGN lr_nutover->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_nutoverweight-timedim = <field_value>.
      ELSE.
        ls_nutoverweight-timedim = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `VALUE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_nutover = <field>.
      ASSIGN lr_nutover->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_nutoverweight-value = <field_value>.
      ELSE.
        ls_nutoverweight-value = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `NUMERICVALUE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_nutover = <field>.
      ASSIGN lr_nutover->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_nutoverweight-numericvalue = <field_value>.
      ELSE.
        ls_nutoverweight-numericvalue = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `LOW` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_nutover = <field>.
      ASSIGN lr_nutover->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_nutoverweight-low = <field_value>.
      ELSE.
        ls_nutoverweight-low = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `HIGH` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_nutover = <field>.
      ASSIGN lr_nutover->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_nutoverweight-high = <field_value>.
      ELSE.
        ls_nutoverweight-high = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    APPEND ls_nutoverweight TO lt_nutoverweight.
    CLEAR ls_nutoverweight.
  ENDLOOP.
ENDIF.



*&---------------------------------------------------------------------*
*& BP_03 structure
*&---------------------------------------------------------------------*
IF lr_bp_03 IS BOUND.
  ASSIGN lr_bp_03->* TO <data>.
  ASSIGN COMPONENT 'VALUE' OF STRUCTURE <data> TO <results>.
  ASSIGN <results>->* TO <table>.

  LOOP AT <table> ASSIGNING <structure>.
    ASSIGN <structure>->* TO <data>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `ID` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_bp_03 = <field>.
      ASSIGN lr_bp_03->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_bp_03-id = <field_value>.
      ELSE.
        ls_bp_03-id = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `INDICATORCODE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_bp_03 = <field>.
      ASSIGN lr_bp_03->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_bp_03-indicator_code = <field_value>.
      ELSE.
        ls_bp_03-indicator_code = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `SPATIALDIMTYPE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_bp_03 = <field>.
      ASSIGN lr_bp_03->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_bp_03-spatialdimtype = <field_value>.
      ELSE.
        ls_bp_03-spatialdimtype = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `SPATIALDIM` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_bp_03 = <field>.
      ASSIGN lr_bp_03->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_bp_03-spatialdim = <field_value>.
      ELSE.
        ls_bp_03-spatialdim = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `TIMEDIMTYPE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_bp_03 = <field>.
      ASSIGN lr_bp_03->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_bp_03-timedimtype = <field_value>.
      ELSE.
        ls_bp_03-timedimtype = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `TIMEDIM` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_bp_03 = <field>.
      ASSIGN lr_bp_03->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_bp_03-timedim = <field_value>.
      ELSE.
        ls_bp_03-timedim = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `VALUE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_bp_03 = <field>.
      ASSIGN lr_bp_03->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_bp_03-value = <field_value>.
      ELSE.
        ls_bp_03-value = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `NUMERICVALUE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_bp_03 = <field>.
      ASSIGN lr_bp_03->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_bp_03-numericvalue = <field_value>.
      ELSE.
        ls_bp_03-numericvalue = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `LOW` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_bp_03 = <field>.
      ASSIGN lr_bp_03->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_bp_03-low = <field_value>.
      ELSE.
        ls_bp_03-low = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `HIGH` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_bp_03 = <field>.
      ASSIGN lr_bp_03->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_bp_03-high = <field_value>.
      ELSE.
        ls_bp_03-high = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    APPEND ls_bp_03 TO lt_bp_03.
    CLEAR ls_bp_03.
  ENDLOOP.
ENDIF.


*&---------------------------------------------------------------------*
*& DEVICES20 structure
*&---------------------------------------------------------------------*

IF lr_dev20 IS BOUND.
  ASSIGN lr_dev20->* TO <data>.
  ASSIGN COMPONENT 'VALUE' OF STRUCTURE <data> TO <results>.
  ASSIGN <results>->* TO <table>.

  LOOP AT <table> ASSIGNING <structure>.
    ASSIGN <structure>->* TO <data>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `ID` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_dev20 = <field>.
      ASSIGN lr_dev20->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_devices20-id = <field_value>.
      ELSE.
        ls_devices20-id = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `INDICATORCODE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_dev20 = <field>.
      ASSIGN lr_dev20->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_devices20-indicator_code = <field_value>.
      ELSE.
        ls_devices20-indicator_code = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `SPATIALDIMTYPE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_dev20 = <field>.
      ASSIGN lr_dev20->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_devices20-spatialdimtype = <field_value>.
      ELSE.
        ls_devices20-spatialdimtype = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `SPATIALDIM` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_dev20 = <field>.
      ASSIGN lr_dev20->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_devices20-spatialdim = <field_value>.
      ELSE.
        ls_devices20-spatialdim = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `TIMEDIMTYPE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_dev20 = <field>.
      ASSIGN lr_dev20->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_devices20-timedimtype = <field_value>.
      ELSE.
        ls_devices20-timedimtype = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `TIMEDIM` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_dev20 = <field>.
      ASSIGN lr_dev20->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_devices20-timedim = <field_value>.
      ELSE.
        ls_devices20-timedim = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `VALUE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_dev20 = <field>.
      ASSIGN lr_dev20->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_devices20-value = <field_value>.
      ELSE.
        ls_devices20-value = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `NUMERICVALUE` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_dev20 = <field>.
      ASSIGN lr_dev20->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_devices20-numericvalue = <field_value>.
      ELSE.
        ls_devices20-numericvalue = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `LOW` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_dev20 = <field>.
      ASSIGN lr_dev20->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_devices20-low = <field_value>.
      ELSE.
        ls_devices20-low = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    CHECK <data> IS ASSIGNED.
    ASSIGN COMPONENT `HIGH` OF STRUCTURE <data> TO <field>.
    IF <field> IS ASSIGNED.
      lr_dev20 = <field>.
      ASSIGN lr_dev20->* TO <field_value>.
      IF <field_value> IS ASSIGNED.
        ls_devices20-high = <field_value>.
      ELSE.
        ls_devices20-high = ''.
      ENDIF.
    ENDIF.
    UNASSIGN: <field>, <field_value>.

    APPEND ls_devices20 TO lt_devices20.
    CLEAR ls_devices20.
  ENDLOOP.
ENDIF.

cl_demo_output=>display( lt_country ).
*cl_demo_output=>display( lt_whosis ).
*cl_demo_output=>display( lt_devices20 ).
*cl_demo_output=>display( lt_nutoverweight ).
*cl_demo_output=>display( lt_bp_03 ).

*DESCRIBE TABLE lt_country       LINES DATA(lv_lines_country).
*DESCRIBE TABLE lt_whosis        LINES DATA(lv_lines_whosis).
*DESCRIBE TABLE lt_devices20     LINES DATA(lv_lines_dev20).
*DESCRIBE TABLE lt_nutoverweight LINES DATA(lv_lines_nutoverweight).
*DESCRIBE TABLE lt_bp_03         LINES DATA(lv_lines_bp_03).
*
*WRITE:/ lv_lines_country, lv_lines_bp_03, lv_lines_dev20, lv_lines_nutoverweight, lv_lines_whosis.
*
*DELETE ADJACENT DUPLICATES FROM lt_country COMPARING code.
*DELETE ADJACENT DUPLICATES FROM lt_whosis        COMPARING ALL FIELDS.
*DELETE ADJACENT DUPLICATES FROM lt_nutoverweight COMPARING ALL FIELDS.
*DELETE ADJACENT DUPLICATES FROM lt_devices20     COMPARING ALL FIELDS.
*DELETE ADJACENT DUPLICATES FROM lt_bp_03         COMPARING ALL FIELDS.
*
*sort lt_country BY code.
*
*INSERT zcountry_db     FROM TABLE lt_country.
*INSERT zwhosis_000001  FROM TABLE lt_whosis.
*INSERT znutoverwghtnum FROM TABLE lt_nutoverweight.
*INSERT zdevice20       FROM TABLE lt_devices20.
*INSERT zbp_03          FROM TABLE lt_bp_03.

*IF sy-subrc EQ 0.
*  WRITE: 'sikeres adatbázis mentés'.
*ENDIF.



*&---------------------------------------------------------------------*
*& Form datamine
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> IV_SERVICE_HOST
*&      <-- EV_JSON_RESPONSE
*&---------------------------------------------------------------------*
FORM datamine  USING    p_iv_service_host
               CHANGING p_ev_json_response.


  cl_http_client=>create_by_url(
    EXPORTING
      url                = p_iv_service_host
    IMPORTING
      client             = lo_client
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).

  IF sy-subrc EQ 0.

    lo_client->request->set_method( if_http_request=>co_request_method_get ).

    lo_client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4
).
    lo_client->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3 ).

    IF sy-subrc EQ 0.

      lv_xstring = lo_client->response->get_data( ).
      lo_client->close( ).

      CALL FUNCTION 'SSFH_XSTRINGUTF8_TO_STRING'
        EXPORTING
          ostr_output_data = lv_xstring
        IMPORTING
          cstr_output_data = p_ev_json_response
        EXCEPTIONS
          conversion_error = 1
          internal_error   = 2
          OTHERS           = 3.
      IF sy-subrc EQ 0.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form deserialize
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_JSON_RESP
*&      <-- p_lr_country
*&---------------------------------------------------------------------*
FORM deserialize  USING    p_lv_json_resp
                  CHANGING p_p_lr_country.

  IF p_lv_json_resp IS NOT INITIAL.
    CALL METHOD /ui2/cl_json=>deserialize
      EXPORTING
        json         = p_lv_json_resp
        pretty_name  = /ui2/cl_json=>pretty_mode-user
        assoc_arrays = abap_true
      CHANGING
        data         = p_p_lr_country.
  ENDIF.

ENDFORM.
