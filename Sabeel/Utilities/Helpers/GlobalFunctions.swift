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
func onBackgroundThread (completion: @escaping () -> Void) {
    let x = DispatchWorkItem(qos: .userInitiated, flags: .enforceQoS) {
        completion()
    }
    DispatchQueue.main.asyncAndWait(execute: x)
}

