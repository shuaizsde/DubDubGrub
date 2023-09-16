//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/15/23.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var companyName = ""
    @State private var bio = ""
    
    var body: some View {
        VStack {
            ZStack {
                NameBackgroundView()
                
                HStack(spacing: 16) {
                    ZStack {
                        AvatarView(size: 84)
                        EditImageView()
                    }
                    VStack {
                        TextField("First Name", text: $firstName).profileNameStyle()
                        TextField("Last Name", text: $lastName).profileNameStyle()
                        TextField("Company Name", text: $companyName)
                    }
                }.padding()
            }
            
            VStack(spacing: 6) {
                CharactersRemainView(currentCount: bio.count)
                
                TextEditor(text: $bio) 
                    .frame(height: 100)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth:1))
            }
            Spacer()
            
            Button {
                
            } label: {
                DDGButtton(title: "Create Profile")
            }
        }
        .padding()
        .navigationTitle("Profile")
    }
}

struct NameBackgroundView: View {
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
    }
}

struct EditImageView: View {
    var body: some View {
        Image(systemName: "square.and.pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 14, height: 14)
            .foregroundColor(.white)
            .offset(y:30)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}


struct CharactersRemainView: View {
    var currentCount: Int
    
    var body: some View {
        Text("Bio: ")
            .font(.callout)
            .foregroundColor(.secondary)
        +
        Text("\(100 - currentCount)")
            .bold()
            .font(.callout)
            .foregroundColor( currentCount <= 100 ? .brandPrimary : Color(.systemPink) )
        +
        Text(" Characters Remain")
            .font(.callout)
            .foregroundColor(.secondary)
    }
}

struct DDGButtton: View {
    let title: String
    var body: some View {
        Text(title)
            .bold()
            .frame(width: 200, height: 44)
            .background(Color.brandPrimary)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}
