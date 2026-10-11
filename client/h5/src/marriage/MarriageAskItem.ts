import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { Config } from "../common/Config";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageAskCfg, MarriageModel } from "../commonModel/MarriageModel";
import { AtlasUrl } from "../util/Util";

export class MarriageAskItem extends BaseItemRenderer {
    public WIDTH = 556
	public HEIGT = 188

    private _model: MarriageModel;
    private _item_list: Array<BaseAwardItem>;

    public constructor() {
        super()
        this.base_file = "marriage"
		this.layout_file = "MarriageAskItem"
        this._model = MarriageModel.GetInstance()
        this.Load()
    }

    public load_callback(){
        this._item_list = []
        this.scroll.hScrollBar.visible = false
	}

    public DeleteMe() {
        for (let item of this._item_list) {
            item.DeleteMe()
        }
        this._item_list.length = 0
        super.DeleteMe()
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        if (!this.data) return
        let data = this.data
        this._img_select.visible = this.selected
        let cfg = MarriageAskCfg[data.propose_type]
        this.label1.color = cfg.color
        this._lb_c.color = cfg.color
        this._lb_en.color = cfg.color
        this._lb_nickname.color = cfg.color
        this._lb_award.color = cfg.color
        ResManager.GetInstance().SetTexture(this.base_item, this._img_bg, `resource/game/marriage/texture/${cfg.bg}.png`)
        if(cfg.bg=="uijh_047c"){
            this._img_bg.pos(0,-8)
            this._img_bg.width=558
            this._img_bg.height=192
        }else{
            this._img_bg.pos(0,0)
            this._img_bg.width=548
            this._img_bg.height=184
        }


        this._img_name.skin = AtlasUrl("marriage", cfg.name)
        // this._img_ring.skin = AtlasUrl("marriage", cfg.ring)
        let cost = JSON.parse(data.cost)
        if (cost && cost[0]) {
            this.UpdateCostData(cost[0])
        }
        let name = data.role_name || "某某"
        this._lb_nickname.text = `${name}的伴侣`

        let dsgt_info_list = Config.PRELOAD_SERVER_CONFIG.config_dsgt
        let dsgt = dsgt_info_list[data.dsgt];
        if (dsgt.type == 1) {
            this.base_item.AddUIEffect(dsgt.resource_id, this._group_dsgt, null, 0.7, true);
        } else {
            let url = `resource/game/dsgtIcon/${dsgt.resource_id}.png`
            ResManager.GetInstance().SetTexture(this.base_item, this._img_dsgt, url)
        }

        let minfo = this._model.GetMateInfo()
        let cfg_1 = ResManager.GetInstance().GetGameConfigFromCache(this,"config_propose_cfg",false)
        let reward_show = []
        let reward=[]
        if(cfg_1&&cfg_1[this.index+1]&&cfg_1[this.index+1].show_reward){
            reward_show = JSON.parse(cfg_1[this.index+1].show_reward)
            reward = minfo && minfo.first_marriage ? reward_show[1][1] : reward_show[0][1]
        }
        this.UpdateItems(reward)
    }

    private UpdateCostData(data) {
        let [type_id] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1])
        ResManager.GetInstance().SetTexture(this.base_item, this._img_cost, GoodsModel.GetGoodsPath(type_id))
        this._lb_cost.text = data[2]
    }

    private UpdateItems(list) {
        if (list) {
            for (let i = 0; i < list.length; i++) {
                let data = list[i]
                let item = this._item_list[i]
                if (!item) {
                    item = new BaseAwardItem(this._group_item)
                    item.Load()
                    item.SetItemSize(57, 57)
                    this._item_list[i] = item
                }
                let [type_id] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1])
                item.SetData(type_id, data[2])
            }
            this._lb_award.visible = list.length > 0
        } else {
            this._lb_award.visible = false
        }
    }
    

    _img_bg: Laya.Image
    _img_select: Laya.Image
    _img_ring: Laya.Image
    _img_name: Laya.Image
    _img_cost: Laya.Image
    label1: Laya.Label
    _lb_c: Laya.Label
    _lb_cost: Laya.Label
    _lb_en: Laya.Label
    _lb_nickname: Laya.Label
    _lb_award: Laya.Label
    _group_dsgt: Laya.Box
    scroll: Laya.Panel
    _group_item: Laya.HBox
    _img_dsgt: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._img_select,
            this._img_ring,
            this._img_name,
            this._img_cost,
            this.label1,
            this._lb_c,
            this._lb_cost,
            this._lb_en,
            this._lb_nickname,
            this._lb_award,
            this._group_dsgt,
            this.scroll,
            this._group_item,
            this._img_dsgt,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_select",
                "_img_ring",
                "_img_name",
                "_img_cost",
                "label1",
                "_lb_c",
                "_lb_cost",
                "_lb_en",
                "_lb_nickname",
                "_lb_award",
                "_group_dsgt",
                "scroll",
                "_group_item",
                "_img_dsgt",
            ])
    }
}
window["MarriageAskItem"] = MarriageAskItem