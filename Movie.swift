import Foundation

class Movie : NSObject, Indexable {
    
    var id : String = ""
    var imdbId : String = ""
    var title : String = ""
    var titleDescription : String = ""
    var episodeTitle : String = ""
    var desc : String = ""
    
    func getKey() -> String {
        return title
    }
    
    init(JSONString: String) {
        super.init()
        
        var error : NSError?
        let JSONData = JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let JSONDictionary: Dictionary = NSJSONSerialization.JSONObjectWithData(JSONData, options: nil, error: &error) as NSDictionary
        
        for (key, value) in JSONDictionary {
            let keyName = key as String
            let keyValue: String = value as String
            
            
            if (keyName == "description"){
                self.desc = keyValue
            } else if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
    }
    
    
}
