import UIKit


//data model for my local api which simulate api from lectures
//struct Movie : Codable {
//    var title : String
//    var image : String
//    var rating : Double
//    var releaseYear : Int
//    var genre : [String]
//}


//data model for Movies App api from rapid api
// i used only some data from it
struct Welcome: Decodable {
    let results: [Result]
}

 struct Result: Decodable {
    let image,rating, year, titleOriginal: String
}
