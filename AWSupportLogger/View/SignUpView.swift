//
//  SignUpView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 8/17/21.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    //Test Image Data
    let imageStorageRef = Storage.storage().reference()
    
    @State private var selectedImageURL: URL?
    
    
    @State private var name: String = ""
    @State private var company: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repassword: String = ""
    @State private var photo: Image?
    @State private var admin: Bool = false
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var isSignUpValid: Bool = false
    
    @State var selectedImageArray : [Image] = []
    
    
    
    var body: some View {
        
        ZStack{
            if viewModel.isLoading == true {
                VStack{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2)
                        .padding(.bottom)
                    Text("Creating Profile...")
                        .foregroundColor(.blue)
                }
            }
            
            ZStack{
                VStack{
                    
                    Spacer()
                    
                    ZStack{
                        if photo != nil {
                            photo?
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.secondary)
                                .frame(width: 150, height: 150)
                            Text("Select a Photo")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                    .onTapGesture {
                        self.showingImagePicker = true
                    }
                    .offset(y: -20)
                    
                    Group {
                        TextField("Company", text: $company)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(Color.black.opacity(0.5), lineWidth: 2))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.bottom)
                            .onChange(of: self.company, perform: { value in
                                if value.count > 30 {
                                    self.company = String(value.prefix(30))
                                }
                            })
                        
                        TextField("First and Last Name", text: $name)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(Color.black.opacity(0.5), lineWidth: 2))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.bottom)
                            .onChange(of: self.name, perform: { value in
                                if value.count > 30 {
                                    self.name = String(value.prefix(30))
                                }
                            })
                        
                        TextField("Email", text: $email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(Color.black.opacity(0.5), lineWidth: 2))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.bottom)
                            .onChange(of: self.email, perform: { value in
                                if value.count > 30 {
                                    self.email = String(value.prefix(30))
                                }
                            })
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(Color.black.opacity(0.5), lineWidth: 2))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.bottom)
                            .onChange(of: self.password, perform: { value in
                                if value.count > 30 {
                                    self.password = String(value.prefix(30))
                                }
                            })
                        
                        SecureField("Password", text: $repassword)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(Color.black.opacity(0.5), lineWidth: 2))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .onChange(of: self.repassword, perform: { value in
                                if value.count > 30 {
                                    self.password = String(value.prefix(30))
                                }
                            })
                    }
                    
                    Spacer()
                    
                    HStack{
                        HStack{
                            Text("ADMIN")
                                .foregroundColor(admin ? .green : .gray)
                            Toggle("", isOn: $admin)
                                .labelsHidden()
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 2)
                                .foregroundColor(admin ? .green : .gray)
                        )
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                        viewModel.signUp(email: email, password: password, repassword: repassword, company: company, name: name, admin: admin, imageURL: self.selectedImageURL)
                        
                    }, label: { Text("Create Account")
                            .frame(width: 300, height: 50)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    })
                    
                }
                .padding(.horizontal, 30)
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                    ImagePicker(image: self.$inputImage, selectedImageURL: self.$selectedImageURL)
                }
                if viewModel.alert{
                    ErrorView(alert: viewModel.alert, error: viewModel.error)
                }
            }
            .blur(radius: viewModel.isLoading ? 5 : 0)
        }
        
    }
    
    func loadImage(){
        guard let inputImage = inputImage else { return }
        photo = Image(uiImage: inputImage)
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
