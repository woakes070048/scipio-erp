<#--
* 
* Content Elements
* 
* The SCIPIO framework comes with a set of standard content elements. The elements are largely based on standard 
* html elements so the transition should be straight forward. Since all macros also standardize the html patterns, 
* it is recommended to rely on the SCIPIO tag alternatives for all html. All macros start with "<@", so tags can
* be converted by adding an @ in front of them. 
* 
* The SCIPIO content elements add new options that can be added as attributes. For example, whereas <@table> will create a
* default table, <@table responsive=true> will generate the very same with added resizing for smaller devices. 
* The available options and their respective use are outlined by this document. 
* 
* Additionally, some already known attributes have been enhanced to make styling easier. As one example, classes are 
* automatically assigned based on the overarching theme. Additional classes can be set with the 'class' attribute. 
* However, the developer has the option to specify whether the classes should expand, or replace default values.
*
* Included by htmlTemplate.ftl.
*
* NOTES: 
* * May have implicit dependencies on other parts of Scipio API.
*
-->

<#-- 
*************
* Heading
************
An HTML heading (title).

  * Usage Examples *  
    <@heading>My Title</@heading>         
                                 
  * Parameters *
    elemType                = (heading|h|p|span|div|raw|(boolean), default: heading) Element type
                              boolean true means use default; false means none (same as "raw").
                              NOTE: Do not specify h1-h6 here; use level argument instead.
    level                   = ((int), default: -current global heading level-) Specific heading level
                              If not specified, current heading level returned by #getCurrentHeadingLevel function is used. 
                              NOTE: Does not consume a level.
    relLevel                = ((int), default: 0) Determines heading level by adding this number to current global heading level
    class                   = ((css-class)) Heading element CSS classes
                              Supports prefixes (see #compileClassArg for more info):
                              * {{{+}}}: causes the classes to append only, never replace defaults (same logic as empty string "")
                              * {{{=}}}: causes the classes to replace non-essential defaults (same as specifying a class name directly)
    levelClassPrefix        = (default: "heading-level-") Prefix for level number class
    id                      = Heading ID
    consumeLevel            = ((boolean), default: false) Whether should consume a level in addition to printing a heading
                              If true, the global heading level is set to (calculated level for this heading) + 1.
                              NOTE: this is better handled through use of the @section macro. Mostly useful for h1.
                              DEV NOTE: default could be made to depend on calculated level.
    containerElemType       = (div|, default: -empty-) If present, adds container around title or this elem type
    containerClass          = ((css-class)) Container element CSS classes
                              Supports prefixes (see #compileClassArg for more info):
                              * {{{+}}}: causes the classes to append only, never replace defaults (same logic as empty string "")
                              * {{{=}}}: causes the classes to replace non-essential defaults (same as specifying a class name directly)      
    containerId             = Container ID  
    attribs                 = ((map)) Extra legacy h1-h6 attributes
                              Needed for names containing dashes.
    inlineAttribs...        = ((inline-args)) Extra legacy h1-h6 attributes
                              NOTE: camelCase names are automatically converted to dash-separated-lowercase-names.
-->
<#assign heading_defaultArgs = {
  "elemType":true, "level":"", "relLevel":"", "class":"", "id":"", "levelClassPrefix":true, "consumeLevel":"", 
  "containerElemType":false, "containerClass":"", "containerId":"", "attribs":{}, "passArgs":{}
}>
<#macro heading args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.heading_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>
  
  <#if !level?has_content>
    <#local level = getCurrentHeadingLevel()>
  </#if>
  <#if relLevel?has_content>
    <#local level = level + relLevel>
  </#if>
  <#if levelClassPrefix?is_boolean>
    <#local levelClassPrefix = levelClassPrefix?string(styles.heading_level_prefix!"", "")>
  </#if>
  <#if levelClassPrefix?has_content>
    <#local headingLevelClass = levelClassPrefix + level?string>
  <#else>
    <#local headingLevelClass = "">
  </#if>
  <#local class = addClassArgDefault(class, headingLevelClass)>
  <#local containerClass = addClassArgDefault(containerClass, headingLevelClass)>
  <#if (consumeLevel?is_boolean && consumeLevel == true)>
    <#local dummy = setCurrentHeadingLevel(level + 1)>
  </#if>
  <#if (level < 1)>
    <#local level = 1>
  </#if>
  <#if elemType?is_boolean>
    <#if elemType>
      <#local hElem = "h">
    <#else>
      <#local hElem = "">
    </#if>
  <#elseif elemType == "heading" || elemType == "h">
    <#local hElem = "h">
  <#elseif elemType == "container">
    <#local hElem = "div">    
  <#elseif elemType == "raw" || !elemType?has_content>
    <#local hElem = "">
  <#else>
    <#local hElem = elemType>
  </#if>
  <#if containerElemType?is_boolean>
    <#local cElem = "">
  <#elseif containerElemType == "container">
    <#local cElem = "div">
  <#elseif containerElemType == "raw" || !containerElemType?has_content>
    <#local cElem = "">
  <#else>
    <#local cElem = containerElemType> 
  </#if>
  <@heading_markup level=level elem=hElem class=class id=id attribs=attribs
    containerElem=cElem containerClass=containerClass containerId=containerId origArgs=origArgs passArgs=passArgs><#nested></@heading_markup>
</#macro>

<#-- Main markup for @heading (minimal logic; a little needed) - theme override
     This may be overridden by themes to change markup without changing logic.
     Here, elem will contain either the value "h" or a valid html element.
     NOTE: wherever this is overridden, should include "catchArgs..." for compatibility (new args won't break old overrides; remove to identify) -->
<#macro heading_markup level=1 elem="" class="" id="" attribs={} excludeAttribs=[] containerElem="" containerClass="" containerId="" origArgs={} passArgs={} catchArgs...>
  <#local elemLevel = level>
  <#if (elemLevel > 6)>
    <#local elemLevel = 6>
  </#if>
  <#if elem == "h">
    <#local elem = "h" + elemLevel?string>
  </#if>
  <#if containerElem?has_content>
    <${containerElem}<@compiledClassAttribStr class=containerClass /><#if containerId?has_content> id="${containerId}"</#if>>
  </#if>
  <#if elem?has_content><${elem}<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#rt>
    <#lt><#if attribs?has_content><@commonElemAttribStr attribs=attribs exclude=excludeAttribs/></#if>></#if><#nested><#if elem?has_content></${elem}></#if>
  <#if containerElem?has_content>
    </${containerElem}>
  </#if>
</#macro>

<#-- 
*************
* Code Block
************
Creates a basic wrapper for code blocks.

  * Usage Examples *  
    <@code type="java">
       // Some java code
    </@code>
                    
  * Parameters *
    type                    = (html|java|css|javascript|log, default:html)
    class                   = ((css-class)) Heading element CSS classes
                              Supports prefixes (see #compileClassArg for more info):
                              * {{{+}}}: causes the classes to append only, never replace defaults (same logic as empty string "")
                              * {{{=}}}: causes the classes to replace non-essential defaults (same as specifying a class name directly)
-->
<#assign code_defaultArgs = {
  "type":"html", "class":"", "passArgs":{}
}>
<#macro code args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.code_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <#local class = addClassArgDefault(class, "")>
  <@code_markup type=type class=class origArgs=origArgs passArgs=passArgs><#nested></@code_markup>
</#macro>

<#-- @code main markup - theme override -->
<#macro code_markup type="" class="" origArgs={} passArgs={} catchArgs...>
  <pre<@compiledClassAttribStr class=class />><code data-language="${type!}"><#rt>
    <#nested><#t>
  </code></pre><#lt>
</#macro>

<#-- 
*************
* mapOfbizFormTypeToTableType
************ 
Maps an Ofbiz form widget type to a @table macro type.
-->
<#function mapOfbizFormTypeToTableType formType>
  <#local res = (styles.form_type_tabletypes_ofbiz[formType])!(styles.form_type_tabletypes_ofbiz["default"])!"">
  <#if res?is_boolean>
    <#return res?string(formType, "")>
  </#if>
  <#return res>
</#function>

<#-- 
*************
* Responsive Table Script
************
Creates a responsive tables script (script only - no markup).
    
  * Parameters *
    enabled                 = ((boolean), default: true) Helper arg to prevent the whole macro from executing, when false
    tableId                 = Table ID
    tableType               = Table type
    tableStyleName          = (default: -based on table type-) Table style name (optimization)
                              Usually should be be omitted and will be determined automatically from table type.
    responsive              = ((boolean), default: -from global styles-) If true, will generate a responsive table
                              Currently, this relies on the jQuery plugin datatables.js (www.datatables.net) to generate responsive table. 
                              Can be combined with fixed column type.
                              If explicitly set to false, will disable responsive regardless of defaults.
                              The default depends on global styles, looked up using table type.
    responsiveOptions       = ((map)) Map of options passed directly to responsive tables implementation (javascript implementation)
    responsiveDefaults      = ((boolean), default: true) Fine-grained control for whether responsive defaults are looked up or not
                              If true, responsive defaults are looked up, and any option in responsiveOptions overrides the defaults per-option; if false, no defaults are used and only 
                              responsiveOptions, fixedColumnsLeft and fixedColumnsRight are used. 
    scrollable              = ((boolean), default: -from global styles-) Scrolling control (convenience parameter)
                              If true, guarantees table will be scrollable horizontally.
                              implementation of scrollable depends on macro and global styles (by default, uses responsive).
                              If explicitly set to false, prevents scrolling.
                              Currently, alias for responsiveOptions.scrollX.
    fixedColumnsLeft        = ((integer)) Number of columns that are fixed on the left-hand side (convenience parameter)
                              Currently, alias for responsiveOptions.fixedColumns.leftColumns.
    fixedColumnsRight       = ((integer)) Number of columns that are fixed on the right hand side  (convenience parameter)
                              Currently, alias for responsiveOptions.fixedColumns.rightColumns.
-->
<#assign tableResponsiveScript_defaultArgs = {
  "enabled" : true, "tableId" : "", "tableType" : "", "tableStyleName" : "", "responsive" : "", "scrollable" : "",
  "responsiveOptions" : {}, "responsiveDefaults" : true, "fixedColumnsLeft" : 0, "fixedColumnsRight" : 0,
  "htmlwrap" : true, "passArgs":{}
}>
<#macro tableResponsiveScript args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.tableResponsiveScript_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#if enabled>
    <#if !(responsive?is_boolean && responsive == false) && tableId?has_content>
      <#if !tableStyleName?has_content>
        <#local tableStyleName = tableType?replace("-","_")>
        <#if (!tableStyleName?has_content) || (!(styles["table_" + tableStyleName]!false)?is_string)>
          <#local tableStyleName = "default">
        </#if>
      </#if>
  
      <#-- defaults -->
      <#if !responsiveDefaults>
        <#local respOpts = {}>
      <#elseif responsive?is_boolean && responsive == true>
        <#local respOpts = styles["table_" + tableStyleName + "_responsive_options"]!styles["table_default_responsive_options"]!{}>
      <#elseif scrollable?is_boolean && scrollable == true>
        <#local respOpts = styles["table_" + tableStyleName + "_scrollable_options"]!styles["table_default_scrollable_options"]!{}>    
      <#else>
        <#local respOpts = {}>
      </#if>
  
      <#-- aliases/abstractions -->
      <#if (fixedColumnsLeft > 0) || (fixedColumnsRight > 0)>
        <#local respOpts = respOpts + { "fixedColumns" : {
            "leftColumns": fixedColumnsLeft!0,
            "rightColumns": fixedColumnsRight!0
          }
        }>
      </#if>
      <#if scrollable?is_boolean>
        <#local respOpts = respOpts + {"scrollX": scrollable}>
      </#if>
  
      <#-- manual overrides -->
      <#if responsiveOptions?has_content>
        <#local respOpts = respOpts + responsiveOptions>
      </#if>
      
      <@script htmlwrap=htmlwrap>
        $(document).ready(function() {
            $('#${tableId}').DataTable(<@objectAsScript lang="js" object=respOpts />);
        } );
      </@script>
    </#if>
  </#if>
</#macro>

<#-- 
*************
* Table
************
Defines a table with advanced generating functionality. Analogous to HTML <table> element.

Required wrapper for all @table sub-element macros.

TODO?: @table macros were made before push/popRequestStack was fully realized, so may be
    overcomplicated at the moment.

  * Usage Examples *  
    <@table type="data-list" id="my-table">
      <@thead>
        <@tr>
          <@th width="15%">col 1</@th>
          <@th width="85%">col 2</@th>
        </@tr>
      </@thead>
      <@tbody>
        <@tr class="my-row-class" valign="middle">
          <@td>data value 1</@td>
          <@td>data value 2</@td>
        </@tr>
      </@tbody>
    </@table>
                    
  * Parameters *
    * General *
    type                    = (generic|(theme-specific), default: generic) Table type
                              * STANDARD TYPES *
                              These types must always be recognized by all styles themes:
                              * {{{generic}}}: generic html table (free-form, complex); no features enabled by default.
                                similar to defining an html <table> manually, but more powerful.
                              * DEFAULT STYLES TYPES *
                              The following are recognized by Scipio standard markup:
                              * {{{data-list}}}: record-containing table, one data record per row (but row cells may be complex and may have tfoot)
                                similar to a form widget "list" or "multi" table; intended to resemble these, to unify them.
                              * {{{data-list-multiform}}}: virtually same as data-list, but expected to contain a multi-submit form, which
                                could change styling requirements.
                                this makes no real semantic difference from data-list to @table macro, but this type exists as analog
                                to form widget "multi" form type, so possible to style differently.
                              * {{{data-complex}}}: record-containing table, but with complex structure (more than one row per record, separators, etc.)
                                there is no form widget equivalent of these and usually need some custom alt-row work.
                              * {{{summary}}}: usually table with one or a few set rows of summary totals
                                e.g. order grand totals. 
                                TODO?: review need for this type (should be converted?)
                              * {{{fields}}}: label-value pairs for display, side-by-side, usually no header, roughly
                                this is especially for legacy Ofbiz code. it is somewhat still valid for display-only fields.
                                legacy Ofbiz code tables may be assigned this for input forms formatted with tables, but they
                                ultimately belong as @field and @row/@cell.
                                TODO: many of these in current templates involving forms and inputs should be converted to @row/@cell (WIP)
                              * {{{fields-vert}}}: like {{{fields}}} but arranged like a regular table with labels in a header row.
                              NOTE: These types are mainly targeted for backend applications.
    class                   = ((css-class), default: -from global styles-) CSS classes
                              Supports prefixes (see #compileClassArg for more info):
                              * {{{+}}}: causes the classes to append only, never replace defaults (same logic as empty string "")
                              * {{{=}}}: causes the classes to replace non-essential defaults (same as specifying a class name directly)
                              Defaults are looked up in global styles using:
                                styles["table_" + type?replace("-","_")]
                              where type is the table type above. If the given style entry does not exist, the default is instead determined by:
                                styles["table_default"]
    id                      = Table ID
    hasHeader               = ((boolean)) Hint to indicate that table is expected to have a header, normally a <@thead> element
                              @table will try to figure this out on its own, but in some cases it may not be possible
                              or not possible to know in advance, in which case caller must specify this flag.
                              Currently, this setting affects the following:
                              * Responsive tables
    autoAltRows             = ((boolean), default: -from global styles-, fallback default: false)
    firstRowAlt             = ((boolean), default: false)
    inheritAltRows          = ((boolean)) Only for nested tables: If true, all rows in nested tables will inherit alt from parent table row
    useFootAltRoots         = ((boolean)) Whether use alt row logic in foot or not
    cellspacing             = ((int), default: -from global styles-, fallback default: -empty-) Traditional cellspacing
                              Should be avoided in modern templates.
    open, close             = ((boolean)) Advanced structure control, for esoteric cases
    attribs                 = ((map)) Other legacy <table> attributes
                              Needed for names containing dashes.
    inlineAttribs...        = ((inline-args)) Other legacy <table> attributes and values
                              NOTE: camelCase names are automatically converted to dash-separated-lowercase-names.
    
    * Responsive Tables *
    responsive, 
    responsiveOptions,
    responsiveDefaults,
    scrollable,
    fixedColumnsLeft,
    fixedColumnsRight       = See @tableResponsiveScript macro for descriptions
                              NOTE: @table with default markup will automatically disable responsive on tables 
                                  that have no @thead element and hasHeader=true is not specified.
                                  Responsive tables may break when no header is present (may require a <thead> HTML element).
-->
<#assign table_defaultArgs = {
  "type":"", "class":"", "id":"", "hasHeader":"", "cellspacing":true, "responsive":"", "scrollable":"", "responsiveOptions":{}, "responsiveDefaults":"", 
  "fixedColumnsLeft":0, "fixedColumnsRight":0, "autoAltRows":"", "firstRowAlt":"", "inheritAltRows":false, "useFootAltRows":false, 
  "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro table args={} inlineArgs...>
  <#-- DEV NOTE: For all @table macros, when adding parameters above, make sure also pushed on scipioTableStack stack below! -->

  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.table_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <#if open>
    <#local tableIdNum = getRequestVar("scipioTableIdNum")!0>
    <#local tableIdNum = tableIdNum + 1 />
    <#local dummy = setRequestVar("scipioTableIdNum", tableIdNum)>
    <#if !id?has_content>
      <#local id="table_"+tableIdNum/>
    </#if>
    <#if !type?has_content>
      <#local type = "generic">
    </#if>
    <#-- save previous globals, for nesting -->
    <#local prevTableInfo = getRequestVar("scipioCurrentTableInfo")!{}>
    <#local prevHasHeaderFlag = getRequestVar("scipioCurrentTableHasHeader")!"">
    <#local prevSectionInfo = getRequestVar("scipioCurrentTableSectionInfo")!{}>
    <#local prevRowAltFlag = getRequestVar("scipioCurrentTableRowAltFlag")!""> <#-- used to keep track of state (always boolean) -->
    <#local prevCurrentRowAlt = getRequestVar("scipioCurrentTableCurrentRowAlt")!""> <#-- the actual alt value of current row (may be empty) -->
    <#local prevLastRowAlt = getRequestVar("scipioCurrentTableLastRowAlt")!""> <#-- the actual alt value of "last" row (may be empty) -->
    <#local styleName = type?replace("-","_")>
    <#if (!styleName?has_content) || (!(styles["table_" + styleName]!false)?is_string)>
      <#local styleName = "default">
    </#if>
    <#if !autoAltRows?is_boolean>
      <#if inheritAltRows>
        <#local autoAltRows = true>
      <#else>
        <#local autoAltRows = styles["table_" + styleName + "_autoaltrows"]!styles["table_default_autoaltrows"]!false>
      </#if>
    </#if>
    <#local defaultClass = styles["table_" + styleName]!styles["table_default"]!"">
    <#local class = addClassArgDefault(class, defaultClass)>
    <#if cellspacing?is_boolean>
      <#if cellspacing>
        <#local cellspacing = styles["table_" + styleName + "_cellspacing"]!styles["table_default_cellspacing"]!"">
      <#else>
        <#local cellspacing = "">
      </#if>
    </#if>
    <#if !responsive?is_boolean>
      <#local responsive = styles["table_" + styleName + "_responsive"]!styles["table_default_responsive"]!"">
    </#if>
    <#if !scrollable?is_boolean>
      <#local scrollable = styles["table_" + styleName + "_scrollable"]!styles["table_default_scrollable"]!"">
    </#if>
    <#if !responsiveDefaults?is_boolean>
      <#local responsiveDefaults = true>
    </#if>
    <#-- NOTE: there's currently some duplication between scipioCurrentTableInfo and scipioTableStack below; do not confuse
            (this was written before the stack functions were fully written) -->
    <#local scipioCurrentTableInfo = {"type": type, "styleName": styleName, "autoAltRows": autoAltRows,
      "inheritAltRows": inheritAltRows, "parentRowAlt": prevCurrentRowAlt, "useFootAltRows": useFootAltRows}>
    <#local dummy = setRequestVar("scipioCurrentTableInfo", scipioCurrentTableInfo)!>
    <#local scipioCurrentTableSectionInfo = {"type": "body", "cellElem": "td"}>
    <#local dummy = setRequestVar("scipioCurrentTableSectionInfo", scipioCurrentTableSectionInfo)!>
    <#-- also set in @thead -->
    <#local dummy = setRequestVar("scipioCurrentTableHasHeader", hasHeader)!>
    <#-- NOTE: scipioCurrentTableRowAltFlag should always be boolean
         NOTE: scipioCurrentTableCurrentRowAlt probably doesn't need to be set here, but playing it safe -->
    <#if firstRowAlt?is_boolean>
      <#local dummy = setRequestVar("scipioCurrentTableRowAltFlag", firstRowAlt)!>
      <#local dummy = setRequestVar("scipioCurrentTableCurrentRowAlt", firstRowAlt)!>
    <#elseif inheritAltRows>
      <#if prevCurrentRowAlt?is_boolean>
        <#local dummy = setRequestVar("scipioCurrentTableRowAltFlag", prevCurrentRowAlt)!>
      <#else>
        <#local dummy = setRequestVar("scipioCurrentTableRowAltFlag", false)!>
      </#if>
      <#local dummy = setRequestVar("scipioCurrentTableCurrentRowAlt", prevCurrentRowAlt)!>
    <#else>
      <#local dummy = setRequestVar("scipioCurrentTableRowAltFlag", false)!>
      <#local dummy = setRequestVar("scipioCurrentTableCurrentRowAlt", false)!>
    </#if>
    <#-- NOTE: this var may be empty string (none) -->
    <#local dummy = setRequestVar("scipioCurrentTableLastRowAlt", prevCurrentRowAlt)!>
    <#local style = "">
    <#local useResponsive = ((responsive?is_boolean && responsive == true) || responsiveOptions?has_content || (scrollable?is_boolean && scrollable == true))
      && !(responsive?is_boolean && responsive == false)>
    <#-- need to save values on a stack if open-only! -->
    <#if !close>
      <#-- TODO?: this stack push is duplicating scipioCurrentTableInfo above;
           could instead always push a stack and have child elems use readRequestStack instead of
           scipioCurrentTableInfo; but requires change all the macros, and as-is this optimizes
           for FTLs somewhat, though also more error-prone... -->
      <#local prevHasHeaderFlag = getRequestVar("scipioCurrentTableHasHeader")!"">
      <#local dummy = pushRequestStack("scipioTableStack", {
        <#-- save prev values -->
        "prevTableInfo":prevTableInfo, 
        "prevSectionInfo":prevSectionInfo, 
        "prevHasHeaderFlag":prevHasHeaderFlag, 
        "prevRowAltFlag":prevRowAltFlag, 
        "prevCurrentRowAlt":prevCurrentRowAlt, 
        "prevLastRowAlt":prevLastRowAlt, 
        
        <#-- save parameters (including local changes) -->
        "type":type, 
        "class":class, 
        "id":id, 
        "hasHeader":hasHeader,
        "cellspacing":cellspacing,
        "responsive":responsive, 
        "scrollable":scrollable, 
        "responsiveOptions":responsiveOptions,
        "responsiveDefaults":responsiveDefaults, 
        "fixedColumnsLeft":fixedColumnsLeft, 
        "fixedColumnsRight":fixedColumnsRight,
        "autoAltRows":autoAltRows, 
        "firstRowAlt":firstRowAlt, 
        "inheritAltRows":inheritAltRows, 
        "useFootAltRows":useFootAltRows, 
        "attribs":attribs,
        "origArgs":origArgs,
        "passArgs":passArgs,
        
        <#-- save local variables -->
        "tableIdNum":tableIdNum, 
        "styleName":styleName, 
        "useResponsive":useResponsive
      })>
    </#if>
  <#elseif close>
    <#local stackValues = popRequestStack("scipioTableStack")!{}>
    <#local dummy = localsPutAll(stackValues)>
  <#else>
    <#-- needed so no undefined vars -->
    <#local styleName = "">
    <#local cellspacing = "">
    <#local useResponsive = false>
    <#local tableIdNum = 0>
  </#if>     
  <#-- having this as map simplifies the args the markup has to pass along, much easier -->
  <#local responsiveArgs = {
    "tableId" : id,
    "tableType" : type,
    "tableStyleName" : styleName,
    "responsive" : responsive,
    "scrollable" : scrollable,
    "responsiveOptions" : responsiveOptions,
    "responsiveDefaults" : responsiveDefaults,
    "fixedColumnsLeft" : fixedColumnsLeft,
    "fixedColumnsRight" : fixedColumnsRight
  }>
  <@table_markup open=open close=close type=type styleName=styleName class=class id=id cellspacing=cellspacing 
      useResponsive=useResponsive responsiveArgs=responsiveArgs autoAltRows=autoAltRows firstRowAlt=firstRowAlt 
      inheritAltRows=inheritAltRows useFootAltRows=useFootAltRows tableIdNum=tableIdNum attribs=attribs origArgs=origArgs passArgs=passArgs>
    <#nested>
  </@table_markup>
  <#if close>
    <#local dummy = setRequestVar("scipioCurrentTableInfo", prevTableInfo)!>
    <#local dummy = setRequestVar("scipioCurrentTableSectionInfo", prevSectionInfo)!>
    <#local dummy = setRequestVar("scipioCurrentTableHasHeader", prevHasHeaderFlag)!>
    <#local dummy = setRequestVar("scipioCurrentTableRowAltFlag", prevRowAltFlag)!>
    <#local dummy = setRequestVar("scipioCurrentTableCurrentRowAlt", prevCurrentRowAlt)!>
    <#local dummy = setRequestVar("scipioCurrentTableLastRowAlt", prevLastRowAlt)!>
  </#if>
</#macro>

<#-- @table main markup - theme override -->
<#macro table_markup open=true close=true type="" styleName="" class="" id="" cellspacing="" useResponsive=false responsiveArgs={} 
  autoAltRows="" firstRowAlt="" inheritAltRows=false useFootAltRows=false tableIdNum=0 attribs={} excludeAttribs=[] origArgs={} passArgs={} catchArgs...>
  <#if open>
    <table<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#rt>
      <#lt><#if cellspacing?has_content> cellspacing="${cellspacing}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs exclude=excludeAttribs/></#if> width="100%">  
  </#if>
      <#nested>
  <#if close>
    </table>
    <#if useResponsive>
      <#-- Responsive tables bug workaround: responsive tables break if table has no header, 
          so only enable if a header was present during rendering -->
      <#local tableHasHeader = getRequestVar("scipioCurrentTableHasHeader")!"">
      <#if tableHasHeader?is_boolean && tableHasHeader == true>
        <@tableResponsiveScript args=responsiveArgs htmlwrap=true passArgs=passArgs />
      </#if>
    </#if>  
  </#if>
</#macro>

<#-- 
*************
* Table header
************
Defines a table header with advanced generating functionality. Analogous to HTML <thead> element.
-->
<#assign thead_defaultArgs = {
  "class":"", "id":"", "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro thead args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.thead_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>
  
  <#if open>
    <#-- inform the parent table (and anything else) that this table has a header -->
    <#local dummy = setRequestVar("scipioCurrentTableHasHeader", true)!>
    <#local prevTableSectionInfo = getRequestVar("scipioCurrentTableSectionInfo")!{}>
    <#local scipioCurrentTableSectionInfo = {"type": "head", "cellElem": "th"}>
    <#local dummy = setRequestVar("scipioCurrentTableSectionInfo", scipioCurrentTableSectionInfo)!>
    <#-- need to save values on a stack if open-only! -->
    <#if !close>
      <#local dummy = pushRequestStack("scipioTableHeadStack", {
        "prevTableSectionInfo":prevTableSectionInfo, 
        
        "class":class, 
        "id":id, 
        "attribs":attribs,
        "origArgs":origArgs,
        "passArgs":passArgs
      })>
    </#if>
  <#elseif close>
    <#local stackValues = popRequestStack("scipioTableHeadStack")!{}>
    <#local dummy = localsPutAll(stackValues)>
  <#else>
    <#-- (no missing values yet) -->
  </#if>
  <@thead_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs>
    <#nested>
  </@thead_markup>
  <#if close>
    <#local dummy = setRequestVar("scipioCurrentTableSectionInfo", prevTableSectionInfo)!>
  </#if>
</#macro>

<#-- @thead main markup - theme override -->
<#macro thead_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open>
    <thead<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>>
  </#if>
      <#nested>
  <#if close>
    </thead>
  </#if>
</#macro>

<#-- 
*************
* Table body
************
Defines a table body with advanced generating functionality. Analogous to HTML <tbody> element.
-->
<#assign tbody_defaultArgs = {
  "class":"", "id":"", "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro tbody args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.tbody_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <#if open>
    <#local prevTableSectionInfo = getRequestVar("scipioCurrentTableSectionInfo")!{}>
    <#local scipioCurrentTableSectionInfo = {"type": "body", "cellElem": "td"}>
    <#local dummy = setRequestVar("scipioCurrentTableSectionInfo", scipioCurrentTableSectionInfo)!>
    <#-- need to save values on a stack if open-only! -->
    <#if !close>
      <#local dummy = pushRequestStack("scipioTableBodyStack", {
        "prevTableSectionInfo":prevTableSectionInfo,
        
        "class":class, 
        "id":id, 
        "attribs":attribs,
        "origArgs":origArgs,
        "passArgs":passArgs
      })>
    </#if>
  <#elseif close>
    <#local stackValues = popRequestStack("scipioTableBodyStack")!{}>
    <#local dummy = localsPutAll(stackValues)>
  <#else>
    <#-- (no missing values yet) -->
  </#if>
  <@tbody_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs>
    <#nested>
  </@tbody_markup>
  <#if close>
    <#local dummy = setRequestVar("scipioCurrentTableSectionInfo", prevTableSectionInfo)!>
  </#if>
</#macro>

<#-- @tbody main markup - theme override -->
<#macro tbody_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open>
    <tbody<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>>
  </#if>
      <#nested>
  <#if close>
    </tbody>
  </#if>
</#macro>

<#-- 
*************
* Table footer
************
Defines a table footer with advanced generating functionality. Analogous to HTML <tfoot> element.
-->
<#assign tfoot_defaultArgs = {
  "class":"", "id":"", "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro tfoot args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.tfoot_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <#if open>
    <#local prevTableSectionInfo = getRequestVar("scipioCurrentTableSectionInfo")!{}>
    <#local scipioCurrentTableSectionInfo = {"type": "foot", "cellElem": "td"}>
    <#local dummy = setRequestVar("scipioCurrentTableSectionInfo", scipioCurrentTableSectionInfo)!>
    <#-- need to save values on a stack if open-only! -->
    <#if !close>
      <#local dummy = pushRequestStack("scipioTableFootStack", {
        "prevTableSectionInfo":prevTableSectionInfo,
        
        "class":class, 
        "id":id, 
        "attribs":attribs,
        "origArgs":origArgs,
        "passArgs":passArgs
      })>
    </#if>
  <#elseif close>
    <#local stackValues = popRequestStack("scipioTableFootStack")!{}>
    <#local dummy = localsPutAll(stackValues)>
  <#else>
    <#-- (no missing values yet) -->
  </#if>
  <@tfoot_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs>
    <#nested>
  </@tfoot_markup>
  <#if close>
    <#local dummy = setRequestVar("scipioCurrentTableSectionInfo", prevTableSectionInfo)!>
  </#if>
</#macro>

<#-- @tfoot main markup - theme override -->
<#macro tfoot_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open>
    <tfoot<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>>
  </#if>
      <#nested>
  <#if close>
    </tfoot>
  </#if>
</#macro>

<#-- 
*************
* Table Row
************
Helps define table rows. takes care of alt row styles. must have a parent @table wrapper. 
                     
  * Parameters *
    type                    = (generic|content|meta|util, default: -dependent on table type-, fallback default: generic)
                              In complete absence of global styles, default is "generic".
                              In default scipio styles, default is "generic" for "generic" tables, and "content" for all other table types.
                              Standard types:
                              * {{{generic}}}: free-form row with no assumptions on content.
                              * {{{content}}}: normal data or content row. exact meaning depends on table type.
                                note that for "data-complex" this definition is currently relaxed.
                              * {{{meta}}}: indicates this is a special info/status row (e.g. "No Records Found" message), not an actual content row.
                                meta rows are treated differently by default as are thead and tfoot rows.
                                exact meaning depends on table type.
                              * {{{util}}}: indicates this is a special utility-only row meant to hold no real data, 
                                such as: spacer rows ({{{<@tr type="util"><@td colspan=3><hr /></@td></@tr>}}})
                                TODO: this isn't handled yet but SHOULD be used in templates anyhow.
    class                   = ((css-class)) CSS classes
                              Supports prefixes (see #compileClassArg for more info):
                              * {{{+}}}: causes the classes to append only, never replace defaults (same logic as empty string "")
                              * {{{=}}}: causes the classes to replace non-essential defaults (same as specifying a class name directly)
    id                      = Row ID
    useAlt                  = ((boolean)) If specified, can manually enable/disable whether alternate row code runs per-row
    alt                     = ((boolean)) If specified, override the automatic auto-alt styling to specific value true or false (manual mode)
                              NOTE: At current time, alt on non-body rows (except foot rows if enabled in @table) does not affect
                                  next row's alt (unless groupLast used explicit on next) logic.
    groupLast               = ((boolean)) If true, considers row logically grouped with last row
                              Sets alt to exact same as last row.
    groupParent             = ((boolean)) Nested tables only, if true, considers row logically grouped with parent row
                              Sets alt to exact same as parent row.
    selected                = ((boolean), default: false) If specified and true marked as selected
    open, close             = ((boolean)) Advanced structure control, for esoteric cases
    attribs                 = ((map)) Other legacy <tr> attributes 
                              Needed for names containing dashes.
    inlineAttribs...        = ((inline-args)) Other legacy <tr> attributes and values
-->
<#assign tr_defaultArgs = {
  "type":"", "class":"", "id":"", "useAlt":"", "alt":"", "groupLast":"", "groupParent":"", "selected":"", 
  "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro tr args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.tr_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <#local scipioCurrentTableInfo = getRequestVar("scipioCurrentTableInfo")!{}>
  <#local scipioCurrentTableSectionInfo = getRequestVar("scipioCurrentTableSectionInfo")!{}>
  <#local scipioCurrentTableRowAltFlag = getRequestVar("scipioCurrentTableRowAltFlag")!false>
  <#local scipioCurrentTableLastRowAlt = getRequestVar("scipioCurrentTableLastRowAlt")!"">
  <#if open>
    <#local tableType = (scipioCurrentTableInfo.type)!"generic">
    <#local tableStyleName = (scipioCurrentTableInfo.styleName)!tableType>
    <#local sectionType = (scipioCurrentTableSectionInfo.type)!"body">
    <#if !type?has_content>
      <#local type = styles["table_" + tableStyleName + "_rowtype"]!styles["table_default_rowtype"]!"generic">
    </#if>
    <#local metaRow = (type == "meta")>
    <#local isRegAltRow = !metaRow && ((sectionType == "body") || (sectionType == "foot" && ((scipioCurrentTableInfo.useFootAltRows)!)==true))>
    <#if !(useAlt?is_boolean && useAlt == false)>
      <#if !alt?is_boolean>
        <#if groupLast?is_boolean && groupLast == true>
          <#local alt = scipioCurrentTableLastRowAlt!""> <#-- may be empty string (none) -->
        <#elseif groupParent?is_boolean && groupParent == true>
          <#local alt = (scipioCurrentTableInfo.parentRowAlt)!"">
        <#elseif (isRegAltRow && ((scipioCurrentTableInfo.autoAltRows)!false) == true)>
          <#if ((scipioCurrentTableInfo.inheritAltRows)!false) == true>
            <#local alt = (scipioCurrentTableInfo.parentRowAlt)!"">
          <#else>
            <#local alt = scipioCurrentTableRowAltFlag!false> <#-- always boolean -->
          </#if>
        <#elseif useAlt?is_boolean && useAlt == true>
          <#-- forced -->
          <#local alt = scipioCurrentTableRowAltFlag!false>
        </#if>
      </#if>
    </#if>
    <#-- save the "effective" or "real" current row alt -->
    <#local scipioCurrentTableCurrentRowAlt = alt>
    <#local dummy = setRequestVar("scipioCurrentTableCurrentRowAlt", scipioCurrentTableCurrentRowAlt)!>
    <#if alt?is_boolean>
      <#local class = addClassArg(class, alt?string(styles.row_alt!, styles.row_reg!))>
    </#if>
    <#if selected?is_boolean && selected == true>
      <#local class = addClassArg(class, styles.row_selected!)>
    </#if>
    <#-- need to save values on a stack if open-only! -->
    <#if !close>
      <#local dummy = pushRequestStack("scipioTableRowStack", {
        "type":type, 
        "class":class, 
        "id":id, 
        "useAlt":useAlt, 
        "alt":alt, 
        "groupLast":groupLast, 
        "groupParent":groupParent, 
        "selected":selected,
        "attribs":attribs,
        "origArgs":origArgs,
        "passArgs":passArgs,
        
        "isRegAltRow":isRegAltRow
      })>
    </#if>
  <#elseif close>
    <#local stackValues = popRequestStack("scipioTableRowStack")!{}>
    <#local dummy = localsPutAll(stackValues)>
  <#else>
    <#local isRegAltRow = false>
  </#if>    
  <@tr_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs>
    <#nested>
  </@tr_markup>
  <#if close>
    <#if !(useAlt?is_boolean && useAlt == false)>
      <#-- NOTE: isRegAltRow check here could be removed but maybe better to keep? only auto-toggle for regular rows... -->
      <#if alt?is_boolean && isRegAltRow> <#-- not needed:  && ((scipioCurrentTableInfo.inheritAltRows)!)==false -->
        <#local scipioCurrentTableRowAltFlag = !alt>
        <#local dummy = setRequestVar("scipioCurrentTableRowAltFlag", scipioCurrentTableRowAltFlag)!>
      </#if>
    </#if>
    <#-- NOTE: may be empty string, that's ok, will record if last was disabled so groupLast always makes sense -->
    <#local scipioCurrentTableLastRowAlt = alt>
    <#local dummy = setRequestVar("scipioCurrentTableLastRowAlt", scipioCurrentTableLastRowAlt)!>
  </#if>
</#macro>

<#-- @tr main markup - theme override -->
<#macro tr_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open>
    <tr<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>>
  </#if>
      <#nested>
  <#if close>
    </tr>
  </#if>
</#macro>

<#-- 
*************
* Table Header Cell
************
Defines a table header cell. Analogous to <th> HTML element.
                    
  * Parameters *
    class                   = ((css-class)) CSS classes 
                              Supports prefixes (see #compileClassArg for more info):
                              * {{{+}}}: causes the classes to append only, never replace defaults (same logic as empty string "")
                              * {{{=}}}: causes the classes to replace non-essential defaults (same as specifying a class name directly)
    id                      = Cell ID
    open, close             = ((boolean)) Advanced structure control, for esoteric cases
    attribs                 = ((map)) Other legacy <th> and <td> attributes
                              Needed for names containing dashes.
    inlineAttribs...        = ((inline-args)) Other legacy <th> and <td> attributes and values
-->
<#assign th_defaultArgs = {
  "class":"", "id":"", "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro th args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.th_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <@th_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs><#nested></@th_markup>
</#macro>

<#-- @th main markup - theme override -->
<#macro th_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open><th<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>></#if><#nested><#if close></th></#if>
</#macro>

<#-- 
*************
* Table Body Cell
************
Defines a table body cell. Analogous to <td> HTML element.
                    
  * Parameters *
    (other)                 = See @th
-->
<#assign td_defaultArgs = {
  "class":"", "id":"", "open":true, "close":true, "attribs":{}, "passArgs":{}
}>
<#macro td args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.td_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local attribs = makeAttribMapFromArgMap(args)>
  <#local origArgs = args>

  <@td_markup open=open close=close class=class id=id attribs=attribs origArgs=origArgs passArgs=passArgs><#nested></@td_markup>
</#macro>

<#-- @td main markup - theme override -->
<#macro td_markup open=true close=true class="" id="" attribs="" origArgs={} passArgs={} catchArgs...>
  <#if open><td<@compiledClassAttribStr class=class /><#if id?has_content> id="${id}"</#if><#if attribs?has_content><@commonElemAttribStr attribs=attribs /></#if>></#if><#nested><#if close></td></#if>
</#macro>

<#-- 
*************
* Table Row Class Attribute String
************
Helps build common data/table row class string (odd, even, etc.). Common pattern (in stock Ofbiz templates).
DEPRECATED: use @table, @tr macros instead. 

  * Usage Examples *  
    <tr<@tableRowClassAttribStr class="myClass" alt=false/>>
                    
  * Parameters *
    class                   = ((css-class)) CSS classes 
                              Supports prefixes (see #compileClassArg for more info):
                              * {{{+}}}: causes the classes to append only, never replace defaults (same logic as empty string "")
                              * {{{=}}}: causes the classes to replace non-essential defaults (same as specifying a class name directly)
    alt                     = ((boolean), default: false) If true is alternate row (odd), if false regular (even)
    selected                = ((boolean), default: false) If true marked as selected
-->
<#assign tableRowClassAttribStr_defaultArgs = {
  "class":"", "alt":"", "selected":"", "passArgs":{}
}>
<#macro tableRowClassAttribStr args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.tableRowClassAttribStr_defaultArgs)>
  <#local dummy = localsPutAll(args)>

  <#if alt?is_boolean>
    <#local class = addClassArg(class, alt?string(styles.row_alt!, styles.row_reg!))>
  </#if>
  <#if selected?is_boolean && selected == true>
    <#local class = addClassArg(class, styles.row_selected!)>
  </#if>
  <@compiledClassAttribStr class=class /><#t>
</#macro>

<#-- 
*************
* Pricing table wrapper
************
Creates a pricing table wrapper.

Since this is very foundation specific, this function may be dropped in future installations.

  * Usage Examples *  
    <@pul>
        <@pli>Text or <a href="">Anchor</a></@pli>
    </@pul>            
                    
  * Parameters *
    title                   = Fieldset title
-->
<#assign pul_defaultArgs = {
  "title":"", "passArgs":{}
}>
<#macro pul args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.pul_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <@pul_markup title=title origArgs=origArgs passArgs=passArgs><#nested></@pul_markup>
</#macro>

<#-- @pul main markup - theme override -->
<#macro pul_markup title="" origArgs={} passArgs={} catchArgs...>
  <ul class="${styles.pricing_wrap!}">
    <#if title?has_content><@pli type="title">${title!}</@pli></#if>
    <#nested>
  </ul>
</#macro>

<#-- 
*************
* Pricing table element
************
Creates a pricing table element/entry.

Since this is very foundation specific, this function may be dropped in future installations.

  * Parameters *
    type                   = ((string) price|description|title|button, default:-empty-)
-->
<#assign pli_defaultArgs = {
  "type":"", "passArgs":{}
}>
<#macro pli args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.pli_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <@pli_markup type=type origArgs=origArgs passArgs=passArgs><#nested></@pli_markup>
</#macro>

<#-- @pli main markup - theme override -->
<#macro pli_markup type="" origArgs={} passArgs={} catchArgs...>
  <#switch type>
    <#case "price">
      <li class="${styles.pricing_price!}"><#nested></li>
    <#break>
    <#case "description">
      <li class="${styles.pricing_description!}"><#nested></li>
    <#break>
    <#case "title">
      <li class="${styles.pricing_title!}"><#nested></li>
    <#break>
    <#case "button">
      <li class="${styles.pricing_cta!}"><#nested></li>
    <#break>        
    <#default>
      <li class="${styles.pricing_bullet!}"><#nested></li>
    <#break>
  </#switch>
</#macro>

<#-- 
*************
* Chart
************
Creates a chart wrapper.

Libraries used:
Foundation Pizza: http://zurb.com/playground/pizza-amore-charts-and-graphs (customization through _base.scss) - deprecated
Chart.js: http://www.chartjs.org/docs/ (customization through _charsjs.scss)

  * Usage Examples *  
    <@chart type="bar" >
        <@chartdata value="36" title="Peperoni"/> 
    </@chart>              
                    
  * Parameters *
    type                    = (pie|bar|line, default: pie)
    library                 = (foundation|chart, default: chart) Uses either chart.js or foundation. 
                               "foundation" is deprecated and requires additional seed data in order to run. 
                               Uncomment "PIZZA AMORE" in component://base-theme/data/BaseThemeData.xml to use
    title                   = ((string), default: -empty-) Data Title
    xlabel                  = X-axis label
    ylabel                  = Y-axis label
    label1                  = Dataset 1 label
    label2                  = Dataset 2 label
    labelUom1               = Dataset 1 currency symbol (automatically added to the tooltips)
    labelUom2               = Dataset 2 currency symbol (automatically added to the tooltips)
    
  * Related *
    @chartdata
-->
<#assign chart_defaultArgs = {
  "type":"pie", "library":"chart", "title":"", "xlabel":"","ylabel":"","label1":"","label2":"","labelUom1":"","labelUom2":"","passArgs":{}
}>
<#macro chart args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.chart_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>

  <#global chartLibrary = library!"chart"/>
  <#local chartIdNum = getRequestVar("scipioChartIdNum")!0>
  <#local chartIdNum = chartIdNum + 1 />
  <#local dummy = setRequestVar("scipioChartIdNum", chartIdNum)>
  <#global chartId = "chart_${renderSeqNumber!}_${chartIdNum!}"/>
  <#global chartType = type/>
  <#global chartDataIndex = 0/>
  
  <@chart_markup type=type chartId=chartId chartIdNum=chartIdNum chartLibrary=chartLibrary chartDatasets=chartDatasets title=title 
    xlabel=xlabel ylabel=ylabel label1=label1 label2=label2 labelUom1=labelUom1 labelUom2=labelUom2
    renderSeqNumber=renderSeqNumber origArgs=origArgs passArgs=passArgs><#nested></@chart_markup>
</#macro>

<#-- @chart main markup - theme override -->
<#macro chart_markup type="" chartLibrary="" title="" chartId="" xlabel="" ylabel="" label1="" label2="" labelUom1="" labelUom2="" chartIdNum=0 renderSeqNumber=0 origArgs={} passArgs={} catchArgs...>
  <#local nestedContent><#nested /></#local>
  <#if chartLibrary=="foundation">
    <#if nestedContent?has_content>
    <@row>
      <@cell columns=3>
        <ul data-${type!}-id="chart_${renderSeqNumber!}_${chartIdNum!}" class="${styles.chart_legend!}">
            <#nested/>
        </ul>
      </@cell>
      <@cell columns=9><div id="chart_${renderSeqNumber!}_${chartIdNum!}" style="height:300px;"></div></@cell>
    </@row>
    <#else>
        <#-- Default to chart.js chart for now, as this is capable of rendering an empty chart -->
        <@chart type=type library="chart" xlabel=xlabel ylabel=ylabel label1=label1 label2=label2>
            <#nested>
        </@chart>
    </#if>
  <#else>
    <#-- Get the number of datasets by inspecting the nested content (chartjs addData function values) -->
    <#if nestedContent?has_content>
        <#assign chartDatasets=chart_get_number_of_datasets(nestedContent, chartLibrary) />
        <#else>
        <#assign chartDatasets=0/>
    </#if>
    <#if (chartDatasets < 1)><#local chartDatasets = 1 /></#if>
    <span class="chart-data">&nbsp;</span>
    <canvas id="${chartId!}" height="300" width="500"></canvas>
    <@script>
        $(function(){
            var chartDataEl = $('.chart-data').first();
            var chartData = chartDataEl.sassToJs({pseudoEl:"::before", cssProperty: "content"});
            var options =  {
                    responsive: true, 
                    responsiveAnimationDuration: 0, 
                    animation: {
                        duration: 1000
                    },
                    maintainAspectRatio: true,
                    tooltips: {
                        mode: <#if type=="line" || type=="bar">'label'<#else>'single'</#if><#if (labelUom1?has_content ||labelUom2?has_content) >,
                        callbacks: {
                            label: function(tooltipItem, data) {                                
                                <#if labelUom1?has_content> 
                                    if(tooltipItem.datasetIndex == 0) {
                                        var datasetLabel = '';                                  
                                        <#if type=="line" || type=="bar">
                                             datasetLabel = data.datasets[tooltipItem.datasetIndex].label;
                                             return datasetLabel + ': ' + tooltipItem.yLabel + ' ${labelUom1!}';
                                        <#elseif type="pie">
                                             datasetLabel = data.labels[tooltipItem.index] + ': ' + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                                             return datasetLabel + ' ${labelUom1!}';
                                        <#else>
                                            return datasetLabel;
                                        </#if>
                                    }
                                </#if>
                                <#if labelUom2?has_content> 
                                    if(tooltipItem.datasetIndex == 1) {
                                        var datasetLabel = data.datasets[tooltipItem.datasetIndex].label || '';
                                        return datasetLabel + ': ' + tooltipItem.yLabel + ' ${labelUom2!}';
                                    }
                                </#if>
                            }
                        }
                        </#if>
                    },
                    hover: {
                        mode: <#if type=="line" || type=="bar">'label'<#else>'single'</#if>
                    },
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 30
                        }
                    },
                    title: {
                        <#if title?has_content>
                            display: true,
                            text: '${title}',
                        <#else>
                            display: false,
                        </#if>
                        fontColor: chartData.scaleLabelFontColor,
                        fontFamily: chartData.scaleLabelFontFamily,
                        fontSize: chartData.scaleLabelFontSize
                    }
                    <#if type=="line" || type=="bar">,
                        <#if type=="line"> animation: {
                        duration: 0
                        },</#if>
                        scales: {
                            type: chartData.scaleType,
                            display: true,                        
                            xAxes: [{
                                gridLines: {
                                    color: chartData.scaleGridLineColor
                                },
                                scaleLabel : {
                                    display: chartData.scaleLabelDisplay,
                                    <#if xlabel?has_content>labelString: '${xlabel!}',</#if>
                                    fontColor: chartData.scaleLabelFontColor,
                                    fontFamily: chartData.scaleLabelFontFamily,
                                    fontSize: chartData.scaleLabelFontSize                                
                                },
                                ticks: {
                                    display: true,
                                    autoSkip: true,
                                    padding:10,
                                    maxRotation:30,
                                    fontColor: chartData.scaleLabelFontColor,
                                    fontFamily: chartData.scaleLabelFontFamily,
                                    fontSize: chartData.scaleLabelFontSize
                                }                            
                              }],
                            yAxes: [{
                                scaleLabel : {
                                    display: chartData.scaleLabelDisplay,
                                    <#if ylabel?has_content>scaleLabel: '${xlabel!}',</#if>
                                    fontColor: chartData.scaleLabelFontColor,
                                    fontFamily: chartData.scaleLabelFontFamily,
                                    fontSize: chartData.scaleLabelFontSize
                                },
                                ticks: {
                                    display: true,
                                    autoSkip: true,                            
                                    fontColor: chartData.scaleLabelFontColor,
                                    fontFamily: chartData.scaleLabelFontFamily,
                                    fontSize: chartData.scaleLabelFontSize
                                }
                            }]
                        }
                    <#elseif type=="pie">,                        
                        scale: {
                           type: chartData.scaleType,
                           display: false
                        }            
                    </#if>
                };
            var ctx_${renderSeqNumber!}_${chartIdNum!} = $('#${chartId!}').get(0).getContext("2d");
            var data = {
                labels :[],
                datasets: [
                    {
                    
                      <#if type=="line" || type=="bar">
                      label: '${label1!}',                      
                      fill: true,
                      backgroundColor: chartData.primaryFillColor,
                      borderColor: chartData.primaryStrokeColor,
                      pointBackgroundColor: chartData.pointColor,
                      pointBorderColor: chartData.primaryPointStrokeColor,
                      pointHoverBackgroundColor: chartData.pointHighlightFill,
                      pointHoverBorderColor: chartData.pointHighlightStroke,
                      <#else>
                      backgroundColor: [
                            chartData.pieFillColor1,
                            chartData.pieFillColor2,
                            chartData.pieFillColor3,
                            chartData.pieFillColor4,
                            chartData.pieFillColor5,
                            chartData.pieFillColor6
                        ],
                        hoverBackgroundColor: [
                            chartData.pieHighlightColor1,
                            chartData.pieHighlightColor2,
                            chartData.pieHighlightColor3,
                            chartData.pieHighlightColor4,
                            chartData.pieHighlightColor5,
                            chartData.pieHighlightColor6
                        ],
                      </#if>
                      data: []
                    }
                    <#if (chartDatasets > 1)>
                    ,{
                      <#if (type=="line" || type=="bar")>
                      label: '${label2!}',
                      fill: true,
                      backgroundColor: chartData.secondaryFillColor,
                      borderColor: chartData.secondaryStrokeColor,
                      pointBackgroundColor: chartData.pointColor,
                      pointBorderColor: chartData.secondaryPointStrokeColor,
                      pointHoverBackgroundColor: chartData.pointHighlightFill,
                      pointHoverBorderColor: chartData.pointHighlightStroke,
                      <#else>
                       backgroundColor: [
                            chartData.pieFillColor1,
                            chartData.pieFillColor2,
                            chartData.pieFillColor3,
                            chartData.pieFillColor4,
                            chartData.pieFillColor5,
                            chartData.pieFillColor6
                        ]
                      </#if>
                      data: []
                    }           
                    </#if>        
                    ]
                };
            var config = {
                <#switch type>
                    <#case "bar">type: 'bar'<#break>
                    <#case "pie">type: 'pie'<#break>
                    <#default>type: 'line'
                </#switch>,
                data: data,
                options: options
            };
            var ${chartId!} = new Chart(ctx_${renderSeqNumber!}_${chartIdNum!},config);
            ${nestedContent}
            ${chartId!}.update();
        });
    </@script>
  </#if>
</#macro>

<#-- 
*************
* chart_get_number_of_datasets
************
Gets chart number of datasets.
                    
  * Parameters *
    content                 = (pie|bar|line, default: pie)
    library                 = (foundation|chart, default: chart)   
-->
<#function chart_get_number_of_datasets content="" library="chart">
    <#if content?has_content>
        <#if library == "chart">
            <#local num_of_values_found = 0 />
            <#-- cleanup spaces and tabs and split by the regex ';.+\n' -->
            <#-- TODO: check if it works for all OS, in linux works -->
            <#local res = content?matches(r".*.data.datasets\[(.*)\].*") />
            
            <#list res as m>
                    <#local num_found=m?groups[1]/>
                    <#if num_found?has_content && (num_found?number > num_of_values_found)>
                        <#local num_of_values_found = num_found?number />
                    </#if>
            </#list>
            
            <#return num_of_values_found+1 />
        </#if>
    </#if>
</#function>

<#-- 
*************
* Chart data
************
Chart data entry.

  * Related *
    @chart
-->
<#assign chartdata_defaultArgs = {
  "title":"", "value":"", "value2":"", "passArgs":{}
}>
<#macro chartdata args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.chartdata_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  
  <#if !chartLibrary?has_content>
    <#local chartLibrary = "foundation"/>
  </#if>

  <@chartdata_markup title=title value=value value2=value2 chartId=chartId chartType=chartType 
    chartLibrary=chartLibrary origArgs=origArgs passArgs=passArgs><#nested></@chartdata_markup>
</#macro>

<#-- @chartdata main markup - theme override -->
<#macro chartdata_markup title="" value="" value2="" chartId="" chartType="" chartLibrary="" origArgs={} passArgs={} catchArgs...>
  <#if chartLibrary == "foundation">
    <#if chartType == "line">
      <#global chartDataIndex =  chartDataIndex + 1 />
      <li data-y="${value!}" data-x="${chartDataIndex}">${title!}</li>
    <#else>
      <li data-value="${value!}">${title!}</li>
    </#if>
  <#else>
      config.data.labels.push('${title!}');
      <#if value?has_content>config.data.datasets[0].data.push(${value!});</#if>
      <#if value2?has_content>config.data.datasets[1].data.push(${value2!});</#if>
  </#if>
</#macro>

<#-- 
*************
* Slider
************
Creates a slider wrapper.

  * Usage Examples *  
    <@slider>
        <@slide title="" image="" link="/myUrl.html">
            // content
        </@slide> 
    </@slide>              
                    
  * Parameters *
    title                   = ((string), default: -empty-) Data Title
    id                      = ((string), default: -empty-) Slider id
    class                   = ((css-class)) Heading element CSS classes
                              Supports prefixes (see #compileClassArg for more info):
                              * {{{+}}}: causes the classes to append only, never replace defaults (same logic as empty string "")
                              * {{{=}}}: causes the classes to replace non-essential defaults (same as specifying a class name directly)
    library                 = (|owl|slick, default: -empty-) Uses either Owl carousel, Slick or foundation orbit. 
                               "owl" & "slick" require additional seed data in order to run. 
                               Uncomment "Owl" in component://base-theme/data/BaseThemeData.xml in order to use
    controls                = ((boolean), default: true) Left / Right navigation
    indicator               = ((boolean), default: true) Bullet indicators
    jsOptions               = (string) Additional js argument, included on js initialization
    
  * Related *
    @slide
-->
<#assign slider_defaultArgs = {
  "title":"", "library":"","id":"","class":"","controls":true,"indicator":true, "jsOptions":"","passArgs":{}
}>
<#macro slider args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.slider_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>

  <#local sliderIdNum = getRequestVar("scipioSliderIdNum")!0>
  <#local sliderIdNum = sliderIdNum + 1 />
  <#local dummy = setRequestVar("scipioSliderIdNum", sliderIdNum)>
  <#global sliderId = "slider_${renderSeqNumber!}_${sliderIdNum!}"/>
    
  <@slider_markup sliderId=(id!sliderId) sliderIdNum=sliderIdNum class=class title=title library=library controls=controls indicator=indicator
        jsOptions=jsOptions origArgs=origArgs passArgs=passArgs><#nested></@slider_markup>
</#macro>

<#-- @chart main markup - theme override -->
<#macro slider_markup title="" sliderId="" sliderIdNum=0 class="" library="" controls=true indicator=true 
        jsOptions="" origArgs={} passArgs={} catchArgs...>
    <#if !sliderId?has_content><#local sliderId = "scipio_slider_${sliderIdNum}"/></#if>
    <#if title?has_content><@heading>${title}</@heading></#if>
    <#switch library>
        <#case "owl">    
            <div class="owl-carousel" class="${class}" id="${sliderId}">
                <#nested/>
            </div>
            <script type="text/javascript">
            $(document).ready(function(){
                  $("#${sliderId}").owlCarousel({${jsOptions}});
                });
            </script>
          <#break>
        <#case "slick">
            <div class="${class}" id="${sliderId}">
                <#nested/>
            </div>
            <script type="text/javascript">
            $(document).ready(function(){
                  $("#${sliderId}").slick({${jsOptions}});
                });
            </script>
          <#break>
        <#default>
            <#local dataOptions>
                <#t>navigation_arrows:${controls?string("true","false")!"true"}; bullets:${indicator?string("true","false")!"true"};slide_number:false;
            </#local>
            
            <div class="${class} ${styles.slider_container!""}" data-orbit id="${sliderId}"<#if dataOptions?has_content> data-options="${dataOptions}"</#if>>
              <#nested/>
            </div>
    </#switch>
</#macro>

<#-- 
*************
* Slide
************
Slider data entry - a single slide.

  * Usage Examples *  
    <@slide title="Slide #1" image="">
       // content
    </@tile>

  * Parameters *
    title                   = ((string), default: -empty-) Data Title
    class                   = ((css-class)) CSS classes 
                              Supports prefixes (see #compileClassArg for more info):
                              * {{{+}}}: causes the classes to append only, never replace defaults (same logic as empty string "")
                              * {{{=}}}: causes the classes to replace non-essential defaults (same as specifying a class name directly)
    library                 = (|owl|slick, default: -empty-) Uses either Owl carousel, Slick or foundation orbit. 
                               "owl" & "slick" require additional seed data in order to run. 
    link                    = Link URL around nested content
                              WARN: can only use if no other links inside nested content
                              NOTE: This parameter is automatically (re-)escaped for HTML and javascript (using #escapeFullUrl or equivalent) 
                                  to help prevent injection, as it is high-risk. It accepts pre-escaped query string delimiters for compatibility,
                                  but other characters should not be manually escaped (apart from URL parameter encoding).
    linkTarget              = (|_blank|(boolean)|..., default: -from global styles-, fallback default: -empty-) Target for link element
                              If boolean, false prevents any; true will allow global styles hash lookup.
    image                   = Background image URL

  * Related *
    @slider
-->
<#assign slide_defaultArgs = {
  "title":"", "class":"", "library":"","link":"", "linkTarget":false, "image":"", "passArgs":{}
}>
<#macro slide args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.slide_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <#local stylePrefix = "slide_">
  
  <#if linkTarget?is_boolean && linkTarget == false>
    <#local linkTarget = "">
  <#elseif (linkTarget?is_boolean && linkTarget == true) || !linkTarget?has_content>
    <#local linkTarget = styles[stylePrefix + "_linktarget"]!"">
  </#if>

  <@slide_markup class=class library=library image=image link=link linkTarget=linkTarget title=title origArgs=origArgs passArgs=passArgs><#nested></@slide_markup>
</#macro>

<#-- @slide main markup - theme override -->
<#macro slide_markup class="" library="" image="" link="" linkTarget="" title="" origArgs={} passArgs={} catchArgs...>
    <#local slideIdNum = getRequestVar("scipioSlideIdNum")!0>
    <#local slideIdNum = slideIdNum + 1 />
    <#local dummy = setRequestVar("scipioSlideIdNum", slideIdNum)>
    <#local slideId = "slide_${renderSeqNumber!}_${slideIdNum!}"/>
    <#if library=="owl" || library=="slick">
        <div id="${slideId}" class="item">
            <#if link?has_content><a href="${escapeFullUrl(link, 'html')}"<#if linkTarget?has_content> target="${linkTarget}"</#if>></#if>
            <div>
            <#if title?has_content><h2>${title!}</h2></#if>
            <#if image?has_content>
            <img src="${image}"/>
            </#if>
              <#local nestedContent><#nested></#local>
              <#if nestedContent?has_content><div class="${styles.slide_content!}">${nestedContent}</div></#if>
            </div>
            <#if link?has_content></a></#if>
        </div>
    <#else>
        <div data-orbit-slide="${slideId}" class="${styles.slide_container!}">
            <#if link?has_content><a href="${escapeFullUrl(link, 'html')}"<#if linkTarget?has_content> target="${linkTarget}"</#if>></#if>
            <div>
            <#if title?has_content><h2>${title}</h2></#if>
              <#if image?has_content>
                <img src="${image}"/>
              </#if>
              <#local nestedContent><#nested></#local>
              <#if nestedContent?has_content><div class="${styles.slide_content!}">${nestedContent}</div></#if>
            </div>
            <#if link?has_content></a></#if>
        </div>
    </#if>
</#macro>


<#-- 
*************
* img
************
Image tag - eases the positioning/styling of images with inline styles. Uses https://www.w3.org/TR/css3-images/#the-object-fit .
Relies on custom scipioObjectFit Javascript function as a fallback for IE.

  * Usage Examples *  
    <@img src="..." type="cover" height="" width=""/>

  * Parameters *
    src                     = (string) image location
                              WARN: At current time, do not pass unsanitized input for this parameter; escaping not implemented
                                  If you must use user input in src, do not use this macro for time being (expect escaping to be applied later).
                              FIXME: escaping for style urls
    class                   = ((css-class)) CSS classes 
                              Supports prefixes (see #compileClassArg for more info):
                              * {{{+}}}: causes the classes to append only, never replace defaults (same logic as empty string "")
                              * {{{=}}}: causes the classes to replace non-essential defaults (same as specifying a class name directly)
    type                    = (none|fill|cover|contain|scale-down|bg-cover, default: cover) 
                              * fill|cover|contain|scale-down = css3 object-fit
                              * bgcover = css background cover
    link                    = Link URL around nested content
                              WARN: can only use if no other links inside nested content
                              NOTE: This parameter is automatically (re-)escaped for HTML and javascript (using #escapeFullUrl or equivalent) 
                                  to help prevent injection, as it is high-risk. It accepts pre-escaped query string delimiters for compatibility,
                                  but other characters should not be manually escaped (apart from URL parameter encoding).
    linkTarget              = (|_blank|(boolean)|..., default: -from global styles-, fallback default: -empty-) Target for link element
                              If boolean, false prevents any; true will allow global styles hash lookup.
    width                   = (string) container width, e.g. "12px" - acts as a max-width
    height                  = (string) container height e.g. "12px" - acts as a max-height  
-->
<#assign img_defaultArgs = {
  "src":"", "type":"cover", "class":"", "width":"", "height":"","link":"", "linkTarget":false, "passArgs":{}
}>
<#macro img args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, scipioStdTmplLib.img_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <#local stylePrefix = "img_">
  
  <#if linkTarget?is_boolean && linkTarget == false>
    <#local linkTarget = "">
  <#elseif (linkTarget?is_boolean && linkTarget == true) || !linkTarget?has_content>
    <#local linkTarget = styles[stylePrefix + "_linktarget"]!"">
  </#if>
  <@img_markup class=class src=src type=type width=width height=height link=link linkTarget=linkTarget origArgs=origArgs passArgs=passArgs><#nested></@img_markup>
</#macro>

<#-- @img main markup - theme override -->
<#macro img_markup class="" src="" type="" width="" height="" link=link linkTarget=linkTarget origArgs={} passArgs={} catchArgs...>
    <#local imgContainer><#if width?has_content>width: ${width};</#if><#if height?has_content>height: ${height};</#if></#local>
    <#local nested><#nested></#local>
    <#switch type>
        <#case "bgcover">
            <#local imgStyle>
                <#-- WARN/FIXME: escapeFullUrl currently doesn't escape style, so this is unsafe! no easy functions for this -->
                background:url('${escapeFullUrl(src, 'style')}') no-repeat center center fixed;        
                -webkit-background-size: cover;
                -moz-background-size: cover;
                -o-background-size: cover;
                background-size: cover;
                margin-bottom:0px;
                display:block;
                position:relative;
                ${imgContainer}
            </#local>
            <div class="scipio-image-container ${class}">
                <#if link?has_content><a href="${escapeFullUrl(link, 'html')}"<#if linkTarget?has_content> target="${linkTarget}"</#if>></#if>
                    <div style="${imgStyle}" class="scipio-image"></div>
                <#if link?has_content></a></#if>
                <#if nested?has_content><#nested></#if>
            </div>
          <#break>
        <#default>
            <#local imgStyle><#if imgContainer?has_content>${imgContainer}</#if>object-fit: ${type};</#local>
            <div class="scipio-image-container ${class}" style="${imgContainer}" scipioFit="${type}">
                <#if link?has_content><a href="${escapeFullUrl(link, 'html')}"<#if linkTarget?has_content> target="${linkTarget}"</#if>></#if>
                    <img src="${src}" class="scipio-image" style="${imgStyle}"/>
                <#if link?has_content></a></#if>
                <#if nested?has_content><#nested></#if>
            </div>
    </#switch>
</#macro>