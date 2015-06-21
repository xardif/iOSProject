import Foundation

protocol Indexable {
    func getHeadline() -> String
    func getSmallHeadline() -> String
    func getJsonDict() -> NSDictionary
    func getUrl() -> String
}

