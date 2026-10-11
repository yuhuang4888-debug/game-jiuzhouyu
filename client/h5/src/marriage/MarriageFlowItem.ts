import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { MarriageDefine, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, Util } from "../util/Util";

export class MarriageFlowItem extends BaseItemRenderer {
    public WIDTH = 560
    public HEIGT = 218

    private _model: MarriageModel;

    public constructor() {
        super()
        this.base_file = "marriage"
        this.layout_file = "MarriageFlowItem"
        this._model = MarriageModel.GetInstance()
        this.Load()
    }

    public DeleteMe() {
        super.DeleteMe()
    }

    public load_callback() {
        Util.AddClickEvent(this._btn_go, () => {
            if (this.data.id == 1) {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageBaseView")
            } else if (this.data.id == 2) {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageFlowerView")
            } else if (this.data.id == 3) {
                let role_lv = RoleManager.GetInstance().GetMainRoleVo().level
                let open_lv = MarriageDefine.OPEN_LV
                if (role_lv >= open_lv) {
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageAskListView")
                } else {
                    Message.show(`${open_lv}级开启求婚`)
                }
            } else if (this.data.id == 4) {

            }
            GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "MarriageFlowView")
        }, this, true)
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_banner, GameResPath.GetIcon("marriage", `${data.banner}`))
        this._img_title.skin = AtlasUrl("marriage", data.title)
        this._lb_tips.style.fontSize = 22
        this._lb_tips.width = 362
        this._lb_tips.style.color = "#ffffff"
        this._lb_tips.innerHTML = Util.StrToHTML(data.tips)
        this._lb_go.text = data.btn
        this.no.text = String(this.data.id)
    }
    

_img_banner:Laya.Image
_img_title:Laya.Image
_box:Laya.Box
no:Laya.Label
_lb_tips:Laya.HTMLDivElement
_btn_go:Laya.Box
img1:Laya.Image
_lb_go:Laya.Label
public GetComponents() {
[
this._img_banner,
this._img_title,
this._box,
this.no,
this._lb_tips,
this._btn_go,
this.img1,
this._lb_go,
]
 = this.GetChildrenByNames([

"_img_banner",
"_img_title",
"_box",
"no",
"_lb_tips",
"_btn_go",
"img1",
"_lb_go",
])
}
}
 window["MarriageFlowItem"]= MarriageFlowItem