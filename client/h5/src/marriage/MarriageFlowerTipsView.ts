import { BaseView1 } from "../common/BaseView1";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { FriendEvent, FriendModel } from "../commonModel/FriendModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ColorUtil, Enum_ColorUtil_Light, Enum_ColorUtil_NEW } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { RefBoxChildsLayout, Util } from "../util/Util";

//伴侣-被人送花提示界面
export class MarriageFlowerTipsView extends BaseView1 {

    private _head: CustomHeadItem;

    Local_Open
    Clear
    LoadSuccess
    UpdateView
    InitEvent
    SourceClickFunc
    public constructor() {
        super()
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageFlowerTipsView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        // this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            local_Util = Util,
            friend_model = FriendModel.GetInstance(),
            _flower_vo_

        this.load_callback = function () {
            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = function () {
            this.UpdateView()
        }

        this.destroy_callback = function () {
            this.Clear()
        }

        this.Local_Open = (parms) => {
            [_flower_vo_] = parms
            super.Open()
        }

        this.Clear = () => {
            if (this._head) {
                this._head.DeleteMe()
                this._head = undefined
            }
            this._lb_get.off(Laya.Event.LINK, this, this.SourceClickFunc);
        }

        this.LoadSuccess = () => {
            this.scroll.vScrollBar.visible = false
            this._head = new CustomHeadItem(this._head_con)
            this._head.Load()

            // this._lb_get.style.color = "#883E43"
            this._lb_get.style.fontSize = 20
            this._lb_get.width = 100
            this._lb_get.innerHTML = "<font color='#883E43'><a href='click_fun'>默默收下</a></font>"
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_108, GameResPath.GetIcon("marriage", "uijh_108"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img88, GameResPath.GetIcon("marriage", "ui_marry_60"))
        }

        this.UpdateView = () => {
            let vo = _flower_vo_
            let frame_id = DressModel.GetInstance().GetDressByType(vo.dress_list, DressType.Photo)
            this._head.SetRoleVoData(vo)
            this._lb_name.text = vo.name
            this._lb_guild.text = vo.guild_name

            let color = ColorUtil.TransHtmlColor(Enum_ColorUtil_NEW.LIGHT_GREEN)
            let name = local_Util.HtmlColorTxt(vo.name, color)
            let goods = local_Util.HtmlColorTxt(GoodsModel.GetGoodsName(vo.goods_id), color)
            let fdata = _model.GetFlowerData(vo.goods_id)
            let intimacy = fdata ? local_Util.HtmlColorTxt(fdata.intimacy, color) : "--"
            let str = `${name}被您的美丽所倾倒，送上了${goods}，增加亲密度${intimacy}点！此刻无比幸福的你想如何答谢TA呢？`

            this._lb_content.style.color = "#ffffff"
            this._lb_content.style.fontSize = 20
            this._lb_content.style.leading = 15
            this._lb_content.width = 374
            // this._lb_content.height = 94
            this._lb_content.x = 30
            // this._lb_content.y = 247
            this._lb_content.width = 300
            // this._lb_content.height = 70
            this._lb_content.style.valign = "middle"
            // this._lb_content.style.align = "center"
            this._lb_content.innerHTML = local_Util.StrToHTML(str)
            // this._lb_content.style.padding = [(this._lb_content.height - this._lb_content.contextHeight) / 2, 0, 0, 0]

            let main_role = RoleManager.GetInstance().mainRoleInfo
            let is_one_server = main_role.server_unique_id == vo.server_id
            let fri_vo = friend_model.getFriendById(vo.role_id)
            this._btn_friend.visible = !fri_vo && is_one_server
            this._btn_thanks.visible = !!fri_vo && is_one_server

            if (this._btn_friend.visible == false) {
                this._Group1.removeChild(this._btn_friend)
            }
            if (this._btn_thanks.visible == false) {
                this._Group1.removeChild(this._btn_thanks)
            }

            RefBoxChildsLayout(this._Group1, 10)
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_go, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageFlowerView", _flower_vo_)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_thanks, () => {
                _model.Fire(MarriageEvent.REQUEST_PROTO, 22305, "l", _flower_vo_.role_id)
                _model.ThanksToChat(_flower_vo_.role_id)
                _model.OpenChatView(_flower_vo_.role_id)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_friend, () => {
                friend_model.Fire(FriendEvent.ADD_FRIEND, _flower_vo_.role_id)
                this.Close()
            }, this, true)

            this._lb_get.on(Laya.Event.LINK, this, this.SourceClickFunc);
        }

        this.SourceClickFunc = (e) => {
            this.Close()
        }
    }



    public Open(...parms) {
        this.Local_Open(parms)
    }
    

_img_108:Laya.Image
_btn_close:Laya.Image
_Image1:Laya.Image
_head_con:Laya.Box
_img88:Laya.Image
_Group1:Laya.Box
_btn_friend:Laya.Box
_Image11:Laya.Image
labelDisplay:Laya.Label
_btn_thanks:Laya.Box
_Image1111:Laya.Image
labelDisplay1:Laya.Label
_btn_go:Laya.Box
_Image111:Laya.Image
labelDisplay11:Laya.Label
_Group2:Laya.Box
_Image2:Laya.Image
_lb_name:Laya.Label
_lb_guild:Laya.Label
_lb_get:Laya.HTMLDivElement
scroll:Laya.Panel
_lb_content:Laya.HTMLDivElement
public GetComponents() {
[
this._img_108,
this._btn_close,
this._Image1,
this._head_con,
this._img88,
this._Group1,
this._btn_friend,
this._Image11,
this.labelDisplay,
this._btn_thanks,
this._Image1111,
this.labelDisplay1,
this._btn_go,
this._Image111,
this.labelDisplay11,
this._Group2,
this._Image2,
this._lb_name,
this._lb_guild,
this._lb_get,
this.scroll,
this._lb_content,
]
 = this.GetChildrenByNames([

"_img_108",
"_btn_close",
"_Image1",
"_head_con",
"_img88",
"_Group1",
"_btn_friend",
"_Image11",
"labelDisplay",
"_btn_thanks",
"_Image1111",
"labelDisplay1",
"_btn_go",
"_Image111",
"labelDisplay11",
"_Group2",
"_Image2",
"_lb_name",
"_lb_guild",
"_lb_get",
"scroll",
"_lb_content",
])
}
}
 window["MarriageFlowerTipsView"]= MarriageFlowerTipsView