
<CFSCRIPT>
  /* COMPARE A DEFAULT VALUE AGAINST AN INCOMING VARIABLE NAME'S VALUE
     THEN SET VALUE ATTRIBUTE OF THE HTML OPTION TAG (SELECTED)
     SYNTAX: setSelectedValue(value,inVarName [,flagString])
     USAGE:  setSelectedValue('1',lc_virtual_tour,'CHECKED')               */
  function setSelectedValue(value,inVarName) {
    var defValue   = trim(value);     // Trim default value
    var inVarValue = trim(inVarName); // evaluate inVarName
    var flagString = "SELECTED";      // set default flag to SELECTED (CHECKED, etc.)
    var outString  = "";              // set default outString to blank
    var listDelimiter = ",";          // set delimiter character string
    var comparisonType  = "ListFindNoCase";  // default string comparison type

    // check to see if a third optional parameter has been passed...
    // this is an alternate flagString value
    if (ArrayLen(Arguments) EQ 3) { flagString = Arguments[3]; }

    // if a fourth optional argument has been passed in...
    // this is a custom listDelimiter
    if (ArrayLen(Arguments) EQ 4) {
      flagString      = Arguments[3];
      listDelimiter   = Arguments[4];
    }

    // if a fifth optional argument has been passed in,
    // then use this to change the default string comparison type (Find, ListFindNoCase, etc.)
    if (ArrayLen(Arguments) EQ 5) {
      flagString      = Arguments[3];
      listDelimiter   = Arguments[4];
      comparisonType  = Arguments[5];
    }

    if (NOT CompareNoCase(comparisonType,"ListFindNoCase")) {
      // check to see if the incoming value is found in the default value list (defValue) based on a delimeter,
      // if so, set the actual VALUE="#defValue#" text with the appropriate SELECTED (flagString) value text
      // note: may need to extend this in the future to allow quoted value lists or other non-comma delimiter(s)
      if (ListFindNoCase(inVarValue,defValue,listDelimiter)) {
        outString = 'value="' & defValue & '" ' & flagString & '="' & flagString & '"';
      }
      else {
        outString = 'value="' & defValue & '"';
      }
    } else if (NOT CompareNoCase(comparisonType,"FindNoCase")) {
      // check to see if the incoming value is found in the specified default value string
      // note: may need to extend this in the future to allow quoted value lists or other non-comma delimiter(s)
      if (FindNoCase(defValue,inVarValue)) {
        outString = 'value="' & defValue & '" ' & flagString & '="' & flagString & '"';
      }
      else {
        outString = 'value="' & defValue & '"';
      }
    }


    return outString;
  }

  /* PARSE A URL STRING TO REMOVE ONE OR MORE PARAMETERS FROM THE SUPPLIED URL */
  // SYNTAX: remURLParam(URLString, 'URLParamName_1,URLParamName_2', 'OutgoingVarName' [, 'WriteOutput'])
  // USAGE:  remURLParam(thispage,'start','thispage_nostart'); // parse thispage to remove "start" variable from URL
  function remURLParam(URLString, URLParamNameList, returnVarName) {
    var argumentsLen   = ArrayLen(Arguments);
    var URLParamName   = "";
    var URLParamValue  = "";
    var temp_URLString = URLString;
    var outString      = "";

    // loop through URLParamNameList and run once per each list item.
    for (idx = 1; idx LTE ListLen(URLParamNameList); idx = idx + 1) {
      URLParamName = ListGetAt(URLParamNameList,idx); // get the URLParamName for this loop
      if ( IsDefined("url.#URLParamName#") ) {
        URLParamValue = Evaluate(URLParamName);
        temp_URLString = ReplaceNoCase(temp_URLString,"&#URLParamName#=#URLParamValue#","","all");
        temp_URLString = ReplaceNoCase(temp_URLString,"&#URLParamName#=#URLEncodedFormat(URLParamValue)#","","all");
      }
    }
    // set dynamic outgoing variable after all substitutions have been made
    "#returnVarName#" = temp_URLString;

    // check to see if optional attibute is Write
    if ( argumentsLen GTE 4 AND Arguments[4] EQ 1 ) {
      outString = Evaluate(returnVarName);
      return outString;
    }
  }

  // TAKE A PROPERLY FORMATED FULL NAME ("FIRST MIDDLE LAST") AND CONVERT IT TO THE FORMAT SPECIFIED
  // THE ARMS FORMAT IS THE DEFAULT FORMAT
  // syntax: convertFullName(fullNameList);
  // usage:  convertFullName("KAROLE D SMITH,TINA M AGUILAR,EDWARD K BENALLY,GREG AULT");
  function convertFullName(fullNameList) {
    var aTemp = ListToArray(fullNameList);
    var convTemp = ""; var strTemp = ""; var fNameTemp = ""; var lmNameTemp = "";
    var fmlDelim = chr(32);   // space: " " delimiter
    var convDelim = chr(124); // pipe : "|" delimiter
    var toType = "ARMS"; // use to allow different return types

    if (NOT Compare(toType,"ARMS")) {
      //convert to format like "SMITH, KAROLE D|AGUILAR, TINA M|BENALLY, EDWARD K|AULT, GREG"
      for (i=1; i LTE ArrayLen(aTemp); i=i+1) {
        lmNameTemp = ListLast(aTemp[i],fmlDelim); // place last item in last name
        // prepend second to last name onto the lmNameTemp

        fNameTemp = ListDeleteAt(aTemp[i],ListLen(aTemp[i],fmlDelim),fmlDelim);
        strTemp  = "#lmNameTemp#,#fNameTemp#";
        convTemp = ListAppend(convTemp,strTemp,convDelim);
      }
    }
    return convTemp;
  }
  /*
  function convertFullName(fullNameList) {
    var aTemp = ListToArray(fullNameList); var listTemp = ""; var strTemp = "";
    var toType = "ARMS"; // use to allow different return types

    if (NOT Compare(toType,"ARMS")) {
      //convert to format like "SMITH, KAROLE D|AGUILAR, TINA M|BENALLY, EDWARD K|AULT, GREG"
      for (i=1; i LTE ArrayLen(aTemp); i=i+1) {
        strTemp  = "#ListLast(aTemp[i]," ")#,#ListDeleteAt(aTemp[i],ListLen(aTemp[i]," ")," ")#";
        listTemp = ListAppend(listTemp,strTemp,"|");
      }
    }
    return listTemp;
  }*/


  /* CREATE A SET OF URL PARAMETERS FOR REQUEST TYPE (SUBAPP_CODE) AND FACILITY ID (FID) */
  function addSubAppURL(subapp_code,fid) {
    var urlAppendage = "subapp_code=" & subapp_code;
    var outString    = "";
    if (lcase(subapp_code) EQ "room") { urlAppendage = urlAppendage & "&fid=" & fid;}
    outString = urlAppendage;
    return outString;
  }

  /* DISPLAY CHARACTER ASCII VALUES
     USAGE: showchars(0,256)                                                */
  function showchars(num_begin,num_end) {
    for (idx = num_begin; idx LTE num_end; idx = idx +1) {
      writeoutput('chr(' & idx & ') = ' & chr(idx) & '<br>');
    }
  }

  /* CREATE END OF LISTING TEXT BASED ON INPUT COUNT */
  function endOfListing(count) {
    return "#RepeatString("-",count)# End of Listing #RepeatString("-",count)#";
  }

  /* CHECK TO SEE IF THE PASSED SORT ORDER IS CONTAINED WITHIN A COLUMN INDEX SUBLIST
     PURPOSE: TO ALLOW A HEADER TO BE HIGHLIGHTED ON MORE THAN ONE SORT ORDER
     SYNTAX: IsSortHeader(columnIndicies,sort_order,colHeaderIndex);
     USAGE:  IsSortHeader("00,01,02,03,04|05,06","04",5);                        */
  /* determine if the sort order sublist (e.g.: 04|05) for a given primary columnIndicies list element 03,04|05,06 matches the current colHeaderIndex

     col sort   idx column name which
     idx orders pos should be bolded
     --- ------ --- -------------------
      1: 00      0  No.
      2: 01      0  Area
      3: 02      0  Service Unit
      4: 99      0  Traveler Name        // returns true when sort order is 99
      5: 04|05   2  BEGIN/END DATE       // returns true when sort order is 04 and/or 05
      6: 04|05   0  Travel Order Number
      7: 06      0  Purpose
  */
  function isSortHeader(columnIndicies,sort_order,colHeaderIndex) {
    if ( ListFind(ListGetAt(columnIndicies,colHeaderIndex),sort_order,"|") ) { return true; }
    else { return false; }
  }

  // FUNCTION TO ESCAPE SPECIAL CHARACTERS IN CORDA POPCHART PCSCRIPT
  // Necessary in PopChart+OptiMap Version 5.1.2a or greater
  // Note: defaults are currently hard-coded, and can be made dynamic if needed later
  function pcEsc(str) {
    escSeq = "\|";
    toBeReplacedStr = ",";
    replaceWithStr  = escSeq & toBeReplacedStr;
    repScope = "ALL";

    str = Replace(str,toBeReplacedStr,replaceWithStr,repScope);
    return str;
  }

  // function to display the value of the numerator with the percentage of the result of the numerator divided by the denominator underneth on the next line
  function dspDivision(numerator,denominator) {
    if ( ArrayLen(Arguments) gt 2 ) { mask = Arguments[3]; }
    WriteOutput(NumberFormat(numerator,request.ReportNumMask) & "<br />" & getPercent(numerator,denominator) & "%");
  }

  // function used in the Quarterly report to display the months a child would have been born in given the end date of a specific fiscal year quarter
  function dspAgeInMonthsTitle(beginMonthsBeforeDate,endMonthsBeforeDate,quarterEndDate) {
    beginMonthBeforeQuarterEndDate = DateAdd("m",-(beginMonthsBeforeDate),quarterEndDate);
    endMonthBeforeQuarterEndDate   = DateAdd("m",-(endMonthsBeforeDate),quarterEndDate);

    WriteOutput("<span style=""font-size:12px; font-weight:bold; color:505050;"">#beginMonthsBeforeDate#-#endMonthsBeforeDate#</span> <br /><br />");
    WriteOutput("<nobr>#Left(MonthAsString(DatePart("m",endMonthBeforeQuarterEndDate)),3)# #DatePart("yyyy",endMonthBeforeQuarterEndDate)#</nobr> <br />");
    WriteOutput("Thru <br />");
    WriteOutput("<nobr>#Left(MonthAsString(DatePart("m",beginMonthBeforeQuarterEndDate)),3)# #DatePart("yyyy",beginMonthBeforeQuarterEndDate)#</nobr> <br />");
  }

</CFSCRIPT>
