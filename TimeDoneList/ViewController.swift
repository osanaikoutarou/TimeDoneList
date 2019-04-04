//
//  ViewController.swift
//  TimeDoneList
//
//  Created by osanai on 2019/04/02.
//  Copyright © 2019 osanai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var states:[[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 100), count:100)
    
    @IBOutlet weak var mon: UIButton!
    @IBOutlet weak var the: UIButton!
    @IBOutlet weak var wen: UIButton!
    @IBOutlet weak var thu: UIButton!
    @IBOutlet weak var fri: UIButton!
    @IBOutlet weak var sat: UIButton!
    @IBOutlet weak var sun: UIButton!
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    func update() {
        mon.setTitle(String(sum(weekOf: 0)), for: .normal)
        the.setTitle(String(sum(weekOf: 1)), for: .normal)
        wen.setTitle(String(sum(weekOf: 2)), for: .normal)
        thu.setTitle(String(sum(weekOf: 3)), for: .normal)
        fri.setTitle(String(sum(weekOf: 4)), for: .normal)
        sat.setTitle(String(sum(weekOf: 5)), for: .normal)
        sun.setTitle(String(sum(weekOf: 6)), for: .normal)
        
        let sumWeek = (sum(weekOf: 0) + sum(weekOf: 1) + sum(weekOf: 2) + sum(weekOf: 3) + sum(weekOf: 4) + sum(weekOf: 5) + sum(weekOf: 6))
        let sumMonth = sumWeek * 30/7
        
        resultLabel.text = "\(sumWeek)時間/週　\(sumMonth)時間/月"
    }
    
    func sum(weekOf: Int) -> Int {
        return states[weekOf].reduce(0, {$0 + $1})
    }
    
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
        if states[index.weekOf][index.time] == 0 {
            states[index.weekOf][index.time] = 1
        }
        else {
            states[index.weekOf][index.time] = 0
        }
        if states[index.weekOf][index.time] == 0 {
            button(weekOf: index.weekOf, time: index.time).backgroundColor = .white
        }
        else {
            button(weekOf: index.weekOf, time: index.time).backgroundColor = .green
        }
        
        update()
    }
    


}

