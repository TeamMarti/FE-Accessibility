//
//  ShortCut.swift
//  MRT
//
//  Created by Kanaya Tio on 15/07/23.
//

import AppIntents
import SwiftUI

class ViewModel: ObservableObject {
    static let shared = ViewModel()
    
    @Published var value: Int = 1
    
    func navigateToView() {
        print("test")
        value = 2
    }
}

struct OpenBottomSheet: AppIntent{
    static let title:LocalizedStringResource = "Open Bottom Sheet"
    
    static let openAppWhenRun: Bool = true

//    @MainActor
//      func perform() async throws -> some IntentResult {
//          Navigator.shared.openCurrentlyReadingPage()
//          return .result()
//      }
    
//    @Parameter(title: "Navigation")
//    var navigation: NavigationType

    @MainActor
    func perform() async throws -> some IntentResult {
//        return.result(dialog: "Okay, Open Bottom Sheet")
        ViewModel.shared.navigateToView()
        return .result()
    }
    
}



