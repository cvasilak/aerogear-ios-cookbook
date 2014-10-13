/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation

public class Config {
    /**
    * Applies the baseURL to the configuration.
    */
    public let baseURL: String
    
    /**
    * Applies the "authorization endpoint" to the request token.
    */
    public var authzEndpointURL: String
    
    /**
    * Applies the "callback URL" once request token issued.
    */
    public let redirectURL: String
    
    /**
    * Applies the "access token endpoint" to the exchange code for access token.
    */
    public var accessTokenEndpointURL: String

    /**
    * Endpoint for request to invalidate both accessToken and refreshToken.
    */
    public let revokeTokenEndpointURL: String?
    
    /**
    * Endpoint for request a refreshToken.
    */
    public let refreshTokenEndpointURL: String?
    
    /**
    * Applies the various scopes of the authorization.
    */
    public let scopes: [String]
    
    /**
    * Applies the "client id" obtained with the client registration process.
    */
    public let clientId: String
    
    /**
    * Applies the "client secret" obtained with the client registration process.
    */
    public let clientSecret: String?
    
    /**
    * Account id is used with AccountManager to store tokens. AccountId is defined by the end-user 
    * and can be any String. If AccountManager is not used, this field is optional.
    */
    public var accountId: String?
    
    public init(base: String, authzEndpoint: String, redirectURL: String, accessTokenEndpoint: String, clientId: String, refreshTokenEndpoint: String? = nil, revokeTokenEndpoint: String? = nil, scopes: [String] = [],  clientSecret: String? = nil, accountId: String? = nil) {
        self.baseURL = base
        self.authzEndpointURL = authzEndpoint
        self.redirectURL = redirectURL
        self.accessTokenEndpointURL = accessTokenEndpoint
        self.refreshTokenEndpointURL = refreshTokenEndpoint
        self.revokeTokenEndpointURL = revokeTokenEndpoint
        self.scopes = scopes
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.accountId = accountId
    }
}