//
//  Constants.swift
//  NewsClient
//
//  Created by ChihHao on 2020/03/01.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit


enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}


enum CellSize {
	static let imageWidth = ScreenSize.width/3.3
	static let imageHeight = ScreenSize.width/4.2
	static let imageCornerRadius: CGFloat = 12
	static let spacingImage2Content: CGFloat = 12
	static let separatorPaddingfromBootm: CGFloat = -8
	static let separatorLineWidth: CGFloat = 1
	static let cellBorderWidth: CGFloat = 2
	static let titleNumberOfLines: Int = 3
	static let sourceNumberOfLines: Int = 1
	static let cellHeight: CGFloat = 100
	static let minimumSpacingSection: CGFloat = 16
}


enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale

    static let isiPhoneSE = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
