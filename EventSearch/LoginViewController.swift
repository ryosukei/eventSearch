//
//  LoginViewController.swift
//  EventSearch
//
//  Created by 青野　凌介 on 2021/10/26.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func handleLoginBtn(_ sender: Any) {
        if let address = emailText.text, let password = passwordText.text {

            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                return
            }

            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")

                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func handleRegisterBtn(_ sender: Any) {
        if let address = emailText.text, let password = passwordText.text, let name = nameTextField.text {
            if address.isEmpty || password.isEmpty || name.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }
            Auth.auth().createUser(withEmail: address, password: password){ authResult, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                let userId:String! = Auth.auth().currentUser?.uid
                // Firebaseに登録
                let userRef = Firestore.firestore().collection("users").document(userId)
                let nameDoc = [
                    "name": name
                ]
                userRef.setData(nameDoc)
                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
