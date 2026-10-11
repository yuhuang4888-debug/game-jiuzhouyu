import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Config } from "../common/Config"
import { WordManager } from "../common/WordManager"

export class SeaAssertRankItem extends BaseItemRenderer {
    _model
    goods_model
    reward_list

    WIDTH = 670
    HEIGT = 80

    public constructor() {
        super()

        this.reward_list = []
        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertRankItem"

        this._model = SeaHegemonyModel.GetInstance()
        this.goods_model = GoodsModel.GetInstance()

        this.load_callback = () => {

            //this:LoadSuccess()
        }
        this.Load();
    }

    public DeleteMe() {
        if (this.reward_list) {
            for (let _ in this.reward_list) {
                var item = this.reward_list[_]
                item.DeleteMe()
            }
            this.reward_list = null
        }
        super.DeleteMe();
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let rank = this.data.rank + 1;
            this._img_rank.visible = rank <= 3
            this._lb_rank.visible = rank > 3
            if (rank <= 3) {
                //this._img_rank.source = "seaAssert.rank_icon_" + (this.itemIndex + 1) + ""
                ResManager.GetInstance().SetImageSpriteTrans(this, this._img_rank, GameResPath.GetIcon('topPlayer', "rank_icon_" + rank))
            } else {
                this._lb_rank.text = rank
            }
            let pos_cfg = Config.PRELOAD_SERVER_CONFIG.config_seacraft_daily_reward;
            // [ts2lua]pos_cfg下标访问可能不正确
            this._lb_job.text = pos_cfg[this.data.pos].name;
            let a_data = this._model.assertRankData
            let seaId: number = (this.data?.sea_id ? this.data.sea_id : a_data?.sea_id) - 1;
            this._lb_name.text = this._model.titleList[seaId] + "·" + this.data.role_name;
            this._lb_fight.text = WordManager.ConvertNum(this.data.power);
            this._lb_num.text = this.data.num;
            if (this.data.reward) {
                this._Scroller1.visible = true
                let rewards = JSON.parse(this.data.reward)
                for (let _ in this.reward_list) {
                    var item = this.reward_list[_]
                    item.SetVisible(false)
                }

                let index = 0;
                for (let key in rewards) {
                    // [ts2lua]rewards下标访问可能不正确
                    let info = rewards[key]
                    // [ts2lua]this.reward_list下标访问可能不正确
                    let item = this.reward_list[index]
                    if (!item) {
                        item = new BaseAwardItem(this.Content)
                        item.Load()
                        item.SetScale(0.5)
                        table.insert(this.reward_list, item)
                    }
                    item.SetVisible(true)
                    let [type_id, lock] = this.goods_model.GetMappingTypeId(info[0], info[1])
                    let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
                    if (goods_vo) {
                        item.SetData(goods_vo.type_id, info[2], lock)
                    }
                    index = index + 1
                }
            } else {
                this._Scroller1.visible = false
            }
        }
    }

    _bg: Laya.Image
    _lb_rank: Laya.Label
    _lb_job: Laya.Label
    _lb_name: Laya.Label
    _lb_fight: Laya.Label
    _lb_num: Laya.Label
    _img_rank: Laya.Image
    _Scroller1: Laya.Panel
    Content: Laya.HBox
    public GetComponents() {
        [
            this._bg,
            this._lb_rank,
            this._lb_job,
            this._lb_name,
            this._lb_fight,
            this._lb_num,
            this._img_rank,
            this._Scroller1,
            this.Content,
        ]
            = this.GetChildrenByNames([

                "_bg",
                "_lb_rank",
                "_lb_job",
                "_lb_name",
                "_lb_fight",
                "_lb_num",
                "_img_rank",
                "_Scroller1",
                "Content",
            ])
        this._Scroller1.hScrollBar.visible = false;
    }
}
window["SeaAssertRankItem"] = SeaAssertRankItem