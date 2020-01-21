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
    var bgView: UIView!
    weak open var delegate: SelectItemViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = .black
        
        bgView = UIView(frame: CGRect(x: 0, y: 44, width: self.frameW, height: self.frameH-44))
        bgView.backgroundColor = .white
        self.addSubview(bgView)
      
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
        
        let model = ItemModel()
        model.isEdit = false

        datas = [datas0,datas1,[model]] as? [[ItemModel]]

        closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "close1"), for: .normal)
        closeBtn.setTitleColor(.black, for: .normal)
        bgView.addSubview(closeBtn)
        closeBtn.rx.tap.subscribe(onNext: { [weak self] in
            self!.delegate?.selectItemClose(dataArray: (self?.datas.first)!)
        }, onError: { error  in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
        closeBtn.snp.makeConstraints { make in
            make.left.equalTo(bgView).offset(10)
            make.top.equalTo(bgView).offset(10)
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
        
        collectionView  = UICollectionView(frame: CGRect(x: 0, y: 45, width: self.frameW, height: bgView.frameH-45), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(SelectItemViewCell.classForCoder(), forCellWithReuseIdentifier: "cellId")
        collectionView.register(SelectItemHeader.classForCoder(), forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader , withReuseIdentifier: "header")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        bgView.addSubview(collectionView)

        let longPressGes = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressMethod(longPressGes:)))
       
        collectionView.addGestureRecognizer(longPressGes)
        
    }
    
    @objc func longPressMethod(longPressGes:UILongPressGestureRecognizer){
        let point: CGPoint = longPressGes.location(in: self.collectionView)
        
        
        guard let indexPath: IndexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        
        if indexPath.section == 1 {
            return
        }
        
        switch longPressGes.state {
        case .began:
        
            if #available(iOS 9.0, *) {
                collectionView.beginInteractiveMovementForItem(at: indexPath as IndexPath)
            } else {
                // Fallback on earlier versions
            }
            break;
        case .changed:
            if #available(iOS 9.0, *) {
                collectionView.updateInteractiveMovementTargetPosition(point)
            } else {
                // Fallback on earlier versions
            }
            break;
        case .ended:
            if #available(iOS 9.0, *) {
                collectionView.endInteractiveMovement()
            } else {
                // Fallback on earlier versions
            }
            break;
        default:
            if #available(iOS 9.0, *) {
                collectionView.cancelInteractiveMovement()
            } else {
                // Fallback on earlier versions
            }
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
        return datas.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas[section].count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! SelectItemHeader
            if indexPath.section == 1{
                view.editBtn.isHidden = true
            }else{
                view.editBtn.isHidden = false
                 view.delegate = self
                
                view.setModel(model: datas[2].first!)
                
            }

            return view

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
            let model2 = datas[2].first
            model.hidden = !model2!.isEdit!
            dataArr0.append(model)
            datas[0] = dataArr0

            let toIndex = IndexPath.init(row: dataArr0.count - 1 , section: 0)
            
            //提前补位才能移动
            collectionView.moveItem(at: indexPath, to: toIndex)
            collectionView.reloadItems(at: [toIndex])
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
        model.hidden = true
        dataArr1.append(model)
        datas[1] = dataArr1
        
        let toIndex = IndexPath.init(row: dataArr1.count - 1 , section: 1)
        
        collectionView.moveItem(at: IndexPath.init(row: index, section: 0), to: toIndex)

        collectionView.reloadItems(at: [toIndex])
        
    }
}
extension SelectItemView: SelectItemHeaderDelegate{
    func editAction(isSelected:Bool) {
        print("edit")
        var dataArr0 = datas[0]
        dataArr0 = dataArr0.map({ (model:ItemModel) in
            model.hidden = !isSelected
            return model
        })
        datas[0] = dataArr0
        
        var dataArr2 = datas[2]
        let model = dataArr2.first
        model?.isEdit = isSelected
        dataArr2[0] = model!
        datas[2] = dataArr2
        
        collectionView.reloadData()
    }
}
protocol SelectItemViewDelegate: NSObjectProtocol  {
    
    func selectItemClose(dataArray:Array<ItemModel>)
    
}


class SelectItemViewCell: UICollectionViewCell {
    
    var titleL: UILabel!
    var model: ItemModel?
    var  cancelBtn: UIButton!
    weak open var delegate: SelectItemViewCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGB_COLOR(r: 244, g: 245, b: 246)
    
        titleL = UILabel()
        titleL.text = "--"
        self.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            make.center.equalTo(self.snp_center)
        }
        
        cancelBtn = UIButton()
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
        
        cancelBtn.setImage(UIImage(named: "close"), for: .normal)
        
    }
    
    func setModel(model:ItemModel){
        self.model = model
        titleL.text = model.title
        if model.isSelected! {
            titleL.textColor = .red
        }else{
            titleL.textColor = .black
        }
        
        cancelBtn.isHidden = model.hidden!
        
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
    
    weak open var delegate: SelectItemHeaderDelegate?
    var editBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleL = UILabel()
        titleL.text = "我的频道"
        self.addSubview(titleL)
        titleL.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        editBtn = UIButton()
        editBtn.setTitle("编辑", for: .normal)
        editBtn.setTitle("完成", for: .selected)
        editBtn.setTitleColor(.black, for: .normal)
        self.addSubview(editBtn)
        editBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(self.snp_right).offset(-10)
        }
        editBtn.addTarget(self, action: #selector(clickAction(button:)), for: .touchUpInside)

    }
    func setModel(model:ItemModel){
        
        editBtn.isSelected = model.isEdit!
        
    }
    @objc func clickAction(button:UIButton){
      
        button.isSelected = !button.isSelected

        self.delegate?.editAction(isSelected: button.isSelected)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
protocol SelectItemHeaderDelegate: NSObjectProtocol {
    func editAction(isSelected:Bool)
}


class ItemModel: NSObject {
    var title: String?
    var isSelected: Bool?
    var hidden: Bool?
    var isEdit: Bool?
    var indexPath: IndexPath?
    
    override init() {
        isEdit = false
        hidden = true
        isSelected = false
    }
}
