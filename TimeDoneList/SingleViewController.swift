//
//  ViewController.swift
//  TimeDoneList
//
//  Created by osanai on 2019/04/02.
//  Copyright © 2019 osanai. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController {

    var states:[[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 100), count:100)

    var colorPatterns: [UIColor] = [.green, .red, .blue, .gray, .purple, .orange]
    
    @IBOutlet weak var mon: UILabel!
    @IBOutlet weak var the: UILabel!
    @IBOutlet weak var wen: UILabel!
    @IBOutlet weak var thu: UILabel!
    @IBOutlet weak var fri: UILabel!
    @IBOutlet weak var sat: UILabel!
    @IBOutlet weak var sun: UILabel!

    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var colorChangeButton: UIButton!
    @IBOutlet weak var patternLabel: UILabel!

    var patternNum: Int = 1 {
        didSet {
            patternLabel.text = "パターン\(patternNum)"
        }
    }
    var selectNum: Int = 1 {
        didSet {
            colorChangeButton.backgroundColor = colorPatterns[selectNum-1]
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorChangeButton.layer.cornerRadius = 15.0
        
        update()

        selectNum = 1
    }
    
    func update() {
        mon.attributedText = sumText(weekOf: 0)
        the.attributedText = sumText(weekOf: 1)
        wen.attributedText = sumText(weekOf: 2)
        thu.attributedText = sumText(weekOf: 3)
        fri.attributedText = sumText(weekOf: 4)
        sat.attributedText = sumText(weekOf: 5)
        sun.attributedText = sumText(weekOf: 6)
        
        resultLabel.attributedText = weekMonthText()
    }

    /// pattern毎の合計個数を求める
    func sum(weekOf: Int) -> [Int] {
        var sums: [Int] = []
        for i in 1...colorPatterns.count {
            let a = states[weekOf].filter { $0 == i }.count
            sums.append(a)
        }
        return sums
    }

    func sumText(weekOf: Int) -> NSAttributedString {
        let sums = sum(weekOf: weekOf)
        var labelComponents: [LabelCreator.LabelComponent] = []

        for (i, e) in sums.enumerated() {
            if e == 0 {
                continue
            }
            let l = LabelCreator.LabelComponent(text: "\(e) ", font: UIFont.boldSystemFont(ofSize: 12), textColor: colorPatterns[i])
            labelComponents.append(l)
        }
        return LabelCreator.create(with: labelComponents)
    }

    func weekMonthText() -> NSAttributedString {
        var labelComponents: [LabelCreator.LabelComponent] = []
        var weekSum: [Int] = [] // color毎の

        for c in 1...colorPatterns.count {
            var s = 0
            [0,1,2,3,4,5,6].forEach { (w) in
                let a = sum(weekOf: w)
                s += a[c-1]
            }
            weekSum.append(s)
        }

        labelComponents.append(LabelCreator.LabelComponent(text: "Week:", font: UIFont.boldSystemFont(ofSize: 13), textColor: .black))

        for (i, e) in weekSum.enumerated() {
            if e == 0 {
                continue
            }
            let l = LabelCreator.LabelComponent(text: "\(e) ", font: UIFont.boldSystemFont(ofSize: 13), textColor: colorPatterns[i])
            labelComponents.append(l)
        }

        let s1 = weekSum.reduce(0, {$0 + $1})

        labelComponents.append(LabelCreator.LabelComponent(text: " 合計:\(s1)時間\n", font: UIFont.boldSystemFont(ofSize: 14), textColor: .black))

        // 月

        labelComponents.append(LabelCreator.LabelComponent(text: "4.3週:", font: UIFont.boldSystemFont(ofSize: 13), textColor: .black))

        for (i, e) in weekSum.enumerated() {
            if e == 0 {
                continue
            }
            let v = Double(Int(Double(e)*43))/10.0
            let l = LabelCreator.LabelComponent(text: "\(v) ", font: UIFont.boldSystemFont(ofSize: 13), textColor: colorPatterns[i])
            labelComponents.append(l)
        }

        let s2 = Double(weekSum.reduce(0, {$0 + $1}) * 43)/10.0

        labelComponents.append(LabelCreator.LabelComponent(text: " 合計:\(s2)時間\n", font: UIFont.boldSystemFont(ofSize: 14), textColor: .black))

        return LabelCreator.create(with: labelComponents)
    }
    
//    func sum(weekOf: Int) -> Int {
//        return states[weekOf].reduce(0, {$0 + $1})
//    }
    
    func indexes(button: UIButton) -> (weekOf: Int, time:Int) {
        for (i, view) in stackview.arrangedSubviews.enumerated() {
            guard let view = view as? UIStackView else {
                continue
            }
            for (j, view2) in view.arrangedSubviews.enumerated() {
                if button.isEqual(view2.subviews.first!) {
                    return (i - 1, j + 6)
                }
            }
        }
        return (0, 0)
    }
    
    func button(weekOf: Int, time: Int) -> UIButton {
        let sv = stackview.arrangedSubviews[weekOf + 1] as! UIStackView
        return sv.arrangedSubviews[time - 6].subviews.first as! UIButton
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        let index = indexes(button: sender)
        let currentValue = states[index.weekOf][index.time]

        if currentValue == 0 {
            // 未選択　→　選択
            states[index.weekOf][index.time] = selectNum
        }
        else if currentValue != selectNum {
            // 別の色 →　今の色
            states[index.weekOf][index.time] = selectNum
        }
        else {
            // 同じ色 →　未選択
            states[index.weekOf][index.time] = 0
        }

        if states[index.weekOf][index.time] == 0 {
            button(weekOf: index.weekOf, time: index.time).backgroundColor = .white
        }
        else {
            button(weekOf: index.weekOf, time: index.time).backgroundColor = colorPatterns[selectNum-1]
        }
        
        update()
    }
    
    @IBAction func stepperDidTap(_ sender: UIStepper) {
        let v = Int(sender.value)
        let a = min(v, colorPatterns.count)
        sender.value = Double(a)
        patternNum = a
    }

    @IBAction func colorCircleTapped(_ sender: Any) {
        if selectNum == colorPatterns.count {
            selectNum = 1
        }
        else if selectNum == patternNum {
            selectNum = 1
        }
        else {
            selectNum += 1
        }
    }

    @IBAction func clearButton(_ sender: Any) {
        [0,1,2,3,4,5,6].forEach { (w) in
            for i in 1...colorPatterns.count {
                states[w][i-1] = 0
            }
        }
        update()
    }

}




class LabelCreator: NSObject {
    struct LabelComponent {
        let text: String
        let font: UIFont
        let textColor: UIColor
    }

    static func create(with components:[LabelComponent]) -> NSMutableAttributedString {
        let text = components.map { $0.text }.joined()
        let attr = NSMutableAttributedString(string: text)

        var location = 0
        components.forEach { (component) in
            attr.addAttributes([.font : component.font,
                                .foregroundColor : component.textColor],
                               range: NSRange(location: location, length: component.text.count))
            location += component.text.count
        }

        return attr
    }
}
