//
//  Photos.swift
//  employee-list
//
//  Created by Ivan Konov on 12/23/22.
//

import Foundation

/// A struct holding employee photos of various sizes.
struct Photos {
    /// An enumeration listing the photo types
    enum Size {
        /// Small size.
        case small
        /// Large size.
        case large
    }
    
    private let photoURLs: [Size: URL]
    
    /// Provides a photo `URL` for a given `Photos.Size`.
    /// - Parameter size: The desired size of the photo.
    /// - Returns: A `URL` for the photo.
    func photoURL(for size: Size) -> URL? {
        self.photoURLs[size]
    }
}
