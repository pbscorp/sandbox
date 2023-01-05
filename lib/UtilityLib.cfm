<!---
	
	This library is part of the Common Function Library Project. An open source
	collection of UDF libraries designed for ColdFusion 5.0. For more information,
	please see the web site at:
		
		http://www.cflib.org
		
	Warning:
	You may not need all the functions in this library. If speed
	is _extremely_ important, you may want to consider deleting
	functions you do not plan on using. Normally you should not
	have to worry about the size of the library.
		
	License:
	This code may be used freely. 
	You may modify this code as you see fit, however, this header, and the header
	for the functions must remain intact.
	
	This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk.
--->

<CFSCRIPT>

/**
 * Function to duplicate the <cfparam> tag within CFSCRIPT.
 * Rewritten by RCamden
 * V2 mods by John Farrar
 * 
 * @param varname 	 The name of the variable. 
 * @param value 	 The default value. If not passed, use  
 * @return Returns the value of the variable parammed. 
 * @author Fred T. Sanders (fred@fredsanders.com) 
 * @version 2, November 13, 2001 
 */
function cfparami(varname) {
	var value = "";
	
	if(arrayLen(Arguments) gt 1) value = Arguments[2];
	if(not isDefined(varname)) setVariable(varname,value);
        return evaluate(varname);
}

/**
 * Returns the closest web safe hexadecimal color for a given hexadecimal color.
 * 
 * @param hexInput 	  
 * @return Returns a string. 
 * @author Tony Brandner (brandner@canada.com) 
 * @version 1, November 21, 2001 
 */
function closestWebSafeColor(hexInput) {
  var cleanHexInput = replace(hexInput,'##','','ALL');
  var hexOutput = '';
  var i = 0;
  if (Len(ReReplace(cleanHexInput, "[0-9abcdefABCDEF]", "","ALL")) eq 0 and Len(cleanHexInput) eq 6) {
    for (i=1; i lte 5; i=i+2) {
      closestMatch = 51 * Round((InputBaseN(mid(cleanHexInput,i,2),16)/51));
      if (closestMatch eq 0) {
        hexOutput = hexOutput & '00';
	} 
      else {
        hexOutput = hexOutput & FormatBaseN(closestMatch,16);
      }
    }
    return hexOutput;
  } 
  else {
    return 'invalid';
  }
}

/**
 * This function deletes all client variables for a user.
 * Version 2 mods by Tony Petruzzi
 * 
 * @param safeList 	 A list of client vars to NOT delete. 
 * @return Returns true. 
 * @author Bernd VanSkiver (bernd@shadowdesign.net) 
 * @version 2, January 29, 2002 
 */
function DeleteClientVariables() {
	var ClientVarList = GetClientVariablesList();
	var safeList = "";
	var i = 1;

	if(ArrayLen(Arguments) gte 1) safeList = Arguments[1];

	for(i=1; i lte listLen(ClientVarList); i=i+1) {
		if(NOT ListFindNoCase(safeList, ListGetAt(ClientVarList, i )))  DeleteClientVariable(ListGetAt(ClientVarList, i));
	}
	return true;
}

/**
 * This UDF translates a dogs age to a humans age.
 * 
 * @param age 	 The age of the dog. 
 * @author David Fekke (david@fekke.com) 
 * @version 1, February 14, 2002 
 */
function DogYearsToHumanYears(DogAge) {
 return ((DogAge - 1)* 7) + 9;
}

/**
 * Returns different colors if the number passed to it is even or odd.
 * Modified by RCamden
 * 
 * @param num 	 The number to check for even/oddness. 
 * @param evencolor 	 The color to use for even numbers. 
 * @param oddcolor 	 The color to use for odd numbers. 
 * @return Returns a string. 
 * @author Mark Andrachek (hallow@webmages.com) 
 * @version 1.1, November 27, 2001 
 */
function EvenOddColor(num,evencolor,oddcolor) {
    return Arguments[(num mod 2 )+ 2];
}

/**
 * Converts the Form structure to hidden form fields.
 * 
 * @param excludeList 	 A list of keys not to copy from the Form scope. Defaults to, and always includes, FIELDNAMES. 
 * @return Returns a string. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1, March 11, 2002 
 */
function formToHidden(){
	//a variable for iterating
	var key = "";
	//should we exlude any?  by default, no
	var excludeList = "FIELDNAMES";
	//a variable to return stuff
	var outVar = "";
	//if there is an argument, it is a list to exclude
	if(arrayLen(arguments))
		excludeList = excludeList & "," & arguments[1];
	//now loop through the form scope and make hidden fields
	for(key in form){
		if(NOT listFindNoCase(excludeList,key))
			outVar = outVar & "<input type=""hidden"" name=""" & key & """ value=""" & htmlEditFormat(form[key]) & """>";
	}
	return outVar;		
}

/**
 * Replace relative url's with a fully qualified URL
 * 
 * @param mytext 	 The string to search. 
 * @param relpage 	 The page to qualify. 
 * @param FQHost 	 The fully qualified host. 
 * @return Returns a string. 
 * @author Ryan Thompson-Jewell (thompsonjewell.ryan@mayo.edu) 
 * @version 1, November 2, 2001 
 */
function FullQualUrl(mytext,RelPage,FQHost) {
	var tmp=rereplacenocase(mytext,"(href\=){1}([""|'| ]*)(/)*(#RelPage#){1}","\1\2#FQHost#/#RelPage#","ALL");
	return tmp;
}

/**
 * Returns the numeric value of a letter's position in the alphabet, or the returns matching letter of a number in the alphabet.
 * 
 * @param charornum 	 Either a character or number. 
 * @return Returns either a character, number, or empty string on error. 
 * @author Seth Duffey (sduffey@ci.davis.ca.us) 
 * @version 1, January 7, 2002 
 */
function GetAlphabetPosition(charornum) {
  var a_numeric = asc("a");
  charornum = lCase(trim(charornum));

  if(isNumeric(charornum)) {
      if(charornum lte 0 OR charornum gte 27) return "";
      return chr(charornum+a_numeric-1);
  } else {
      if(len(charornum) gt 1) return "";
      if(REFind("[^a-z]",charornum)) return "";
      return asc(charornum) - a_numeric + 1;
  }
  return 1;
}

/**
 * Function returns a structure of client variable.
 * 
 * @return Returns a structure. 
 * @author Robert Segal (rsegal@figleaf.com) 
 * @version 1, August 2, 2001 
 */
function getclientvariables() {
 var lclientvarlist = getclientvariableslist();
 var stclientvar = structnew();
 var i = 1;
 for(i=1;i lte listlen(lclientvarlist);i=i+1)
 structinsert(stclientvar,"#listgetat(lclientvarlist,i)#",evaluate("client.#listgetat(lclientvarlist,i)#"));
 return stclientvar;
}

/**
 * Converts an HTML (hex) color code to gray.  An optional second argument allows for conversion to a web-safe color in the same step.
 * 
 * @param hex_color 	 6 character hex color code you want converted to grayscale. 
 * @param web_safe 	 Boolean.  Indicates whether to return the closest web-safe grayscale value.  Default is No. 
 * @return Returns a string. 
 * @author Sierra Bufe (sierra@brighterfusion.com) 
 * @version 1.0, November 22, 2001 
 */
function Grayscale(hex_color) {
  // strip out any leading pound signs
  var clean_hex = replace(hex_color,'##','','ALL');
  // parse out rgb values, convert them to decimal, and make into a list
  var rgb = InputBaseN(Left(clean_hex,2),16) & "," & InputBaseN(Mid(clean_hex,3,2),16) & "," & InputBaseN(Right(clean_hex,2),16);
  // find average value from the list
  var gray = ArrayAvg(ListToArray(rgb));
  // check to see if a web_safe result is preferred
  if ((ArrayLen(Arguments) GT 1) AND Arguments[2])
    gray = Round(gray / 51) * 51;

  // convert gray to hexadecimal and pad with a zero if necessary
  gray = FormatBaseN(gray,16);
  if (len(gray) is 1) gray = "0" & gray;
    // return gray value as a new 6-digit hex color
    return gray & gray & gray;
}

/**
 * Convert a hex RGB triplet to HSL (hue, saturation, luminance).
 * 
 * @param RGBTriplet 	 Hex RGB triplet to convert to HSL triplet. 
 * @return Returns a comma delimited list of values. 
 * @author Matthew Walker (matthew@electricsheep.co.nz) 
 * @version 1, November 6, 2001 
 */
function HexToHSL(RGBTriplet) {
	// ref Foley and van Dam, Fundamentals of Interactive Computer Graphics
	
	var R = 0;
	var G = 0;
	var B = 0;
	var H = 0;
	var S = 0;
	var L = 0;
	var TidiedTriplet = Replace(RGBTriplet, "##", "", "ALL");
	var MinColor = 0;
	var MaxColor = 0;
	
	if ( ListLen(RGBTriplet) GT 1 ) {
		R = ListFirst(RGBTriplet);
		G = ListGetAt(RGBTriplet, 2);
		B = ListLast(RGBTriplet);
	}
	else {
		R = InputBaseN(Mid(TidiedTriplet, 1,2), 16) / 255;
		G = InputBaseN(Mid(TidiedTriplet, 3,2), 16) / 255;
		B = InputBaseN(Mid(TidiedTriplet, 5,2), 16) / 255;
	}	
		
	MinColor = Min(R, Min(G, B));
	MaxColor = Max(R, Max(G, B));
	L = (MaxColor + MinColor)/2;

	if ( MaxColor NEQ MinColor ) { // not grey
		if ( L LT 0.5 )
			S=(MaxColor-MinColor)/(MaxColor+MinColor);
		else
			S=(MaxColor-MinColor)/(2-MaxColor-MinColor);
		if ( R EQ MaxColor )
			H = (G-B)/(MaxColor-MinColor);
		if ( G EQ MaxColor )
			H = 2 + (B-R)/(MaxColor-MinColor);
		if ( B EQ MaxColor )
			H = 4 + (R-G)/(MaxColor-MinColor);
		H = H / 6;	
	}
	
	return "#H#,#S#,#L#";
}

/**
 * Convert a hexadecimal color into a RGB color value.
 * 
 * @param hexColor 	 6 character hexadecimal color value. 
 * @return Returns a string. 
 * @author Eric Carlisle (ericc@nc.rr.com) 
 * @version 1.0, November 6, 2001 
 */
function HexToRGB(hexColor){
  /* Strip out poundsigns. */
  Var tHexColor = replace(hexColor,'##','','ALL');
	
  /* Establish vairable for RGB color. */
  Var RGBlist='';
  Var RGPpart='';	

  /* Initialize i */
  Var i=0;

  /* Loop through each hex triplet */
  for (i=1; i lte 5; i=i+2){
    RGBpart = InputBaseN(mid(tHexColor,i,2),16);
    RGBlist = listAppend(RGBlist,RGBpart);
  }
  return RGBlist;
}

/**
 * Convert an HSL (hue, saturation, luminance) triplet to a hex RGB triplet.
 * 
 * @param h 	 Hue value between 0 and 1.  Decimals must have a leading zero. 
 * @param s 	 Saturation value between 0 and 1.  Decimals must have a leading zero. 
 * @param l 	 Luminosityvalue between 0 and 1.  Decimals must have a leading zero. 
 * @return Returns a string. 
 * @author Matthew Walker (matthew@electricsheep.co.nz) 
 * @version 1, November 6, 2001 
 */
function HSLtoHex(H,S,L) {
	// ref Foley and van Dam, Fundamentals of Interactive Computer Graphics
	var R = L;
	var G = L;
	var B = L;
        Var temp1=0;
        Var temp2=0;
        Var Rtemp3=0;
        Var Gtemp3=0;
        Var Btemp3=0;
        Var Rhex=0;
        Var Ghex=0;
        Var Bhex=0;
	if ( S ) {
		if ( L LT 0.5 )
			temp2 = L * (1 + S);
		else
			temp2 = L + S - L * S;
		temp1 = 2 * L - temp2;

		Rtemp3 = H + 1/3;
		Gtemp3 = H;
		Btemp3 = H - 1/3;
		if ( Rtemp3 LT 0 )
			Rtemp3 = Rtemp3 + 1;
		if ( Gtemp3 LT 0 )
			Gtemp3 = Gtemp3 + 1;
		if ( Btemp3 LT 0 )
			Btemp3 = Btemp3 + 1;
		if ( Rtemp3 GT 1 )
			Rtemp3 = Rtemp3 - 1;	
		if ( Gtemp3 GT 1 )
			Gtemp3 = Gtemp3 - 1;	
		if ( Btemp3 GT 1 )
			Btemp3 = Btemp3 - 1;	
		
		if ( 6 * Rtemp3 LT 1 )
			R = temp1 + (temp2 - temp1) * 6 * Rtemp3;
		else
			if ( 2 * Rtemp3 LT 1 )
				R = temp2;
			else
				if ( 3 * Rtemp3 LT 2 )
					R = temp1 + (temp2 - temp1) * ((2/3) - Rtemp3) * 6;
				else
					R = temp1;
		
		if ( 6 * Gtemp3 LT 1 )
			G = temp1 + (temp2 - temp1) * 6 * Gtemp3;
		else
			if ( 2 * Gtemp3 LT 1 )
				G = temp2;
			else
				if ( 3 * Gtemp3 LT 2 )
					G = temp1 + (temp2 - temp1) * ((2/3) - Gtemp3) * 6;
				else
					G = temp1;
		
		if ( 6 * Btemp3 LT 1 )
			B = temp1 + (temp2 - temp1) * 6 * Btemp3;
		else
			if ( 2 * Btemp3 LT 1 )
				B = temp2;
			else
				if ( 3 * Btemp3 LT 2 )
					B = temp1 + (temp2 - temp1) * ((2/3) - Btemp3) * 6;
				else
					B = temp1;
	}
	Rhex = FormatBaseN(R*255,16);
	if ( Len(Rhex) EQ 1 )
		Rhex = "0" & Rhex;
	Ghex = FormatBaseN(G*255,16);
	if ( Len(Ghex) EQ 1 )
		Ghex = "0" & Ghex;
	Bhex = FormatBaseN(B*255,16);
	if ( Len(Bhex) EQ 1 )
		Bhex = "0" & Bhex;
	
	return UCase(Rhex & Ghex & Bhex);
}

/**
 * Returns true if the function is a BIF (built in function).
 * 
 * @param name 	 The name to check. 
 * @return Returns a boolean. 
 * @author Raymond Camden (ray@camdenfamily.com) 
 * @version 1, September 26, 2001 
 */
function IsBIF(name) {
    return ListFindNoCase(StructKeyList(GetFunctionList()),name) GT 0;
}

/**
 * Returns True if the user has not requested a page within the given time span.
 * 
 * @param timespan 	 Days, hours, minutes, and seconds (using CreateTimeSpan) before client variables should be timed out. 
 * @return Returns a Boolean value. 
 * @author Rob Brooks-Bilson (rbils@amkor.com) 
 * @version 1, August 3, 2001 
 */
function IsClientTimeout(timespan)
{
  if (DateCompare(CreateODBCDateTime(Now()), DateAdd("s", (Round(timespan* 86400)), Client.LastVisit)) GTE 0){ 
    Return True;
  }
  else{
    Return False;
  }
}

/**
 * Returns true/false if the current template is being called as a custom tag.
 * 
 * @return Returns a Boolean value. 
 * @author Jordan Clark (JordanClark@Telus.net) 
 * @version 1, January 29, 2002 
 */
function IsCustomTag() {
  return yesNoFormat( listFindNoCase( getBaseTagList(), "CF_" & listFirst( listLast( getCurrentTemplatePath(), "/\" ), "." ) ) );
}

/**
 * Returns true if the function is a BIF (built in function) or UDF (user defined function).
 * 
 * @param name 	 The name to check. 
 * @return Returns a boolean. 
 * @author Raymond Camden (ray@camdenfamily.com) 
 * @version 1, September 26, 2001 
 */
function IsFunction(str) {
 if(ListFindNoCase(StructKeyList(GetFunctionList()),str)) return 1;
 if(IsDefined(str) AND Evaluate("IsCustomFunction(#str#)")) return 1;
 return 0;
}

/**
 * Returns true if valid hexadecimal color.
 * 
 * @param hexInput 	 Hex value you want to validate. 
 * @return Returns a Boolean. 
 * @author Tony Brandner (brandner@canada.com) 
 * @version 1, November 26, 2001 
 */
function IsHexColor(hexInput) {
  var cleanHexInput = replace(hexInput,'##','','ALL');
  if (Len(ReReplace(cleanHexInput, "[0-9abcdefABCDEF]", "","ALL")) eq 0 and Len(cleanHexInput) gt 5) {
    return True;
  } else {
      return False;
    }
}

/**
 * Checks to see if calling template is base template.
 * 
 * @return Returns a boolean. 
 * @author Scott Wintheiser (scott@lightburndesigns.com) 
 * @version 1, February 24, 2002 
 */
function isIncluded(){
	IF (getCurrentTemplatePath() NEQ getBaseTemplatePath()) return true;
	else return false;
}

/**
 * Returns true if the given color is a web safe hexadecimal color.
 * 
 * @param hexColor 	 Hex color representation to validate. 
 * @return Returns a Boolean value. 
 * @author Eric Carlisle (ericc@nc.rr.com) 
 * @version 1, November 6, 2001 
 */
function IsWebSafeColor(hexColor){
  /* Establish list of web safe colors */
  Var safeList = "00,33,66,99,cc,ff";
	
  /* Strip out poundsigns from argument. */
  Var tHexColor = replace(hexColor,'##','','ALL');

  /* Initialize i */
  Var i=0;
  
  /* Loop over r,g,b hex values */
  for (i=1; i lte 5; i=i+2){
		
    /* Set result to FALSE if a color isn't web safe. */	
    if (listFindNoCase(safeList,mid(tHexColor,i,2)) eq 0){
      return False;
    }
  }
  return True;
}

/**
 * Pass this UDF a Yes/No question, and it will return a prediction.
 * 
 * @param question 	 Yes/No question you want to ask the magic 8 ball. 
 * @return Returns a string. 
 * @author Rob Brooks-Bilson (rbils@amkor.com) 
 * @version 1, December 3, 2001 
 */
function Magic8Ball(question){
  var validQuestion=False;
  var wordList="am,are,can,could,couldn't,will,would,wouldn't,won't,was,wasn't,must,musn't,may,if,is,isn't,should,shouldn't,do,did,don't,shall,shant";
  var i=0;
  var Answer=ArrayNew(1);
  for (i=1; i lte ListLen(wordList); i=i+1) {
    if (ListFirst(question, " ") EQ ListGetAt(wordList, i)){
	    validQuestion=True;
      break;
      }
  }
  // Initialize an array with all of the responses 
  Answer[1] = "Most likely";
  Answer[2] = "Very doubtful";
  Answer[3] = "It is certain";
  Answer[4] = "My sources say NO";
  Answer[5] = "As I see it, yes";
  Answer[6] = "Concentrate and ask again";
  Answer[7] = "My reply is NO";
  Answer[8] = "Signs point to yes";
  Answer[9] = "Cannot predict now";
  Answer[10] = "Outlook Good";
  Answer[11] = "Reply hazy, try again";
  Answer[12] = "It is decidedly so";
  Answer[13] = "Don't count on it";
  Answer[14] = "My sources say Yes";
  Answer[15] = "Yes, Definetly";
  Answer[16] = "Ask again later";
  Answer[17] = "Without a doubt";
  Answer[18] = "Outlook not so good";
  Answer[19] = "You may rely on it";
  Answer[20] = "Better not tell you now";
  Answer[21] = "YES";
  Answer[22] = "NO";
  
  if (ValidQuestion EQ True)
    return Answer[RandRange(1,22)];
  else
    return "I'm not sure I understand.  Please rephrase the question and ask again.";
}

/**
 * Creates a Select form item populated with given string items.
 * Mods by RCamden
 * 
 * @param name 	 The name of the Select item. 
 * @param values 	 The values for the drop down. 
 * @param selected 	 Selected item. 
 * @return Returns a string. 
 * @author Seth Duffey (sduffey@ci.davis.ca.us) 
 * @version 1.2, November 28, 2001 
 */
function MakeSelectList(name,stringList) {
    var outstring="<select name=#name#>";
    var i = 1;

    for (i=1; i LTE listLen(stringList); i=i+1) {
	outstring = outstring & "<option value=#listGetAt(stringList,i)#";
        if(arrayLen(arguments) gt 2 AND arguments[3] IS listGetAt(stringList,i)) outstring = outstring & " selected";
        outstring = outstring & ">#listGetAt(stringList,i)#";
    }

    outstring = outstring & "</select>";
    return outstring;
}

/**
 * Implementation of Hoare's Quicksort algorithm for sorting arrays of arbitrary items.
 * Slight mods by RCamden (added var for comparison)
 * 
 * @param arrayToCompare 	 The array to be sorted. 
 * @param sorter 	 The comparison UDF. 
 * @return Returns a sorted array. 
 * @author James Sleeman (james@innovativemedia.co.nz) 
 * @version 1, March 12, 2002 
 */
function quickSort(arrayToCompare, sorter){
	var lesserArray  = ArrayNew(1);
	var greaterArray = ArrayNew(1);
	var pivotArray   = ArrayNew(1);
	var examine      = 2;
	var comparison = 0;

	pivotArray[1]    = arrayToCompare[1];

	if (arrayLen(arrayToCompare) LT 2) {
		return arrayToCompare;
	}
				
	while(examine LTE arrayLen(arrayToCompare)){
		comparison = sorter(arrayToCompare[examine], pivotArray[1]);
		switch(comparison) {
			case "-1": {
				arrayAppend(lesserArray, arrayToCompare[examine]);
				break;
			}
			case "0": {
				arrayAppend(pivotArray, arrayToCompare[examine]);
				break;
			}
			case "1": {
				arrayAppend(greaterArray, arrayToCompare[examine]);
				break;
			}
		}
		examine = examine + 1;
	}				
				
	if (arrayLen(lesserArray)) {
		lesserArray  = quickSort(lesserArray, sorter);
	} else {
		lesserArray = arrayNew(1);
	}	
		
	if (arrayLen(greaterArray)) {
		greaterArray = quickSort(greaterArray, sorter);
	} else {
		greaterArray = arrayNew(1);
	}
				
	examine = 1;
	while(examine LTE arrayLen(pivotArray)){
		arrayAppend(lesserArray, pivotArray[examine]); 
		examine = examine + 1;
	};
				
	examine = 1;
	while(examine LTE arrayLen(greaterArray)){
		arrayAppend(lesserArray, greaterArray[examine]); 
		examine = examine + 1;
	};
				
	return lesserArray;				
}

/**
 * Converts an RGB color value into a hexadecimal color value.
 * 
 * @param r 	 Red value triplet (0-255) 
 * @param g 	 Green value triplet (0-255) 
 * @param b 	 Blue value triplet (0-255) 
 * @return Returns a string. 
 * @author Eric Carlisle (ericc@nc.rr.com) 
 * @version 1, November 27, 2001 
 */
function RGBtoHex(r,g,b){
  Var hexColor="";
  Var hexPart = '';
  Var i=0;
	
  /* Loop through the Arguments array, containing the RGB triplets */
  for (i=1; i lte 3; i=i+1){
    /* Derive hex color part */
    hexPart = formatBaseN(Arguments[i],16);
		
    /* Pad with "0" if needed */
    if (len(hexPart) eq 1){
      hexPart = '0' & hexPart;	
    } 
		
    /* Add hex color part to hexadecimal color string */
    hexColor = hexColor & hexPart;
  }
  return hexColor;
}

/**
 * Converts a structure to hidden form fields.
 * 
 * @param struct 	 The structure to convert. 
 * @return Returns a string. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1, March 10, 2002 
 */
function structToHidden(struct){
	//a variable for iterating
	var key = "";
	//a variable to return stuff
	var outVar = "";
	//now loop through the form scope and make hidden fields
	for(key in struct){
		if(isSimpleValue(struct[key]))
			outVar = outVar & "<input type=""hidden"" name=""" & key & """ value=""" & htmlEditFormat(struct[key]) & """>";
	}
	return outVar;		
}

/**
 * Converts the URL structure to hidden form fields.
 * 
 * @param excludeList 	 A list of keys not to copy from the URL structure. 
 * @return Returns a string. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1, March 10, 2002 
 */
function urlToHidden(){
	//a variable for iterating
	var key = "";
	//should we exlude any?  by default, no
	var excludeList = "";
	//a variable to return stuff
	var outVar = "";
	//if there is an argument, it is a list to exclude
	if(arrayLen(arguments))
		excludeList = arguments[1];
	//now loop through the form scope and make hidden fields
	for(key in url){
		if(NOT listFindNoCase(excludeList,key))
			outVar = outVar & "<input type=""hidden"" name=""" & key & """ value=""" & htmlEditFormat(url[key]) & """>";
	}
	return outVar;		
}
</CFSCRIPT>
