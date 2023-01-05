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


function toggleDataFields() {
  const strDataType = document.getElementById('matrixCellDataType').value;
  if (strDataType == "title") {
    $("#rowMatrixCellTitle").show();
    document.getElementById('matrixCellTitle').focus();
  } else {
    $("#rowMatrixCellTitle").hide();
    return document.getElementById('addMatrixCell').click();
  }
}
 function confirmDeteteTable() {
  fncFillRequiredCellsToPassEdit();
  if (!confirm('Are you sure you wish to delete the working-table?') ) {
    return false;
  }
  function fncFillRequiredCellsToPassEdit() {
    document.getElementById('matrixCellRowNum').value = 1;
    document.getElementById('matrixCellColNum').value = 1;
    document.querySelector('#matrixCellDataType').value = "title";
  }
  return true;
}

 
function fncHighlightCell(){
  let intCol = document.getElementById('matrixCellColNum').value;
  let intRow = document.getElementById('matrixCellRowNum').value;
  if (intRow.length < 1 || intCol.length < 1) {
    return;
  }
  let arrMatrixTable = document.getElementsByName('tdWorkingTableCell');
  for (let i=0; i < arrMatrixTable.length; i++) {
      arrMatrixTable[i].style.border="thin solid white";
  }

  document.getElementById('tdWorkingTableCellId' + intRow + intCol)
        .style.border="thin solid red"; 
  document.querySelector('#matrixCellDataType').value = 
                document.getElementById('tdWorkingTableCellId' + intRow + intCol).getAttribute("data-dataType");
                
}
      
function fncSetSelect(g_intRow, g_intCol){
  document.getElementById('matrixCellRowNum').value=g_intRow;
  document.getElementById('matrixCellColNum').value=g_intCol;
  fncHighlightCell()
}
