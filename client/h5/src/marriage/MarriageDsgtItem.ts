import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { DsgtModel } from "../commonModel/DsgtModel";
import { MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { SetHtmlStyle, Util } from "../util/Util";

export class MarriageDsgtItem extends BaseItemRenderer {
    public WIDTH = 548
    public HEIGT = 102

    private _model: MarriageModel;
    public constructor() {
        super()
        this.base_file = "marriage"
        this.layout_file = "MarriageDsgtItem"
        this._model = MarriageModel.GetInstance()
        this.Load()
    }

    public DeleteMe() {
        super.DeleteMe()
    }

    public load_callback() {
        Util.AddClickEvent(this._btn_flower, () => {
            let married = RoleManager.GetInstance().GetMainRoleVo().is_marriage == 2
            if (married) {
                let mate_info = this._model.GetMateInfo()
                if (!mate_info) return
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageFlowerView",mate_info)
            } else {
                Alert.Show("结婚后与伴侣互赠鲜花方可增加恩爱值哦，是否立即前往结婚", Alert_Type.Two, () => {
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageAskListView")
                    GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "MarriageDsgtView")
                })
            }
        }, this, true)

        // ResManager.GetInstance().SetTexture(this.base_item, this._img_056, "resource/game/marriage/texture/uijh_056.png")
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        this._lb_intimacy.text = `恩爱值达到${data.love_num}`
        let dsgt_info_list = Config.PRELOAD_SERVER_CONFIG.config_dsgt
        let dsgt = dsgt_info_list[data.dsgt];
        if (dsgt.type == 1) {
            this.base_item.AddUIEffect(dsgt.resource_id, this._group_dsgt, null, 0.8, true);
        } else {
            let url = `resource/game/dsgtIcon/${dsgt.resource_id}.png`
            ResManager.GetInstance().SetTexture(this.base_item, this._img_dsgt, url)
        }

        let mate_info = this._model.GetMateInfo()
        let dic = DsgtModel.GetInstance().GetDsgtInfoVo()
        let unlock = dic[data.dsgt] && dic[data.dsgt].status != 0
        this._img_unlock.visible = unlock
        this._btn_flower.visible = !unlock

        let attr_list = dsgt.attr_list
        SetHtmlStyle(this._lb_attr,{c:"#a13a4d",f:20,lh:25,w:300})
        this._lb_attr.innerHTML = Util.StrToHTML(this._model.GetDsgtAttrStr(attr_list, "'#ef8d9f'"))
        this._lb_attr.style.width=300
    }
    


_img_056:Laya.Image
_btn_flower:Laya.Image
_img_unlock:Laya.Image
_img_dsgt:Laya.Image
_group_dsgt:Laya.Box
group1:Laya.Box
img1:Laya.Image
_lb_intimacy:Laya.Label
_lb_attr:Laya.HTMLDivElement
public GetComponents() {
[
this._img_056,
this._btn_flower,
this._img_unlock,
this._img_dsgt,
this._group_dsgt,
this.group1,
this.img1,
this._lb_intimacy,
this._lb_attr,
]
 = this.GetChildrenByNames([

"_img_056",
"_btn_flower",
"_img_unlock",
"_img_dsgt",
"_group_dsgt",
"group1",
"img1",
"_lb_intimacy",
"_lb_attr",
])
}
}
 window["MarriageDsgtItem"]= MarriageDsgtItem