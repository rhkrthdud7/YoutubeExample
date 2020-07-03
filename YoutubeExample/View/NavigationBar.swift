//
//  NavigationBar.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/03.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class NavigationBar: UIView {
    init(subviews: [UIView] = []) {
        super.init(frame: .zero)
        
        setupViews(subviews: subviews)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let imageViewLogo = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "image_logo")
        $0.contentMode = .scaleAspectFit
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    func setupViews(subviews: [UIView]) {
        addSubview(imageViewLogo)
        imageViewLogo.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        subviews.forEach { view in
            stackView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.width.equalTo(view.snp.height)
            }
        }
    }
}
