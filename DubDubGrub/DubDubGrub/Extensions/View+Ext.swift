//
//  View+Ext.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/16/23.
//

import Foundation
import SwiftUI

extension View {
    func profileNameStyle() -> some View {
        self.modifier(ProfileNameText())
    }
}
 
