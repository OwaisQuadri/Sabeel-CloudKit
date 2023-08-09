//
//  CGFloat+Ext.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

extension CGFloat {
    enum Dimension {
        case width
        case height
    }
    static func relativeToScreen(_ dimension: Dimension, ratio: CGFloat) -> CGFloat {
        switch dimension {
            case .width:
                return UIScreen.main.bounds.size.width * ratio
            case .height:
                return UIScreen.main.bounds.size.height * ratio
        }
    }
}
