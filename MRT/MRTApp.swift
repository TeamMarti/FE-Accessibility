//
//  MRTApp.swift
//  MRT
//
//  Created by Kanaya Tio on 14/07/23.
//

import SwiftUI

@main
struct MRTApp: App {
    @ObservedObject var viewModel: ViewModel = ViewModel.shared
    var body: some Scene {
        WindowGroup {
            if viewModel.value == 1 {
                ContentView().environmentObject(viewModel)
            } else {
                ContentView().environmentObject(viewModel)
            }
        }
    }
}
