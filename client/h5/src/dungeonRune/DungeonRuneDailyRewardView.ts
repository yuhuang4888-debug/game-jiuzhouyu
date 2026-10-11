import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
export class DungeonRuneDailyRewardView extends BaseView1 {

    item_list = []
    click_time
    model: BaseDungeonModel = BaseDungeonModel.GetInstance()

    public constructor() {
        super()
        this.base_file = "dungeonRune"
        this.layout_file = "DungeonRuneDailyRewardView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.click_bg_toClose = true
        this.change_scene_close = true
        this.is_center = true
        this.show_open_movie = true

        this.load_callback = () => {
            this.LoadSuccess()
        }
        this.open_callback = () => {
            this.UpdateView()
        }
        this.close_callback = () => {
        }
        this.destroy_callback = () => {
            this.Remove()
        }
    }

    public InitEvent() {
        Util.AddClickEvent(this._img_close, () => {
            this.Close()
        }, this, true)

        Util.AddClickEvent(this._img_continue, () => {
            let challenge_data = this.model.GetRuneChallengeData()
            if (challenge_data) {

                if (SceneManager.GetInstance().IsSuitBossScene()) {
                    Message.show("当前场景不能进入")
                    return
                }

                //先退出队伍
                if (!BaseDungeonModel.GetInstance().TryToEnterDungeon(challenge_data.dun_id)) return


                this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61001, challenge_data.dun_id)
            } else {
                Message.show("已达到最高层")
            }
        }, this, true)

        Util.AddClickEvent(this._img_get, () => {
            let time = TimeUtil.getServerTime()
            if (this.click_time > 0 && time - this.click_time < 0.2) {
                return
            }
            this.click_time = time

            this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61114)

        }, this, true)


        this.BindEvent(this.model, BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, (dun_type?) => {
            if (dun_type == DUN_TYPE.Rune) {
                this.UpdateView()
            }
        })
    }

    public LoadSuccess() {
        this.InitEvent()
    }

    public UpdateView() {
        let dun_list = this.model.GetDungeonInfo(DUN_TYPE.Rune)
        if (dun_list) {
            let cur_floor = this.model.GetRuneCurFloor()
            this._lb_floor.text = cur_floor

            let dungeon_rune_lv_data_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_rune_lv_data
            if (dungeon_rune_lv_data_cfg) {
                let cur_floor_cfg = dungeon_rune_lv_data_cfg[cur_floor]
                let cur_floor_daily_reward = JSON.parse(cur_floor_cfg.daily_rewards)
                let len = cur_floor_daily_reward.length
                for (let i in cur_floor_daily_reward) {
                    var reward = cur_floor_daily_reward[i]
                    let item = this.item_list[i]
                    if (!item) {
                        item = new BaseAwardItem(this._panel_reward)
                        item.SetItemSize(85, 85)
                        item.Load()
                        this.item_list[i] = item
                    }

                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
                    let vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                    if (vo) {
                        item.SetData(type_id, reward[2])
                    }
                    item.SetVisible(true)
                    item.SetPosition(Number(i) * 101, 0)
                }

                this._panel_reward.width = 85 * len + 16 * (len - 1)

                let j = this.item_list.length
                if (j > len) {
                    do {
                        let item = this.item_list[j - 1]
                        item.SetVisible(false)
                        j = j - 1
                    } while ((j > len)
                    )
                }
            }
        }

        if(this.model.RuneAllIsDone()){
            this._img_get.x = 201
            this._img_continue.visible = false
        }
        else{
            this._img_get.x = 91
            this._img_continue.visible = true
            let challenge_data = this.model.GetRuneChallengeData()
            if (challenge_data) {
                let cfgs = Config.PRELOAD_SERVER_CONFIG.config_dungeon
                let dun_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, challenge_data.dun_id, false, cfgs)
                this._img_red.visible = RoleManager.GetInstance().GetMainRoleVo().fighting >= Number(dun_cfg.recommend_power) * BaseDungeonModel.Recommend_Power_Module
            } else {
                this._img_red.visible = false
            }
        }
    }

    public Remove() {
        for (let i in this.item_list) {
            var item = this.item_list[i]
            item.DeleteMe()
        }
        this.item_list.length = 0
    }

    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _img_close: Laya.Image
    _img_continue: Laya.Image
    _img_red: Laya.Image
    _img_get: Laya.Image
    _lb_floor: Laya.Label
    _panel_reward: Laya.Panel
    public GetComponents() {
        [
            this._img_bg,
            this._img_bg2,
            this._img_close,
            this._img_continue,
            this._img_red,
            this._img_get,
            this._lb_floor,
            this._panel_reward,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_bg2",
                "_img_close",
                "_img_continue",
                "_img_red",
                "_img_get",
                "_lb_floor",
                "_panel_reward",
            ])
    }
}
window["DungeonRuneDailyRewardView"] = DungeonRuneDailyRewardView