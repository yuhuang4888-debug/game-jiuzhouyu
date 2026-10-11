import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel"
import { PlatformManager } from "../PlatformManager"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { Util } from "../util/Util"

export class TreasureExchangeItem extends BaseItemRenderer {
    public click_bg
    public name_label
    public score_label
    public item_group
    public select_img
    public rare_img
    public _Image1: Laya.Image
    public bind_id
    public item: BaseAwardItem
    public id
    public clickGroup
    model = RuneTreasureModel.GetInstance()

    public WIDTH=307
    public HEIGT=104

    public constructor() {
        super()
        this.base_file = "runeTreasure"
        this.layout_file = "TreasureExchangeItem"
        this.Load()
    }


    public load_callback(){
        this.bind_id = this.model.Bind(RuneTreasureEvent.SELECT_SHOP_ITEM, (id) => {
            if (this.data && this.id == id) {
                this.select_img.visible = true
            } else {
                if (this.select_img.visible) {
                    this.select_img.visible = false
                }
            }
        })
        Util.AddClickEvent(this.clickGroup, () => {
            if (this.id)
                this.model.Fire(RuneTreasureEvent.SELECT_SHOP_ITEM, this.id)
        }, this, false)
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let self = this
            if (PlatformManager.IsEyouEnPlatform()) {
                // self.name_label.size = 18
                // self.name_label.maxWidth = 150;
                // self.name_label.wordWrap = true;
            }
            let local_util = Util
            let local_gmodel = GoodsModel.GetInstance()
            if (self.data) {
                if (!self.item) {
                    self.item = new BaseAwardItem(self.item_group)
                    self.item.Load()
                    self.item.SetScale(0.7)
                }
                if (self.data.reward) {
                    let goods_list = JSON.parse(self.data.reward)
                    let [type_id, lock] = local_gmodel.GetMappingTypeId(goods_list[0][0], goods_list[0][1])
                    let goods_vo = local_gmodel.GetGoodsBasicByTypeId(type_id)
                    if (goods_vo) {
                        // self.item.SetData(goods_vo.type_id, goods_list[0][2], false, lock, false, true)
                        self.item.SetData(goods_vo.type_id, goods_list[0][2], lock)
                    }
                    self.id = self.data.id
                    self.name_label.style.fontSize=24
                    self.name_label.style.color="#ffffff"
                    self.name_label.innerHTML = local_util.StrToHTML(GoodsModel.GetGoodsNameWithColorDark(goods_list[0][1]))
                    self.name_label.width=1000
                    this.name_label.x=165/2-this.name_label.contextWidth/2
                    this.name_label.y=38/2-this.name_label.contextHeight/2
                }
                self.score_label.style.fontSize=18
                self.score_label.style.color="#93847d"
                let score=this.model.equip_treasure_socre
                if(score>=self.data.score){
                    self.score_label.innerHTML = local_util.StrToHTML(`所需积分:${local_util.HtmlColorTxt(`${self.data.score}`, ColorUtil.GetColorDark(ColorType.GREEN))}`)
                }else{
                    self.score_label.innerHTML = local_util.StrToHTML(`所需积分:${local_util.HtmlColorTxt(`${self.data.score}`, ColorUtil.GetColorDark(ColorType.RED))}`)
                }  
                self.score_label.width=1000
                self.rare_img.visible = self.data.rare ? true : false
            }
        }
    }

    public DeleteMe() {
        let self = this
        if (self.item) {
            self.item.DeleteMe()
            self.item = null
        }
        if (self.bind_id) {
            self.model.UnBind(self.bind_id)
            self.bind_id = null
        }
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this.click_bg,
            this._Image1,
            this.name_label,
            this.score_label,
            this.item_group,
            this.select_img,
            this.rare_img,
            this.clickGroup
        ]
            = this.GetChildrenByNames([

                "click_bg",
                "_Image1",
                "name_label",
                "score_label",
                "item_group",
                "select_img",
                "rare_img",
                "clickGroup"
            ])
    }
}

window["TreasureExchangeItem"]=TreasureExchangeItem