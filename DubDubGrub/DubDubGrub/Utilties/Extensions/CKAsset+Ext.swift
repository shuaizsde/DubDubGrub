//
//  CKAsset+Ext.swift
//  DubDubGrub
//
//  Created by Sean Allen on 5/29/21.
//

import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        let placeholder = ImageDimension.getPlaceholder(for: dimension)

        guard let fileUrl = self.fileURL else { return placeholder }

        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? placeholder
        } catch {
            return placeholder
        }
    }
}
