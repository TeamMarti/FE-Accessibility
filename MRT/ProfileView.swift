//
//  ProfileView.swift
//  MRT
//
//  Created by Kanaya Tio on 17/07/23.
//

import SwiftUI

struct ProfileView: View {
    @State var userName: String = ""
    @State var userEmail: String = ""
    
    var body: some View {
        VStack{
            Text("Profil")
                .font(.system(size: 17))
                .foregroundColor(Color("Black"))
                .fontWeight(.semibold)
            
            Divider()
                .padding(.top, 2.0)
                .padding(.bottom, 16.0)
            
            Image("Profil")
            
            Text(userName)
                .font(.system(size: 22))
                .foregroundColor(Color("Black"))
                .fontWeight(.semibold)
            
            PlainText(text: userEmail)
                .font(.system(size: 17))
                .foregroundColor(Color("Black"))
                .fontWeight(.regular)
            
            Text("Edit Profil")
                .font(.system(size: 17))
                .foregroundColor(Color("White"))
                .fontWeight(.medium)
                .frame(width: 130, height: 44)
                .background(Color("DarkBlue"))
                .cornerRadius(5)
            
            Divider()
                .frame(width: 359)
                .padding(.vertical)
            
            HStack{
                Text("Ubah PIN")
                    .font(.system(size: 17))
                    .foregroundColor(Color("Black"))
                    .fontWeight(.semibold)
                    .padding(.trailing, 245.0)
                
                Image(systemName: "chevron.right")
            }.padding(.bottom)
            
            HStack{
                Text("Log Out")
                    .font(.system(size: 17))
                    .foregroundColor(Color("Black"))
                    .fontWeight(.semibold)
                    .padding(.trailing, 260.0)
                
                Image(systemName: "chevron.right")
            }
//            Spacer().frame(height:280)
            Spacer()
        }
        .onAppear {
            userName = UserDefaults.standard.string(forKey: "userName") ?? "John Doe"
            userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "john.doe@gmail.com"
        }
    }
}

struct PlainText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.black)
            .onTapGesture {}
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
