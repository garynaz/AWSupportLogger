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
    @State private var photo: Image?
    @State private var admin: Bool = false
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var isSignUpValid: Bool = false
    
    @State var selectedImageArray : [Image] = []
    
    
    var disableSignUpButton : Bool {
        return self.email.isEmpty || self.password.isEmpty || self.name.isEmpty || self.company.isEmpty
    }
    
    
    var body: some View {
        
        ScrollView{
            VStack{
                Group {
                    TextField("Company", text: $company)
                        .padding(.leading)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Divider()
                        .padding(.bottom)
                        .onChange(of: self.company, perform: { value in
                            if value.count > 30 {
                                self.company = String(value.prefix(30))
                            }
                        })
                    
                    TextField("First and Last Name", text: $name)
                        .padding(.leading)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Divider()
                        .padding(.bottom, 30)
                        .onChange(of: self.name, perform: { value in
                            if value.count > 30 {
                                self.name = String(value.prefix(30))
                            }
                        })
                    
                    TextField("Email", text: $email)
                        .padding(.leading)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Divider()
                        .padding(.bottom)
                        .onChange(of: self.email, perform: { value in
                            if value.count > 30 {
                                self.email = String(value.prefix(30))
                            }
                        })
                    
                    SecureField("Password", text: $password)
                        .padding(.leading)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Divider()
                        .padding(.bottom, 30)
                        .onChange(of: self.password, perform: { value in
                            if value.count > 30 {
                                self.password = String(value.prefix(30))
                            }
                        })
                    
                }
                
                VStack{
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
                .padding(.bottom)
                
                
                ZStack{
                    if photo != nil {
                        photo?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.secondary)
                            .frame(width: 200, height: 200)
                        Text("Tap to select a photo")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                .padding(.bottom, 50)
                                
                Button(action: {
                    //Uploads image to storage...
                    let randomID = UUID.init().uuidString
                    
                    Storage.storage().reference().child("images/\(randomID).jpg").putFile(from: self.selectedImageURL!, metadata: nil) { metadata, error in
                        viewModel.signUp(email: email, password: password, company: company, name: name, admin: admin, photoRef: "images/\(randomID).jpg")
                    }
                    
                }, label: { Text("Create Account")
                    .disabled(disableSignUpButton)
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                })
                
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
                ImagePicker(image: self.$inputImage, selectedImageURL: self.$selectedImageURL)
            }
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
