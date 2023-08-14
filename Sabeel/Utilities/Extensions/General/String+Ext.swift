//
//  String+Ext.swift
//  Sabeel
//
//  Created by Owais on 2023-08-13.
//
// PROJECT REUSABLE

import Foundation

extension String : Identifiable {
    public var id: ObjectIdentifier {
        return ObjectIdentifier(String.self)
    }
}
