import { BaseController } from "../common/BaseController";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { FairyWishEvent, FairyWishModel } from "../commonModel/FairyWishModel"
import "../fairyWish/FairyWishView"
import "../fairyWish/FairyWishAttrItem"
import "../fairyWish/FairyWishNodeItem"
import "../fairyWish/FairyWishNodeItem2"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
export class FairyWishController extends BaseController {
    InitInfo
    InitEvent
    view_dic
    constructor() {
        super();
        let user_msg_adapter = UserMsgAdapter.GetInstance()
        let fairy_model = FairyWishModel.GetInstance()
        let outwardModel = OutWardBaseModel.GetInstance()
        this.view_dic = {}
        this.InitEvent = () => {
            fairy_model.Bind(FairyWishEvent.REQUEST_PROTO, (pt,fairy_id) => {
                this.SendFmtToGame(51300, "i", fairy_id)
            })
            fairy_model.Bind(FairyWishEvent.REQUEST_UPDATE_PROTO, (pt,fairy_id, node_id) => {
                this.SendFmtToGame(51301, "ii", fairy_id, node_id)
            })
            fairy_model.Bind(FairyWishEvent.ON_TOUCH_ICON, (pt,fairy_id) => {
                this.SendFmtToGame(51302, "i", fairy_id)
            })
            fairy_model.Bind(FairyWishEvent.OPEN_VIEW, async (view_name: string, ...new_args) => {
				let view = this.view_dic[view_name]
				if (!view) {
					this.view_dic[view_name] = true
					if (this.view_dic[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						this.view_dic[view_name] = view
					}
				}
				if (view) {
					view.Open(...new_args)
				}
			}
			)
            
        }

        this.InitInfo = () => {
            let On51300 = () => {
                let scmd = user_msg_adapter.GetSCMD(51300)
                fairy_model.setFairyInfo(scmd)
                outwardModel.UpdateOutWardStrongerRed(scmd.fairy_id-1000)
            }
            let On51301 = () => {
                let scmd = user_msg_adapter.GetSCMD(51301)
                fairy_model.updateNodeInfo(scmd)
                outwardModel.UpdateOutWardStrongerRed(scmd.fairy_id-1000)
            }

            let On51303 = () => {
                let scmd = user_msg_adapter.GetSCMD(51303)
                fairy_model.updateRedInfo(scmd)
            }
            this.RegisterProtocal(51300, On51300) //某一仙灵的全部信息
            this.RegisterProtocal(51301, On51301) //更新仙灵的节点信息
            this.RegisterProtocal(51303, On51303) //是否第一次点击图标
        }

        this.InitInfo()
        this.InitEvent()
    }
}
window["FairyWishController"] = FairyWishController