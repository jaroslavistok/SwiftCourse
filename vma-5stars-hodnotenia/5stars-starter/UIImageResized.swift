//
//  UIImageResized.swift
//  5stars-starter
//
//  Created by Jaroslav Istok on 07/01/2017.
//  Copyright © 2017 Touch4IT. All rights reserved.
//
import UIKit

extension UIImage {
    func resizedImage(withTargetSize: CGSize) -> UIImage {
        let originalSize = size
        
        let widthRatio  = withTargetSize.width  / originalSize.width
        let heightRatio = withTargetSize.height / originalSize.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: originalSize.width * heightRatio, height: originalSize.height * heightRatio)
        } else {
            newSize = CGSize(width: originalSize.width * widthRatio,  height: originalSize.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
