function toggleAllFields() {
  var answerTypeCode = $("#answer_type option:selected").attr("answer_type_code");
  toggleCheckboxes(answerTypeCode);
  toggleAnswerDataType(answerTypeCode);
  toggleAnswerMaxLength(answerTypeCode);
  toggleAnswerLabel(answerTypeCode);
  toggleExplanationOnNo(answerTypeCode);
  toggleMatrices(answerTypeCode);
}

function toggleCheckboxes(answerTypeCode) {
  if (answerTypeCode == "checkbox") {
    $("#checkboxOptions").show();
  } else {
    $("#checkboxOptions").hide();
  }
}

function toggleAnswerDataType(answerTypeCode) {
  if (answerTypeCode == "text") {
    $("#answerDataTypeRow").show();
  } else {
    $("#answerDataTypeRow").hide();
  }
}

function toggleAnswerMaxLength(answerTypeCode) {
  if (answerTypeCode == "text") {
    $("#answerMaxLengthRow").show();
  } else {
    $("#answerMaxLengthRow").hide();
  }
}

function toggleAnswerLabel(answerTypeCode) {
  if (answerTypeCode == "text") {
    $("#answerLabelRow").show();
  } else {
    $("#answerLabelRow").hide();
  }
}

function toggleExplanationOnNo(answerTypeCode) {
  if (answerTypeCode == "radio") {
    $("#showExplanationOnNoRow").show();
  } else {
    $("#showExplanationOnNoRow").hide();
  }
}

function toggleMatrices(answerTypeCode) {
  if (answerTypeCode == "matrix") {
    $("#matricesOptions").show();
  } else {
    $("#matricesOptions").hide();
  }
}


let g_cntlKeyPressed = false;
function fncToggleDataFields() {
  const eleSelectDropdown = document.getElementById('matrixCellDataType');
  const strDataType = eleSelectDropdown.options[eleSelectDropdown.selectedIndex].text;
  if (strDataType == "title") {
    $("#rowMatrixCellTitle").show();
    document.getElementById('matrixCellTitle').focus();
      fncCloseDataTypeSelect();
  } else {
      $("#rowMatrixCellTitle").hide();
      document.getElementById('addMatrixCell').click();
  }
}
function fncUpdateCellPlaceHolder() {
  let intCol = document.getElementById('matrixCellColNum').value;
  let intRow = document.getElementById('matrixCellRowNum').value;
    document.getElementById('matrixCellTitle').value=strTitle.trim();
  try {
  document.getElementById('tdWorkingTableCellId' + intRow + intCol).getAttribute("data-dataType");
  document.querySelector('#tdWorkingTableCellId + intRow + intCol input').innerText="";
  } catch {
  document.querySelector('#tdWorkingTableCellId + intRow + intCol input').placeholder="";
  }
};
  
const g_arrFormRowCols = [];

function fncHighlightCell(){ // from change of row or column input or click event of table cell
    let intCol = document.getElementById('matrixCellColNum').value;
    let intRow = document.getElementById('matrixCellRowNum').value;
    console.log('intRow is now ' + intRow + ' intCol is now ' + intRow);
  if (intRow.length < 1 || intCol.length < 1) {
    return;
  }
  // build array of col/rows to pass in the form 

  if (!g_cntlKeyPressed) {
    let arrMatrixTable = document.getElementsByName('tdWorkingTableCell');
    for (let i=0; i < arrMatrixTable.length; i++) {
      arrMatrixTable[i].style.border="thin solid white";
      g_arrFormRowCols.length  = 0;
    }
  }
  let objFormCol = {
    "row": intRow,
    "column": intCol
   }
  g_arrFormRowCols.push(objFormCol);
   
  document.getElementById('lstEditRowColumns').value=JSON.stringify(g_arrFormRowCols);
   
  document.getElementById('tdWorkingTableCellId' + intRow + intCol).style.border="thin solid red";

  const eleSelectedMatrixCell = document.getElementById('tdWorkingTableCellId' + intRow.toString() + intCol.toString());
  const strDataType = eleSelectedMatrixCell.getAttribute("data-dataType");

  console.log('strDataType of selected cell is ' + strDataType);

  document.querySelector('#matrixCellDataType').value = strDataType;
                
  console.log('strDataType is now ' + strDataType);

  if (strDataType == 'title') {
    const strTitle = eleSelectedMatrixCell.innerText;
    console.log('strTitle is now ' + strTitle);
    document.getElementById('matrixCellTitle').value=strTitle.trim();
  }
}

function isKeyPressed(event) {
  let text = "";
  if (event.ctrlKey) {
    return true;
  } else {
   return false;
  }
}
function fncSetSelect(a_intRow, a_intCol){// onClick of table column
  document.getElementById('matrixCellRowNum').value=a_intRow;
  document.getElementById('matrixCellColNum').value=a_intCol;
  fncHighlightCell();
  const eleSelectDropdown = document.getElementById('matrixCellDataType');
  let strSelectedOption = eleSelectDropdown.options[eleSelectDropdown.selectedIndex].text;
  eleSelectDropdown.size = eleSelectDropdown.options.length;
  console.log('strSelectedOption ' + strSelectedOption);
  if (strSelectedOption == 'title') {
    $("#rowMatrixCellTitle").show();
    fncCloseDataTypeSelect();
    document.getElementById('matrixCellTitle').focus();
  } else {
     $("#rowMatrixCellTitle").hide();
     fncOpenDataTypeSelect();
     document.getElementById('matrixCellTitle').value="";
     document.getElementById('matrixCellDataType').click();
  }
}
function fncOpenDataTypeSelect() {
    let eleSelectDropdown = document.getElementById('matrixCellDataType');
    //document.getElementById('spanTitleDataType').style.display = "none";
   // eleSelectDropdown.style.display = "block";
    eleSelectDropdown.size = eleSelectDropdown.options.length;
    eleSelectDropdown.focus();
}
function fncCloseDataTypeSelect() {
    let eleSelectDropdown = document.getElementById('matrixCellDataType');
    //eleSelectDropdown.style.display = "none";
    //document.getElementById('spanTitleDataType').style.display = "inline";
    eleSelectDropdown.size = 1;
    
    
}
function fncSubmitForm(a_strTransaction, a_intRowOrCol) {
  fncFillRequiredCellsToPassEdit();
  if (a_strTransaction.indexOf('delete') > -1) {
    if (!confirm('Confirm transaction ' + a_strTransaction) ) {
      return false;
    }
  }
  document.getElementById(a_strTransaction).value=a_intRowOrCol;
  document.getElementById(a_strTransaction).click();
}
function fncConfirmDeleteTable() {
  fncFillRequiredCellsToPassEdit();
  if (!confirm('Are you sure you wish to delete the working-table?') ) {
    return false;
  }
  return true;
}
function fncFillRequiredCellsToPassEdit() {
  document.getElementById('matrixCellRowNum').value = 1;
  document.getElementById('matrixCellColNum').value = 1;
  document.querySelector('#matrixCellDataType').value = "title";
}