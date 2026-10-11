import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Util } from "../util/Util"
export class LuckyTreasureRecordView extends BaseView1 {

    Local_Open

    public constructor() {
        super()
        this.base_file = "luckyTreasure"
        this.layout_file = "LuckyTreasureRecordView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.not_show_item_use = true
        this.show_open_movie = true

        let record_item_
        let model = CustomActivityModel.GetInstance()
        let info_
        
        this.load_callback = () => {
            if (!record_item_&&info_) {
                let b = info_.base_type
                let s = info_.sub_type
                record_item_ = model.LoadActRecord(this._box_record,b, s, 2)
            }


            Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

        }


        this.Local_Open = (...parms) => {
            if (parms&&parms.length>0) {
                info_ = parms[0]
            }
            super.Open()
        }

        this.destroy_callback = () => {
            if (record_item_) {
				record_item_.DeleteMe()
			}
			record_item_ = null
        }
    }


    public Open(...new_args) {
        this.Local_Open(...new_args)
    }



    public DeleteMe() {
        super.DeleteMe()
    }

    _Image111: Laya.Image
    _Image4: Laya.Image
    _img_close: Laya.Image
    _Image5: Laya.Image
    titleLabel: Laya.Label
    _box_record: Laya.Box
    public GetComponents() {
        [
            this._Image111,
            this._Image4,
            this._img_close,
            this._Image5,
            this.titleLabel,
            this._box_record,
        ]
            = this.GetChildrenByNames([

                "_Image111",
                "_Image4",
                "_img_close",
                "_Image5",
                "titleLabel",
                "_box_record",
            ])
    }
}
window["LuckyTreasureRecordView"] = LuckyTreasureRecordView