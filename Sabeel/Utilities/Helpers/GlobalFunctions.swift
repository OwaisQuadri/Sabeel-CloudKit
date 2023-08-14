//
//  GlobalFunctions.swift
//  Sabeel
//
//  Created by Owais on 2023-08-13.
//
// PROJECT REUSABLE

import Foundation

func onMainThread (completion: @escaping () -> Void) {
    DispatchQueue.main.async {
        completion()
    }
}
func updateUIOnMainThread (completion: @escaping () -> Void) {
    DispatchQueue.main.async {
        completion()
    }
}

