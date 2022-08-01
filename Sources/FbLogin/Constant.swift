//MARK: some constant strings
let kEmailPermission = "email"
let kProfilePermission = "public_profile"
let kParamaterFields = "fields"
let kFieldsName = "id, name, email"


//MARK: some constant errors
public enum FbAuthError: String {
    case FacebookDeclinedPermissions
    case TokenNotFound
    case UserDataNotFound
    case FacebookLoginCancelled
    case unknown
}
