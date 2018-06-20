//
//  MBProgressHUD+Rx.swift
//  RxSwiftCodableSample
//
//  Created by cano on 2018/06/20.
//  Copyright © 2018年 sample. All rights reserved.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa

extension Reactive where Base: MBProgressHUD {
    static func isAnimating(view: UIView) -> AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()  // なくてもよい？
            switch event {
            case .next(let value):
                if value {
                    MBProgressHUD.showAdded(to: view, animated: true)
                } else {
                    MBProgressHUD.hide(for: view, animated: true)
                }
            default:
                break
            }
        }
    }
}
