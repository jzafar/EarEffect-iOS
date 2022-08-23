/*
See LICENSE folder for this sample’s licensing information.

Abstract:
`Artwork` represents a `Artwork` object from the Apple Music Web Services.
*/

import UIKit

struct Artwork: Codable {
    let height: Int?
    let width: Int?
    let url: String
    
    
    func imageURL(size: CGSize) -> URL {
        var imageURLString = url.replacingOccurrences(of: "{w}", with: "\(Int(size.width))")
        imageURLString = imageURLString.replacingOccurrences(of: "{h}", with: "\(Int(size.width))")
        imageURLString = imageURLString.replacingOccurrences(of: "{f}", with: "png")
        return URL(string: imageURLString)!
    }
}
