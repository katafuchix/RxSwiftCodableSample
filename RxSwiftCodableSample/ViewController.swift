//
//  ViewController.swift
//  RxSwiftCodableSample
//
//  Created by cano on 2018/06/20.
//  Copyright © 2018年 sample. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import MBProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var refreshButton: UIBarButtonItem!

    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = ""
        }
    }
    @IBOutlet weak var genderLabel: UILabel! {
        didSet{
            genderLabel.text = ""
        }
    }
    @IBOutlet weak var locationLabel: UILabel! {
        didSet{
            locationLabel.text = ""
        }
    }
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.text = ""
        }
    }

    let viewModel = RandomUserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.bind()
    }

    // MARK: - Binding
    func bind() {
        // 右上ボタン
        self.refreshButton.rx.tap.asDriver().drive(onNext: { [weak self] _
            in self?.viewModel.fetch().subscribe(onError: { error in
                    print(error.localizedDescription)
                } ).disposed(by: (self?.rx.disposeBag)!)
        } ).disposed(by: rx.disposeBag)

        // APIからのランダムデータ取得結果
        self.viewModel.item.asDriver().drive(onNext: { [weak self] in
            if let resultList = $0 {
                for person in resultList.results {
                    self?.nameLabel.text        = person.name.title
                    self?.genderLabel.text      = person.gender
                    self?.locationLabel.text    = person.location.city
                    self?.emailLabel.text       = person.email
                }
            }
        }).disposed(by: rx.disposeBag)

        // ローディング
        self.viewModel.isLoading.asDriver()
            .drive(MBProgressHUD.rx.isAnimating(view: self.view))
            .disposed(by: rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

