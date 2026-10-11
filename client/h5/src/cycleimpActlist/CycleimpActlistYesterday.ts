import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"
import { BaseItem1 } from "../common/BaseItem1"
import { CycleimpActlistYesterdayItem } from "./CycleimpActlistYesterdayitem"
import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { TimeUtil } from "../util/TimeUtil"

export class CycleimpActlistYesterday extends BaseView1 {
    _img_bg: Laya.Image
    _Image1: Laya.Image
    _btn_close: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Label1: Laya.Label
    _Label2: Laya.Label
    _lb_level_desc: Laya.Label
    _Label3: Laya.Label
    _lb_none: Laya.Label
    Content: Laya.List
    _Image4: Laya.Image
    _Group1: Laya.HBox
    _Label4: Laya.Label
    _lb_rank: Laya.Label
    _Label5: Laya.Label
    _lb_level: Laya.HTMLDivElement
    title_bg: Laya.Image
    lb_title: Laya.HTMLDivElement

    InitEvent
    LoadSuccess
    UpdateView
    change_scene_close
    click_bg_toClose
    close_callback
    is_center
    loop_mgr
    open_callback
    show_open_movie
    use_background

    public constructor() {
        super()

        let rank_data_ = null
        this.base_file = "cycleimpActlist"
        this.layout_file = "CycleimpActlistYesterday"
        this.layer_value = Enum_UILayer.Activity
        let model = CycleimpActlistModel.GetInstance()
        this.is_center = true
        this.change_scene_close = true
        this.show_open_movie = true
        this.use_background = true
        this.click_bg_toClose = true
        let type = model.type
        let subtype = model.subtype
        this.preload_server_config = {
            "config_cycle_rank_reward": false
        }
        this.load_callback = () => {

            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = () => {
            this.UpdateView()
        }

        this.close_callback = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = null
            }
        }
        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("cycleimpActlist", "uijjsh_017"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this.title_bg, GameResPath.GetIcon("cycleimpActlist", "ui_activity_07"))
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)
        }

        this.UpdateView = () => {
            rank_data_ = model.GetYesterdayInfo()
            if (!rank_data_) {
                return
            }
            let bool = rank_data_ && rank_data_.length == 0
            this.Content.visible = !bool
            this._lb_none.visible = bool
            let level_desc = null
            if (1 == rank_data_.type) {
                level_desc = "坐骑"
            } else if (2 == rank_data_.type) {
                level_desc = "侍魂"
            } else if (3 == rank_data_.type) {
                level_desc = "羽翼"
            } else if (4 == rank_data_.type) {
                level_desc = "御守"
            } else if (5 == rank_data_.type) {
                level_desc = "神兵"
            } else if (6 == rank_data_.type) {
                level_desc = "背饰"
            } else if (7 == rank_data_.type) {
                level_desc = ""
            }
            this._lb_level_desc.text = level_desc
            this.lb_title.innerHTML = TimeUtil.timeConversion(TimeUtil.getServerTime() - 3600 * 24) + "<font color = '#0a953e'>" + level_desc + "培养</font>榜单排名已截止"
            this.lb_title.x = 554 / 2 - this.lb_title.contextWidth / 2;
            let isRank: boolean = (rank_data_.rank && rank_data_.rank != 0);
            this._lb_rank.text = isRank && rank_data_.rank || "未上榜";
            this._Label5.visible = rank_data_?.rank > 0;
            this._Label5.text = rank_data_.score + "分";
            if (bool) {
                return
            }

            let list = rank_data_.rank_list
            let temp_list = []
            let max_num = 10
            let is_have_role = false
            let i = 1
            do {
                is_have_role = false
                for (let key in list) {
                    if (list[key].rank == i) {
                        is_have_role = true
                        list[key].type = rank_data_.type
                        list[key].subtype = rank_data_.subtype
                        temp_list.push(list[key])
                        break
                    }
                }
                if (!is_have_role) {
                    let temp = { rank: i, type: rank_data_.type, subtype: rank_data_.subtype }
                    temp_list.push(temp)
                    table.insert(list, temp)
                }
                i++
            } while (i <= max_num)
            table.sort(list, (a?, b?) => {
                if (a.rank != b.rank) {
                    return a.rank < b.rank
                }
                return false
            })

            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.Content, CycleimpActlistYesterdayItem, temp_list, LoopScrCon.Vertical)
            } else {
                this.loop_mgr.replaceAll(temp_list)
            }

        }

    }

    public GetComponents() {
        [
            this._img_bg,
            this._Image1,
            this._btn_close,
            this._Image2,
            this._Image3,
            this._Label1,
            this._Label2,
            this._lb_level_desc,
            this._Label3,
            this._lb_none,
            this.Content,
            this._Image4,
            this._Group1,
            this._Label4,
            this._lb_rank,
            this._Label5,
            this._lb_level,
            this.title_bg,
            this.lb_title
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_Image1",
                "_btn_close",
                "_Image2",
                "_Image3",
                "_Label1",
                "_Label2",
                "_lb_level_desc",
                "_Label3",
                "_lb_none",
                "Content",
                "_Image4",
                "_Group1",
                "_Label4",
                "_lb_rank",
                "_Label5",
                "_lb_level",
                "title_bg",
                "lb_title"
            ])
        this.lb_title.style.fontSize = 20
        this.lb_title.style.color = "#763320"
        this.lb_title.style.wordWrap = false

    }
}
window["CycleimpActlistYesterday"] = CycleimpActlistYesterday