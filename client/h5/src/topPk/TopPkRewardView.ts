import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { TopPkModel } from "../commonModel/TopPkModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { TopPkDailyRewardItem } from "./TopPkDailyRewardItem"
import { TopPkDailyRewardView } from "./TopPkDailyRewardView"
import { TopPkLevelRewardView } from "./TopPkLevelRewardView"
import { TopPkRankRewardView } from "./TopPkRankRewardView"
import { TopPkRewardTabItem } from "./TopPkRewardTabItem"

export class TopPkRewardView extends BaseView1 {
    _Image1: Laya.Image
    _Image4: Laya.Image
    _Group1: Laya.Box
    _Image2: Laya.Image
    _Label1: Laya.Label
    _Image3: Laya.Image
    _gp_con: Laya.Box
    _list_tab_con: Laya.Image
    Content: Laya.List
    _img_close: Laya.Image
    InitEvent
    InitTab
    InitView
    LoadSuccess
    Remove
    Scr_Scroller1
    SwitchTab
    UpdateTabRed
    UpdateView
    loop_mgr

    public constructor() {
        super()


        this.base_file = "topPk"
        this.layout_file = "TopPkRewardView"
        this.layer_value = Enum_UILayer.Activity
        this.change_scene_close = true
        this.use_background = true
        this.is_center = true
        this.destroy_imm = true
        this.show_open_movie = true
        this.click_bg_toClose = true
        let model = TopPkModel.GetInstance()
        let local_TopPkModel = TopPkModel
        let tab_arr_ = null
        let default_index_ = 0
        let now_index_ = null
        let item_list_ = null
        let tab_name_list_ = [{ name: "段位奖励", red_flag: TopPkModel.RedFlag.Level_Reward }, { name: "排名奖励", red_flag: null }, { name: "每日奖励", red_flag: TopPkModel.RedFlag.Daily_Reward }]
        let tab_list_ = null
        this.load_callback = () => {

            this.LoadSuccess()
        }

        this.destroy_callback = () => {
            this.Remove()
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this,this._Image1,GameResPath.GetIcon("topPk","bg_03"))

            this.InitEvent()
            this.InitView()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._img_close, () => {
                this.Close()
            }
                , this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
            //this:BindEvent(model, FriendInviteModel.REFRESH_TAB_DOT,(type?, state?) => {
            //this:UpdateTabRed(type, state)
            //}
            //)
            this.BindEvent(model, local_TopPkModel.REFRESH_RED_FLAG, (flag?) => {
                let bool = model.HasRedFlag(flag)
                if (flag == local_TopPkModel.RedFlag.Level_Reward) {
                    this.UpdateTabRed(1, bool)
                } else if (flag == local_TopPkModel.RedFlag.Daily_Reward) {
                    this.UpdateTabRed(3, bool)
                }
            }
            )
        }

        this.InitView = () => {
            this.InitTab()
            this.SwitchTab(default_index_, true)
            this.loop_mgr.SetSelectIndex(default_index_)
        }

        this.InitTab = () => {
            if (!tab_list_) {
                tab_list_ = []
            }
            for (let key in tab_name_list_) {

                // [ts2lua]tab_name_list_下标访问可能不正确
                let obj = tab_name_list_[key]
                table.insert(tab_list_, {
                    name: obj.name, red_state: model.HasRedFlag(obj.red_flag)
                })
            }
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.Content, TopPkRewardTabItem, tab_list_, LoopScrCon.Horizontal,1, () => {
                    this.SwitchTab()
                })
            } else {
                this.loop_mgr.replaceAll(tab_list_)

            }
        }

        this.UpdateView = () => {
            if (!item_list_) {
                item_list_ = []
            }
            // [ts2lua]item_list_下标访问可能不正确
            let item = item_list_[now_index_]
            if (!item) {
                if (0 == now_index_) {
                    item = new TopPkLevelRewardView(this._gp_con)
                } else if (1 == now_index_) {
                    item = new TopPkRankRewardView(this._gp_con)
                } else if (2 == now_index_) {
                    item = new TopPkDailyRewardView(this._gp_con)
                }
                // [ts2lua]item_list_下标访问可能不正确
                item_list_[now_index_] = item
                item.Load()
            }
            this.PopUpChild(item)
        }

        this.SwitchTab = (is_index?) => {
            if (is_index == null) {
                is_index = false
            }
            // [ts2lua]lua中0和空字符串也是true，此处is_index需要确认
            let index = is_index || this.Content.selectedIndex
            if (now_index_ == index) {
                return
            }
            now_index_ = index
            this.UpdateView()
        }

        this.Remove = () => {

            if (item_list_) {
                for (let _tmpi in item_list_) {
                    var obj = item_list_[_tmpi]
                    if (obj) {
                        obj.DeleteMe()
                    }
                }
                item_list_ = null
            }
            now_index_ = null
            tab_list_ = null
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = null
            }
        }

        this.UpdateTabRed = (type?, state?) => {
            // [ts2lua]tab_list_下标访问可能不正确
            if (tab_list_ && tab_list_[type - 1]) {
                // [ts2lua]tab_list_下标访问可能不正确
                tab_list_[type - 1].red_state = state
                if (!this.loop_mgr) {
                    this.loop_mgr = new LoopScrowViewMgr()
                    this.loop_mgr.SetData(this.Content, TopPkRewardTabItem, tab_list_, LoopScrCon.Horizontal)
                } else {
                    this.loop_mgr.replaceAll(tab_list_)

                }
            }
        }


    }




    public GetComponents() {
        [
            this._Image1,
            this._Image4,
            this._Group1,
            this._Image2,
            this._Label1,
            this._Image3,
            this._gp_con,
            this._list_tab_con,
            this.Content,
            this._img_close,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image4",
                "_Group1",
                "_Image2",
                "_Label1",
                "_Image3",
                "_gp_con",
                "_list_tab_con",
                "Content",
                "_img_close",
            ])
    }
}
window["TopPkRewardView"] = TopPkRewardView