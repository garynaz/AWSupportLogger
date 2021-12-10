//
//  DetailView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 9/18/21.
//

import SwiftUI
import Firebase

struct DetailView: View {
    
    @EnvironmentObject private var appViewModel: AppViewModel
    @State var msgTxt = ""
    @State var noMsg = true
    @State var restorePlaceholder = false
    
    var selectedTicket: Ticket!
    
    var body: some View {
        
        VStack{
            
            VStack(alignment: .leading) {
                Text(selectedTicket.type)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 25, weight: .light))
                
                Text(selectedTicket.date)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding()
                
                HStack {
                    HStack {
                        Text(selectedTicket.name)
                            .font(.system(size: 20, weight: .light))
                            .padding()
                    }
                    Spacer()
                    
                    if selectedTicket.priority == "High"{
                        Text("\(selectedTicket.priority) Priority")
                            .padding()
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    } else if selectedTicket.priority == "Medium"{
                        Text("\(selectedTicket.priority) Priority")
                            .padding()
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    } else {
                        Text("\(selectedTicket.priority) Priority")
                            .padding()
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                }
                
                Text(selectedTicket.inquiry)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20, weight: .light))
                    .padding()
                
            }
            .padding()
            .navigationBarTitle(selectedTicket.company, displayMode: .inline)
            .listStyle(PlainListStyle())
            
            
            if noMsg == true {
                Text("Chat With IT Support!")
                    .foregroundColor(Color(UIColor.systemGray2))
                    .padding(.top)
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 8){
                    ForEach(appViewModel.allMessagesArray){ i in
                        HStack{
                            
                            if i.ticketId == selectedTicket.ticketId{
                                
                                if i.userId == selectedTicket.userId {
                                    Spacer()
                                    Text(i.lastMsg)
                                        .onAppear(){
                                            noMsg = false
                                        }
                                        .padding()
                                        .background(Color.blue)
                                        .clipShape(ChatBubble(myMsg: true))
                                        .foregroundColor(.white)
                                } else {
                                    Text(i.lastMsg)
                                        .onAppear(){
                                            noMsg = false
                                        }
                                        .padding()
                                        .background(Color.green)
                                        .clipShape(ChatBubble(myMsg: true))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding(.trailing)
                        .padding(.leading)
                    }
                }
            }
            
            HStack{
                TextField("Enter Message" + (restorePlaceholder ? "" : " "), text: self.$msgTxt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    
                
                Button(action: {
                    appViewModel.sendMsg(message: self.msgTxt, stamp: Timestamp(date: Date()), ticketId: selectedTicket.ticketId, userId: appViewModel.userIdRef)
                    
                    self.msgTxt = ""
                    self.restorePlaceholder.toggle()
                    
                }){
                    Text("Send")
                }
            }
            .padding()
            
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}


struct messageCellView: View {
    
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var userPhoto: UIImage
    var userName: String
    var time: String
    var date: String
    var lastMsg: String
    
    var body: some View{
        HStack{
            
            Image(uiImage: userPhoto)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 55, height: 55)
            
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 6){
                        Text(userName)
                        Text(lastMsg).foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 6){
                        Text(date).foregroundColor(.gray)
                        Text(time).foregroundColor(.gray)
                    }
                }
                Divider()
            }
        }
    }
}

struct ChatBubble: Shape {
    
    var myMsg: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
    
}
