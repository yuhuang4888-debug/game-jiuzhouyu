import { BaseView1 } from "../common/BaseView1";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { PlatformManager } from "../PlatformManager";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { TimeUtil } from "../util/TimeUtil";
import { RefBoxChildsLayout, SetHtmlCenter, Util } from "../util/Util";
import { GameResPath } from "../util/GameResPath";

//伴侣-发布征友界面
export class MarriageIssueView extends BaseView1 {

    private _head: CustomHeadItem;
    Clear
    LoadSuccess
    InitEvent
    OverCharLimit
    FocusFun
    BlurFun
    EnterFun
    manifesto_list
    RangeManifesto
    public constructor() {
        super();
        let _model = MarriageModel.GetInstance(),
            platform_mgr = PlatformManager.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            local_Util = Util,
            local_Message = Message,
            local_MarriageEvent = MarriageEvent,
            _char_limit_ = 30,
            _tag_list_ = [],
            _tag_tips_ = "点击添加个性标签",
            _fri_data_,
            language_cfg_

        this.base_file = "marriage"
        this.dependent_res = ["marriage2"];
        this.layout_file = "MarriageIssueView";
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true
        this.manifesto_list=[]

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("marriage", "uijh_092"))
            this.LoadSuccess()
            this.InitEvent()
        }
        this.destroy_callback = function () {
            this.Clear()
        }
        if (platform_mgr.is_alpha || platform_mgr.need_alpha_open_charge) {
            this.preload_client_config = { "ConfigLanguageMaskAlpha": false,"ConfigMarriageManifesto":false }
            language_cfg_ = "ConfigLanguageMaskAlpha"
        }
        else {
            this.preload_client_config = { "ConfigLanguageMask": false ,"ConfigMarriageManifesto":false}
            language_cfg_ = "ConfigLanguageMask"
        }

        this.Clear = () => {
            if (this._head) {
                this._head.DeleteMe()
                this._head = undefined
            }
            //this._edit_text.off(Laya.Event.INPUT, this, this.OverCharLimit)
        }

        this.LoadSuccess = () => {

            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"ConfigMarriageManifesto",true)
            this.manifesto_list = cfg["manifesto"]
            this._lb_edit.text=this.RangeManifesto()

            this._head = new CustomHeadItem(this.head_con)
            this._head.Load()
            _tag_list_ = []
            res_mgr.SetTexture(this, this._img_bg, "resource/game/marriage/texture/uijh_092.png")

            // this._edit_text.maxChars = _char_limit_
            // this._edit_text.on(Laya.Event.INPUT, this, this.OverCharLimit);


            let role_vo = RoleManager.GetInstance().GetMainRoleVo()
            this._lb_name.text = role_vo.name
            this._lb_guild.text = role_vo.guild_id ? `结社：${role_vo.guild_name}` : "暂未加入结社"
            let frame_id = DressModel.GetInstance().GetDressByType(role_vo.dress_list, DressType.Photo)
            this._head.SetRoleVoData(role_vo)

            this._lb_tag.text = _model.GetTagsStr(_model.GetTagListByCookie())

            let second: number = _model.GetConstantData(17)
            let minute = second / 60
            let min_str = second % 60 ? minute.toFixed(1) : minute
            let tips = local_Util.HtmlColorTxt(`等待${min_str}分钟`, Enum_ColorUtil_Dark.GREEN)
            tips = `发布征友信息后需${tips}可再次发布`

            this._lb_tips.style.fontSize = 18
            this._lb_tips.style.align = "center"
            this._lb_tips.width = 344
            this._lb_tips.style.color = "#8B615B"
            this._lb_tips.innerHTML = tips
            SetHtmlCenter(this._lb_tips, { "x": 0, "w": 430 })
            _fri_data_ = _model.GetFriendData(1, role_vo.role_id)
        }

        this.RangeManifesto=()=>{
            if(this.manifesto_list&&this.manifesto_list.length>0){
                let ran= Util.RandomRange(0,this.manifesto_list.length-1)
                console.warn("测试随机数据：",ran)
                return this.manifesto_list[ran]
            }
            return "你好，交个朋友~"
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_go, () => {
                let language_cfg = res_mgr.GetGameConfigFromCache(this, language_cfg_, true)
                let text = this._lb_edit.text
                let filter_callback =(is_filter) =>
                {
                    if (is_filter) {
                        local_Message.show("内容有敏感词")
                        return
                    }
                    if (text == "") {
                        local_Message.show("征友宣言不可以为空")
                        return
                    }
                    let fdata = _fri_data_
                    let time = _model.GetConstantData(17)
                    if (fdata && TimeUtil.getServerTime() - fdata.time < time) {
                        let rtime = TimeUtil.getServerTime() - fdata.time
                        let minute = Math.ceil((time - rtime) / 60)
                        local_Message.show(`${minute}分钟后才能发布交友`)
                        return
                    }
                    _model.Fire(local_MarriageEvent.SEND_ISSUE_INFO, text, 0, _tag_list_)
                }
                local_Util.HasFilterWord(text, language_cfg, filter_callback, 2)
                // this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_cancel, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._lb_change, () => {
                this._lb_edit.text=this.RangeManifesto()
            }, this, true)

            
            local_Util.AddClickEvent(this._lb_tag, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageTagView")
            }, this, true)

            this.BindEvent(_model, local_MarriageEvent.SAVE_TAG, (tag_list) => {
                let str = _model.GetTagsStr(tag_list)
                this._lb_tag.text = str
                _tag_list_ = tag_list
            })
        }

        this.OverCharLimit = () => {
            if (this._lb_edit.text.length > _char_limit_) {
                Message.show(`征友宣言不能超过${_char_limit_}个字`)
            }
        }
    }

    public Open(...parms) {
        // [this._content] = parms
        super.Open()
    }



_img_bg:Laya.Image
_btn_close:Laya.Image
head_con:Laya.Box
_lb_tips:Laya.HTMLDivElement
_lb_name:Laya.Label
_lb_guild:Laya.Label
group2:Laya.Box
img2:Laya.Image
_lb_tag:Laya.Label
group3:Laya.Box
img3:Laya.Image
_lb_edit:Laya.Label
_lb_change:Laya.Label
group4:Laya.HBox
_btn_cancel:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
_btn_go:Laya.Box
_Image11:Laya.Image
labelDisplay1:Laya.Label
public GetComponents() {
[
this._img_bg,
this._btn_close,
this.head_con,
this._lb_tips,
this._lb_name,
this._lb_guild,
this.group2,
this.img2,
this._lb_tag,
this.group3,
this.img3,
this._lb_edit,
this._lb_change,
this.group4,
this._btn_cancel,
this._Image1,
this.labelDisplay,
this._btn_go,
this._Image11,
this.labelDisplay1,
]
 = this.GetChildrenByNames([

"_img_bg",
"_btn_close",
"head_con",
"_lb_tips",
"_lb_name",
"_lb_guild",
"group2",
"img2",
"_lb_tag",
"group3",
"img3",
"_lb_edit",
"_lb_change",
"group4",
"_btn_cancel",
"_Image1",
"labelDisplay",
"_btn_go",
"_Image11",
"labelDisplay1",
])
}
}
 window["MarriageIssueView"]= MarriageIssueView