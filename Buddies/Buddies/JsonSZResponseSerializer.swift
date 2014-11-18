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

class URIMatcher<S: JSONSerializable> {
    
    var models = [String: S.Type]()
    
    subscript(key: String) -> S.Type? {
        get {
            return models[key]
        }
        
        set {
            models[key] = newValue
        }
    }
    
    init() {}
    
    func add(path: String, type: S.Type) {
       models[path] = type
    }
    
}

class JsonSZResponseSerializer<M: JSONSerializable>: ResponseSerializer {
    
    typealias Model = M
    
    let jsonSZ = JsonSZ()
    let matcher: URIMatcher<M>
    
    init(matcher: URIMatcher<M>) {
        self.matcher = matcher
    }
    
    /**
    Deserialize the response received to Model Object
    
    :returns: the serialized response
    */
    func response(response: NSURLResponse, data: NSData) -> (Model?) {
        //let JSON: M? = super.response(response, data: data)

        // determine path
        let path = response.URL?.path!
        
        // retrieve class by path
        let type = self.matcher[path!]
        
        if type != nil {
        let object = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
            return self.jsonSZ.fromJSON(object!, to: type!)
         }
        
        return nil
    }

    /**
    Validate the response received
    
    :returns:  either true or false if the response is valid for this particular serializer
    */
    func validateResponse(response: NSURLResponse, data: NSData, error: NSErrorPointer) -> Bool {
        // TODO: should we check if the response contains valid object
        return true
    }
}