import UIKit
import FacebookLogin
import AuthenticationServices
 
public protocol FbLoginStatusProtocol {
    func fbLoginSuccess(token: String, userData : [String: Any])
    func fbLoginFail(error: String)
    func fbLoginCancel(error: String)
    func fbLoginAccess(status: Bool)
}

public class FbLoginController: UIViewController {
    private var delegate: FbLoginStatusProtocol?
    
    public init(delegate: FbLoginStatusProtocol?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    public func beginFbLogin() {
        LoginManager.init().logIn(permissions: [kEmailPermission, kProfilePermission], from: self) { result, error in
            if let error =  error {
                self.delegate?.fbLoginFail(error: error.localizedDescription)
            } else {
                guard let result = result else {
                    self.delegate?.fbLoginFail(error: kFacebookDeclinedPermissions)
                    return
                }
                if result.isCancelled {
                    self.delegate?.fbLoginCancel(error: kFacebookLoginHasBeenCancelled)
                } else {
                    guard let token = result.token?.tokenString else {
                        self.delegate?.fbLoginFail(error: kTokenNotFound)
                        return
                    }
                    self.delegate?.fbLoginAccess(status: true)
                    self.fetchUserProfile(token: token)
                }
                
            }
        }
    }
    
    private func fetchUserProfile(token: String) {
        GraphRequest(graphPath: "/me", parameters: [kParamaterFields: kFieldsName]).start { connections, res, error in
            if let error = error {
                self.delegate?.fbLoginFail(error: error.localizedDescription)
            } else {
                guard let userData = res as? [String: Any] else {
                    self.delegate?.fbLoginFail(error: kUserDataNotFound)
                    return
                }
                self.delegate?.fbLoginSuccess(token: token, userData: userData)
            }
        }
    }
}
