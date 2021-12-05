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
    @State private var visiblePass : Bool = false
    @State var selectedImageArray : [Image] = []
    
    
    var body: some View {
        
        ZStack{
            Color
                .themeBackground
                .ignoresSafeArea()
            
            if viewModel.isLoading == true {
                VStack{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2)
                        .padding(.bottom)
                    Text("Loading Profile...")
                        .foregroundColor(.blue)
                }
            }
            
            ZStack{
                
                VStack{
                    
                    Image(uiImage: #imageLiteral(resourceName: "awText"))
                        .resizable()
                        .frame(width: 180, height: 100)
                        .padding(.bottom, 50)
                    
                    TextField("Email", text: $username)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(Color(UIColor.systemGray2), lineWidth: 1))
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onChange(of: self.username, perform: { value in
                            if value.count > 10 {
                                self.username = String(value.prefix(20)) //Max 20 Characters for Username.
                            }
                        })
                        .padding(.bottom)
                        
                    
                    HStack(spacing: 15){
                        VStack{
                            if self.visiblePass {
                                TextField("Password", text: $password)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .onChange(of: self.password, perform: { value in
                                        if value.count > 10 {
                                            self.password = String(value.prefix(10)) //Max 10 Characters for Password.
                                        }
                                    })
                            } else {
                                SecureField("Password", text: $password)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .onChange(of: self.password, perform: { value in
                                        if value.count > 10 {
                                            self.password = String(value.prefix(10)) //Max 10 Characters for Password.
                                        }
                                    })
                            }
                        }
                        
                        Button {
                            self.visiblePass.toggle()
                        } label: {
                            Image(systemName: self.visiblePass ? "eye.slash.fill" : "eye.fill")
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color(UIColor.systemGray2), lineWidth: 1))
                    
                    
                    //SignIn Button
                    Button(action: {
                        viewModel.signIn(email: username, password: password)
                    }, label: {
                        Text("Sign In")
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.themeBackground)
                            .background(Color.themeAccent)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .padding()
                    })
                    
                    
                    //SignUp Button
                    NavigationLink("Create Account", destination: SignUpView())
                        .frame(width: 300, height: 50)
                        .foregroundColor(Color.themeBackground)
                        .background(Color.themeAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                }
                .padding(.horizontal, 25)
                .navigationTitle("AW Support")
                
                if viewModel.alert{
                    ErrorView(alert: viewModel.alert, error: viewModel.error)
                }
            }
            .blur(radius: viewModel.isLoading ? 5 : 0)
        }
        
    }
    
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
