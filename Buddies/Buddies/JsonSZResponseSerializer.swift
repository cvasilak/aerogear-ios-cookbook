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

class URIMatcher {
    
    var models = [String:  JSONSerializable]()
    
    subscript(key: String) -> AnyObject.Type? {
        get {
            return models[key]
        }
        
        set {
            models[key] = newValue
        }
    }
    
    init() {}
    
    func add(path: String, type: AnyObject.Type) {
       models[path] = type
    }
    
}

class JsonSZResponseSerializer: JsonResponseSerializer {
    
    let jsonSZ = JsonSZ()
    let matcher: URIMatcher
    
    init(matcher: URIMatcher) {
        self.matcher = matcher
    }
    
    /**
    Deserialize the response received to Model Object
    
    :returns: the serialized response
    */
    override func response(response: NSURLResponse, data: NSData) -> (AnyObject?) {
        let JSON: AnyObject? = super.response(response, data: data)

        // determine path
        let path = response.URL?.path!
        
        // retrieve class by path
        let type: AnyObject.Type? = self.matcher[path!] as JSONSerializable.Type
        
        if type != nil {
            return self.jsonSZ.fromJSON(JSON, to: type!)
         }
        
        return nil
    }

    /**
    Validate the response received
    
    :returns:  either true or false if the response is valid for this particular serializer
    */
    override func validateResponse(response: NSURLResponse, data: NSData, error: NSErrorPointer) -> Bool {
        // TODO: should we check if the response contains valid object
        return super.validateResponse(response, data: data, error: error)
    }
}