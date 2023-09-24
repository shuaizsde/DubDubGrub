//
//  UIImage+Ext.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/24/23.
//

import CloudKit
import UIKit

extension UIImage {
        
    func convertToCKAsset() -> CKAsset? {
        // Get app base document directory url
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document Directory url came back nil")
            return nil
        }
        
        // append unique id for profile image
        let fileUrl  = urlPath.appendingPathComponent("selectedAvatarImage")
        
        // write image data to location the address points to
        guard let imageData = jpegData(compressionQuality: 0.25) else {return nil}
        
        // Create our CKAsset with that fileUrl
        do {
            try imageData.write(to: fileUrl)
            return CKAsset(fileURL: fileUrl)
        }catch {
            return nil
        }
        
    }
}
