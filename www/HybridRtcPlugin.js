var exec = require('cordova/exec');
var hybridRtc = function(){};  

hybridRtc.prototype.plus = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "plus", [arg0]);
};

hybridRtc.prototype.minus = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "minus", [arg0]);
};

hybridRtc.prototype.initWithAppKey = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "initWithAppKey", arg0);
};

hybridRtc.prototype.connectWithToken = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "connectWithToken", arg0);
};

hybridRtc.prototype.addGlobalListener = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "addGlobalListener", arg0);
};

hybridRtc.prototype.addMessageReceivedListener = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "addMessageReceivedListener", arg0);
};

hybridRtc.prototype.getConversationList = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "getConversationList", arg0);
};

hybridRtc.prototype.removeConversation = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "removeConversation", arg0);
};

hybridRtc.prototype.disconnect = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "disconnect", arg0);
};

hybridRtc.prototype.startCall = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "startCall", arg0);
};

hybridRtc.prototype.accept = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "accept", arg0);
};

hybridRtc.prototype.hangup = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "hangup", arg0);
};

hybridRtc.prototype.joinRoom = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "joinRoom", arg0);
};

hybridRtc.prototype.groupChat = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "groupChat", arg0);
};

hybridRtc.prototype.pushToConversationPage = function(arg0, success, error) {
    exec(success, error, "HybridRtcPlugin", "pushToConversationPage", arg0);
};

module.exports = new hybridRtc();
