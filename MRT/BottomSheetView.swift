//
//  BottomSheetView.swift
//  MRT
//
//  Created by Kanaya Tio on 14/07/23.
//

import SwiftUI

struct BottomSheetView: View {
    @Binding var isShowingBottomSheet: Bool
    @State var navigate: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("Konfirmasi Pemotongan Saldo")
                    .font(.headline)
                
                Spacer().frame(height: 9)
                
                Image("MartiNoTravelYet")
                
                Spacer().frame(height: 6)
                
                Text("Apakah kamu yakin?")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Black"))
                
                Spacer().frame(height: 7)
                
                Text("Setelah terkonfirmasi, saldo otomatis terpotong\nsaat kamu keluar dari gerbang stasiun tujuan")
                    .font(.system(size: 15))
                    .foregroundColor(Color("Black"))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 25)
                
                Button(action: {
              
                }) {
                    ZStack{
                        Rectangle()
                            .frame(width: 156, height: 44)
                            .cornerRadius(6)
                            .foregroundColor(Color("DarkBlue"))
                        
                        Text("KONFIRMASI")
                            .font(.system(size: 17))
                            .foregroundColor(Color("White"))
                            .fontWeight(.medium)
                    }
                }
            }
            
            NavigationLink(destination: ContentView(), isActive: $isShowingBottomSheet) {
                            EmptyView()
                        }
                        .hidden()
            .background(Color.white)
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}
