//
//  AdminView.swift
//
//
//  Created by Gary Naz on 9/19/21.
//

import SwiftUI
import Firebase

struct AdminView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var body: some View {
        List{
            ForEach(appViewModel.allTicketsArray) { ticket in
                VStack{
                    NavigationLink(
                        destination: DetailView(selectedTicket: ticket)){
                            
                            VStack(alignment: .leading) {
                                
                                Text("\(ticket.type)")
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .semibold))
                                
                                HStack(alignment: .center) {
                                    Text(appViewModel.userInfo!.company)
                                        .font(.system(size: 20, weight: .bold))
                                    Spacer()
                                    Text("\(ticket.status)")
                                        .padding()
                                        .minimumScaleFactor(0.5)
                                        .background(Color.green)
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        .lineLimit(1)
                                }
                                Text("\(ticket.date)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Spacer()
                                Text("Submitted By: \(appViewModel.userInfo!.name)")
                                    .font(.system(size: 15, weight: .light))
                                    .padding(.bottom, 5)
                                Text("\(ticket.inquiry)")
                                    .lineLimit(2)
                                    .foregroundColor(.gray)
                            }
                        }
                }
            }
            .onDelete(perform: deleteTicket)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("ADMIN")
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appViewModel.signOut()
                } label: {
                    Text("Sign Out")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    Image(uiImage: appViewModel.photoImage!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    Text(appViewModel.userInfo!.name)
                        .font(.system(size: 20))
                    EditButton()
                        .animation(.default)
                }
            }
        }
    }
    
    func deleteTicket(at offsets: IndexSet){
        for offset in offsets {
            let selectedTicket = appViewModel.allTicketsArray[offset].key!
            
            DispatchQueue.main.async {
                appViewModel.rootTicketCollection!.document(selectedTicket.documentID).delete()
                appViewModel.allTicketsArray.remove(at: offset)
            }
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
