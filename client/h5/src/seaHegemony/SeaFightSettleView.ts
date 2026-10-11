import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Util, GlobalTimerQuest, SetSizeDeltaY, SetAnchoredPositionY, SetHtmlStyle, HtmlColorTxt } from "../util/Util"

export class SeaFightSettleView extends BaseView1 {

    Local_Open
    InitView
    data
    ClearTimer
    time
    leaveFunc
    timerId
    UpdateLayout
    public constructor() {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaFightSettleView"
        this.layer_value = Enum_UILayer.Activity
        let local_util = Util
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()
        let local_goodsModel = GoodsModel.GetInstance()
        let rankRewardList = null
        let rewardList = null
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.load_callback = () => {
            SetHtmlStyle(this.rankLb, { c: "#663915", f: 20, w: 240, ww: false })
            SetHtmlStyle(this.selfLb, { c: "#663915", f: 20, w: 240, ww: false })
            Util.AddClickEvent(
                this.totalBtn, () => {
                    local_modelIns.Fire(local_model.OPEN_VIEW, "SeaFightTotalView")
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.leaveBtn, () => {
                    local_modelIns.Fire(local_model.REQUEST_PROTO, 18614)
                    this.Close()
                },
                this,
                true
            )
            this.InitView()
        }

        this.Local_Open = (...new_args) => {
            let parms = new_args
            if (parms) {
                this.data = parms[0]
                console.warn(this.data)
            }
            super.Open()
        }

        this.InitView = () => {
            if (this.data && this.is_loaded) {
                let is_win = this.data.status == 1
                let resMgr = ResManager.GetInstance()
                let bg_res = is_win ? "com_up2_bg1" : "com_up2_bg2"
                let title_img = is_win ? "ui_copy_64" : "ui_copy_67"
                let title_war = is_win ? "ui_war_008" : "ui_war_008a"
                let title_rank = is_win ? "ui_rank_008" : "ui_rank_008"
                resMgr.SetOutsideImageSprite(this,this._img_title1,GameResPath.GetIcon("seaHegemony",title_rank))
                resMgr.SetOutsideImageSprite(this,this._img_title2,GameResPath.GetIcon("seaHegemony",title_war))
                resMgr.SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("dungeonCommon", bg_res))
                resMgr.SetImageSprite(this, this._img_title, "dungeonCommon", title_img)



                this.rankLb.innerHTML = `所在结社排名:${HtmlColorTxt(this.data.guild_rank, "'#b03c17'")}`
                this.selfLb.innerHTML = `个人积分排名:${HtmlColorTxt(this.data.self_rank, "'#b03c17'")}`


                this.ClearTimer()
                this.time = 10
                this.timerId = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.leaveFunc()
                }, 1)
                this.leaveFunc()
                if (!rankRewardList) {
                    rankRewardList = []
                }

                // 排名奖励
                let reward = this.data.rank_reward
                let size=85
                let i = 0
                do {
                    let item:BaseAwardItem = new BaseAwardItem(this.Content)
                    item.Load()
                    item.SetItemSize(size,size)
                    let [type_id, bind] = local_goodsModel.GetMappingTypeId(reward[i].style, reward[i].typeId)
                    item.SetData(type_id, reward[i].count)
                    rankRewardList[i] = item
                    i = i + 1
                } while ((i < reward.length))

                this.Content.x=(this.scroller1.width-(reward.length*size+(reward.length-1)*this.Content.space))/2


                // 战场奖励
                reward = this.data.reward

                let boo=reward.length > 0?true:false
                this.UpdateLayout(boo)

                if (!rewardList) {
                    rewardList = []
                }
                for (let i = 0; i < reward.length; i++) {
                    let item:BaseAwardItem = new BaseAwardItem(this.Content1)
                    item.Load()
                    item.SetItemSize(size,size)
                    let [type_id, bind] = local_goodsModel.GetMappingTypeId(reward[i].style, reward[i].typeId)
                    item.SetData(type_id, reward[i].count)
                    rewardList[i] = item
                }

                this.Content1.x=(this.scroller2.width-(reward.length*size+(reward.length-1)*this.Content1.space))/2
            }
        }

        //boo true展示战场奖励  false不展示战场奖励
        this.UpdateLayout=(boo)=>{
            this._img_bg2.visible=this._img_title2.visible=this.scroller2.visible=boo
            if(boo){
                this.bg1.height=605
            }else{
                this.bg1.height=445
            }
            this.leaveBtn.y=this.totalBtn.y=this.bg1.y+this.bg1.height+15
            this._box.height=this.bg1.height+105
        }

        this.ClearTimer = () => {
            if (this.timerId) {
                GlobalTimerQuest.CancelQuest(this.timerId)
                this.timerId = null
            }
        }

        this.leaveFunc = () => {
            if (this.time <= 0) {
                this.ClearTimer()
                this.Close()
            }
            else if (this.labelDisplay) {
                this.time = this.time - 1
                this.labelDisplay.text = `关闭(${this.time})`
            }
        }

        this.close_callback = () => {
            this.ClearTimer()
            if (rewardList) {
                for (let _tmpi in rewardList) {
                    var vo = rewardList[_tmpi]
                    vo.DeleteMe()
                }
                rewardList = null
            }
            if (rankRewardList) {
                for (let _tmpi in rankRewardList) {
                    var vo = rankRewardList[_tmpi]
                    vo.DeleteMe()
                }
                rankRewardList = null
            }
            this.data = null
        }
    }

    public Open(...new_args) {

        this.Local_Open(...new_args)
    }


_box:Laya.Box
bg1:Laya.Image
_img_title:Laya.Image
_img_txt_bg:Laya.Image
_img_txt_tag1:Laya.Image
_img_txt_tag2:Laya.Image
_img_bg1:Laya.Image
_img_title1:Laya.Image
_img_bg2:Laya.Image
_img_title2:Laya.Image
scroller1:Laya.Panel
Content:Laya.HBox
scroller2:Laya.Panel
Content1:Laya.HBox
rankLb:Laya.HTMLDivElement
selfLb:Laya.HTMLDivElement
leaveBtn:Laya.Box
_Image11:Laya.Image
labelDisplay:Laya.Label
totalBtn:Laya.Box
_Image1:Laya.Image
labelDisplay1:Laya.Label
public GetComponents() {
[
this._box,
this.bg1,
this._img_title,
this._img_txt_bg,
this._img_txt_tag1,
this._img_txt_tag2,
this._img_bg1,
this._img_title1,
this._img_bg2,
this._img_title2,
this.scroller1,
this.Content,
this.scroller2,
this.Content1,
this.rankLb,
this.selfLb,
this.leaveBtn,
this._Image11,
this.labelDisplay,
this.totalBtn,
this._Image1,
this.labelDisplay1,
]
 = this.GetChildrenByNames([

"_box",
"bg1",
"_img_title",
"_img_txt_bg",
"_img_txt_tag1",
"_img_txt_tag2",
"_img_bg1",
"_img_title1",
"_img_bg2",
"_img_title2",
"scroller1",
"Content",
"scroller2",
"Content1",
"rankLb",
"selfLb",
"leaveBtn",
"_Image11",
"labelDisplay",
"totalBtn",
"_Image1",
"labelDisplay1",
])
}
}
 window["SeaFightSettleView"]= SeaFightSettleView