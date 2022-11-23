import ballerinax/googleapis.gmail;
import ballerina/log;

configurable string clientId = "54220665783-dl8rdb15aedc0aj0dv9lon9kckaf8ou9.apps.googleusercontent.com";
configurable string clientSecret = "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";
configurable string refreshUrl = "https://oauth2.googleapis.com/token";
configurable string refreshToken = "1//04xQST4jaXT70CgYIARAAGAQSNwF-L9IrYFgV9tehP8HGUL6-TjBYSICX_PPKpfYFJX2DGZwFOIXPheW5E784LQhsXvwFYUkqO3o";

public function main() returns error? {
    
    gmail:ConnectionConfig gmailConfig = {
    auth: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshUrl: refreshUrl,
        refreshToken: refreshToken
        }
    };

    gmail:Client gmailClient = check new(gmailConfig);
    
    // Moves the specified message to the trash.
    log:printInfo("Trash a message");

    // ID of the message to trash.
    string sentMessageId = "184a2e80092b8d56"; 

    gmail:Message|error trash = gmailClient->trashMessage(sentMessageId);

    if (trash is gmail:Message) {
        log:printInfo("Successfully trashed the message");
    } else {
        log:printError("Failed to trash the message");
    }
    log:printInfo("End!");
}
