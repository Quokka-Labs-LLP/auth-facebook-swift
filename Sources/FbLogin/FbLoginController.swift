import UIKit
import FacebookLogin
import AuthenticationServices
 
public protocol FbLoginStatusProtocol: AnyObject {
    func fbLoginSuccess(token: String, userData : [String: Any])
    func fbLoginFail(error: FbAuthError)
    func fbLoginCancel(error: FbAuthError)
    func fbLoginAccess(status: Bool)
}

public class FbLoginController: UIViewController {
    private weak var delegate: FbLoginStatusProtocol?
    
    public init(delegate: FbLoginStatusProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    public func beginFbLogin() {
        LoginManager.init().logIn(permissions: [kEmailPermission, kProfilePermission], from: self) { result, error in
            if let error =  error {
                self.delegate?.fbLoginFail(error: FbAuthError(rawValue: error.localizedDescription) ?? .unknown)
            } else {
                guard let result = result else {
                    self.delegate?.fbLoginFail(error: .facebookDeclinedPermissions)
                    return
                }
                if result.isCancelled {
                    self.delegate?.fbLoginCancel(error: .facebookLoginCancelled)
                } else {
                    guard let token = result.token?.tokenString else {
                        self.delegate?.fbLoginFail(error: .tokenNotFound)
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
                self.delegate?.fbLoginFail(error: FbAuthError(rawValue: error.localizedDescription) ?? .unknown)
            } else {
                guard let userData = res as? [String: Any] else {
                    self.delegate?.fbLoginFail(error: .userDataNotFound)
                    return
                }
                self.delegate?.fbLoginSuccess(token: token, userData: userData)
            }
        }
    }
}
