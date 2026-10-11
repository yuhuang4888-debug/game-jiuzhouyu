import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { SetAnchoredPositionY, SetLocalPositionY, SetSizeDeltaX, SetSizeDeltaY, Util } from "../util/Util"

export class TreasureRecordItem extends BaseItem1{
    public record_label:Laya.HTMLDivElement

    // public WIDTH=480
    // public HEIGT=20

    data 
    needRefresh=false

    public constructor(parent?) {
        super(parent)
        this.base_file = "runeTreasure"
        this.layout_file = "TreasureRecordItem"
        // this.Load()
        this.load_callback = function () {
			if(this.needRefresh){
                this.SetData(this.data)
            }
		}
    }

    

    public SetData(data?) {
        let self=this
        this.data=data
        if (self.is_loaded) {
            let self = this
            if (self.data) {
                let goods_name = GoodsModel.GetGoodsNameWithColorLight(self.data.gtyp_id)
                let str = ``
                let color = "'#60aeff'"
                if (self.data.type == 1) {
                    // self.record_label.textFlow = Util.StrToHTML(
                    //     `${Util.HtmlColorTxt(`${self.data.role_name}`, ColorUtil.GetColorLight(ColorType.GREEN))}在${Util.HtmlColorTxt(RuneTreasureModel.getInstance().GetTypeWord(self.data.type), ColorUtil.GetColorLight(ColorType.BLUE))}中获得${self.data.goods_num}个${goods_name}`)
                } else if (self.data.type == 2) {
                    color = "'#a376ff'"
                    // self.record_label.textFlow = Util.StrToHTML(
                    //     `${Util.HtmlColorTxt(`${self.data.role_name}`, ColorUtil.GetColorLight(ColorType.GREEN))}在${Util.HtmlColorTxt(RuneTreasureModel.getInstance().GetTypeWord(self.data.type), ColorUtil.GetColorLight(ColorType.PURPLE))}中获得${self.data.goods_num}个${goods_name}`)
                } else if (self.data.type == 3) {
                    color = "'#ff9015'"
                    // self.record_label.textFlow = Util.StrToHTML(
                    //     `${Util.HtmlColorTxt(`${self.data.role_name}`, ColorUtil.GetColorLight(ColorType.GREEN))}在${Util.HtmlColorTxt(RuneTreasureModel.getInstance().GetTypeWord(self.data.type), ColorUtil.GetColorLight(ColorType.ORANGE))}中获得${self.data.goods_num}个${goods_name}`)
                }
                let type = RuneTreasureModel.GetInstance().GetTypeWord(self.data.type)
                let is_mark = this.data.role_name == "蒙面人"
                let self_mask = is_mark && RoleManager.GetInstance().GetMainRoleId() == this.data.role_id
                let name = self_mask ? `蒙面人(自己)` : this.data.role_name
                let Sstr = ``
                if (self.data.server_id && !is_mark) {
                    Sstr = `S${self.data.server_num}.`
                }
                if (self.data.is_rare) {
                    str = `<font color='#b3ff48'>${Sstr}${name}</font>欧皇附身，在<font color=${color}>${type}</font>中获得${self.data.goods_num}个${goods_name}，幸运值稍后重置，勇士们抓紧机会！`
                } else {
                    str = `<font color='#b3ff48'>${Sstr}${name}</font>在<font color=${color}>${type}</font>中获得${self.data.goods_num}个${goods_name}`
                }
                self.record_label.style.fontSize=20
                self.record_label.style.color="#FFFFFF"
                self.record_label.width=480
                self.record_label.style.wordWrap=true
                self.record_label.innerHTML = Util.StrToHTML(str)
                SetSizeDeltaY(this.display_obj,this.record_label.contextHeight)
                self.needRefresh=false
            }
        } else {
            self.needRefresh = true
        }
    }


    public GetComponents() {
        [
            this.record_label,
        ]
            = this.GetChildrenByNames([

                "record_label",
            ])
    }

    public DeleteMe(){
        super.DeleteMe()
    }
}

window["TreasureRecordItem"]=TreasureRecordItem