import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { BabyModel, BabyEvent } from "../commonModel/BabyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { AtlasUrl, Util } from "../util/Util"

export class BabyIlluItem extends BaseItem1 {
    static Width = 172
    public model = BabyModel.GetInstance()

    public shadow_img_list
    public star_img_list = {}

    public cfg
    public item: BaseAwardItem

    public index
    public babyId
    public sprite_info
    public select_cache
    public constructor(parent) {
        super(parent)
        this.base_file = "baby"
        this.layout_file = "BabyIlluItem"
        this.load_callback = function () {
            this.LoadSuccess()
        }
    }

    public SetData = (index, babyId) => {
        let self = this
        self.index = index
        self.babyId = babyId
        if (self.is_loaded) {
            let ill_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_baby_figure", false)
            let cfg = ill_cfg[self.babyId]
            // if (!this.item) {
            //     this.item = new BaseAwardItem(this.itemGp)
            //     this.item.Load()
            //     this.item.SetScale(0.8)
            //     this.item.SetShowTips(false)
            // }
            if (cfg) {
                let cost = JSON.parse(cfg.cost)
                let goodBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(cost[0][1])
                if (goodBasic) {
                    ResManager.GetInstance().SetImageSprite(this,  self.box, "common", `com_goods_plate_${goodBasic.color}`)
                    //self.box.skin = AtlasUrl("common", `com_goods_plate_${goodBasic.color}`)
                }
            }
            ResManager.GetInstance().SetImageSprite(this, this.resImg,"baby",`${cfg.resource_id}`)
            if (!self.model.babyIllusionData || !self.model.babyIllusionData[self.babyId]) {
                //未激活
                this.unActive.visible = true

                this.star_shadow_group.visible = this.star_group.visible = this.starbg.visible = false
                // this.stageLb.visible = 
            } else {
                //已激活                
                this.unActive.visible = false
                // this.starbg.visible = true
                // let data = self.model.babyIllusionData[self.babyId]
                // this.stageLb.visible =
                // this.stageLb.text = `${data.baby_star}阶`
                this.star_shadow_group.visible = this.star_group.visible = true
                let data = self.model.babyIllusionData[self.babyId]
                if (!self.shadow_img_list) {
                    self.shadow_img_list = {}
                }
                for (let i = 0; i < 5; i++) {
                    let shadow = this.shadow_img_list[i]
                    if (!shadow) {
                        shadow = new Laya.Image()
                        shadow.width = 22
                        shadow.height = 23
                        self.star_shadow_group.addChild(shadow)
                        self.shadow_img_list[i] = shadow
                    }
                    let star = this.star_img_list[i]
                    if (!star) {
                        star = new Laya.Image()
                        star.width = 22
                        star.height = 23
                        self.star_group.addChild(star)
                        self.star_img_list[i] = star
                    }

                    ResManager.GetInstance().SetImageSprite(this, shadow, "baby", "flower")
                    if (data.baby_star <= 5) {
                        ResManager.GetInstance().SetImageSprite(this, star, "baby", "flower_0")
                    }else if (data.baby_star <= 10) {
                        ResManager.GetInstance().SetImageSprite(this, star, "baby", "flower1")
                    } else {
                        ResManager.GetInstance().SetImageSprite(this, star, "baby", "flower2")

                    }

                    if (i < data.baby_star % 5 || data.baby_star % 5 == 0) {
                        star.visible = true
                    } else {
                        star.visible = false
                    }
                }
            }
            if (self.select_cache) {
                self.SetSelect(self.select_cache)
            }
            this.red_dot.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BABY_ILLU_RED, this.babyId)
        }
    }

    public LoadSuccess = () => {
        let self = this
        if (self.babyId) {
            self.SetData(self.index, self.babyId)
        }
        self.InitEvent()
    }

    public InitEvent = () => {
        let self = this
        Util.AddClickEvent(self.clickGp, () => {
            self.model.Fire(BabyEvent.SELECT_ILLU_ITEM, self.index, self.babyId)
        }, self, true)

        self.BindEvent(self.model, BabyEvent.BABY_ILLUSION_DATA, () => {
            self.SetData(self.index, self.babyId)
        })

        self.BindEvent(self.model, BabyEvent.UPDATE_ILLU_RED, () => {
            this.red_dot.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BABY_ILLU_RED, this.babyId)
        })
    }

    public SetRedDot = (bool) => {
        let self = this
        if (bool) {
            self.red_dot.visible = true
        } else {
            self.red_dot.visible = false
        }
    }

    public SetSelect = (bool) => {
        let self = this
        self.select_cache = bool
        if (self.is_loaded) {
            if (bool) {
                self.select_img.visible = true
            } else {
                self.select_img.visible = false
            }
        }
    }

    public DeleteMe() {
        if (this.item) {
            this.item.DeleteMe()
            this.item = null
        }
        super.DeleteMe()
    }

    clickGp: Laya.Box
    _Image1: Laya.Image
    unActive: Laya.Image
    select_img: Laya.Image
    starbg: Laya.Image
    box: Laya.Image
    resImg: Laya.Image
    star_shadow_group: Laya.HBox
    star_group: Laya.HBox
    red_dot: Laya.Image
    stageLb: Laya.Label
    public GetComponents() {
        [
            this.clickGp,
            this._Image1,
            this.unActive,
            this.select_img,
            this.starbg,
            this.box,
            this.resImg,
            this.star_shadow_group,
            this.star_group,
            this.red_dot,
            this.stageLb,
        ]
            = this.GetChildrenByNames([

                "clickGp",
                "_Image1",
                "unActive",
                "select_img",
                "starbg",
                "box",
                "resImg",
                "star_shadow_group",
                "star_group",
                "red_dot",
                "stageLb",
            ])
    }
}
window["BabyIlluItem"] = BabyIlluItem