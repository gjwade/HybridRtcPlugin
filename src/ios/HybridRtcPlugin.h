/********* HybridRtcPlugin.h Cordova Plugin header file *******/

#import <Cordova/CDV.h>

@interface HybridRtcPlugin : CDVPlugin {
  // Member variables go here.
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command;

- (void)plus:(CDVInvokedUrlCommand*)command;
- (void)minus:(CDVInvokedUrlCommand*)command;

- (void)initWithAppKey:(CDVInvokedUrlCommand*)command;
- (void)connectWithToken:(CDVInvokedUrlCommand*)command;
- (void)getConversationList:(CDVInvokedUrlCommand*)command;
- (void)startCall:(CDVInvokedUrlCommand*)command;
- (void)accept:(CDVInvokedUrlCommand*)command;
- (void)hangup:(CDVInvokedUrlCommand*)command;

- (void)joinRoom:(CDVInvokedUrlCommand*)command;
- (void)groupChat:(CDVInvokedUrlCommand*)command;
- (void)pushToConversationPage:(CDVInvokedUrlCommand*)command;
@end
