//
//  ContentView.swift
//  Facebook-auth
//
//  Created by abhishek on 28/07/23.
//

import SwiftUI
import FbLogin

struct ContentView: View {
    
 
   
    
    var body: some View {
        VStack {
            Button {
              
                let vc = FbLoginController(delegate: self)
                vc.beginFbLogin()
                
            } label: {
                Text("Login with facebook").foregroundColor(.white)
                    .padding()
                    .background(
                
                        RoundedRectangle(cornerRadius: 40)
                            .shadow(color: .black, radius: 2 )
                            .frame(width: 300,height: 60)
                )
            }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView : FbLoginStatusProtocol {
    func fbLoginSuccess(token: String, userData: [String : Any]) {
        debugPrint(token,userData)
    }
    
    func fbLoginFail(error: FbLogin.FbAuthError) {
        debugPrint(error)
    }
    
    func fbLoginAccess(status: Bool) {
        debugPrint(status)
    }
    
    
}
