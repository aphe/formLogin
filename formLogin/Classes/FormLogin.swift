//
//  FormLogin.swift
//  Pods
//
//  Created by Afriyandi Setiawan on 5/27/17.
//
//

import UIKit

open class ResponsiveTextField: UITextField {
    
    @IBOutlet public weak var nextResponderField: UIResponder?
    @IBOutlet public weak var prevResponderField: UITextField?
    
    //load dari storyboard
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUp()
    }
    
    //load dari code
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func setUp() {
        addTarget(self, action: #selector(validate(textField:)), for: .editingDidEndOnExit)
    }
    
    func validate(textField: UITextField) {
        
        if prevResponderField != nil {
            if (prevResponderField?.text?.isEmpty)!{
                prevResponderField?.becomeFirstResponder()
                return
            }
        }
        
        if (textField.text?.isEmpty)! {
            let _alert:UIAlertController = UIAlertController(title: "FAILED".localize, message: "CANNOT_EMPTY".localize, preferredStyle: .alert)
            _alert.addAction(UIAlertAction(title: "DONE".localize, style: .cancel,
                                           handler: { (action) -> Void in
            }))
            _alert.show()
            textField.becomeFirstResponder()
            return
        }
        
        //tambahkan jenis textfield lain bedasarkan jenis keyboarnya pada case-case berikutnya
        switch textField.keyboardType {
        case .emailAddress:
            if !valid(email: textField.text!) {
                let _alert:UIAlertController = UIAlertController(title: "FAILED".localize, message: "INVALID_EMAIL_FORMAT".localize, preferredStyle: .alert)
                _alert.addAction(UIAlertAction(title: "DONE".localize, style: .cancel,
                                               handler: { (action) -> Void in
                }))
                _alert.show()
                textField.becomeFirstResponder()
                return
            }
        default:
            break
        }
        
        //cek apakah responder berikutnya button atau bukan
        switch nextResponderField {
        case let button as UIButton:
            if button.isEnabled {
                button.sendActions(for: .touchUpInside)
            } else {
                resignFirstResponder()
            }
        case .some(let responder):
            responder.becomeFirstResponder()
        default:
            resignFirstResponder()
        }
    }
    
    //fungsi-fungsi validasi
    func valid(email: String) ->Bool{
        let _emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let _emailTest = NSPredicate(format:"SELF MATCHES %@", _emailRegEx)
        
        return _emailTest.evaluate(with: email)
    }
    
}

extension UIAlertController {
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let presented = controller.presentedViewController {
            presented.present(self, animated: animated, completion: completion)
            return
        }
        switch controller {
        case let navVC as UINavigationController:
            presentFromController(controller: navVC.visibleViewController!, animated: animated, completion: completion)
            break
        case let tabVC as UITabBarController:
            presentFromController(controller: tabVC.selectedViewController!, animated: animated, completion: completion)
        default:
            controller.present(self, animated: animated, completion: completion)
        }
    }
}

extension String {
    var localize:String {
        guard let mainBundle = Bundle(identifier: Bundle.main.bundleIdentifier!) else {
            return self
        }
        return NSLocalizedString(self, tableName: nil, bundle: mainBundle, value: "", comment: "")
    }
}
