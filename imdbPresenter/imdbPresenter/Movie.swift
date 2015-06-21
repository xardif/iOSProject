import Foundation

class Movie : NSObject, Indexable {
    
    var id : String = ""
    var imdbId : String = ""
    var title : String = ""
    var titleDescription : String = ""
    var episodeTitle : String = ""
    var desc : String = ""
    var imageLink : String = ""
    var jsonDict : NSDictionary = NSDictionary()
    
    func getHeadline() -> String {
        return title
    }
    
    func getSmallHeadline() -> String {
        return titleDescription
    }
    
    func getJsonDict() -> NSDictionary {
        return jsonDict
    }
    
    func getUrl() -> String {
        return imageLink
    }
        
    init(JSONDictionary: NSDictionary) {
        super.init()
        self.jsonDict = JSONDictionary
        
        for (key, value) in JSONDictionary {
            let keyName = key as String
            let keyValue: String = value as String
            
            
            if (keyName == "description"){
                self.desc = keyValue
            } else if (keyName == "titleDescription") {
                var splitArray = split(keyValue){ $0 == "," }
                self.titleDescription = splitArray[0]
            } else if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
    }
    
}

func == (lhs: Movie, rhs: Movie) -> Bool {
    return lhs.getJsonDict() == rhs.getJsonDict()
}

func == (lhs: Movie, rhs: Actor) -> Bool {
    return lhs.getJsonDict() == rhs.getJsonDict()
}