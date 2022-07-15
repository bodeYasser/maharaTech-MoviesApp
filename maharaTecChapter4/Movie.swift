import UIKit

struct Movie :Decodable {
    var title : String
    var image : String
    var rating : Double
    var releaseYear : Int
    var genre : [String]
}
