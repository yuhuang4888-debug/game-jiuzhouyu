import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SeaAppointItem } from "./SeaAppointItem"
import { SeaAppointTab } from "./SeaAppointTab"

export class SeaAppointView extends BaseView1 {

    InitView
    positonArr
    SelectPositon
    peopleArr
    public constructor() {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaAppointView"
        this.layer_value = Enum_UILayer.Activity
        this.preload_server_config = { "config_seacraft_daily_reward": false }
        let local_util = Util
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.destroy_imm = true
        this.load_callback = () => {

            this.InitView()
        }

        this.InitView = () => {
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.saveBtn, () => {
                    local_modelIns.Fire(local_model.APPOINT)
                    this.Close()
                },
                this,
                true
            )
            let tabData = []
            let peopleData = []
            let data = local_modelIns.seaSoldierData
            local_modelIns.selectInfo = []
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seacraft_daily_reward", false)// Config.Seacraftdailyreward
            if (cfg) {
                for (let key in cfg) {

                    // [ts2lua]cfg下标访问可能不正确
                    let vo = cfg[key]
                    if (vo.level >= 2 && vo.level < 5) {
                        table.insert(tabData, [vo.level, vo.name, vo.limit])
                    }
                }
                if (data) {
                    let realData = []
                    let role_id = RoleManager.GetInstance().GetMainRoleId()
                    for (let _tmpi in data.job_list) {
                        var vo = data.job_list[_tmpi]
                        if (vo.self_level < 6) {
                            // [ts2lua]local_modelIns.selectInfo下标访问可能不正确
                            let info = local_modelIns.selectInfo[vo.self_level]
                            if (!info) {
                                // [ts2lua]cfg下标访问可能不正确
                                info = { limit: cfg[vo.self_level].limit, level: vo.self_level, num: 1, people: [vo.role_id] }
                                // [ts2lua]local_modelIns.selectInfo下标访问可能不正确
                                local_modelIns.selectInfo[vo.self_level] = info
                            } else {
                                info.num = info.num + 1
                                table.insert(info.people, vo.role_id)
                            }
                        }
                        if (role_id != vo.role_id) {
                            table.insert(realData, vo)
                        }
                    }
                    peopleData = realData
                    this.noImg.visible = realData.length == 0
                    this.noLb.visible = realData.length == 0
                }
            }
            this.positonArr = new LoopScrowViewMgr()
            this.positonArr.SetData(this.Content1, SeaAppointTab, tabData, LoopScrCon.Vertical, 1, (item?) => {
                let lv = tabData[item][0]
                this.SelectPositon(lv)
            })

            this.peopleArr = new LoopScrowViewMgr()
            this.peopleArr.SetData(this.Content, SeaAppointItem, peopleData, LoopScrCon.Vertical, 1)

            if (tabData[0]) {
                this.SelectPositon(tabData[0][0])
                this.positonArr.SetSelectIndex(0)
            }

        }

        this.SelectPositon = (index?) => {
            //if (this.positonArr.select_index != index ) {
            local_modelIns.selectingPosition = index
            local_modelIns.Fire(local_model.SELECT_POSITION, index)
            //}
        }

        this.destroy_callback = () => {
            local_modelIns.selectInfo = []

            if (this.peopleArr) {
                this.peopleArr.DeleteMe()
                this.peopleArr = null
            }

            if (this.positonArr) {
                this.positonArr.DeleteMe()
                this.positonArr = null
            }
        }
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }


bg:Laya.Image
_Image1:Laya.Image
closeBtn:Laya.Image
_Image3:Laya.Image
_Image4:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
Content:Laya.List
Content1:Laya.List
saveBtn:Laya.Box
_Image11:Laya.Image
labelDisplay:Laya.Label
noLb:Laya.Label
noImg:Laya.Image
_Image2_title:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this.bg,
this._Image1,
this.closeBtn,
this._Image3,
this._Image4,
this._Label1,
this._Label2,
this._Label3,
this.Content,
this.Content1,
this.saveBtn,
this._Image11,
this.labelDisplay,
this.noLb,
this.noImg,
this._Image2_title,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"bg",
"_Image1",
"closeBtn",
"_Image3",
"_Image4",
"_Label1",
"_Label2",
"_Label3",
"Content",
"Content1",
"saveBtn",
"_Image11",
"labelDisplay",
"noLb",
"noImg",
"_Image2_title",
"_lb_win_name",
])
}
}
 window["SeaAppointView"]= SeaAppointView