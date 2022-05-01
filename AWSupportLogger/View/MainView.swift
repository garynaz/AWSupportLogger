//
//  FirstView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 8/28/21.
//

import SwiftUI
import Firebase


struct MainView: View {
	@EnvironmentObject private var appViewModel: AppViewModel
	
	var body: some View {
		
		VStack(spacing: 30){
			
			NavigationLink(destination: SupportView()){
				awButton(content: "Request Support", backColor: Color.themeSecondary)
			}
			
			NavigationLink(destination: QuoteView()){
				awButton(content: "Request Quote", backColor: Color.orange)
			}
			
			NavigationLink(destination: TicketView()){
				awButton(content: "Ticket Status", backColor: Color.green)
			}
			.padding(.bottom)
		}
		.padding(.leading)
		.padding(.trailing)
		.navigationBarBackButtonHidden(true)
		.navigationBarTitle(appViewModel.userInfo!.company, displayMode: .large)
		.navigationBarItems(leading:
								Menu("Account"){
			Button("Sign Out") {
				appViewModel.allMessagesArray.removeAll()
				appViewModel.userTicketsArray.removeAll()
				appViewModel.signOut()
			}
			Button("Delete All Ticket Data", action: appViewModel.deleteAllUserTicketData)
			Button("Delete Account", action: appViewModel.deleteUserAccount)
		},trailing: HStack{
			Image(uiImage: appViewModel.photoImage!)
				.resizable()
				.scaledToFit()
				.clipShape(Circle())
				.frame(width: 50, height: 50)
			
			Text(appViewModel.userInfo!.name)
				.font(.system(size: 20))
		})
		
		
	}
	
}


struct FirstView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
	}
}




struct awButton: View {
	var content : String
	var backColor : Color
	var body: some View {
		ZStack{
			VStack {
				HStack {
					Image(uiImage: #imageLiteral(resourceName: "awText"))
						.resizable()
						.frame(width: 30, height: 20)
						.padding(.leading)
					Spacer()
				}
				.padding(.top)
				Spacer()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
			.background(backColor)
			.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
			
			Text("\(content)")
				.font(.largeTitle)
				.fontWeight(.semibold)
				.foregroundColor(Color.white)
			
		}
		
		
	}
}
