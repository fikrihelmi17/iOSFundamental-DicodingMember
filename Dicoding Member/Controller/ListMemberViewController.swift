//
//  ViewController.swift
//  Dicoding Member
//
//  Created by Fikri on 20/07/20.
//  Copyright © 2020 Fikri Helmi. All rights reserved.
//

import UIKit

class ListMemberViewController: UIViewController {

    @IBOutlet weak var memberTableView: UITableView!
    
    private var members: [MemberModel] = []
    private var memberId: Int = 0
    private lazy var memberProvider: MemberProvider = { return MemberProvider()} ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMembers()
    }
    
    private func loadMembers(){
        self.memberProvider.getAllMember{ (result) in
            DispatchQueue.main.async {
                self.members = result
                self.memberTableView.reloadData()
            }
        }
    }
    
    private func setupView() {
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }

}

extension ListMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as? MemberTableViewCell {
            let member = members[indexPath.row]
            cell.fullNameMember.text = member.name
            cell.professionMember.text = member.profession
            
            if let image = member.image {
                cell.imageMember.image = UIImage(data: image)
                cell.imageMember.layer.cornerRadius = cell.imageMember.frame.height/2
                cell.imageMember.clipsToBounds = true
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ListMemberViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = members[indexPath.row].id {
            memberId = Int(id)
        }
        self.performSegue(withIdentifier: "moveToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "moveToDetail") {
            if let vc = segue.destination as? DetailMemberViewController {
                vc.memberId = self.memberId
            }
        }
    }
}

