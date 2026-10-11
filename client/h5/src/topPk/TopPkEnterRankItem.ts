import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { TopPkModel } from "../commonModel/TopPkModel"
import { GameResPath } from "../util/GameResPath"
import { Config } from "../common/Config"

export class TopPkEnterRankItem extends BaseItemRenderer {
    _img_bg: Laya.Image
    _lb_rank: Laya.Label
    _img_rank: Laya.Image
    _lb_name: Laya.Label
    _lb_level_name: Laya.Label
    _lb_point: Laya.Label
    model
    WIDTH = 670
    HEIGT = 40
    public constructor(parent) {
        super()


        this.base_file = "topPk"
        this.layout_file = "TopPkEnterRankItem"
        this.model = TopPkModel.GetInstance()
        this.load_callback = () => {

            //ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("topPk", "uidfjj_006"))
        }
        this.Load()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data == null) { return }
            let data = this.data
            let top_pk_rank_reward_cfg = Config.PRELOAD_SERVER_CONFIG.config_top_pk_rank_reward
            let cfg = this.model.GetLevelCfg(data.rank_lv, top_pk_rank_reward_cfg)
            if (cfg) {
                this._lb_level_name.text = cfg.rank_name
            }
            this._lb_name.text = "s" + data.server + "." + data.role_name
            this._lb_point.text = this.model.GetLevelTotalPoint(data.rank_lv, top_pk_rank_reward_cfg) + data.point
            //this._img_bg.visible = !(this.index % 2 == 1)
            let rank = this.index + 1
            let bool = rank > 3
            this._img_rank.visible = !bool
            this._lb_rank.visible = bool
            if (bool) {
                this._lb_rank.text = String(rank)
            } else {
                TopPkModel.SetRankIcon(this._img_rank, rank,false)//, false
            }
        }
    }



    public GetComponents() {
        [
            this._img_bg,
            this._lb_rank,
            this._img_rank,
            this._lb_name,
            this._lb_level_name,
            this._lb_point,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_lb_rank",
                "_img_rank",
                "_lb_name",
                "_lb_level_name",
                "_lb_point",
            ])
    }
}
window["TopPkEnterRankItem"] = TopPkEnterRankItem