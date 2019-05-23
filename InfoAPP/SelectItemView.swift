//
//  SelectItemView.swift
//  InfoAPP
//
//  Created by leeco on 2019/5/22.
//  Copyright © 2019 zsw. All rights reserved.
//选择新闻条目

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
class SelectItemView: UIView {
    var closeBtn: UIButton!
    var datas: [[ItemModel]]!
    var selectedIndexPath: IndexPath!
    var collectionView: UICollectionView!
    
    weak open var delegate: SelectItemViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = .white
        
      selectedIndexPath = IndexPath.init(row: 0, section: 0)
        
        let titles1 = ["头条","社会","国内","国际","娱乐","体育","军事","科技","财经","时尚"]
        let titles2 = ["头条1","社会1","国内1","国际1","娱乐1","体育1","军事1","科技1","财经1","时尚1"]

        var  datas0 = Array<Any>()
        for i in 0..<titles1.count{
            let model = ItemModel()
            model.title = titles1[i]
            model.indexPath = IndexPath.init(row: i, section: 0)
            datas0.append(model)
        }
        var  datas1 = Array<Any>()
        for i in 0..<titles2.count{
            let model = ItemModel()
            model.title = titles2[i]
            model.indexPath = IndexPath.init(row: i, section: 1)
            datas1.append(model)
        }
        datas = [datas0,datas1] as? [[ItemModel]]

        
        
        closeBtn = UIButton()
        closeBtn.setTitle("X", for: UIControl.State.normal)
        closeBtn.setTitleColor(.black, for: .normal)
        self.addSubview(closeBtn)
        closeBtn.rx.tap.subscribe(onNext: { [weak self] in
            self!.delegate?.selectItemClose()
        }, onError: { error  in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
        closeBtn.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(10)
            make.width.height.equalTo(35)
        }
        
        let interitemSpacing = 12.5
        
        let itemW = (self.frameW - CGFloat(interitemSpacing*5))/4
        
        
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: itemW, height: 60)
        layout.minimumLineSpacing = CGFloat(interitemSpacing)
        layout.minimumInteritemSpacing = CGFloat(interitemSpacing)
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: KSCREEN_WIDTH, height: 40)
        layout.sectionInset = UIEdgeInsets.init(top: CGFloat(interitemSpacing), left: CGFloat(interitemSpacing), bottom: 0, right: CGFloat(interitemSpacing))
        
        collectionView  = UICollectionView(frame: CGRect(x: 0, y: 40, width: self.frameW, height: self.frameH-40), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(SelectItemViewCell.classForCoder(), forCellWithReuseIdentifier: "cellId")
        collectionView.register(SelectItemHeader.classForCoder(), forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader , withReuseIdentifier: "header")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)

        let longPressGes = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressMethod(longPressGes:)))
       
        collectionView.addGestureRecognizer(longPressGes)
        
        
    }
    
    @objc func longPressMethod(longPressGes:UILongPressGestureRecognizer){
        let point: CGPoint = longPressGes.location(in: self.collectionView)
        
        
        guard let indexPath: IndexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        
        switch longPressGes.state {
        case .began:
        
            collectionView.beginInteractiveMovementForItem(at: indexPath as IndexPath)
            break;
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(point)
            break;
        case .ended:
            collectionView.endInteractiveMovement()
            break;
        default:
            collectionView.cancelInteractiveMovement()
            break
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SelectItemView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var dataArr = datas![sourceIndexPath.section]
        
        let model = dataArr[sourceIndexPath.row]
        
        dataArr.remove(at: sourceIndexPath.row)
        dataArr.insert(model, at: destinationIndexPath.row)
        
        datas.remove(at: sourceIndexPath.section)
        datas.insert(dataArr, at: sourceIndexPath.section)

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas[section].count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
         
            return view
            
            break

        default: break
            
        }
        return UIView() as! UICollectionReusableView
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SelectItemViewCell
        cell.delegate = self
        let model = datas[indexPath.section][indexPath.row]
        cell.setModel(model: model)
        return cell
    }
}
extension SelectItemView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {

            var dataArr1 = datas![indexPath.section]
            let model = dataArr1[indexPath.row]
            dataArr1.remove(at: indexPath.row)
            datas[indexPath.section] = dataArr1


            var dataArr0 = datas![0]
            dataArr0.append(model)
            datas[0] = dataArr0

            //提前补位才能移动
            collectionView.moveItem(at: indexPath, to: IndexPath.init(row: dataArr0.count - 1 , section: 0))
            
        }else{
            
            if selectedIndexPath != indexPath , selectedIndexPath != nil {
                
                var dataArr = datas![selectedIndexPath!.section]
                
                let selectedModel = dataArr[selectedIndexPath!.row]
                selectedModel.isSelected = false
                
                let model = dataArr[indexPath.row]
                model.isSelected = true
                print(model.title)
                //替换
                dataArr[selectedIndexPath.row] = selectedModel
                dataArr[indexPath.row] = model
                
                datas[indexPath.section] = dataArr
                
                selectedIndexPath = indexPath;
            }

            collectionView.reloadData()
            
        }

    }
}
extension SelectItemView: SelectItemViewCellDelegate {
    func selectItemViewCellCancel(model: ItemModel) {
        

        let dataArr0 = datas[0]
        //找出位置
        guard let index = dataArr0.firstIndex(of:model) else { return  }
        //过滤
        let array = dataArr0.filter { itemModel -> Bool in
           return itemModel != model
        }
        datas[0] = array
        
        var dataArr1 = datas[1]
        dataArr1.append(model)
        datas[1] = dataArr1
        collectionView.moveItem(at: IndexPath.init(row: index, section: 0), to: IndexPath.init(row: dataArr1.count - 1 , section: 1))

    }
}

protocol SelectItemViewDelegate: NSObjectProtocol  {
    func selectItemClose()
}


class SelectItemViewCell: UICollectionViewCell {
    
    var titleL: UILabel!
    var model: ItemModel?
    weak open var delegate: SelectItemViewCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGB_COLOR(r: 244, g: 245, b: 246)
    
        titleL = UILabel()
        titleL.text = "热点"
        self.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            make.center.equalTo(self.snp_center)
        }
        
        let  cancelBtn = UIButton()
        self.addSubview(cancelBtn)
        
        cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            self!.delegate?.selectItemViewCellCancel(model: self!.model!)
            }, onError: { error  in
                print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
        
        cancelBtn.snp.makeConstraints { make in
            make.right.equalTo(self).offset(10)
            make.top.equalTo(self).offset(-10)
            make.width.height.equalTo(20)
        }
        cancelBtn.backgroundColor = .red
        
    }
    
    func setModel(model:ItemModel){
        self.model = model
        titleL.text = model.title
        if model.isSelected! {
            titleL.textColor = .red
        }else{
            titleL.textColor = .black
        }
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01 ){
            return nil
        }
        let resultView  = super.hitTest(point, with: event)
        if resultView != nil {
            return resultView
        }else{
            for subView in self.subviews.reversed() {
                let convertPoint : CGPoint = subView.convert(point, from: self)
                let hitView = subView.hitTest(convertPoint, with: event)
                if (hitView != nil) {
                    return hitView
                }
            }
        }
        return nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SelectItemViewCellDelegate: NSObjectProtocol {
    func selectItemViewCellCancel(model:ItemModel);
}

class SelectItemHeader: UICollectionReusableView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleL = UILabel()
        titleL.text = "我的频道"
        self.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self.snp_centerY)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class ItemModel: NSObject {
    var title: String?
    var isSelected: Bool?
    var indexPath: IndexPath?
    override init() {

        isSelected = false
    }
}
