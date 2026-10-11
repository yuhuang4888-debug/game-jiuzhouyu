import { EquipmentIcon } from "../bag/EquipmentIcon"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class FeastBossEnterView extends BaseItem1 {
    rules: Laya.Label
    time: Laya.HTMLDivElement
    _title: Laya.Image
    _Image11: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Scroller1: Laya.Panel
    Content: Laya.HBox
    enterBtnGroup: Laya.Box
    btn_effect: Laya.Box
    red_dot: Laya.Image
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    time_conta: Laya.Box
    _Image4: Laya.Image
    _gp_time: Laya.Box
    _Group1: Laya.Box
    _Image5: Laya.Image
    activity_time_lb: Laya.Label
    bg1: Laya.Image
    AddRewards
    CancelTimer
    Dispose
    InitEvents
    LoadSuccess
    OnTime
    Scr_Scroller1
    SetAwardList
    SetData
    StartTimer
    UpdateActivityTime
    UpdateTime
    _type
    act_info
    count_time_id
    end_time
    model
    now_str: String
    scroll_group
    timer
    item_list: any

    public constructor(parent?) {
        super(parent)

        this.base_file = "feastBoss"
        this.layout_file = "FeastBossEnterView"
        this.model = BossModel.GetInstance()
        let local_BossBaseModel = BossModel
        let custom_activity_model = CustomActivityModel.GetInstance()
        let local_TimeUtil = TimeUtil
        this.load_callback = () => {
            this._Scroller1.hScrollBar.visible = false
            this.time.style.fontSize = 20
            this.time.style.valign = "center"
            this.time.style.color = "#a0ff67"
            this.time.style.wordWrap = false
            this.LoadSuccess()
            this.InitEvents()
        }

        this.Dispose = () => {
            if (this.item_list) {
                for (let _tmpi in this.item_list) {
                    var obj = this.item_list[_tmpi]
                    obj.DeleteMe()
                }
            }
            this.item_list = null
            this.CancelTimer()
            if (this.timer) {
                this.timer.DeleteMe()
            }
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIconOtherPath("feastBoss", "uigwgc_004"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11, GameResPath.GetIconOtherPath("feastBoss", "uigwgc_004"))
            this.item_list = []
            //this.model.Fire(local_BossBaseModel.SCMD_REQUEST, 46026)
            let str = "1.怪物从传送门中源源不断地走出,你需要保护好你的水晶.\n2.每60秒刷新一波大妖,共10波.\n3.击杀大妖会掉落宝箱,采集宝箱可获得丰厚奖励."
            this.rules.text = Util.StrToHTML(str)
        }

        this.InitEvents = () => {
            let enter_fun = () => {
                this.model.Fire(local_BossBaseModel.SCMD_REQUEST, 46003, local_BossBaseModel.BossType.feast, 0)
            }

            Util.AddClickEvent(this.enterBtnGroup, enter_fun, this, true)
            this.SetData()
        }

        this.SetData = () => {
            // [ts2lua]local_BossBaseModel:GetInstance().timer_mark_dic下标访问可能不正确
            let sub_type = local_BossBaseModel.GetInstance().timer_mark_dic[local_BossBaseModel.FEAST_BOSS_ID]
            if (!this.is_loaded || sub_type == null) {
                return
            }
            this.act_info = custom_activity_model.GetActInfo(local_BossBaseModel.FEAST_BOSS_ID, sub_type)
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
            if (cfg && this.act_info) {
                CustomActivityModel.GetInstance().LoadCompontRes(this, cfg, "FeastBossEnterView", this.act_info.show_id)
            }
            custom_activity_model.CloseACTRed(this.act_info.base_type, this.act_info.sub_type, null, this.act_info.show_id)
            this.UpdateTime()
            this.timer = custom_activity_model.LoadActTimer(this._gp_time, this.act_info.etime, 20, "#a0ff67", null, "#ffffff", "活动剩余时间：")
            this.SetAwardList()
        }

        this.UpdateTime = () => {
            this.CancelTimer()
            let [is_in_activity_time, left_time, next_open_time, next_open_time_sec] = this.model.GetFeastBossTime(this.act_info.base_type, this.act_info.sub_type)
            if (is_in_activity_time) {
                this.StartTimer(2, is_in_activity_time, left_time || 0)
            } else {
                this.StartTimer(1, is_in_activity_time, next_open_time_sec || 0)
            }
        }

        this.StartTimer = (_type?, str?, end_time?) => {
            this.count_time_id = GlobalTimerQuest.AddPeriodQuest(() => {
                this.OnTime()
            }, 1)
            this._type = _type
            this.now_str = str
            this.end_time = end_time
            this.OnTime()
        }

        this.OnTime = () => {
            if (this.end_time != null) {
                let time = this.end_time - TimeUtil.getServerTime()
                if (this.end_time <= 0) {
                    this.CancelTimer()
                    this.time.innerHTML = ""
                    //this:UpdateTime()
                } else {
                    let str
                    if (this.now_str) {
                        str = `剩余活动时间：<font color='#a0ff67'>${local_TimeUtil.convertTime(time)}</font>`
                    } else {
                        str = `大妖的攻势将在<font color='#a0ff67'>${local_TimeUtil.convertTime(time)}</font>后到来`
                    }

                    this.time.innerHTML = Util.StrToHTML(str)
                }
                let a = <Laya.HBox>this.time.parent
                if (a)
                    a.refresh()
            } else {
                this.CancelTimer()
            }
        }

        this.CancelTimer = () => {
            if (this.count_time_id) {
                GlobalTimerQuest.CancelQuest(this.count_time_id)
                this.count_time_id = null
            }
        }

        this.SetAwardList = () => {
            let list = custom_activity_model.cache_scmd_33101_list
            for (let _tmpi in list) {
                var vo = list[_tmpi]
                if (vo.base_type == Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.FEASTBOSS) {
                    let cfg = ErlangParser.GetInstance().Parse(vo.condition)
                    for (let _tmpi in cfg) {
                        var content = cfg[_tmpi]
                        if (content[0] == "show_reward") {
                            let reward_list = content[1]
                            this.AddRewards(reward_list)
                        }
                        else if (content[0] == "time") {
                            let time_list = content[1]
                            this.UpdateActivityTime(time_list)
                        }
                    }
                }
            }
        }

        this.AddRewards = (reward_list?) => {
            let item: EquipmentItem = null
            let i = 0
            do {
                item = this.item_list[i]
                if (!item) {
                    item = new EquipmentItem(this.Content)
                    this.item_list[i] = item
                    item.Load()
                    item.SetItemSize(100, 100)
                }
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(Number(reward_list[i][0]), Number(reward_list[i][1]))
                item.SetData(type_id, Number(reward_list[i][2]))
                i = i + 1
            } while ((i < reward_list.length))
        }

        this.UpdateActivityTime = (time_list?) => {
            let time = "活动时间：每天"
            let i = 0
            do {
                let hour = time_list[i][0][0]
                // [ts2lua]lua中0和空字符串也是true，此处Number(time_list[i][0][1]) == 0需要确认
                let minute = (Number(time_list[i][0][1]) == 0 && (":00") || (":" + time_list[i][0][1]))
                let time_open = hour + minute
                if (i < time_list.length - 1) {
                    time = time + time_open + "、"
                } else {
                    time = time + time_open
                }
                i = i + 1
            } while ((i < time_list.length))
            this.activity_time_lb.text = time
        }
    }

    public DeleteMe() {

        this.Dispose()
        super.DeleteMe()
    }


    public GetComponents() {
        [
            this.rules,
            this.time,
            this._title,
            this._Image11,
            this._Image2,
            this._Image3,
            this._Scroller1,
            this.Content,
            this.enterBtnGroup,
            this.btn_effect,
            this.red_dot,
            this._Image1,
            this.labelDisplay,
            this.time_conta,
            this._Image4,
            this._gp_time,
            this._Group1,
            this._Image5,
            this.activity_time_lb,
            this.bg1
        ]
            = this.GetChildrenByNames([

                "rules",
                "time",
                "_title",
                "_Image11",
                "_Image2",
                "_Image3",
                "_Scroller1",
                "Content",
                "enterBtnGroup",
                "btn_effect",
                "red_dot",
                "_Image1",
                "labelDisplay",
                "time_conta",
                "_Image4",
                "_gp_time",
                "_Group1",
                "_Image5",
                "activity_time_lb",
                "bg1"
            ])
    }
}
window["FeastBossEnterView"] = FeastBossEnterView