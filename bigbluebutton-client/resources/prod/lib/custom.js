var key = "BigBlueButtonShortcutMapping";
function getCustomKeySettings() {
  var json = localStorage.getItem(key);
  console.log("Json returned: " + json);
  return json;
}
function setCustomKeySettings(json) {
  console.log(json);
  localStorage.setItem(key, json);
  console.log("Json set: " + json);
  return;
}
function notifyCustomKeysChanged() {
  return true;
}