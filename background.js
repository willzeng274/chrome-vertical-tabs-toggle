const NATIVE_HOST = "com.tabbar.toggle";

chrome.commands.onCommand.addListener((command) => {
  if (command === "toggle-vertical-tabs") {
    chrome.runtime.sendNativeMessage(NATIVE_HOST, { action: "toggle" });
  }
});
