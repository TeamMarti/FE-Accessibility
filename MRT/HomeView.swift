//
//  HomeView.swift
//  MRT
//
//  Created by Kanaya Tio on 17/07/23.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingBottomSheet = false
    @ObservedObject var viewModel: ViewModel = ViewModel.shared
    var body: some View {

        NavigationStack{
            Spacer().frame(height: 55)
            
            VStack{
                HStack {
                    VStack(alignment: .leading) {
                        
                        Text(" Hi, Maria Jonas!")
                            .font(.system(size: 15)) .foregroundColor(Color("LightGray"))
                        
                        Spacer().frame(height: 5)

                        HStack{
                            Image(systemName: "creditcard")
                                .font(.system(size: 25))
                                .foregroundColor(Color("Black"))

                            Text("RP 50.000")
                                .fontWeight(.semibold).foregroundColor(Color("Black"))
                                .font(.system(size: 22))
                        }
                    }
                    
                    ZStack{
                        Rectangle()
                            .frame(width: 138, height: 34)
                            .cornerRadius(6)
                            .foregroundColor(Color("Blue"))

                        HStack{
                            Image(systemName: "plus")
                                .font(.system(size: 15))
                                .foregroundColor(Color("White"))
                                .fontWeight(.medium)

                            Text("Top Up Saldo")
                                .foregroundColor(Color("White"))
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }.padding(.leading, 60.0)
                    }
                
                Divider()
                Spacer().frame(height: 16)

                ZStack{
                    ZStack{
                        Image("ConfirmPaymentBackground")
                        
                        Text("Konfirmasi\nPemotongan Saldo")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Black")).position(x:118, y: 43)
                        
                        Text("Saldo akan terpotong otomatis\nsaat kamu keluar dari peron\nstasiun tujuan")     .font(.system(size: 13))
                            .fontWeight(.regular)
                            .foregroundColor(Color("Black"))
                            .position(x:126, y: 99)
                        
                    }
                   

                    VStack{
                            Button(action: {
                            isShowingBottomSheet = true
                        }) {
                            ZStack{
                                Rectangle()
                                    .frame(width: 113, height: 36)
                                    .cornerRadius(6)
                                    .foregroundColor(Color("White"))
                                
                                Text("KONFIRMASI")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("Black"))
                                    .padding()
                                    .cornerRadius(10)
                                    .fontWeight(.semibold)
                            }.position(x:90, y: 160)
                        }
                    }
                }

                Spacer().frame(height: 30)
                
                Text("Perjalananmu Hari Ini")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Black"))
                    .padding(.trailing, 190.0)
                
                Spacer().frame(height: 70)
                
                Image("MartiNoTravelYet")

                Text("Hari ini kamu belum ada perjalanan dengan Swee")
                    .font(.system(size: 13))
                    .fontWeight(.light)
                    .foregroundColor(Color("LightGray"))

            }.sheet(isPresented: $isShowingBottomSheet, content: {
                BottomSheetView(isShowingBottomSheet: $isShowingBottomSheet)
                    .presentationDetents([.fraction(0.5)])
            })
            
            Spacer().frame(height: 200)

        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            if viewModel.value != 1 {
                isShowingBottomSheet = true
            }

        }
    }
        
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
