//
//  UserState.swift
//  Thinh
//
//  Created by Linh Le on 3/18/17.
//  Copyright © 2017 coderschool. All rights reserved.
//

import UIKit
import Firebase
import Gloss
import MapKit

public typealias UserId = String
class User: NSObject, Glossy {

    var avatar: String?
    var gender: Sex?
    var name: String?
    var phone: String?
    var prefer: Sex?
    var id: UserId?
    var status: Bool?
    var caption: String?
    var cover: URL?
    var lat: CLLocationDegrees?
    var lon: CLLocationDegrees?
    
    static var currentUser: User?
    
    enum Sex: String {
        case male = "male"
        case female = "female"
        case unknown = "unknown"
    }
    
    required init?(json: JSON) {
        self.avatar = FirebaseKey.avatar <~~ json
        self.gender = FirebaseKey.gender <~~ json
        self.name = FirebaseKey.name <~~ json
        self.phone = FirebaseKey.phone <~~ json
        self.prefer = FirebaseKey.prefer <~~ json
        self.id = FirebaseKey.id <~~ json
        self.status = FirebaseKey.status <~~ json
        self.caption = FirebaseKey.caption <~~ json
        self.cover = FirebaseKey.cover <~~ json
        self.lat = FirebaseKey.lat <~~ json
        self.lon = FirebaseKey.lon <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            FirebaseKey.avatar ~~> avatar,
            FirebaseKey.gender ~~> gender,
            FirebaseKey.name ~~> name,
            FirebaseKey.phone ~~> phone,
            FirebaseKey.prefer ~~> prefer,
            FirebaseKey.id ~~> id,
            FirebaseKey.status ~~> status,
            FirebaseKey.caption ~~> caption,
            FirebaseKey.cover ~~> cover,
            FirebaseKey.lat ~~> lat,
            FirebaseKey.lon ~~> lon])
    }
    
    override init() {
        
    }
    
    init(user: FIRUser) {
        self.avatar = user.photoURL?.absoluteString
        self.name = user.displayName
        self.id = user.uid
        self.gender = Sex.unknown
        self.prefer = Sex.unknown
        self.caption = ""
        self.status = true
        self.phone = "unknow"
    }
    
    func withAvatar(_ avatar: String) -> User {
        self.avatar = avatar
        return self
    }
    
    func withGender(_ gender: Sex) -> User{
        self.gender = gender
        return self
    }
    
    func withName(_ name: String) -> User {
        self.name = name
        return self
    }
    
    
    func withPhone(_ phone: String) -> User {
        self.phone = phone
        return self
    }
    
    func withPrefer(_ prefer: Sex) -> User {
        self.prefer = prefer
        return self
    }
    
//    func withId(_ id: UserId) -> User {
//        self.id = id
//        return self
//    }
    
    func withStatus(_ status: Bool) -> User {
        self.status = status
        return self
    }
    
    func withCaption(_ caption: String) -> User {
        self.caption = caption
        return self
    }
    
    func location() -> CLLocation {
        return CLLocation(latitude: lat ?? 0, longitude: lon ?? 0)
    }
    
    
    static func mock() -> [User] {
        var users = [User]()
        for i in 0..<30 {
            let user = User(json:
                [FirebaseKey.name: names[i],
                 FirebaseKey.gender: sexes[i].rawValue,
                 FirebaseKey.avatar: links[i],
                 FirebaseKey.phone: phones[i],
                 FirebaseKey.id: ids[i],
                 FirebaseKey.prefer: prefers[i].rawValue,
                 FirebaseKey.caption: descs[i],
                 FirebaseKey.status: false,
                 FirebaseKey.lat: lats[i],
                 FirebaseKey.cover: covers[i],
                 FirebaseKey.lon: lons[i]
                ])
            users.append(user!)
        }
        return users
    }
    
    static let names = [name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13, name14, name15, name16, name17, name18, name19, name20, name21, name22, name23, name24, name25, name26, name27, name28, name29, name30]
    static let links = [avatar1, avatar2, avatar3, avatar4, avatar5, avatar6, avatar7, avatar8, avatar9, avatar10, avatar11, avatar12, avatar13, avatar14, avatar15, avatar16, avatar17, avatar18, avatar19, avatar20, avatar21, avatar22, avatar23, avatar24, avatar25, avatar26, avatar27, avatar28, avatar29, avatar30]
    static let ids = [user1, user2, user3, user4, user5, user6, user7, user8, user9, user10, user11, user12, user13, user14, user15, user16, user17, user18, user9
        , user20, user21, user22, user23, user24, user25, user26, user27, user28, user29, user30]
    static let descs = [desc1, desc2, desc3, desc4, desc5, desc6, desc7, desc8, desc9, desc10, desc11, desc12, desc13, desc14, desc15, desc16, desc17, desc18, desc19, desc20, desc21, desc22, desc23, desc24, desc25, desc26, desc27, desc28, desc29, desc30]
    static let sexes = [sex1, sex2, sex3, sex4, sex5, sex6, sex7, sex8, sex9, sex10, sex11, sex12, sex13, sex14, sex15, sex16, sex17, sex18, sex19, sex20, sex21, sex22, sex23, sex24, sex25, sex26, sex27, sex28, sex29, sex30]
    static let prefers = [prefer1, prefer2, prefer3, prefer4, prefer5, prefer6,prefer7, prefer8, prefer9, prefer10, prefer11, prefer12, prefer13, prefer14, prefer15, prefer16, prefer17, prefer18, prefer19, prefer20, prefer21, prefer22, prefer23, prefer24, prefer25, prefer26, prefer27, prefer28, prefer29, prefer30]
    static let lats = [lat1, lat2, lat3, lat4, lat5, lat6, lat7, lat8, lat9, lat10, lat11, lat12, lat13, lat14, lat15, lat16, lat17, lat18, lat19, lat20, lat21, lat22, lat23, lat24, lat25, lat26, lat27, lat28, lat29, lat30]
    static let lons = [lon1, lon2, lon3, lon4, lon5, lon6, lon7, lon8, lon9, lon10, lon11, lon12, lon13, lon14, lon15, lon16, lon17, lon18, lon19, lon20, lon21, lon22, lon23, lon24, lon25, lon26, lon27, lon28, lon29, lon30]
    static let phones = [phone1, phone2, phone3, phone4, phone5, phone6, phone7, phone8, phone9, phone10,phone11,phone12,phone13,phone14,phone15,phone16,phone17,phone18,phone19,phone20,phone21,phone22,phone23,phone24,phone25,phone26,phone27,phone28,phone29,phone30]
    static let covers = [cover1,cover2,cover3,cover4,cover5,cover6,cover7,cover8,cover9,cover10,cover11,cover12,cover13,cover14,cover15,cover16,cover17,cover18,cover19,cover20,cover21,cover22,cover23,cover24,cover25,cover26,cover27,cover28,cover29,cover30]
    
    static func createBot() -> User {
        return User(json: [
            FirebaseKey.id: botId,
            FirebaseKey.name: botName,
            FirebaseKey.gender: botSex,
            FirebaseKey.avatar: botAvatar,
            FirebaseKey.prefer: botPrefer,
            FirebaseKey.caption: botDes])!
    }
    
    static let botName = "ThaThinh"
    static let botAvatar = "https://e27.co/img/startups/11852/logo-1457327647.png"
    static let botDes = "Developing Developers"
    static let botSex = Sex.male
    static let botPrefer = Sex.female
    static let botId = "fuckTheBugs"
    
    // mock user data
    static let user20 = "S5cirBWXUiOGnareVEEWbjaIJN02"
    static let name20 = "Harley Trung"
    static let avatar20 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t31.0-8/11703293_10100901374320434_2543083367635502905_o.jpg?oh=e7f649ba4b7bb4e8b3b009b2df670061&oe=5998B046"
    static let desc20 = "i work on tech training & bilingual education. we're hiring at CoderSchool & Blue Sky Academy"
    static let phone20 = "0903342991"
    static let sex20 = Sex.male
    static let prefer20 = Sex.female
    static let lat20 = 10.778184
    static let lon20 = 106.700994
    static let cover20: String! = nil
    
    static let user1 = "cdP7J0LNP2gUG3BeEq29N8JHDt72"
    static let name1 = "Đặng Việt"
    static let avatar1 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t31.0-8/1531951_472627046182268_1638135017_o.jpg?oh=ddb563e39d25f453b577a36a38ca514e&oe=59692A86"
    static let desc1 = "Sống nội tâm, yêu màu tía"
    static let sex1 = Sex.male
    static let phone1 = "01225139439"
    static let lat1 = 10.7579235
    static let lon1 = 106.6973611
    static let prefer1 = Sex.female
    static let cover1 = "http://ajc.hcma.vn/Uploaded/mainghiem/2014_11_05/marxism.jpg?maxwidth=650"
    
    static let user6 = "wnlI40CQLLX7LVohp6tW8LqOmqD3"
    static let avatar6 = "http://anh.24h.com.vn/upload/1-2016/images/2016-01-22/1453435185-1453434580-3.jpg"
    static let name6 = "Bắc Đẩu"
    static let phone6 = "0903342991"
    static let desc6 = "Một khi cụ đã thương muốn làm người thường cụ cũng không cho"
    static let sex6 = Sex.female
    static let prefer6 = Sex.male
    static let lat6 = 10.7865659
    static let lon6 = 106.683883
    static let cover6: String! = nil
    
    static let user2 = "WR3OioP6R0UTPUoWItWyJX5g4p62"
    static let name2 = "Linh Lê"
    static let phone2 = "0984688743"
    static let avatar2 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t31.0-8/13063139_634160786731295_2174880575869215799_o.jpg?oh=7d102fc8d13573b96800f5fd7ff3139a&oe=596E46C5"
    static let desc2 = "Tâm hồn trong sáng"
    static let lat2 = 10.846800
    static let lon2 = 106.636649
    static let sex2 = Sex.male
    static let prefer2 = Sex.female
    static let cover2 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t31.0-8/10710458_395162890631087_5286764241473258217_o.jpg?oh=5dd4bc356329bf7f1832e2d7055254ad&oe=5955778D"
    
    
    static let user3 = "i6mDtuUTA7NVJxzmX3wClZH582s1"
    static let avatar3 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F3.jpg?alt=media&token=190b9e47-f245-4918-86ee-c92179c0d60b"
    static let name3 = "Xuân Mai"
    static let phone3 = "0903342991"
    static let desc3 = "Draco Dormiens Nunquam Titillandus"
    static let lat3 = 10.7730801
    static let lon3 = 106.6982786
    static let sex3 = Sex.female
    static let prefer3 = Sex.male
    static let cover3: String! = nil
    
    static let user4 = "cPO5kK767qMhMxrUDSjF2cd75IP2"
    static let name4 = "Sobin Hoàng Sơn"
    static let avatar4 = "http://znews-photo.d.za.zdn.vn/w660/Uploaded/mzdqv/2016_04_21/soobin1.jpg"
    static let phone4 = "0903342991"
    static let desc4 = "Từng chặng đường dài mà ta qua, đều để lại kỷ niệm quý giá; Để lại một điều rằng rằng càng đi xa ta càng thêm nhớ nhà"
    static let sex4 = Sex.male
    static let prefer4 = Sex.female
    static let lat4 = 10.7445835
    static let lon4 = 106.6856697
    static let cover4: String! = nil
    
    static let user24 = "H1NHDr1QjlgwHUJJ5DS2B9E7hqf1"
    static let avatar24 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F7.jpg?alt=media&token=452ab287-8dca-41b0-a3dd-a74fb3301d95"
    static let name24 = "Tử Yên"
    static let phone24 = "0903342991"
    static let desc24 = "What do you mean"
    static let sex24 = Sex.female
    static let prefer24 = Sex.male
    static let lat24 = 10.7527096
    static let lon24 = 106.6688169
    static let cover24: String! = nil
    
    
    static let user5 = "rsu1wVrOsDeBBlfriSkhMsW6sKm2"
    static let avatar5 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-9/15871854_1650346778598340_3128247238115573349_n.jpg?oh=a52b2910eab2941395a0f01eafd36ab1&oe=595CDE3B"
    static let name5 = "Sơn Tùng"
    static let phone5 = "0903342991"
    static let desc5 = "Xin hãy là em của ngày hôm qua"
    static let sex5 = Sex.male
    static let prefer5 = Sex.female
    static let lat5 = 10.7126581
    static let lon5 = 106.7360382
    static let cover5: String! = nil
    
    static let user7 = "yIoo1rv5FvaEusPooUF3HXtwt7G2"
    static let avatar7 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-9/15871458_1547913765237939_6046469785741529254_n.jpg?oh=400fe3c6073caf7b45abd6c6ffb9ed23&oe=594DDA54"
    static let name7 = "Trấn Thành"
    static let phone7 = "0903342991"
    static let desc7 = "Yêu là phải nói cũng như đói là phải ăn"
    static let sex7 = Sex.male
    static let prefer7 = Sex.female
    static let lat7 = 10.7527069
    static let lon7 = 106.6688169
    static let cover7: String! = nil
    
    static let user8 = "3JqA5vuaFhMbd8bS5Y82RSB9G092"
    static let name8 = "Donald Trump"
    static let phone8 = "0903342991"
    static let avatar8 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-9/16174753_10158517450380725_87513729581056003_n.jpg?oh=cd7c84cbc1929f9c8142284f3ced79da&oe=595C747A"
    static let desc8 = "Make America Great Again"
    static let sex8 = Sex.male
    static let prefer8 = Sex.female
    static let lat8 = 10.7831803
    static let lon8 = 106.6982434
    static let cover8: String! = nil
    

    static let user9 = "4MfSmNC6J6M2n2rHMW8Rl0DeCYx2"
    static let name9 = "Kim Jong Un"
    static let phone9 = "0903342991"
    static let avatar9 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-9/406461_205539312865422_1454086306_n.jpg?oh=465c4f6d2b8e5a8403e620a74d6a436c&oe=595030FE"
    static let desc9 = "Trade nukes for food"
    static let sex9 = Sex.male
    static let prefer9 = Sex.female
    static let lat9 = 39.027666
    static let lon9 = 125.773101
    static let cover9: String! = nil
    
    static let user10 = "KlQzdbgLraTAt85b3tqPc7njzFQ2"
    static let name10 = "Viên Viên"
    static let phone10 = "0903342991"
    static let avatar10 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F1.jpg?alt=media&token=5574f907-7260-4e3d-ae3e-e951dd4816a0"
    static let desc10 = "Giang Tô đệ nhất kỹ nữ"
    static let sex10 = Sex.female
    static let lat10 = 10.7527067
    static let lon10 = 106.6688146
    static let prefer10 = Sex.male
    static let cover10: String! = nil
    
    static let user11 = "ScnTerJ0ckcjODE87Lyc7ULJdrk2"
     static let avatar11 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F2.jpg?alt=media&token=09218ddf-2df7-45e4-a676-3544d4e8fe6c"
    static let name11 = "Hạ Nguyễn"
    static let desc11 = ""
    static let phone11 = "0903342991"
    static let sex11 = Sex.female
    static let prefer11 = Sex.male
    static let lat11 = 10.7851177
    static let lon11 = 106.6823341
    static let cover11: String! = nil
    
    static let user18 = "WhEZVoiMDpTA4QkdI8dHCZFyG752"
    static let name18 = "Đạt Trần"
    static let phone18 = "0938481680"
    static let avatar18 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-9/15622573_1085371901571808_5746077286281389946_n.jpg?oh=1e4ac7b38fb7b0cabba9b2e301ab9b23&oe=5999D42E"
    static let desc18 = "Im rich"
    static let sex18 = Sex.male
    static let prefer18 = Sex.female
    static let lat18 = 10.8465972
    static let lon18 = 106.668165
    static let cover18 = "http://d1vqbpto5tbbz0.cloudfront.net/blog/wp-content/uploads/2015/01/21180000/iOS-and-Android.jpg"
    
    static let user13 = "kAywm67rnKRrlSrTEuWe14ayVrv1"
    static let avatar13 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F4.jpg?alt=media&token=7f444e1c-b2f4-4ee7-8b13-55714d56879a"
    static let name13 = "Phi Yến"
    static let phone13 = "0903342991"
    static let desc13 = "Yến là yến ko thích nha"
    static let sex13 = Sex.female
    static let prefer13 = Sex.male
    static let lat13 = 10.7765282
    static let lon13 = 106.698802
    static let cover13: String! = nil
    
    static let user14 = "tpe0qfm577eZ3VgCaatP42cPk2n2"
    static let avatar14 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F5.jpg?alt=media&token=01cb085a-65ae-469d-b2f8-0ab2a82e3c38"
    static let name14 = "Kim Liên"
    static let phone14 = "0908952570"
    static let desc14 = "Bày mưu gian, bợm già dỗ khách; Ham tình dục, gái đĩ giết chồng"
    static let sex14 = Sex.female
    static let prefer14 = Sex.male
    static let lat14 = 10.7897149
    static let lon14 = 106.6876916
    static let cover14 = "https://previews.123rf.com/images/hamsterman/hamsterman1203/hamsterman120300008/12515902-Young-beautiful-sexy-lady-with-long-hairs-in-abstract-plastic-tube-ring-flash-fashion-portrait-Stock-Photo.jpg"
    
    static let user15 = "zJPO6qqMKVPTb7lENxrVBtn2D1F2"
    static let avatar15 = "https://firebasestorage.googleapis.com/v0/b/thinh-43483.appspot.com/o/mock%2F6.png?alt=media&token=2396158b-200f-4b7b-82a9-f208fa582147"
    static let name15 = "Lãng Tử Yến Thanh"
    static let desc15 = "Lãng tử phong lưu lãng tử sầu, Sống trong tiên cảnh vẫn lo âu"
    static let sex15 = Sex.male
    static let phone15 = "0903342991"
    static let prefer15 = Sex.female
    static let lat15 = 10.7640026
    static let lon15 = 106.6806042
    static let cover15: String! = nil
    
    
    static let user16 = "7ufjet2By0UHMVtf0MINZ4gC63H3"
    static let name16 = "Dave Võ"
    static let phone16 = "0903342991"
    static let avatar16 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-9/14322613_10153821054462091_7607588987828378428_n.jpg?oh=c19715460c5e8892558026fc40899843&oe=59589BA9"
    static let desc16 = "I will make it through"
    static let sex16 = Sex.male
    static let lat16 = 10.7706286
    static let lon16 = 106.6992986
    static let prefer16 = Sex.female
    static let cover16: String! = nil
    
    static let user17 = "PdZ7Xg53WaPFpDc8QLP5de25c3F3"
    static let name17 = "Soái Ca Mặt Trời"
    static let avatar17 = "http://eva-img.24hstatic.com/upload/2-2016/images/2016-04-28/cong-thuc-che-tao-soai-ca-van-nguoi-me-cua-bien-kich-hang-dau-han-quoc-91dotsc-1461779559-width500height375.jpg"
    static let phone17 = "0903342991"
    static let desc17 = "Đã là quân nhân thì xác định không có bạn gái vì vất vả quá"
    static let sex17 = Sex.male
    static let lat17 = 10.774329
    static let lon17 = 106.6935157
    static let prefer17 = Sex.female
    static let cover17: String! = nil
    
    static let user12 = "e6boIwD7rZfz8W9FDqlY41LXn993"
    static let name12 = "Bill Gates"
    static let phone12 = "0903342991"
    static let avatar12 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-9/10322603_10152660298856961_5840658467777063124_n.jpg?oh=7897e5f2b21bc8409c3adee73fb27c95&oe=596206B8"
    static let desc12 = "I will always choose a lazy person to do a difficult job, because he will find an easy way to do it"
    static let sex12 = Sex.male
    static let prefer12 = Sex.female
    static let lat12 = 10.7769038
    static let lon12 = 106.6961743
    static let cover12: String! = nil
    
    
    static let user19 = "jYfiiw29RSZoqohs2ApbYJpXoRv2"
    static let avatar19 = "http://dantri4.vcmedia.vn/WZKQ2cccccccccccckCc0AfnZ0zh4c/Image/2015/07/xb-c0629.jpg"
    static let phone19 = "0903342991"
    static let name19 = "Nam Tào"
    static let desc19 = "Trông giao diện khác hẳn như kiểu mới cài Win"
    static let sex19 = Sex.male
    static let prefer19 = Sex.female
    static let lat19 = 10.7865659
    static let lon19 = 106.683883
    static let cover19: String! = nil

    static let user21 = "CAnWZ9ADu6QGQ3IsVlKVntsTBiJ2"
    static let avatar21 = "http://media2.thethaovanhoa.vn/2017/01/17/12/18/Ngoc-Hoang-cover.jpg"
    static let name21 = "Ngọc Hoàng"
    static let desc21 = "Từ nay, Thiên Đình không có chuyện bổ nhiệm người nhà mà không bổ nhiệm người tài"
    static let phone21 = "0903342991"
    static let sex21 = Sex.male
    static let prefer21 = Sex.female
    static let lat21 = 10.7874586
    static let lon21 = 106.682691
    static let cover21 : String! = nil
    
    static let user22 = "z1cLfM8bR0hYTBHhz6TZr4t2LOC3"
    static let name22 = "Pikalong"
    static let avatar22 = "http://thuthuattienich.com/wp-content/uploads/2017/02/hinh-anh-pikalong-binh-luan-facebook-12.jpg"
    static let desc22 = "I dont care"
    static let sex22 = Sex.male
    static let phone22 = "0903342991"
    static let prefer22 = Sex.unknown
    static let lat22 = 10.770054
    static let lon22 = 106.6684026
    static let cover22: String! = nil
    
    static let user23 = "nanALxR9dcT5NZeWcGV8bq7atGH3"
    static let avatar23 = "https://scontent.fsgn5-2.fna.fbcdn.net/v/t1.0-9/16298923_404793143198445_127090722721106637_n.jpg?oh=f70746ee050af79c9287748cf7df20d9&oe=5959804B"
    static let name23 = "Erik Trần"
    static let phone23 = "0903342991"
    static let desc23 = "Sau tất cả, mình trở về với nhau"
    static let sex23 = Sex.male
    static let prefer23 = Sex.female
    static let lat23 = 10.8033034
    static let lon23 = 106.6486846
    static let cover23: String! = nil
    
    static let user25 = "qEXDOLL1ykPSpNE0quQhbTrqggA3"
    static let name25 = "Đoàn Ngọc Hải"
    static let avatar25 = "http://cafefcdn.com/thumb_w/660/2017/infonet-doan-ngoc-hai-1487583676256.JPG"
    static let phone25 = "0903342991"
    static let desc25 = "Lấn vỉa hè một tấc cũng đập"
    static let sex25 = Sex.male
    static let lat25 = 10.7805963
    static let lon25 = 106.6970933
    static let prefer25 = Sex.female
    static let cover25: String! = nil
    
    static let user26 = "VUoc532PABTXwHAc5ceaIAtem9D2"
    static let avatar26 = "https://pbs.twimg.com/profile_images/1146014416/mark-zuckerberg.jpg"
    static let name26 = "Mark Zuckerberg"
    static let desc26 = "Move fast, break thing"
    static let sex26 = Sex.male
    static let phone26 = "0903342991"
    static let lat26 = 10.7806225
    static let lon26 = 106.6905272
    static let prefer26 = Sex.female
    static let cover26: String! = nil
    
    static let user27 = "SyHSwBEV7zYR1FEzuqBTevOJVsH3"
    static let name27 = "Anonymous"
    static let avatar27 = "https://pbs.twimg.com/profile_images/824716853989744640/8Fcd0bji.jpg"
    static let desc27 = "Nobody can give you freedom, nobody can give you equality or justice, if you are a man, you take it"
    static let phone27 = "0903342991"
    static let sex27 = Sex.male
    static let lat27 = 10.759470
    static let lon27 = 106.678499
    static let prefer27 = Sex.female
    static let cover27: String! = nil
    
    static let user28 = "oyeh9Uw3ROgMESbdve57meldz2P2"
    static let avatar28 = "http://nguoinoitieng.vn/images/data/images/hantt/tieu-su-ngoc-trinh-nu-hoang-noi-y/ngoc-trinh-hai.jpg"
    static let name28 = "Ngọc Trinh"
    static let phone28 = "0903342991"
    static let desc28 = "Tôi ham tiền nhưng không dùng mọi cách để kiếm tiền, tôi còn phải chừa một phương lấy chồng chứ"
    static let sex28 = Sex.female
    static let prefer28 = Sex.male
    static let lat28 = 10.7403729
    static let lon28 = 106.696182
    static let cover28: String! = nil
    
    static let user29 = "MmnlhICjeRh6p3XcMIVpfiPLgBm2"
    static let name29 = "Vũ Cát Tường"
    static let avatar29 = "http://static-img.nhac.vui.vn/imageupload/upload2013/2013-4/album/2013-10-17/1381994117_Vet-Mua-Album-Vu-Cat-Tuong.jpg"
    static let desc29 = "Người ta yêu nhiều nói ít"
    static let sex29 = Sex.female
    static let phone29 = "0903342991"
    static let prefer29 = Sex.unknown
    static let lat29 = 10.7849798
    static let lon29 = 106.6861242
    static let cover29: String! = nil
    
    static let user30 = "uqN20jagX1dZwti749FTmZbqpHn1"
    static let name30 = "Quang Lương"
    static let avatar30 = "http://file.tinnhac.com/resize/600x-/2016/09/13/IMG7874-c63d.jpg"
    static let desc30 = "我愿变成童话里, 你爱的那个天使"
    static let sex30 = Sex.male
    static let phone30 = "0903342991"
    static let prefer30 = Sex.female
    static let lat30 = 10.7849799
    static let lon30 = 106.6926903
    static let cover30: String! = nil
}
