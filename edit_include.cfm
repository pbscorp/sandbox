
<script src="adminQuestionEdit.js"></script>
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<cfinclude  template="lib/StrLib2.cfm">
<cfinclude  template="lib/UtilityLib.cfm">
<cfset oAnswerMatrices = createObject('component',"com.system.answerMatrices") />

    <div>
<!--- 		  			<cfdump  var="#variables.arrStQuestionMatrices#"> --->
						<cfoutput>
							<cfset errors = arrayNew(1)>
							<cfset aryStcEditRowColumn = arrayNew(1)>
							<form method="post" name="mainSubNav" id="mainSubNav">
							<cfif isDefined('form.lstEditRowColumns') AND len(form.lstEditRowColumns)>
								<cfset aryStcEditRowColumn = deserializeJSON(form.lstEditRowColumns)>
								<!-- <cfdump var="#aryStcEditRowColumn#"> -->
							</cfif>
							<div id="matricesOptions">
								<cfif structKeyExists(form, "deleteMatrixTable") AND NOT arrayLen(errors)>
										<cfset session.arrStQuestionMatrices = arrayNew(1)>
										<cfset variables.arrStQuestionMatrices = arrayNew(1)>
								<cfelseif structKeyExists(form, "addMatrixTable") AND NOT arrayLen(errors)>
										<cfset variables.arrStQuestionMatrices = 
													oAnswerMatrices.createNewTable(form.matrixCellTotalRows, form.matrixCellTotalCols)>
										<cfset session.arrStQuestionMatrices = variables.arrStQuestionMatrices>
								<cfelseif structKeyExists(form, "addMatrixRow") AND NOT arrayLen(errors)>
									<cfset variables.arrStQuestionMatrices = oAnswerMatrices.insertTableRow(form.addMatrixRow)>
									<cfset session.arrStQuestionMatrices = variables.arrStQuestionMatrices>
								<cfelseif structKeyExists(form, "deleteMatrixRow") AND NOT arrayLen(errors)>
									<cfset variables.arrStQuestionMatrices = oAnswerMatrices.deleteTableRow(form.deleteMatrixRow)>
									<cfset session.arrStQuestionMatrices = variables.arrStQuestionMatrices>
								<cfelseif structKeyExists(form, "addMatrixColumn") >
									<cfset variables.arrStQuestionMatrices = oAnswerMatrices.insertTableColumn(form.addMatrixColumn)>
									<cfset session.arrStQuestionMatrices = variables.arrStQuestionMatrices>
								<cfelseif structKeyExists(form, "deleteMatrixColumn") AND NOT arrayLen(errors)>
									<cfset variables.arrStQuestionMatrices = oAnswerMatrices.deleteTableColumn(form.deleteMatrixColumn)>
									<cfset session.arrStQuestionMatrices = variables.arrStQuestionMatrices>
								<cfelseif structKeyExists(session, "arrStQuestionMatrices") >
											<cfset variables.arrStQuestionMatrices = session.arrStQuestionMatrices>
									<cfelse>
											<cfset variables.arrStQuestionMatrices = arrayNew(1)>
									</cfif>

								<!--- <cfdump  var="#variables.arrStQuestionMatrices#">
									<cfdump  var="#arraylen(variables.arrStQuestionMatrices)#">
										 --->
								<cfif arraylen(variables.arrStQuestionMatrices) LT 1>
									<table border="0">
										<tr><td><font face="arial" size="2">Number of rows:</font></td>
												<td><input type="numeric" name="matrixCellTotalRows" id="matrixCellTotalRows"
													onFocus="this.select()"
													required class="adminFormField" size="2" min=1 value="">
												</td>
										</tr>
										<tr><td><font face="arial" size="2">Number of cols:</font></td>
												<td><input type="numeric"  name="matrixCellTotalCols" id="matrixCellTotalCols"
													required class="adminFormField" size="2" min=2 value="" onFocus="this.select()"></td>
										</tr>
										<tr>
											<td><input vspace="2px" hspace="3" type="submit" name="addMatrixTable" value="Add Table" class="buttnLg">
											</td>
										</tr>
									</table>
								<cfelse>

								<cfif structKeyExists(form, "addMatrixCell") AND NOT arrayLen(errors)><!--- if no errors, add cell to arrStQuestionMatrices --->
									<cfset oAnswerMatrices.updateTableCell(aryStcEditRowColumn, form.matrixCellDataType, form.matrixCellTitle)>
								</cfif>
            <table border="0" id="matrixTable">
              <tr><td><font face="arial" size="2">Row Number:</font></td>
                  <td><input type="number" name="matrixCellRowNum" id="matrixCellRowNum"
										min = "1" max = "#oAnswerMatrices.getRowCount()#" required
										onChange="fncHighlightCell()"
										onFocus="this.select()"
										class="adminFormField" size="2" value="" /></td>
              </tr>
              <tr><td><font face="arial" size="2">Column Number:</font></td>
                  <td><input type="number" name="matrixCellColNum" id="matrixCellColNum"
															min = "1" max = "#oAnswerMatrices.getColumnCount()#" required
															onChange="fncHighlightCell()"
															onFocus="this.select()"
															class="adminFormField" size="2" value="" /></td>
              </tr>
              <tr><td><font face="arial" size="2">Cell Data Type:</font></td>
                  <td>
          	        <select name="matrixCellDataType" id="matrixCellDataType" class="selectBoxText" 
														required style="width:400px; font-weight:bold; color:284369;"
														onchange="toggleDataFields();">
                      <option value="" cell_type_code="none">Select One</option>
          	          <cfloop list="title,integer,dollar,varchar,text" index="i">
            	          <option value="#i#" cell_type_code="#i#" <cfif IsDefined("form.matrixCellDataType") AND form.matrixCellDataType EQ "#i#">selected</cfif>>#i#</option>
          	            <!--- <option #setSelectedValue(i,lc_cellDataType)#>#i#</option> --->
          	          </cfloop>
          	        </select>
                  </td>
              </tr>
              <tr id="rowMatrixCellTitle">
                <td><font face="arial" size="2">Cell Title:</font></td>
                <td><input type="text" name="matrixCellTitle" id="matrixCellTitle" 
										onFocus="this.select()" class="adminFormField"
                    onChange="document.getElementById('addMatrixCell').click()" size="25" value="" >
											<font face="arial" size="2">(only if Cell Data Type = 'title')</font>
								</td>
              </tr>
              <tr>
								<td>
									<input vspace="2px" hspace="3" type="submit" name="addMatrixCell" id="addMatrixCell" value="Update Cell" class="buttnLg">
									<span style="display: none">
										<input type="submit" name="addMatrixRow"
														id="addMatrixRow" value="">
										<input type="submit" name="deleteMatrixRow"
														id="deleteMatrixRow" value="">
										<input type="submit" name="addMatrixColumn"
														id="addMatrixColumn" value="">
										<input type="submit" name="deleteMatrixColumn"
														id="deleteMatrixColumn" value="">
										<input type="hidden" name="lstEditRowColumns"
														id="lstEditRowColumns" value="">
				</span>
								</td>
								<td><input vspace="2px" hspace="3" type="submit" 
									onClick="return fncConfirmDeleteTable();" name="deleteMatrixTable" value="Delete Table" class="buttnLg">
								</td>
							</tr>
							 <!---<cfdump var="#variables.arrStQuestionMatrices#">
							<cfdump  var="#ArrayLen(variables.arrStQuestionMatrices)#">
              display contents of arrStQuestionMatrices (if any) --->
              <cfif ArrayLen(variables.arrStQuestionMatrices) GT 0>
                <tr>
                  <td colspan="2">
										<table>
											<tr>
												<cfset currRowNum = 0>
												<cfset currCellNum = 0>
												<cfloop from="1" to="#arrayLen(variables.arrStQuestionMatrices)#" index="i">
													<cfif i eq 1>
														<tr>
															<cfset intColLength = oAnswerMatrices.getColumnCount()>
															<cfloop from="0" to="#intColLength#" index="j">
																<td style="min-width:65px; 
																					text-align:center;
																					font-weight:bold;
																					font-size:20px;
																					cursor: pointer;">
																	<span style="color:green;"
																				onmouseover="style='background-color: ccc;'"
																				onmouseout="style='background-color: white;color:green;'"
																				onClick="fncSubmitForm('addMatrixColumn', #j#);" 
																				title = "Add Column After">+
																	</span>
																	<cfif j GT 0>
																		<span style="color:red;min-width:65px;" 
																					onmouseover="style='background-color: ccc;'"
																					onmouseout="style='background-color: white;color:red;'"
																					onClick="fncSubmitForm('deleteMatrixColumn', #j#);" 
																			title = "Delete Column ">--
																		</span>
																	</cfif>
																</td>
															</cfloop>
														</tr>
													</cfif>
													<cfif variables.arrStQuestionMatrices[i]['rowNum'] NEQ currRowNum>
														<cfif currRowNum GT 0>
															</tr>
															
														</cfif>
														<cfset currRowNum = variables.arrStQuestionMatrices[i]['rowNum']>
														<cfset currCellNum = 0>
														<tr>
															<td style="min-width:65px; 
																	text-align:center;
																	font-weight:bold;
																	font-size:20px;
																	cursor: pointer;">
																<span style="color:green;"
																			onmouseover="style='background-color: ccc;'"
																			onmouseout="style='background-color: white;color:green;'"
																			onClick="fncSubmitForm('addMatrixRow', #currRowNum#);" 
																			title = "Add New Line Below">+
																</span>
																<span style="color:red;min-width:65px;" 
																			onmouseover="style='background-color: ccc;'"
																			onmouseout="style='background-color: white;color:red;'"
																			onClick="fncSubmitForm('deleteMatrixRow', #currRowNum#);" 
																	title = "Delete line ">--
																</span>
															</td>
															
													</cfif>
													<cfset currCellNum = currCellNum + 1>
													<td 
															id = "tdWorkingTableCellId#currRowNum##currCellNum #"
															name = "tdWorkingTableCell" data-dataType = 
																		"#variables.arrStQuestionMatrices[i]['cellDataType']#"
															onmousedown="g_cntlKeyPressed = isKeyPressed(event);"
															onClick="fncSetSelect(#currRowNum#, #currCellNum#, g_cntlKeyPressed)"
														<cfif (structKeyExists(form, "addMatrixRow") AND
																			form.addMatrixRow + 1 == arrStQuestionMatrices[i]['rowNum'])  OR
																(structKeyExists(form, "addMatrixColumn") AND
																			form.addMatrixColumn + 1 == arrStQuestionMatrices[i]['colNum'])>
															style="background-color: ccc;font-weight:bold;cursor: pointer;"
														<cfelse>
															style = "cursor: pointer;"
														</cfif>>
														<!--- display cell by cellDataType (title, integer, varchar, text) --->
														<cfif variables.arrStQuestionMatrices[i]['cellDataType'] EQ "title">
															<font face="arial" size="2"><b>#arrStQuestionMatrices[i]['cellTitle']#</b></font>
														</cfif>
														<cfif variables.arrStQuestionMatrices[i]['cellDataType'] EQ "integer">
															<input type="text" class="adminFormField" size="11"
															style = "cursor: pointer;" value="" placeholder="9999" />
														</cfif>
														<cfif variables.arrStQuestionMatrices[i]['cellDataType'] EQ "dollar">
															<input type="text" class="adminFormField" size="15"
															style = "cursor: pointer;" value=""  placeholder="$9,999.99" />
														</cfif>
														<cfif variables.arrStQuestionMatrices[i]['cellDataType'] EQ "varchar">
															<input type="text" class="adminFormField" size="25"
															style = "cursor: pointer;" value="" placeholder="varchar"/>
														</cfif>
														<cfif variables.arrStQuestionMatrices[i]['cellDataType'] EQ "text">
															<textarea rows="2" cols="50" maxlength="1500" 
															style = "cursor: pointer;">textarea</textarea>
														</cfif>
													</td>
												</cfloop>
											</tr>
										</table>
								</td>
							</tr>
						</cfif>
					</table>
				</cfif>
				</cfoutput>
			</div>

	