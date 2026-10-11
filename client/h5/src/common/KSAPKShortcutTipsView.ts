import { PlatformManager } from "../PlatformManager";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { BaseView1 } from "./BaseView1";
import { CommonRewardItem } from "./CommonRewardItem";
import { Config } from "./Config";
import { Enum_UILayer } from "./LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "./LoopScrowViewMgr";
import { ResManager } from "./ResManager";

class KSAPKShortcutTipsView extends BaseView1 {

    LoadSuccess
    InitEvent

    item_loop_mgr
    public constructor() {
        super()
        this.base_file = "common";
        this.layout_file = "KSAPKShortcutTipsView";
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        this.show_open_movie = true;
        this.is_center = true

        this.load_callback = function () {
            this.LoadSuccess();

        }
        this.destroy_callback = function () {
            if (this.item_loop_mgr) {
				this.item_loop_mgr.DeleteMe()
				this.item_loop_mgr = undefined
			}
        }
        this.LoadSuccess = () => {
            //resource/game/alert/other/uisy_023.png
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("alert", "uisy_023"))

            PlatformManager.GetInstance().CancelAPKShourtcutTimer()

            

            let cfgs = Config.PRELOAD_SERVER_CONFIG.config_wx_kv
            let list = []
            if (cfgs && cfgs["13"]) {
                list = JSON.parse(cfgs["13"].value)
            }

            let pre_reward_list = []
            for (let vo of list) {
                pre_reward_list.push({
                    size: 87,
                    vo: {
                        style: vo[0],
                        typeId: vo[1],
                        count: vo[2]
                    }
                })
            }

            this.item_loop_mgr = new LoopScrowViewMgr()
            this.item_loop_mgr.SetData(this._list_reward, CommonRewardItem, pre_reward_list, LoopScrCon.Horizontal, 1)

            let len = pre_reward_list.length

            if (len > 5)
                len = 5
        
            this._list_reward.width = len * 87 + (len - 1) * 5

            this.InitEvent();
        }

        this.InitEvent = () => {
            let close_fun = () => {
                this.Close()
            }
            Util.AddClickEvent(this._img_close, close_fun, this, true)


            let save_fun = () => {
                PlatformManager.GetInstance().SaveAPKShortcut(() => {
                    this.Close()
                })
            }
            Util.AddClickEvent(this._img_save, save_fun, this, true)
        }
    }
    _img_bg: Laya.Image
    _list_reward: Laya.List
    _img_close: Laya.Image
    _img_save: Laya.Image
    _lb_ok: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._list_reward,
            this._img_close,
            this._img_save,
            this._lb_ok,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_list_reward",
                "_img_close",
                "_img_save",
                "_lb_ok",
            ])
    }
}
window["KSAPKShortcutTipsView"] = KSAPKShortcutTipsView