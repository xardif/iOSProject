import Foundation

class Actor : NSObject, Indexable {
    
    var id : String = ""
    var imdbId : String = ""
    var name : String = ""
    var desc : String = ""
    var jsonDict : NSDictionary = NSDictionary()
    var imageLink : String = ""
    
    func getHeadline() -> String {
        return name
    }
    
    func getSmallHeadline() -> String {
        return desc
    }
    
    func getJsonDict() -> NSDictionary {
        return jsonDict
    }
    
    init(JSONDictionary: NSDictionary) {
        super.init()
        self.jsonDict = JSONDictionary
        
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

func == (lhs: Actor, rhs: Actor) -> Bool {
    return lhs.getJsonDict() == rhs.getJsonDict()
}

func == (lhs: Actor, rhs: Movie) -> Bool {
    return lhs.getJsonDict() == rhs.getJsonDict()
}