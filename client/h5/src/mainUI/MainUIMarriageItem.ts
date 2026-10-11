import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { MarriageModel } from "../commonModel/MarriageModel"
import { Util } from "../util/Util"

/**婚恋 新手预览 */
export class MainUIMarriageItem extends BaseView1 {
    icon
    public constructor() {
        super()
        this.base_file = "mainUI"
        this.layout_file = "MainUIMarriageItem"
        this.layer_value = Enum_UILayer.Main

        this.load_callback = () => {
            this.display_obj.right = -10
			let y = 278
			let liu_hai_height = Util.GetLiuhaiHeight()
			if (liu_hai_height && liu_hai_height > 0) {
				y = 278 + liu_hai_height
			}
            this.display_obj.y = y
            ResManager.GetInstance().SetImageSprite(this, this._img, "mainUI", this.icon)

            Util.AddClickEvent(this._img, () => {
                MarriageModel.GetInstance().ClickForeShowFunc()
            }, this, true)


            MainUIManager.GetInstance().AddMoveComponent(this, this.display_obj, true, MainUIManager.MOVE_TYPE.Right)
        }


        this.close_callback = () => {

        }
        this.destroy_callback = () => {
            if (MainUIManager.GetInstance().HasMoveComponent(this, this.display_obj)) {
                MainUIManager.GetInstance().RemoveMoveOneComponent(this, this.display_obj)
            }
        }

    }

    public SetIcon(icon) {
        this.icon = icon
        ResManager.GetInstance().SetImageSprite(this, this._img, "mainUI", this.icon)
    }

    public Open(...new_args) {
        this.icon = new_args[0]
        super.Open()
    }

    public DeleteMe() {
        super.DeleteMe()
    }

    _img: Laya.Image
    public GetComponents() {
        [
            this._img,
        ]
            = this.GetChildrenByNames([

                "_img",
            ])
    }
}
window["MainUIMarriageItem"] = MainUIMarriageItem