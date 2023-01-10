<cfcomponent displayname="answerMatrices">
  <cfset request.IHPESdb = "IHPESdb_dev.dbo.">

  <cffunction name="getByQuestionID" access="public" output="false" returntype="query">
    <cfargument name="osaq_id" type="string" required="true" hint="can be a list of ids" />

    <cfset var qQuestionMatrices = "" />

    <cfquery datasource="#request.IHPESds#" name="qQuestionMatrices">
      SELECT
        m.rowNum,
        m.colNum,
        m.cellDataType,
        m.cellTitle
      FROM
        #request.IHPESdb#ORAPSelfAssessmentQuestionMatrices m
      WHERE
        m.osaq_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.osaq_id#" list="true" />)
      ORDER BY
        m.rowNum, m.colNum
		</cfquery>

    <cfreturn qQuestionMatrices />
  </cffunction>

  <cffunction name="getBySectionID" access="public" output="false" returntype="query">
    <cfargument name="osas_id" type="string" required="true" hint="can be a list of ids" />
    <cfargument name="asufac_code" type="string" required="true" />

    <cfset var qAnswerMatrices = "" />

    <cfquery datasource="#request.IHPESds#" name="qAnswerMatrices">
      SELECT
        q.osaq_id,
        m.osaa_id,
        m.rowNum,
        m.colNum,
        m.cellData
      FROM
        #request.IHPESdb#ORAPSelfAssessmentAnswer a
        LEFT JOIN #request.IHPESdb#ORAPSelfAssessmentAnswerMatrices m
          ON a.osaa_id = m.osaa_id
        LEFT JOIN #request.IHPESdb#ORAPSelfAssessmentQuestion q
          ON a.osaq_id = q.osaq_id
      WHERE
        q.osas_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.osas_id#" list="true" />)
        <cfif len(arguments.asufac_code)>
          AND a.asufac_code IN (<cfqueryparam value="#arguments.asufac_code#" list="Yes" cfsqltype="cf_sql_varchar" maxlength="6">)
        </cfif>
      ORDER BY
        q.osaq_id, m.osaa_id, m.rowNum, m.colNum
		</cfquery>

    <cfreturn qAnswerMatrices />
  </cffunction>

  <cffunction name="deleteByQuestionID" access="public" output="false" returntype="void">
    <cfargument name="osaq_id" type="numeric" required="true" />
    <cfargument name="osaqm_ids" type="string" required="false" default="" hint="a list of osaqm_ids that should not be deleted" />

    <cfquery datasource="#request.IHPESds#">
      DELETE FROM
        #request.IHPESdb#ORAPSelfAssessmentQuestionMatrices
      WHERE
        osaq_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.osaq_id#" />
        <cfif len(arguments.osaqm_ids)>
          AND osaqm_id NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.osaqm_ids#" />)
        </cfif>
		</cfquery>

  </cffunction>

  <cffunction name="add" access="public" output="false" returntype="void">
    <cfargument name="arrStQuestionMatrices" type="array" required="true" />
    <cfargument name="osaq_id" type="numeric" required="true" />
    <cfargument name="whocreated" type="string" required="true" />

    <cfquery datasource="#request.IHPESds#">
      <cfloop from="1" to="#arrayLen(arguments.arrStQuestionMatrices)#" index="i">
        INSERT INTO #request.IHPESdb#ORAPSelfAssessmentQuestionMatrices (
          osaq_id,
          rowNum,
          colNum,
          cellDataType,
          cellTitle,
          whocreated,
          whoupdated
	      )
	      VALUES (
	        <cfqueryparam value="#arguments.osaq_id#" cfsqltype="cf_sql_integer" />,
	        <cfqueryparam value="#arguments.arrStQuestionMatrices[i]['rowNum']#" cfsqltype="cf_sql_integer" />,
          <cfqueryparam value="#arguments.arrStQuestionMatrices[i]['colNum']#" cfsqltype="cf_sql_integer" />,
	        <cfqueryparam value="#arguments.arrStQuestionMatrices[i]['cellDataType']#" cfsqltype="cf_sql_varchar" maxlength="7" />,
          <cfqueryparam value="#arguments.arrStQuestionMatrices[i]['cellTitle']#" cfsqltype="cf_sql_varchar" maxlength="100" />,
	        <cfqueryparam value="#arguments.whocreated#" cfsqltype="cf_sql_varchar" maxlength="32" />,
	        <cfqueryparam value="#arguments.whocreated#" cfsqltype="cf_sql_varchar" maxlength="32" />
	      )
      </cfloop>
		</cfquery>
  </cffunction>

  <cffunction name="updateTableCell" access="public" output="false" returntype="any">
    <cfargument name="aryStcEditRowColumn" type="array" required="true" />
    <cfargument name="matrixCellDataType" type="string" required="true" />
    <cfargument name="matrixCellTitle" type="string" required="true" />
      <cfset variables.arrStQuestionMatrices = session.arrStQuestionMatrices>
        <cfloop  from="1" to="#arrayLen(aryStcEditRowColumn)#" index="i">
          <cfset intArryKey = getArryKey(arguments.aryStcEditRowColumn[i].row, arguments.aryStcEditRowColumn[i].column)>
          <cfset variables.arrStQuestionMatrices[intArryKey]["cellDataType"] = arguments.matrixCellDataType>
          <cfif arguments.matrixCellDataType EQ "title">
            <cfset variables.arrStQuestionMatrices[intArryKey]["cellTitle"] = arguments.matrixCellTitle>
          <cfelse>
            <cfset variables.arrStQuestionMatrices[intArryKey]["cellTitle"] = " ">
          </cfif>
        </cfloop>
      <cfset session.arrStQuestionMatrices = variables.arrStQuestionMatrices>
  </cffunction>


  <cffunction name="getColumnCount" access="public" output="false" returntype="numeric">
    <cfset intColCount = structFind(session.arrStQuestionMatrices[arrayLen(session.arrStQuestionMatrices)], 'colNum')>
    <cfreturn intColCount>
  </cffunction>

  <cffunction name="getRowCount" access="public" output="false" returntype="numeric">
    <cfset intRowCount = structFind(session.arrStQuestionMatrices[arrayLen(session.arrStQuestionMatrices)], 'rowNum')>
    <cfreturn intRowCount>
  </cffunction>

  <cffunction name="getArryKey" access="public" output="false" returntype="any">
    <cfargument name="a_RowNum" type="string" required="true" />
    <cfargument name="a_ColNum" type="string" required="true" />
    <cfset intArryKey = ( (#arguments.a_RowNum# - 1) * getColumnCount() )  + #arguments.a_ColNum# >
    <cfreturn val(intArryKey)>

  </cffunction>

  <cffunction name="createNewTable" access="public" output="false" returntype="any">
    <cfargument name="a_totRows" type="numeric" required="true" />
    <cfargument name="a_totCols" type="numeric" required="true" />
    <cfscript>
      intTotRows = val(arguments.a_totRows);
      intTotCols = val(arguments.a_totCols);
      var intIndex = 1;
      var intRowNum = 1
      var myArrStQuestionMatrices = arrayNew(1);
      for (intRowNum = 1; intRowNum <= intTotRows; intRowNum++) {
        arrayAppend(myArrStQuestionMatrices, fncBuildTableRow(intIndex, intRowNum, intTotCols), "true");
        intIndex = intIndex + intTotCols;
      }
      var intMax = arrayLen(myArrStQuestionMatrices);
      var i = 1;
      for (i = 1; i <= intMax; i++) {
        if (!(ArrayIsDefined(myArrStQuestionMatrices, i))  ) {
            ArrayDeleteAt(myArrStQuestionMatrices, i)
            intMax--;
            i--;
        }
      }
    return fncRemoveEmptyEntries(myArrStQuestionMatrices);;
    </cfscript>
  </cffunction>

  <cffunction name="fncRemoveEmptyEntries" access="public" output="false" returntype="any">
    <cfargument name="a_myArrStQuestionMatrices" type="array" required="true" />
    <cfscript>
      var myArrStQuestionMatrices = a_myArrStQuestionMatrices;
      var intMax = arrayLen(myArrStQuestionMatrices);
      var i = 1;
      for (i = 1; i <= intMax; i++) {
        if (!(ArrayIsDefined(myArrStQuestionMatrices, i))  ) {
            ArrayDeleteAt(myArrStQuestionMatrices, i)
            intMax--;
            i--;
        }
      }
      return myArrStQuestionMatrices;
    </cfscript>
  </cffunction>
      

  <cffunction name="fncBuildTableRow" access="public" output="false" returntype="any">
      <cfargument name="a_intIndex" type="numeric" required="true" />
      <cfargument name="a_intRow" type="numeric" required="true" />
      <cfargument name="a_intColCount" type="numeric" required="true" />
      <cfscript>
        var intRowNum = arguments.a_intRow;
        var intColCount = a_intColCount;
        var intColNum = 1;
        var i = a_intIndex;
        //var i = 3;
        var myArrStQuestionMatrices = arrayNew(1);
        for (intColNum=1; intColNum <= intColCount; intColNum++) {
          myArrStQuestionMatrices[i]=fncAddColumnCell(intRowNum, intColNum);
          i = i + 1;
        }
      return myArrStQuestionMatrices;
    </cfscript>
      
    
  </cffunction>
    
  <cffunction name="fncAddColumnCell" access="public" output="false" returntype="any">
    <cfargument name="a_intRow" type="numeric" required="true" />
    <cfargument name="a_intCol" type="numeric" required="true" />
    <cfscript>
      var intRowNum = arguments.a_intRow;
      var intColNum = arguments.a_intCol;
      var stcQuestionMatrices=structNew();
      stcQuestionMatrices['rowNum']=intRowNum;
      stcQuestionMatrices['colNum']=intColNum;
      if (intRowNum == 1 || intColNum == 1 ) { 
        stcQuestionMatrices['cellDataType']="title";
        if (intRowNum == 1) {
          stcQuestionMatrices['cellTitle']=" Column#intColNum#";
        } else {
          stcQuestionMatrices['cellTitle']=" Row#intRowNum#";
        }
        
      } else {
        stcQuestionMatrices['cellDataType']="dollar";
        stcQuestionMatrices['cellTitle']="";
      }
      return stcQuestionMatrices;
    </cfscript>
  </cffunction>

  <cffunction name="insertTableRow" access="public" output="false" returntype="any">
    <cfargument name="a_intRow" type="numeric" required="true" />
    <cfscript>
      var intRow = val(arguments.a_intRow);
      var intRowCount = getRowCount();
      var intColCount = getColumnCount();
      var intmax = intColCount * intRow;
      var myNewArrStQuestionMatrices = arrayNew(1);
      var myArrStQuestionMatrices = session.arrStQuestionMatrices;
      var i = 1;
      for (i=1; i <= intmax; i++) {
        myNewArrStQuestionMatrices[i]=myArrStQuestionMatrices[i];
      }
      arrayAppend(myNewArrStQuestionMatrices, fncBuildTableRow(i, intRow + 1, intColCount), "true");
      var j = i + intColCount;
      myNewArrStQuestionMatrices = fncRemoveEmptyEntries(myNewArrStQuestionMatrices);
      intmax = (intColCount * intRowCount) + intColCount;
      for (j= i + intColCount; j <= intmax; j++) {
        
        myNewArrStQuestionMatrices[j]=myArrStQuestionMatrices[i];
        myNewArrStQuestionMatrices[j]['rowNum']=myArrStQuestionMatrices[i]['rowNum'] + 1;
        i++;
      }
      return fncRemoveEmptyEntries(myNewArrStQuestionMatrices);
      </cfscript>
        
    </cffunction>
  
    <cffunction name="deleteTableRow" access="public" output="false" returntype="any">
      <cfargument name="a_intRow" type="numeric" required="true" />
      <cfscript>
        var intRow = val(arguments.a_intRow);
        var intRowCount = getRowCount();
        var intColCount = getColumnCount();
        var intmax = intColCount * (intRow -1);
        var myNewArrStQuestionMatrices = arrayNew(1);
        var myArrStQuestionMatrices = session.arrStQuestionMatrices;
        var i = 1;
        for (i=1; i <= intmax; i++) {
          myNewArrStQuestionMatrices[i]=myArrStQuestionMatrices[i];
        }
        intmax = (intColCount * intRowCount);
        for (var j = i + intColCount; j <= intmax; j++) {
          myNewArrStQuestionMatrices[i]=myArrStQuestionMatrices[j];
          myNewArrStQuestionMatrices[i]['rowNum']=myArrStQuestionMatrices[j]['rowNum'] - 1;
          i++;
        }
        return fncRemoveEmptyEntries(myNewArrStQuestionMatrices);
        </cfscript>
          
      </cffunction>

      <cffunction name="insertTableColumn" access="public" output="false" returntype="any">
        <cfargument name="a_intCol" type="numeric" required="true" />
        <cfscript>
          var intAfterCol = val(arguments.a_intCol);
          var intRowCount = getRowCount();
          var intColCount = getColumnCount();
          var myNewArrStQuestionMatrices = arrayNew(1);
          var myArrStQuestionMatrices = session.arrStQuestionMatrices;
          var ip = 0;
          var op = 0;
          for (intCurrRow=1; intCurrRow <= intRowCount; intCurrRow++) {
            for (intCurrCol=1; intCurrCol <= intAfterCol; intCurrCol++) {
                ip++;
                op++;
                myNewArrStQuestionMatrices[op]=myArrStQuestionMatrices[ip];
            }
            op++;
            myNewArrStQuestionMatrices[op]= fncAddColumnCell(intCurrRow, intAfterCol +1);

            for (intCurrCol=intAfterCol +1; intCurrCol <= intColCount; intCurrCol++) {
                op++;
                ip++;
                myNewArrStQuestionMatrices[op]=myArrStQuestionMatrices[ip];
                myNewArrStQuestionMatrices[op]['colNum']=intCurrCol + 1;
            }
          }
          return fncRemoveEmptyEntries(myNewArrStQuestionMatrices);
          //return myNewArrStQuestionMatrices;
          </cfscript>
        </cffunction>
        
        <cffunction name="deleteTableColumn" access="public" output="false" returntype="any">
          <cfargument name="a_intCol" type="numeric" required="true" />
          <cfscript>
            var intCol = val(arguments.a_intCol);
            var intRowCount = getRowCount();
            var intColCount = getColumnCount();
            var myNewArrStQuestionMatrices = arrayNew(1);
            var myArrStQuestionMatrices = session.arrStQuestionMatrices;
            var op = 0;
            var ip = 0;
            for (intCurrRow=1; intCurrRow <= intRowCount; intCurrRow++) {
              for (intCurrCol=1; intCurrCol < intCol; intCurrCol++) {
                  ip++;
                  op++;
                  myNewArrStQuestionMatrices[op]=myArrStQuestionMatrices[ip];
              }
              ip++;
              for (intCurrCol=intCol; intCurrCol < intColCount; intCurrCol++) {
                  ip++;
                  op++;
                  myNewArrStQuestionMatrices[op]=myArrStQuestionMatrices[ip];
                  myNewArrStQuestionMatrices[op]['colNum']=intCurrCol;
              }
            }
            return myNewArrStQuestionMatrices;
            </cfscript>
              
          </cffunction>
  </cfcomponent>