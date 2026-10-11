import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { FirstBloodEvent, FirstBloodModel } from "../commonModel/FirstBloodModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { DungeonRuneFirstItem } from "./DungeonRuneFirstItem"
import { DungeonRuneFirstTab } from "./DungeonRuneFirstTab"

export class DungeonRuneFirstView extends BaseView1 {


    tab_data
    selectIndex
    tab_loop_mgr
    item_list
    item_loop_mgr
    model
    click_time
    fmodel
    public constructor() {
        super()
        this.base_file = "dungeonRune"
        this.layout_file = "DungeonRuneFirstView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.click_bg_toClose = true
        this.model = BaseDungeonModel.GetInstance()
        this.fmodel = FirstBloodModel.GetInstance()
        this.is_center = true

        this.selectIndex = 0
        this.item_list = []
        this.preload_server_config = {
            config_boss_first_blood_plus_boss: false
        }
        this.load_callback = () => {
            this.LoadSuccess()
        }
        this.open_callback = () =>{
            this.InitTab()
        }
        this.close_callback = () =>{
            this.selectIndex = 0
        }
        this.destroy_callback = () => {
            this.Remove()
        }
    }

    public InitEvent() {
        Util.AddClickEvent(this._img_close, () => {
            this.Close()
        }, this, true)

        Util.AddClickEvent(this._box_get, () => {
            let time = TimeUtil.getServerTime()
            if (this.click_time > 0 && time - this.click_time < 0.2) {
                //Message.show("点击过快")
                return
            }
            this.click_time = time

            let cfg = this.tab_data[this.selectIndex]
            if (cfg) {
                this.fmodel.Fire(FirstBloodEvent.REQUEST_PROTO, 18802, "cci", cfg.type, cfg.sub_type, cfg.object_id)
            }
        }, this, true)

        this.BindEvent(this.fmodel, FirstBloodEvent.UPDATE_RUNE_DATA, () => {
            this.InitItem()
            this.InitReward()
            this.UpdateRed()
        })

        this.BindEvent(this.fmodel, FirstBloodEvent.UPDATE_RUNE_RED, () => {
            this.InitTab()
            this.UpdateRed()
        })
    }

    public LoadSuccess() {
        this._img_bg2.skin = GameResPath.GetIcon("common", "bg_04")
        this._img_bg3.skin = GameResPath.GetIcon("common2", "com_title_bg_1")
        // this._img_bg4.skin = GameResPath.GetIcon("dungeonRune", "uifwt_011")
        // ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("common", "bg_04"))
        // ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg3, GameResPath.GetIcon("common2", "com_title_bg_1"))
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg4, GameResPath.GetIcon("dungeonRune", "uifwt_011"))

        this._panel_reward.hScrollBarSkin = ""
        this.InitEvent()
    }

    public InitTab() {
        let config_boss_first_blood_plus_boss = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_first_blood_plus_boss", false)
        this.tab_data = this.model.GetRuneFirstTab(config_boss_first_blood_plus_boss)
        if (!this.tab_loop_mgr) {
            this.tab_loop_mgr = new LoopScrowViewMgr()
            this.tab_loop_mgr.SetData(this._list_tab, DungeonRuneFirstTab, this.tab_data, LoopScrCon.Vertical, null, (index) => {
                this.TabTouch(index)
            })
            this.tab_loop_mgr.SetSelectIndex(this.selectIndex)
        } else {
            this.selectIndex = this.model.GetRuneFirstTabIndex(this.tab_data)
            this.tab_loop_mgr.replaceAll(this.tab_data)
            this.tab_loop_mgr.FirstOnChild(this.selectIndex)
            this.tab_loop_mgr.SetSelectIndex(this.selectIndex)
        }
        this.ReqestViewData()
    }

    public TabTouch = (real_index?) => {
        if (real_index == this.selectIndex) {
            return
        }
        this.selectIndex = real_index
        this.ReqestViewData()
    }


    public ReqestViewData() {
        let cfg = this.tab_data[this.selectIndex]
        if (cfg) {
            this.fmodel.Fire(FirstBloodEvent.REQUEST_PROTO, 18804, "cci", cfg.type, cfg.sub_type, cfg.object_id)
        }
    }


    public InitItem() {
        let data = []
        let fdata: any = []
        let cfg = this.tab_data[this.selectIndex]
        if (cfg) {
            fdata = this.fmodel.GetRuneFirstData(cfg.type, cfg.sub_type, cfg.object_id)
            fdata = fdata && fdata.pass_role_list || []
            if (fdata != []) {
                table.sort(fdata, (a?, b?) => {
                    return a.rank < b.rank
                })
            }
        }
        let max = 5
        for (let i = 0; i < max; i++) {
            let rankData = fdata[i]
            if (rankData) {
                table.insert(data, rankData)
            } else {
                table.insert(data, { none: true })
            }
        }

        if (!this.item_loop_mgr) {
            this.item_loop_mgr = new LoopScrowViewMgr()
            this.item_loop_mgr.SetData(this._list_item, DungeonRuneFirstItem, data, LoopScrCon.Vertical)
        } else {
            this.item_loop_mgr.replaceAll(data)
        }

    }

    public InitReward() {
        let tabCfg = this.tab_data[this.selectIndex]
        let roleid = 0
        let cfg = this.tab_data[this.selectIndex]
        if (cfg) {
            let fdata = this.fmodel.GetRuneFirstData(cfg.type, cfg.sub_type, cfg.object_id)
            if (fdata) {
                table.sort(fdata.pass_role_list, (a?, b?) => {
                    return a.rank < b.rank
                })
            }
            roleid = (fdata && fdata.pass_role_list[1]) && fdata.pass_role_list[1].role_id || 0
        }
        let main_role_id = RoleManager.GetInstance().GetMainRoleId()

        let rewardList = ErlangParser.GetInstance().Parse((main_role_id == roleid || roleid == 0) && tabCfg.whole_first_blood_reward || tabCfg.own_reward)
        for (let i in rewardList) {
            var reward = rewardList[i]
            let item = this.item_list[i]
            if (!item) {
                item = new EquipmentItem(this._panel_reward)
                item.Load()
                item.SetScale(0.67)
                item.SetUseMask(true)
                table.insert(this.item_list, item)
            }
            item.ExcuteCallback(() => {
                item.SetVisible(true)
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
                let vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                if (vo) {
                    item.SetData(type_id, reward[2])
                }
            }
            )
            item.SetPosition(Number(i) * 87, 0)
        }

        let j = this.item_list.length
        if (j > rewardList.length) {
            do {
                let item = this.item_list[j - 1]
                item.SetVisible(false)
                j = j - 1
            } while ((j > rewardList.length)
            )
        }
    }

    public UpdateRed() {
        let data = this.tab_data[this.selectIndex]
        if(!data) return
        let red = this.fmodel.GetRuneFirstRed(data.object_id)
        this._img_get_red.visible = red
        let get = this.fmodel.GetRuneFirstHave(data.object_id)
        Util.SetImageGray(this._box_get, !red)
        this._box_get.mouseEnabled = red
        let text = "未达成"
        if (red) {
            text = "领取"
        } else if (get) {
            text = "已领取"
        }
        this._lb_get.text = text
    }

    public Remove() {

        if (this.tab_loop_mgr) {
            this.tab_loop_mgr.DeleteMe()
            this.tab_loop_mgr = null
        }

        if (this.item_loop_mgr) {
            this.item_loop_mgr.DeleteMe()
            this.item_loop_mgr = null
        }

        for (let i in this.item_list) {
            var item = this.item_list[i]
            item.DeleteMe()
        }
        this.item_list = []
    }



    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _img_bg3: Laya.Image
    _img_bg4: Laya.Image
    _img_bg5: Laya.Image
    _img_close: Laya.Image
    _lb_title: Laya.Label
    _lb_title2: Laya.Label
    _lb_title3: Laya.Label
    _box_get: Laya.Box
    _img_get: Laya.Image
    _lb_get: Laya.Label
    _img_get_red: Laya.Image
    _list_tab: Laya.List
    _list_item: Laya.List
    _panel_reward: Laya.Panel
    public GetComponents() {
        [
            this._img_bg,
            this._img_bg2,
            this._img_bg3,
            this._img_bg4,
            this._img_bg5,
            this._img_close,
            this._lb_title,
            this._lb_title2,
            this._lb_title3,
            this._box_get,
            this._img_get,
            this._lb_get,
            this._img_get_red,
            this._list_tab,
            this._list_item,
            this._panel_reward,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_bg2",
                "_img_bg3",
                "_img_bg4",
                "_img_bg5",
                "_img_close",
                "_lb_title",
                "_lb_title2",
                "_lb_title3",
                "_box_get",
                "_img_get",
                "_lb_get",
                "_img_get_red",
                "_list_tab",
                "_list_item",
                "_panel_reward",
            ])
    }
}
window["DungeonRuneFirstView"] = DungeonRuneFirstView
