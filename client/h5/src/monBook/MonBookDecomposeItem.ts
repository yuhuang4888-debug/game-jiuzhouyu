import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { ResManager } from "../common/ResManager";
import { MonBookModel } from "../commonModel/MonBookModel";
import { AtlasUrl } from "../util/Util";

export class MonBookDecomposeItem extends BaseItemRenderer {
    public WIDTH = 85
	public HEIGT = 85

    public item: BaseAwardItem
    private model = MonBookModel.GetInstance()
    private select_stage = true
    private is_decompose_item = true
    private delay_set_obj
    public constructor() {
        super();
        this.base_file = "monBook"
		this.layout_file = "MonBookDecomposeItem"
        this.Load()
    }

    public createChildren(): void {
        super.createChildren();
        // this.touchChildren = true;
    }

    public load_callback() {
		if (!this.item) {
            this.item = new BaseAwardItem(this._item_gp)
            this.item.Load()
            this.item.SetItemSize(85, 85)
        }
	}

    protected dataChanged(): void {
        if (super.dataChanged()) {
            if (this.data) {
                let cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "ClientMonBookDecomposeHarvestConfig", true)
                let type_id = this.data.type_id
                let num = this.data.goods_num
                for (let key in cfg) {
                    let value = cfg[key]
                    if (type_id == value)
                        this.is_decompose_item = false
                }
                this.item.ExcuteCallback(() => {
                    this.item.select_image.skin = AtlasUrl("monBook", "select")
                    if (this.is_decompose_item) {
                        if (this.model.decompose_dir[type_id]) {
                            // this.item.SetSelect(true)
                            this.select_stage = true
                        }
                        else {
                            // this.item.SetSelect(false)
                            this.select_stage = false
                        }
                        this.item.SetClickCallBack(this.Callback)
                        this.item.SetData(type_id, num, undefined, this.select_stage)
                    }
                    else {
                        if (this.delay_set_obj) {
                            clearTimeout(this.delay_set_obj)
                            this.delay_set_obj = null
                        }
                        let func = () => {
                            if (num == 0)
                                this.item.SetGary(true)
                            else
                                this.item.SetGary(false)
                        }
                        this.delay_set_obj = setTimeout(func, 100)
                        this.item.SetData(type_id, num)
                    }
                })
            }
        }
    }

    public Callback = () => {
        let stage
        let goods_vo = this.data
        if (this.select_stage == true)
            stage = false
        else
            stage = true
        this.select_stage = stage
        this.item.SetSelect(stage)
        this.model.Fire(MonBookModel.SELECT_ITEM, stage, goods_vo)
    }



    public DeleteMe() {
        let self = this
        if (self.item) {
            self.item.DeleteMe()
            self.item = null
        }
        if (this.delay_set_obj) {
            clearTimeout(this.delay_set_obj)
            this.delay_set_obj = null
        }
        super.DeleteMe()
    }
    _item_gp: Laya.Box
    public GetComponents() {
        [
            this._item_gp,
        ]
            = this.GetChildrenByNames([

                "_item_gp",
            ])
    }
}
window["MonBookDecomposeItem"] = MonBookDecomposeItem