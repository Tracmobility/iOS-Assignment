//
//  SignUpViewController.swift
//  TracMobility
//
//  Created by Shalini on 20/02/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var countryCode: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBAction func firstNameButtonTapped(_ sender: Any) {
        _ = isValidName(firstNameTextField) //validate the first name
        _ = enableSubmit() //check for enable/disable submit
    }
    
    @IBAction func lastNameButtonTapped(_ sender: Any) {
        _ = isValidName(lastNameTextField) //validate the last name
        _ = enableSubmit() //check for enable/disable submit
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        _ = isValidEmail() //validate the email Id
        _ = enableSubmit() //check for enable/disable submit
    }
    
    @IBAction func mobileNumberButtonTapped(_ sender: Any) {
        _ = isValidPhoneNumber() //validate the phone number
        _ = enableSubmit() //check for enable/disable submit
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        //check for enable/disable submit
        if enableSubmit() {
            self.signupButtonTapped(.SignUp)
        }
    }
    
    @IBAction func appleButtonTapped(_ sender: Any) {
        self.signupButtonTapped(.Apple)
    }
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        self.signupButtonTapped(.Google)
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        self.signupButtonTapped(.FaceBook)
    }
    
    var returnButton = UIButton()
    var defaultCountryCode = "🇬🇧+44"
    lazy var countryCodeArray = [String]()
    lazy var picker = CustomUIPicker.getFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpButton.isEnabled = false
        
        //tap gesture for view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
        
        //tap gesture for textField
        let textFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTextField))
        countryCode.addGestureRecognizer(textFieldTapGesture)
        
        //custom return button
        returnButton.setTitle("Return", for: UIControl.State())
        returnButton.setTitleColor(UIColor.black, for: UIControl.State())
        returnButton.frame = CGRect(x: 0, y: 163, width: 106, height: 53)
        returnButton.addTarget(self, action: #selector(returnButtonTapped), for: UIControl.Event.touchUpInside)
        
        //get current country code
        getCountryBasedTimeZone() {
            (countryName, countryCode, countryFlag) in
            
            self.defaultCountryCode = "\(countryFlag ?? "🇬🇧")\(countryCode ?? "+44")"
            self.countryCode.text = self.defaultCountryCode
        }
    }
    
    override func  viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        
        _ = enableSubmit() //check for enable/disable submit
        view.endEditing(true) //dismiss the keyboard
    }
    
    @objc func handleTextField(tapGesture: UITapGestureRecognizer) {
        
        if countryCodeArray.isEmpty {
            
            getCountryBasedTimeZone() {
                (_, _, _) in
                
                let countryCode_Array = self.countryCodeArray.map({$0.components(separatedBy: "_").joined()})
                
                let selectedRow = (self.countryCodeArray.map({$0.components(separatedBy: "_").first})).firstIndex(of: "\(self.countryCode.text ?? self.defaultCountryCode)") ?? 0
                self.customPicker(countryCode_Array, selectedRow)
                
            }
        } else {
            
            let countryCode_Array = self.countryCodeArray.map({$0.components(separatedBy: "_").joined()})
            
            let selectedRow = (self.countryCodeArray.map({$0.components(separatedBy: "_").first})).firstIndex(of: "\(self.countryCode.text ?? self.defaultCountryCode)") ?? 0
            self.customPicker(countryCode_Array, selectedRow)
        }
    }
    
    //return button tapped for mobile number keyboard
    @objc func returnButtonTapped() {
        phoneNumberTextField.resignFirstResponder()
        view.endEditing(true)
    }
    
    @objc func keyboardWillHide(_ note : Notification) -> Void{
        DispatchQueue.main.async { () -> Void in
            self.returnButton.isHidden = true
        }
    }
    
    //name validation
    func isValidName(_ nameTextField: UITextField) -> Bool {
        if nameTextField.text != nil {
            
            let nameRegEx = "^[a-zA-Z]*['.-]?[a-zA-Z]+['.]?$"
            let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
            
            if nameTest.evaluate(with: nameTextField.text?.removingBlankSpaces()) {
                return updateValidView(nameTextField)
            } else {
                return updateErrorView(nameTextField)
            }
        }
        return false
    }
    
    //email validation
    func isValidEmail() -> Bool {
        
        if emailAddressTextField.text != nil {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            
            if emailTest.evaluate(with: emailAddressTextField.text!) {
                return updateValidView(emailAddressTextField)
            } else {
                return updateErrorView(emailAddressTextField)
            }
        }
        return false
    }
    
    //phone number validation
    func isValidPhoneNumber() -> Bool{
        
        if phoneNumberTextField.text != nil {
            if phoneNumberTextField.text?.count ?? 0 < 7 {
                return updateErrorView(phoneNumberTextField)
            } else {
                return updateValidView(phoneNumberTextField)
            }
        }
        return false
    }
    
    //update the view with valid prompt
    func updateValidView(_ textField: UITextField) -> Bool {
        
        textField.setBorderColor(0.0, UIColor.lightGray, 5.0)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        return true
    }
    
    //update the view with error prompt
    func updateErrorView(_ textField: UITextField) -> Bool {
        
        textField.setBorderColor(0.5, UIColor.red, 5.0)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        return false
    }
    
    //disable the keyboard for country code
    func disableKeyboard(_ textField: UITextField) -> Bool {
        if textField == countryCode {
            countryCode.resignFirstResponder()
            return false
        }
        return true
    }
    
    //enable/disable submit button
    func enableSubmit() -> Bool {
        
        if (!(firstNameTextField.text?.removingBlankSpaces().isEmpty)!) && (!(lastNameTextField.text?.removingBlankSpaces().isEmpty)!) && (!(emailAddressTextField.text?.removingBlankSpaces().isEmpty)!) && (!(phoneNumberTextField.text?.removingBlankSpaces().isEmpty)!) {
            
            if isValidName(firstNameTextField) && isValidName(lastNameTextField) && isValidEmail() && isValidPhoneNumber() {
                DispatchQueue.main.async { self.signUpButton.isEnabled = true }
                return true
            }
            return false
        } else {
            DispatchQueue.main.async { self.signUpButton.isEnabled = false }
            return false
        }
    }
}

//MARK: `Sign Up / Sign In with Facebook, Google, Apple `
extension SignUpViewController {
    
    //sign up
    func signupButtonTapped(_ type: SignInType) {
        
        if Reachability.isConnectedToNetwork() {
                        
            if type == .SignUp {
                
                /// `Normal sign up`
                successSignUp()
                
            } else {
                
                //present and start the activity indicator
                DispatchQueue.main.async {
                    CustomActivityIndicator.sharedInstance.presentActivityIndicator(self)
                    CustomActivityIndicator.sharedInstance.startAnimating(self)
                    self.signUpButton.isEnabled = false }
                
                /// `Google, Facebook, Apple`
                Authentication().signUp { success in
                    
                    DispatchQueue.main.async { self.signUpButton.isEnabled = true
                        CustomActivityIndicator.sharedInstance.stopAnimating(self) }
                    
                    if success {
                        
                        self.successSignUp()
                    } else {
                        CustomAlertView.sharedInstance.okAlert(self, "Error", "Sorry, something went wrong. Please try after some time!", "OK", .default, alertStyle: .alert)
                    }
                }
            }
        } else {
            
            //no internet pop up
            DispatchQueue.main.async { self.signUpButton.isEnabled = true
                CustomActivityIndicator.sharedInstance.stopAnimating(self) }
            CustomAlertView.sharedInstance.okAlert(self, "No Internet Connection", "Make sure your device is connected to the internet.", "OK", .default, alertStyle: .alert)
        }
    }
    
    func successSignUp() {
        
        let alert = UIAlertController(title: "Signed up successfully", message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0){
            alert.dismiss(animated: true, completion: nil)
            
            /// `Save the user Information`
            let userDict:Dictionary<String, String> = ["FirstName": self.firstNameTextField.text ?? "Trac Mobility", "LastName": self.lastNameTextField.text ?? "", "Email": self.emailAddressTextField.text ?? "tracmobility@gmail.com", "CountryCode": self.countryCode.text ?? self.defaultCountryCode, "PhoneNumber": self.phoneNumberTextField.text ?? "7743405150"]
            UserDefaults.standard.set(userDict, forKey: "userInfo")
            
            let storyboard = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "DashboardViewControllerID") as! DashboardViewController
            storyboard.modalPresentationStyle = .fullScreen
            
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
    }
}

//MARK: `UITextField Delegates`
extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        //character limit
        switch textField {
        case firstNameTextField, lastNameTextField: return newLength <= 150
        case emailAddressTextField: return newLength <= 120
        case phoneNumberTextField: return newLength < 15
            
        default:
            return true
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //moving the cursor one after the other textfield
        switch textField {
        case firstNameTextField: lastNameTextField.becomeFirstResponder()
        case lastNameTextField: emailAddressTextField.becomeFirstResponder()
        case emailAddressTextField: phoneNumberTextField.becomeFirstResponder()
        case phoneNumberTextField: textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        //check for enable/disable submit
        _ = enableSubmit()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == phoneNumberTextField {
            DispatchQueue.main.async { () -> Void in
                self.returnButton.isHidden = false
                let keyBoardWindow = UIApplication.shared.windows.last
                self.returnButton.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-53, width: 106, height: 53)
                keyBoardWindow?.addSubview(self.returnButton)
                keyBoardWindow?.bringSubviewToFront(self.returnButton)
            }
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else {
            DispatchQueue.main.async {  self.returnButton.isHidden =  true }
        }
        return disableKeyboard(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _ = disableKeyboard(textField)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTextField || textField == lastNameTextField {
            _ = isValidName(textField)
            
        } else if textField == emailAddressTextField {
            _ = isValidEmail()
            
        } else if textField == phoneNumberTextField {
            _ = isValidPhoneNumber()
        }
        return disableKeyboard(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = disableKeyboard(textField)
    }
}

//MARK: `UIPicker Delegates`
extension SignUpViewController: CustomUIPickerDelegate {
    
    //get country name and flag based on time zone
    func getCountryBasedTimeZone(completion: @escaping (_ countryName: String?,_ countryCode: String?,_ countryFlag: String?) -> ()) {
        
        let url = Bundle.main.url(forResource: "Countries", withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        do {
            let object = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                guard let countryJsonObject = dictionary["countryPick"] as? [[String: AnyObject]] else { return }
                
                if countryCodeArray.isEmpty {
                    for countries in countryJsonObject {
                        let flagCharacter = countries["code"] as? String ?? "GB"
                        let name  = countries["name"] as? String ?? "United Kingdom"
                        let code = countries["dial_code"] as? String ?? "+44"
                        
                        let emoji = getEmojiFromCharacter(countryCode: flagCharacter);
                        let flagString = String(emoji);
                        
                        self.countryCodeArray.append("\(flagString)\(code)_ \(name)")
                        self.countryCode.text = "\(flagString)\(code)"
                    }
                }
                
                //fetch default country code
                let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
                let country = countryJsonObject.filter({$0["code"] as? String == countryCode}).first
                
                let emoji = getEmojiFromCharacter(countryCode: country?["code"] as? String ?? "GB");
                let flagString = String(emoji)
                completion(country?["name"] as? String ?? "United Kingdom", country?["dial_code"] as? String ?? "+44", flagString)
                
            }
        } catch {
            // Handle Error
        }
    }
    
    //get country flag
    public func getEmojiFromCharacter(countryCode: String) -> Character {
        let base = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        
        var string = ""
        countryCode.uppercased().unicodeScalars.forEach {
            if let scala = UnicodeScalar(base + $0.value) {
                string.append(String(describing: scala))
            }
        }
        return Character(string)
    }
    
    //ui picker
    func customPicker(_ pickerArray: [String],_ selectedRow: Int) {
        picker.delegate = self
        
        picker.pickerRow = nil
        picker.pickerValue = nil
        picker.config.animationDuration = 0.25
        picker.config.pickerArray = pickerArray
        picker.config.selectedRow = selectedRow
        print(selectedRow)
        
        picker.show(inVC: self)
    }
    
    func customPicker(_ amPicker: CustomUIPicker, didSelect row: Int, value: String) {
        
        let country_Code = value
        let code = country_Code.components(separatedBy: " ").first ?? ""
        self.countryCode.text = code
    }
    
    func customPickerDidCancelSelection(_ amPicker: CustomUIPicker) {
        print("cancel")
    }
}
