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


class StringResponseSerializer : ResponseSerializer {
    
    func response(data: NSData) -> (AnyObject?) {
        return NSString(data: data, encoding:NSUTF8StringEncoding)
    }
    
    func validateResponse(response: NSURLResponse!, data: NSData!, inout error: NSError) -> Bool {
        let httpResponse = response as NSHTTPURLResponse
        var isValid = true
        
        if !(httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
            isValid = false
            var userInfo: [NSObject: AnyObject] = [
                NSLocalizedDescriptionKey: "Request failed: \(httpResponse.statusCode)" as NSString,
                NSURLErrorFailingURLErrorKey: httpResponse.URL?.absoluteString as NSString!
            ]
            
            error = NSError(domain: HttpResponseSerializationErrorDomain, code: httpResponse.statusCode, userInfo: userInfo)
        }
        
        return isValid
    }
}