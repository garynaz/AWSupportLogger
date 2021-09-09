//
//  ChatList.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 7/31/21.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var username : String = ""
    @State private var password : String = ""
    @State private var shouldShowLoginAlert: Bool = false
    @State var selectedImageArray : [Image] = []
    
    var disableLoginButton : Bool {
        return self.username.isEmpty || self.password.isEmpty
    }
    
    var body: some View {
        
        VStack{
            
            Image(uiImage: #imageLiteral(resourceName: "awText"))
                .resizable()
                .frame(width: 180, height: 100)
                .padding(.bottom, 50)
            
            TextField("Email", text: $username)
                .padding(.leading)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            Rectangle().fill(Color.gray.opacity(0.25)).frame(height: 1, alignment: .center).padding(.bottom)
                .padding(.bottom)
                .onChange(of: self.username, perform: { value in
                    if value.count > 10 {
                        self.username = String(value.prefix(20)) //Max 10 Characters for Username.
                    }
                })
            
            SecureField("Password", text: $password)
                .padding(.leading)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            Rectangle().fill(Color.gray.opacity(0.25)).frame(height: 1, alignment: .center)
                .onChange(of: self.username, perform: { value in
                    if value.count > 10 {
                        self.username = String(value.prefix(10)) //Max 10 Characters for Password.
                    }
                })
            
            
            //SignIn Button
            Button(action: {
                viewModel.signIn(email: username, password: password)
            }, label: {
                Text("Sign In")
                    .disabled(disableLoginButton)
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .padding()
            })
            
            
            //SignUp Button
            NavigationLink("Create Account", destination: SignUpView())
                .frame(width: 300, height: 50)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
        }
        .navigationTitle("AW Support")
        
    }
    
    
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
