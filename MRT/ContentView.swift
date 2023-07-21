//
//  ContentView.swift
//  MRT
//
//  Created by Kanaya Tio on 14/07/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    init() {
        let unselectedColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            UITabBar.appearance().unselectedItemTintColor = unselectedColor
        }
    
    var body: some View {
        TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Beranda")  
                        }
                        .tag(0)
                    
                    HistoryView()
                        .tabItem {
                            Image(systemName: "clock")
                            Text("Riwayat")
                            
                                  
                        }
                        .tag(1)
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profil")
                        }
                        .tag(2)
        }
        .accentColor(Color("DarkBlue"))
        
        .toolbarColorScheme(.light, for: .tabBar)
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
