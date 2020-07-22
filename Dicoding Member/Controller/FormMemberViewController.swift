//
//  FormMemberViewController.swift
//  Dicoding Member
//
//  Created by Fikri on 20/07/20.
//  Copyright © 2020 Fikri Helmi. All rights reserved.
//

import UIKit

class FormMemberViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleForm: UILabel!
    @IBOutlet weak var imageMember: UIImageView!
    @IBOutlet weak var nameMember: UITextField!
    @IBOutlet weak var emailMember: UITextField!
    @IBOutlet weak var professionMember: UITextField!
    @IBOutlet weak var aboutMember: UITextField!
    
    private let imagePicker = UIImagePickerController()
    private lazy var memberProvider: MemberProvider = {return MemberProvider()}(
    )
    var memberId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupForm()
    }
    
    @IBAction func getImage(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveMember(_ sender: Any) {
        saveMember()
    }
    
    private func loadMembers(){
        memberProvider.getMember(memberId) {(member) in
            DispatchQueue.main.async {
                self.nameMember.text = member.name
                self.professionMember.text = member.profession
                self.emailMember.text = member.email
                self.aboutMember.text = member.about
                
                if let image = member.image {
                    self.imageMember.image = UIImage(data: image)
                    self.imageMember.layer.cornerRadius = self.imageMember.frame.height/2
                    self.imageMember.clipsToBounds = true
                }
            }
        }
    }
    
    private func setupView(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        imageMember.layer.cornerRadius = imageMember.frame.height/2
        imageMember.clipsToBounds = true
    }
    
    private func setupForm(){
        if memberId > 0 {
            titleForm.text = "Update Member"
            createButton.titleLabel?.text = "Update"
            loadMembers()
        } else {
            titleForm.text = "Create New Member"
            createButton.titleLabel?.text = "Create"
            createButton.isEnabled = false
        }
    }
    
    private func saveMember(){
        guard let name = nameMember.text, name != "" else {
            alert("Field name is empty")
            return
        }
        
        guard let email = emailMember.text, name != "" else {
            alert("Field email is empty")
            return
        }
        
        guard let profession = professionMember.text, name != "" else {
            alert("Field email is empty")
            return
        }
        
        guard let about = aboutMember.text, name != "" else {
            alert("Field email is empty")
            return
        }
        
        if let image = imageMember.image, let data = image.pngData() as NSData? {
            if memberId > 0 {
                memberProvider.updateMember(memberId, name, email, profession, about, data as Data) {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Successful", message: "Member updated.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) {(action) in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                memberProvider.createMember(name, email, profession, about, data as Data) {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Successful", message: "New member created.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) {(action) in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func alert(_ message: String){
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController,animated: true, completion: nil)
    }
}

extension FormMemberViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let result = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.imageMember.contentMode = .scaleToFill
            self.imageMember.image = result
            createButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Failed", message: "Image can't be loaded.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
