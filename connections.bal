import ballerinax/salesforce;

final salesforce:Client salesforceClient = check new ({baseUrl: baseUrl, auth: {refreshUrl: refreshUrl, refreshToken: refreshToken, clientId: clientId, clientSecret: clientSecret}});
