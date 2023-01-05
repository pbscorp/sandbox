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

  <cffunction name="getColumnCount" access="public" output="false" returntype="numeric">
    <cfset intColCount = structFind(session.arrStQuestionMatrices[arrayLen(session.arrStQuestionMatrices)], 'colNum')>
    <cfreturn intColCount>
  </cffunction>

  <cffunction name="getRowCount" access="public" output="false" returntype="numeric">
    <cfset intColCount = structFind(session.arrStQuestionMatrices[arrayLen(session.arrStQuestionMatrices)], 'rowNum')>
    <cfreturn intColCount>
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
      myArrStQuestionMatrices = arrayNew(1);
      i = 0;
      for (rowNum=1; rowNum <= intTotRows; rowNum++) {
        for (colNum=1; colNum <= intTotCols; colNum++) {
          i = i + 1;
          myArrStQuestionMatrices[i]=structNew();
          myArrStQuestionMatrices[i]['rowNum']=rowNum;
          myArrStQuestionMatrices[i]['colNum']=colNum;
          if (rowNum == 1 || colNum == 1 ) { 
            myArrStQuestionMatrices[i]['cellDataType']="title";
            if (colNum == 1) {
              myArrStQuestionMatrices[i]['cellTitle']=" Row#rowNum#";
            } else {
              myArrStQuestionMatrices[i]['cellTitle']=" Column#colNum#";
            }
            
          } else {
            myArrStQuestionMatrices[i]['cellDataType']="dollar";
            myArrStQuestionMatrices[i]['cellTitle']="";
          }
        }
      }
    return myArrStQuestionMatrices;
    </cfscript>
      
  </cffunction>
</cfcomponent>