
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class FlowerRankRewardItem extends BaseItemRenderer {
    WIDTH = 608
    HEIGT = 120

    model: CustomActivityModel
    item_list = []
    public constructor() {
        super()
        this.base_file = "flowerRank"
        this.layout_file = "FlowerRankRewardItem"
        this.model = CustomActivityModel.GetInstance()
        this.load_callback = () => {
            this.LoadSuccess()
        }
        this.Load()
    }

    public InitEvent = () => {
    }

    public LoadSuccess = () => {
        this._panel_reward.hScrollBarSkin = ""

        //resource/game/flowerRank/texture/ui_activity_02.png
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("flowerRank", "ui_activity_02"))

        this.InitEvent()
    }

    public dataChanged = () => {
        if (super.dataChanged()) {
            let act_info = this.data.info
            let act_data = this.data.data
            let cur_sex = this.data.cur_sex
            let my_rank = this.data.my_rank


            let b = act_info.base_type
            let s = act_info.sub_type
            let cond = this.model.GetActCondition(b, s, "data", act_data.grade)
            if (cond) {
                let range = cond.rank
                let str = range[0] == range[1] && range[0] || range[0] + "~" + range[1]
                this._lb_rank.text = str

                let my_sex = RoleManager.GetInstance().mainRoleInfo.sex
                let bool = my_sex == cur_sex
                if (bool && my_rank >= Number(range[0]) && my_rank <= Number(range[1]) ) {
                    this._img_cur.visible = true
                }
                else{
                    this._img_cur.visible = false
                }
            }

            let reward_list = this.model.GetActReward(b, s, act_data.form_type, act_data.reward, cur_sex)

            for (let i in reward_list) {
                var reward = reward_list[i]
                let item = this.item_list[i]
                if (!item) {
                    item = new BaseAwardItem(this._panel_reward)
                    item.SetItemSize(84)
                    item.Load()
                    this.item_list[i] = item
                }

                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
                let vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                if (vo) {
                    item.SetData(type_id, reward[2], lock)
                }
                item.SetVisible(true)
                item.SetPosition(Number(i) * 98, 0)
            }

            let j = this.item_list.length
            if (j > reward_list.length) {
                do {
                    let item = this.item_list[j - 1]
                    item.SetVisible(false)
                    j = j - 1
                } while ((j > reward_list.length)
                )
            }
        }
    }


    public DeleteMe() {
        for (let i in this.item_list) {
            var item = this.item_list[i]
            item.DeleteMe()
        }
        this.item_list.length = 0
        super.DeleteMe()
    }


    _img_bg: Laya.Image
    _lb_rank: Laya.Label
    _panel_reward: Laya.Panel
    _img_cur: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._lb_rank,
            this._panel_reward,
            this._img_cur,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_lb_rank",
                "_panel_reward",
                "_img_cur",
            ])
    }
}
window["FlowerRankRewardItem"] = FlowerRankRewardItem