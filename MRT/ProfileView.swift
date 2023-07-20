//
//  ProfileView.swift
//  MRT
//
//  Created by Kanaya Tio on 17/07/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack (alignment: .leading) {
            VStack (alignment: .leading) {
                Text("Profil")
                    .font(.system(size: 34))
                    .foregroundColor(Color("Black"))
                    .fontWeight(.semibold)
                
                Spacer().frame(height: 14)
                
                Divider()
                    .padding(.leading, -20.0)
            }
            
            
            Spacer().frame(height: 21)
            
            Text("Data Diri")
                .font(.system(size: 22))
                .foregroundColor(Color("DarkBlue"))
                .fontWeight(.semibold)
            
            Spacer().frame(height: 19)
            
            HStack{
                VStack(alignment: .leading){
                    Text("Nama")
                        .font(.system(size: 15))
                        .foregroundColor(Color("Black"))
                        .fontWeight(.regular)
                    
                    Spacer().frame(height: 10)
                    
                    Text("Maria Jonas")
                        .font(.system(size: 17))
                        .foregroundColor(Color("Black"))
                        .fontWeight(.bold)
                }
                
                Spacer().frame(width: 225)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("MediumGrey"))
                    .padding(.leading, 10.0)
            }
            
            Divider().frame(width: 349)
            
            Spacer().frame(height: 19)
            
            VStack (alignment: .leading) {
                Text("Email")
                    .font(.system(size: 15))
                    .foregroundColor(Color("Black"))
                    .fontWeight(.regular)
                
                Spacer().frame(height: 10)
                
                PlainText(text: "Jonas.Mar@gmail.com")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                
                Divider().frame(width: 349)
                
                Spacer().frame(height: 36)
            }
         
            VStack (alignment: .leading) {
                Text("Keamanan")
                    .font(.system(size: 22))
                    .foregroundColor(Color("DarkBlue"))
                    .fontWeight(.semibold)
                
                Spacer().frame(height: 19)
                
                HStack{
                    Text("Ubah PIN")
                        .font(.system(size: 20))
                        .foregroundColor(Color("Black"))
                        .fontWeight(.semibold)
                    
                    Spacer().frame(width: 225)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("MediumGrey"))
                        .padding(.leading, 10.0)
                }
                
                Divider().frame(width: 349)
            }
            
            Spacer().frame(height: 326)
        }
        .padding(.leading, 17.0)
        
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
