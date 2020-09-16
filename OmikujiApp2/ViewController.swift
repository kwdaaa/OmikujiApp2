//
//  ViewController.swift
//  OmikujiApp2
//
//  Created by 川田 文香 on 2020/09/15.
//  Copyright © 2020 kwdaaa.com. All rights reserved.
//

import UIKit

// 音楽ライブラリを使うためのコード
import AVFoundation

// 音楽再生用の変数を定義

class ViewController: UIViewController {
    
    var resultAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    
    
    
    
    @IBOutlet weak var stickView: UIView!
    
    @IBOutlet weak var stickLabel: UILabel!
    
    @IBOutlet weak var stickHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stickBottomMargin: NSLayoutConstraint!
    
    
    let resultTexts: [String] = [
        "大吉",
        "中吉",
        "小吉",
        "吉",
        "末吉",
        "凶",
        "大凶"
    ]
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        
        // もしモーションが、シェイクモーションじゃなかったら、または、overViewがHidden（隠す）になってなかったら
        if motion != UIEvent.EventSubtype.motionShake ||  overView.isHidden == false {
            // シェイクモーション以外では動作させない。
            // 結果の表示中は動作させない。
            //（上記２つのどちらかの場合、retuenで終了されて動作しなくなる）
            return
        }
        
        // arc4random_uniform関数 → 0〜引数にとった値-1の範囲の整数をランダムに返す関数。
        // カウント数から-1引くことで（1~7→0~6）、配列の値と（今回の場合、0~6）合う。
        let resultNum = Int( arc4random_uniform(UInt32(resultTexts.count)) )
        
        // スティックラベル（.textでテキスト形式の指定）に、変数resultTextsの配列番号[resultNum]番目を入れる。
        stickLabel.text = resultTexts[resultNum]
        
        // 紐付け制約の変数.constant（.constantで変数形式の指定）で数値を取ることができる。
        // omikuji_stickのBottomMargin（omikuji_headとの間隔）は今0。
        // おみくじが本体から出てくる時、omikuji_stickの高さ分（128）× -1にすることで、BottomMarginが -128になって、本体から出てくる。
        stickBottomMargin.constant = stickHeight.constant * -1
        
        
        //　おみくじが出てくるアニメーション
        // UIView.animateは関数。アニメーションさせるため。
        // 「withDuration:」はアニメーションを行う秒数を設定。「withDuration: 1」でアニメーションを１秒で行うことを指定。
        UIView.animate(withDuration: 1.0, animations: {
        // 通常はanimationsのクロージャ内で座標の変更などを行うが、制約の変更でアニメーションさせる場合は「self.view.layoutIfNeeded()」のみでアニメーションが反映される。
            self.view.layoutIfNeeded()
            
        },completion: { (finished: Bool) in
            // stickLabelに表示されたおみくじ結果と同じおみくじ結果を、bigLabelにも表示させる。
            self.bigLabel.text = self.stickLabel.text
                
            // overViewのHiddenを解除
            self.overView.isHidden = false
            
            // 結果表示の時に音を再生（Play）する。
            self.resultAudioPlayer.play()
            
        })
    }

    @IBOutlet weak var overView: UIView!
    
    @IBOutlet weak var bigLabel: UILabel!
    
    @IBAction func tapRetryButton(_ sender: UIButton) {
        // overViewのHiddenを再設定
        overView.isHidden = true
        // omikuji_stickのBottomMargin（omikuji_headとの間隔）をもう一度0にリセット。※-128のままになってたから。
        stickBottomMargin.constant = 0
    }
    
    // 音楽を再生。"drum"と".mp3"を変えることで他のファイルを読み込めるようになる。
    func setupSound() {
        
        
        if let sound = Bundle.main.path(forResource: "drum", ofType: ".mp3"){
            // 読み込んだ結果があるときの処理。
            //
            resultAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            resultAudioPlayer.prepareToPlay()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //音を鳴らす
        setupSound()
        // Do any additional setup after loading the view.
    }


}

