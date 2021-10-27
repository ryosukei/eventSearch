//
//  SearchViewController.swift
//  EventSearch
//
//  Created by 青野　凌介 on 2021/10/26.
//

import UIKit
import Firebase

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var eventNameTextView: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var eventPlaceTextView: UITextField!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var selectImage: UIImageView!
    @IBAction func handleImageSelectBtn(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil{
            let image = info[.originalImage] as! UIImage
            selectImage.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func handlePostBtn(_ sender: Any) {
        print("DEBUG: handlePostBtnのスタート")
        if let image = selectImage.image, let eventName = eventNameTextView.text, let place = eventPlaceTextView.text, let fromDate = startDatePicker, let toDate =  endDate {
            print("DEBUG: handlePostBtnのPostのスタート")
            let imageData = image.jpegData(compressionQuality: 0.75)
            // 画像とイベントの保存先
            let eventRef = Firestore.firestore().collection("events").document()
            let imageName = eventRef.documentID + ".jpg"
            let imageref = Storage.storage().reference().child("images").child(imageName)
            print("DEBUG: SVProgressHUDのスタート")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            imageref.putData(imageData!, metadata: metadata) { (metadata, error) in
                if error != nil {
                    // 画像のアップロード失敗
                    print(error!)
                    // 投稿処理をキャンセルし、先頭画面に戻る
                    UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                    return
                }
                // FireStoreに投稿データを保存する
                let eventDoc = [
                    "name":eventName,
                    "place":place,
                    "image":imageName,
                    "fromDate":fromDate.date,
                    "toDate":toDate.date
                ] as [String : Any]
                eventRef.setData(eventDoc)
                // 投稿処理が完了したので先頭画面に戻る
               UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                print("DEBUG: UIApplicationあたり")
            }
        }
       
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
