import { BaseView1 } from "../common/BaseView1"
import { CommonRuleView } from "../common/CommonRuleView"
import { Enum_UILayer } from "../common/LayerManager"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"

export class CountryMeritView extends BaseView1 {
    InitView
    SetData

    public constructor() {
        super()

        this.base_file = "country"
        this.layout_file = "CountryMeritView"
        this.layer_value = Enum_UILayer.Activity
        this.preload_client_config = { "ClientRuleViewConfig": false }
        this.preload_server_config = { "config_sea_exploit": false }
        this.use_background = true
        this.is_center = true
        this.click_bg_toClose = true
        let local_resMgr = ResManager.GetInstance()
        let local_util = Util
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()
        this.load_callback = () => {
            this._Scroller1.vScrollBarSkin=""
            SetHtmlStyle(this.nextneedLb,{c:"#763320",f:18,w:400,ww:false})
            SetHtmlStyle(this.nexttitle,{c:"#763320",f:18,w:400,ww:false})
            ResManager.GetInstance().SetOutsideImageSprite(this,this.bg,GameResPath.GetIconOtherPath("country","ui_hyzg_bg"))
            this.InitView()
        }

        this.InitView = () => {
            Util.AddClickEvent(
                this.getBtn, () => {
                    MaterialsTool.GetInstance().materialsTips(36255101)
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.ruleBtn, () => {
                    let ruleConfig = local_resMgr.GetGameConfigFromCache(this, "ClientRuleViewConfig", true)
                    if (ruleConfig) {
                        // [ts2lua]ruleConfig下标访问可能不正确
                        let ShowConfig = ruleConfig["seaHegemony"]
                        if (ShowConfig) {
                            let ruleView = new CommonRuleView()
                            // [ts2lua]ShowConfig下标访问可能不正确
                            ruleView.Open(ShowConfig["content"])
                            // [ts2lua]ShowConfig下标访问可能不正确
                            ruleView.SetTitle(ShowConfig["title"])
                        }
                    }
                },
                this,
                true
            )
            this.BindEvent(
                local_modelIns,
                local_model.UPDATE_MERIT_DATA, () => {
                    this.SetData()
                }
            )
            this.SetData()
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18653)
        }

        this.SetData = () => {
            let curData = local_modelIns.meritData
            let cfg = local_resMgr.GetGameConfigFromCache(this, "config_sea_exploit", false)//Config.Seaexploit
            if (curData && cfg) {
                // [ts2lua]cfg下标访问可能不正确
                let curCfg = cfg[curData.lv]
                // [ts2lua]cfg下标访问可能不正确
                let nextCfg = cfg[curData.lv + 1]
                if (curCfg) {
                    let curStr = ""
                    this.posLb.text = curCfg.military_name
                    let propList = JSON.parse(curCfg.attr)
                    let addList = JSON.parse(curCfg.passive_skill)
                    let addStr = ""
                    if (propList.length == 0 && nextCfg) {
                        propList = JSON.parse(nextCfg.attr)
                        this.addLb.text = "暂无加成"
                        this.nulllb.visible=true
                    } else {
                        this.nulllb.visible=false
                        for (let _tmpi in propList) {
                            var vo = propList[_tmpi]

                            let str1=`${WordManager.GetProperties(vo[0])}+${WordManager.ConvertToPercentValue(vo[0], vo[1])}\n`
                            curStr = curStr + str1
                        }
                        for (let _tmpi in addList) {
                            var vo = addList[_tmpi]
                            addStr = addStr + WordManager.ConvertToPercentValue(vo[0], vo[1]) + WordManager.GetProperties(vo[0]) + "\n"
                        }
                        this.addLb.text = "战场场景中增加\n" + addStr
                    }
                    this.propLb.text = Util.StrToHTML(curStr)
                   // this.propLb.style.width=199

                    local_resMgr.SetOutsideImageSprite(this,this.curIcon,GameResPath.GetIconOtherPath("country",curData.lv+""))

                }
                if (nextCfg) {
                    this._Label2.text=`下级军衔【${nextCfg.military_name}】`
                    let exp = JSON.parse(nextCfg.need_exploit)
                    this.nextneedLb.innerHTML = Util.StrToHTML("需要战功:<font color='#c85a37'>" + curData.exploit + "</font>/<font color='#19ae4a'>" + exp[0] + "</font>")
                    this.ruleBtn.x=this.nextneedLb.contextWidth+this.nextneedLb.x+10
                    let addList = JSON.parse(nextCfg.passive_skill)
                    let addStr = ""
                    for (let _tmpi in addList) {
                        var vo = addList[_tmpi]
                        addStr = addStr + WordManager.ConvertToPercentValue(vo[0], vo[1]) + WordManager.GetProperties(vo[0])
                    }

                    this.nexttitle.innerHTML=`军衔加成：战场场景中增加${HtmlColorTxt(addStr,"'#c85a37'")}`
                    local_resMgr.SetOutsideImageSprite(this,this.nextIcon,GameResPath.GetIconOtherPath("country",(curData.lv+1)+""))
                    this.nextGp.visible = true
                } else {
                    this.nextGp.visible = false
                    this._Label2.text=`已满级`
                }
            }
        }
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }



bg:Laya.Image
_img_bg1:Laya.Image
_img_bg2:Laya.Image
closeBtn:Laya.Image
_img1:Laya.Image
_img2:Laya.Image
nulllb:Laya.Label
_Scroller1:Laya.Panel
propLb:Laya.Label
curIcon:Laya.Image
_Image4:Laya.Image
posLb:Laya.Label
_Label1:Laya.Label
addLb:Laya.Label
nextGp:Laya.Box
getBtn:Laya.Box
_Image11:Laya.Image
labelDisplay:Laya.Label
nextIcon:Laya.Image
_Label2:Laya.Label
nextneedLb:Laya.HTMLDivElement
nexttitle:Laya.HTMLDivElement
ruleBtn:Laya.Image
_Image2_title:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this.bg,
this._img_bg1,
this._img_bg2,
this.closeBtn,
this._img1,
this._img2,
this.nulllb,
this._Scroller1,
this.propLb,
this.curIcon,
this._Image4,
this.posLb,
this._Label1,
this.addLb,
this.nextGp,
this.getBtn,
this._Image11,
this.labelDisplay,
this.nextIcon,
this._Label2,
this.nextneedLb,
this.nexttitle,
this.ruleBtn,
this._Image2_title,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"bg",
"_img_bg1",
"_img_bg2",
"closeBtn",
"_img1",
"_img2",
"nulllb",
"_Scroller1",
"propLb",
"curIcon",
"_Image4",
"posLb",
"_Label1",
"addLb",
"nextGp",
"getBtn",
"_Image11",
"labelDisplay",
"nextIcon",
"_Label2",
"nextneedLb",
"nexttitle",
"ruleBtn",
"_Image2_title",
"_lb_win_name",
])
}
}
 window["CountryMeritView"]= CountryMeritView